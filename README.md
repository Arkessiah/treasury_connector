Test for senior blockchain developers.
## project description
You are tasked with coming up with the approaches to connect a smart contract (treasury) to different liquidity pools and DeFi protocols (eg: uniswap,AAVE etc.).
- The treasury smart contract should be able to receive USDC or any other stable coin
- The funds (eg:USDC) are to be distributed among the different protocols and swapped for either USDT or DAI (in case of a liquidity pool).
- The ratio of these funds to be distributed can be set in the smart contract by the owner of the smart contract and can be changed dynamically after the deployment to the test/mainnet chains. - The contract should be able to withdraw the funds in the liquidity pools or DeFi protocols fully or partially.
- We should be able to calculate the aggregated percentage yield of all the protocols.
- You can use third-party code / services like https://beefy.com.
## Instructions
1. Coming up with detailed solutions in writing as a document and creating a visual version of the smart contracts like a block diagram (use any third party tool like https://app.diagrams.net/ ).
## Bonus points
1. Write the actual code in solidity and deploy it to test networks like polygon mumbai. Share the github repo along with the deployed smart contract address.


By: Antonio Maroto


DEPLOY CONTRACT Mumbai:  0x7853D26BbBBdC9EEF85C9ce239fcEaa9378EE0D9  

BeefyVault Mumbai Address: '0x3E7F60B442CEAE0FE5e48e07EB85Cfb1Ed60e81A'


Diagram: 

[Diagram](./img/diagram.png)
         
 //This performance estimate does not take into account the performance of the underlying DeFi protocols. I use the same strategy that Beefy uses

[Beefy Strategy](./img/Flow_LP.png)

Beefy Repo:
https://github.com/beefyfinance/beefy-contracts/blob/master/contracts/BIFI/interfaces/beefy/IVault.sol