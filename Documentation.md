$RailGunTrader Contract
Functions:
placeOrder:

Parameters: orderType (buy/sell), amount, price
Description: Allows traders to place buy or sell orders within a 10-minute window, receiving a unique order ID.
cancelOrder:

Parameters: orderID
Description: Traders can cancel their placed orders, subject to a cancellation fee.
executeTrades:

Description: After every 10-minute window, executes matched orders in a FIFO sequence, settling trades in two one-way transactions.

Private Order Book: All orders are stored privately within the smart contract during the 10-minute trading window.
Events:
OrderPlaced: Fired when a new order is placed.
OrderCanceled: Fired when an order is canceled.
TradeExecuted: Fired after the execution of matched orders.

$TerrainTreasury Contract

Functions:
accumulateAssets:

Description: Accumulates assets (ETH, USDC) through trades executed by RailGunTrader.
mintTerrainCoin:

Description: Triggers minting of TerrainCoin when the treasury accumulates a specified amount of ETH.
borrowUSDC:

Description: Allows users to borrow USDC from the ETH/USDC balance in TerrainTreasury.

$TerrainCoin Contract

Functions:
tradeFeeRebate:

Parameters: tradeAmount
Description: Users receive a 20% rebate in TerrainCoin for completed trades exceeding 10 ETH in a trading window.
coverTradeFees:

Parameters: amount
Description: Enables users to cover trade fees within RailGunTrader using TerrainCoin.
angelInvesting:

Description: Allows TerrainCoin holders to fund the TerrainCoin/USDC liquidity pool, serving as an angel fund for other Optimism Superchain protocols.
Protocol Overview
TerrainProtocol combines RailGunTrader, TerrainTreasury, and TerrainCoin to create a decentralized and discrete OTC trading experience, fostering angel investing in Optimism Superchain and Mode Network DeFi protocols. RailGunTrader ensures secure and efficient trades, TerrainTreasury accumulates assets for minting TerrainCoin, and TerrainCoin acts as a versatile token for trade fee rebates and angel investing.

By combining these elements, TerrainProtocol introduces a novel approach to decentralized finance, offering scalability, privacy, and sustainable growth in the rapidly evolving landscape of Optimistic Superchain DeFi.
