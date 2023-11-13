// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// Import BeefyVault interface from Beefy repository
import "./interfaces/beefy/IVault.sol";

contract Treasury is Ownable {
    IERC20 public stablecoin; // Stable token (USDC or other)
    IVault public beefyVault; // Address of the BeefyVault contract
    bool public beefyVaultSet; // Boolean to check if BeefyVault address is set
    uint256 public usdtPercentage;
    uint256 public daiPercentage;
    address public protocolA;
    address public protocolB;

    // Events
    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);
    event RatiosUpdated(uint256 usdtPercentage, uint256 daiPercentage);

    constructor(address _stablecoin, address _beefyVault, address _initialOwner)  Ownable(_initialOwner) {
        stablecoin = IERC20(_stablecoin);
        beefyVault = IVault(_beefyVault);
        usdtPercentage = 50;
        daiPercentage = 50;

        // Check if BeefyVault address is set
        beefyVaultSet = (_beefyVault != address(0));
    }

    function deposit(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        require(
            stablecoin.transferFrom(msg.sender, address(this), amount),
            "Transfer failed"
        );
        emit Deposit(msg.sender, amount);
    }

    function setRatios(uint256 _usdtPercentage, uint256 _daiPercentage)
        external
        onlyOwner
    {
        require(
            _usdtPercentage + _daiPercentage <= 100,
            "Total percentage exceeds 100"
        );
        usdtPercentage = _usdtPercentage;
        daiPercentage = _daiPercentage;
        emit RatiosUpdated(_usdtPercentage, _daiPercentage);
    }

    function depositFunds() internal {
        // Call earn() to deposit funds into the strategy
        IStrategy(beefyVault.strategy()).deposit();
    }

    function distributeFunds() external onlyOwner {
        require(beefyVaultSet, "Beefy Vault address not set");
    
        // Call depositFunds() to deposit funds into the strategy
        depositFunds();

        // Rest of the logic to distribute funds between protocols
        // ...
    }

    function withdrawFunds(uint256 amount) external onlyOwner {
        require(beefyVaultSet, "Beefy Vault address not set");

        IVault(beefyVault).withdraw(amount);

        // To withdraw all available funds,
        // BeefyVault(beefyVault).withdrawAll();

        // Transfer funds from the BeefyVault contract back to the Treasury contract
        uint256 totalBalance = stablecoin.balanceOf(address(this));
        stablecoin.transfer(owner(), totalBalance);
    }

    function calculateAggregateYield() external returns (uint256) {
        // Get the balance of want() before calling earn
        uint256 balanceBefore = want().balanceOf(address(this));

        // Call depositFunds() to deposit funds into the strategy
        depositFunds();

        // Get balance of want() after calling earn
        uint256 balanceAfter = want().balanceOf(address(this));

        // Calculate the yield as the difference in balances
        uint256 yield = balanceAfter - balanceBefore;

        // Return the calculated yield
        return yield;
    }

    function want() internal view returns (IERC20) {
        return IVault(beefyVault).want();
    }
}