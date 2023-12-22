# Terrain
Railgun decentralizes OTC trading to mine new Terrain for the Mode Protocol and Optimistic Mainnet 

Railgun Decentralized Exchange: Frequent OTC Opportunities with Optimistic Rollup

Introduction:
Welcome to the Terrain, a decentralized OTC-exchange that democratizes the OTC auction process using Optimistic Rollup Technology.  This DEX offers unique 10-minute trading window paired with orderbook clearing and re-shuffling to create an old-school Bid/Ask feel to a decentralized exchange.  10-minute trading windows open and close 24/7 for traders to place orders on the ETH/USDC pair, with a First-In-First-Out(FIFO) matching mechanism and hidden orderbook to help accumulations and profit takes at set prices and liquid quantities regardless of market conditions. 

Features:
-24/7 OTC Opportunities in 10-minute trading windows for active and frequent trading opportunities
-Blind Auction with orderbook privacy for current and most recent 10-minute trading window
-FIFO Matching Mechanism that ensures the first buy order that matches a sell order and vice-versa is the trade that goes through 
-Mode/Optimistic Fee Sequencer to build up a Terrain ETH Treasury with unlock levels to mint Terrain OP Superchain Tokens and build a USDC Loan Pool in treasury
-Unique Gas Fee optimizer that ensures matched trades go through regardless of gas fees and utilizes two one-way transfers for each participant for all orders placed during each trade window to avoid MEV on ETH Mainnet once trade-window clears which promotes stable gas fees
-Minting occurs after accumulating 40 ETH in treasury with the first sell for 10 ETH minting 10,000 Supertokens and subsequent buys every 10 ETH mint for 5,000 supertokens and sell 5 ETH on one OTC buy order a trade window 
-Users receive a 20% Supertoken rebate for trade fees above 10 ETH. Rebates contribute to the Supertoken Liquidity pool for traders to angel fund other Mode Protocols. The Treasury becomes an investment tool for future Optimistic Rollup protocols through Terrain/USDC pairs that allow for USDC loans from the Terrain Treasury. 

Three Smart Contract DApp Structure:

1. RailgunTrader.sol - The 10-minute Trading Window OTC-Dex with private orderbook for the in-trading window period
2. TerrainTreasury.sol - The Protocol Treasury that uses OP Fee Sequencer to build up an ETH treasury later used to mint TerrainCoin and and to fill partial buy-orders for ETH to build a USDC Loan Pool
3. TerrainCoin.sol(ERC-20 Token) - A OP Superchain native-token to be developed later for fee rebates and angel-fund investing through LP listing that can be used by protocols to borrow USDC from the TerrainTreasury USDC Loan Pool for their DeFi Products.

   
   
