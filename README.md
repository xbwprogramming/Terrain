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

   
   


Documentation:

1. RailgunTrader.sol

State Variables:
terrainTreasury: The address of the TerrainTreasury contract, representing the treasury for TerrainCoin.
ethUsdcTrading: The address of the ETHUSDCTrading contract, representing the trading functionality for the ETH/USDC pair.

Events:
BuyOrderPlaced: Emitted when a buy order is placed. Includes the buyer's address, order ID, and order details.
SellOrderPlaced: Emitted when a sell order is placed. Includes the seller's address, order ID, and order details.
TerrainCoinPurchased: Emitted when TerrainCoin is purchased. Includes the buyer's address, ETH amount spent, and TerrainCoin amount received.
TerrainCoinSold: Emitted when TerrainCoin is sold. Includes the seller's address, ETH amount received, and TerrainCoin amount sold.

Functions:
constructor(address _terrainTreasury): Initializes the smart contract with the address of the TerrainTreasury contract.
Inputs:
_terrainTreasury: The address of the TerrainTreasury contract.
placeBuyOrder(uint256 _ethAmount) external: Allows users to place a buy order in the ETH/USDC trading pair.
Inputs:
_ethAmount: The amount of ETH the buyer is willing to spend.
placeSellOrder(uint256 _usdcAmount) external: Allows users to place a sell order in the ETH/USDC trading pair.
Inputs:
_usdcAmount: The amount of USDC the seller is willing to receive.
sellTerrainCoin(uint256 _ethAmount) external: Allows the TerrainTreasury contract to initiate the sale of TerrainCoin in exchange for ETH.

Inputs:
_ethAmount: The amount of ETH to be sold.
executeTrades() external: Executes all matched buy and sell orders within the trading window, clearing the order book.
getOrderBook() external view returns (uint256[] memory, uint256[] memory): Retrieves the current order book.
Returns:
uint256[] memory: An array containing buy order prices.
uint256[] memory: An array containing sell order prices.

These functions provide the necessary functionality for placing buy and sell orders, executing trades, and interacting with the order book. The events facilitate event tracking for user interactions and transactions. The onlyOwner modifier is not explicitly used in this contract, but additional access control can be implemented as needed.

2. TerrainTreasury.sol

State Variables:
railgunTrader: The address of the RailgunTrader contract. Only this contract is allowed to trigger the selling of TerrainCoin.
minEthForMint: The minimum amount of ETH required to trigger the minting of TerrainCoin.
terrainPerEth: The ratio of TerrainCoin to ETH during minting.
nextMintThreshold: The next ETH threshold required to trigger the minting of TerrainCoin.

Events:
MintTerrainCoin: Emitted when TerrainCoin is minted. Includes the recipient's address, the ETH amount used for minting, and the corresponding TerrainCoin amount.

Modifiers:
onlyRailgunTrader: A modifier restricting certain functions to be callable only by the RailgunTrader contract.

Functions:
constructor(address _railgunTrader): Initializes the smart contract with the address of the RailgunTrader contract.
mintTerrainCoin(uint256 _ethAmount) external onlyOwner: Allows the owner to mint TerrainCoin based on the provided ETH amount.

Inputs:
_ethAmount: The amount of ETH to be converted into TerrainCoin.
sellTerrainCoin(uint256 _ethAmount) external onlyRailgunTrader: Called by the RailgunTrader contract to initiate the sale of TerrainCoin in exchange for ETH.
Inputs:
_ethAmount: The amount of ETH to be sold in exchange for TerrainCoin.
setRailgunTrader(address _railgunTrader) external onlyOwner: Allows the owner to update the address of the RailgunTrader contract.
Inputs:
_railgunTrader: The new address of the RailgunTrader contract.
setMinEthForMint(uint256 _minEthForMint) external onlyOwner: Allows the owner to update the minimum ETH required for minting.
Inputs:
_minEthForMint: The new minimum ETH required for minting.
setTerrainPerEth(uint256 _terrainPerEth) external onlyOwner: Allows the owner to update the Terrain to ETH mint ratio.
Inputs:
_terrainPerEth: The new ratio of TerrainCoin to ETH during minting.

These functions provide the necessary functionality for minting TerrainCoin, selling TerrainCoin, and updating configuration parameters. The onlyOwner and onlyRailgunTrader modifiers restrict access to certain functions, ensuring proper control and security.

3. TerrainCoinsol

TerrainRebate Event:

Inputs:
recipient: The address receiving the TerrainCoin rebate.
amount: The amount of TerrainCoin rebated.

Explanation:
The TerrainRebate event is emitted when a rebate in TerrainCoin is provided to a user.
solidity

event TerrainRebate(address indexed recipient, uint256 amount);

TerrainBack Event:

Inputs:
payer: The address covering trade fees using TerrainCoin.
amount: The amount of TerrainCoin used for covering trade fees.

Explanation:
The TerrainBack event is emitted when TerrainCoin is used to cover trade fees.
solidity

event TerrainBack(address indexed payer, uint256 amount);

These functions and events provide the core functionality of the TerrainCoin contract, allowing minting, rebates, and covering trade fees with TerrainCoin.

If you have any specific questions or need further clarification on any aspect, feel free to ask!





