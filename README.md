# Terrain
Railgun decentralizes OTC trading to mine new Terrain for the Mode Protocol and Optimistic Mainnet 
Railgun Decentralized Exchange: Frequent OTC Opportunities with Optimistic Rollup

Introducing Railgun DEX, a decentralized exchange (DEX) built on the Optimistic Superchain for lightning-fast and cost-effective trades. Railgun DEX operates on 10-minute trading windows, offering users frequent opportunities to place buy and sell orders in a private order book. Orders are executed using a FIFO matching mechanism, providing fair and transparent trade execution.

Railgun DEX leverages the Optimistic Superchain Sequencer fee to build up an ETH treasury, fostering sustainability and growth. The treasury is used to mint TerrainCoin, an Optimistic Superchain-native token, at a 1,000 TerrainCoin to 1 ETH rate. Users can earn TerrainCoin rebates on trade fees and use it to cover future trade fees.

The ecosystem includes:

RailgunTrader: The main trading contract facilitating private order books and 10-minute trade windows.
TerrainTreasury: Manages the treasury buildup, mints TerrainCoin, and sells ETH to partially filled buy-orders to fund a USDC Loan Pool for TerrainCoin to borrow against
TerrainCoin: An ERC-20 token minted in TerrainTreasury, offering rebates and fee coverage for Railgun DEX users, and future TerrainCoin/USDC Liquidity Pool Integration for other protocols to stake and borrow USDC against TerrainTreasury
Railgun DEX empowers users with frequent trading opportunities, transparent order matching, and novel features like TerrainCoin rebates, creating an efficient and sustainable decentralized trading experience. Join Railgun DEX for a faster, fairer, and more rewarding trading journey!

Features:
-Private Orderbook OTC-Dex with 24/7 10-minute Trade Close & Clears
-Gas Optimization feature for all placed trades to execute on two one-way transfers to evade MEV on ETH Mainnet
-OP/MODE Mainnet Fee Sequencer to develop a treasury for native OP Superchain TerrainCoin mining & USDC Loan Pool Development
-Collateralize your farmed TerrainCoin with future TerrainCoin/USDC Liquidity Pool Integrations to stake in dApps for them to borrow against USDC Loan Pool

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





