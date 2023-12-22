// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract RailgunTrader {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    address public admin;
    IERC20 public usdc;

    enum OrderType {BUY, SELL}

    TerrainCoin public terrainCoin;
    TerrainTreasury public terrainTreasury;


constructor(address _terrainTreasury, address _terrainCoin) {
    terrainTreasury = TerrainTreasury(_terrainTreasury);
    terrainCoin = TerrainCoin(_terrainCoin);
}



    struct Order {
        OrderType orderType;
        address trader;
        uint256 amount;
        uint256 price;
    }

    struct Trade {
        address buyer;
        address seller;
        uint256 amount;
        uint256 price;
    }

    mapping(address => mapping(uint256 => Order[])) private orderBook;
    uint256 public currentWindowEnd;
    uint256 public windowSize = 10 minutes;

    // New mapping to store matched trades
    mapping(uint256 => Trade[]) private matchedTrades;

    event OrderPlaced(
        OrderType indexed orderType,
        address indexed trader,
        uint256 amount,
        uint256 price
    );

    event TradeExecuted(
        address indexed buyer,
        address indexed seller,
        uint256 amount,
        uint256 price
    );

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not authorized");
        _;
    }

    constructor(address _usdc) {
        admin = msg.sender;
        usdc = IERC20(_usdc);
        currentWindowEnd = block.timestamp.add(windowSize);
    }

    function placeOrder(OrderType _orderType, uint256 _amount, uint256 _price) external {
        require(_amount > 0, "Amount must be greater than 0");
        require(_price > 0, "Price must be greater than 0");
        require(block.timestamp < currentWindowEnd, "Trading window closed");

        Order memory newOrder = Order({
            orderType: _orderType,
            trader: msg.sender,
            amount: _amount,
            price: _price
        });

        orderBook[msg.sender][currentWindowEnd].push(newOrder);
        emit OrderPlaced(_orderType, msg.sender, _amount, _price);
    }

    function executeTrades() external onlyAdmin {
        require(block.timestamp >= currentWindowEnd, "Window not closed yet");

        Order[] storage buys = orderBook[address(this)][currentWindowEnd];
        Order[] storage sells = orderBook[address(this)][currentWindowEnd];

        for (uint256 i = 0; i < buys.length; i++) {
            for (uint256 j = 0; j < sells.length; j++) {
                if (buys[i].price >= sells[j].price) {
                    uint256 tradeAmount = buys[i].amount <= sells[j].amount ? buys[i].amount : sells[j].amount;

                    // Add matched trades to the storage
                    matchedTrades[currentWindowEnd].push(Trade({
                        buyer: buys[i].trader,
                        seller: sells[j].trader,
                        amount: tradeAmount,
                        price: sells[j].price
                    }));

                    // Update the order amounts
                    buys[i].amount = buys[i].amount.sub(tradeAmount);
                    sells[j].amount = sells[j].amount.sub(tradeAmount);

                    if (buys[i].amount == 0) {
                        // Remove fully filled buy order
                        buys[i] = buys[buys.length - 1];
                        buys.pop();
                    }

                    if (sells[j].amount == 0) {
                        // Remove fully filled sell order
                        sells[j] = sells[sells.length - 1];
                        sells.pop();
                    }
                }
            }
        }

        // Clear trades for the next window
        delete orderBook[address(this)][currentWindowEnd];
        currentWindowEnd = block.timestamp.add(windowSize);

        // Execute matched trades
        executeMatchedTrades(currentWindowEnd);
    }

    // Function to execute matched trades
    function executeMatchedTrades(uint256 _windowEnd) internal {
        Trade[] storage trades = matchedTrades[_windowEnd];

        for (uint256 i = 0; i < trades.length; i++) {
            // Execute the trade logic
            usdc.safeTransferFrom(trades[i].buyer, trades[i].seller, trades[i].amount.mul(trades[i].price));
            payable(trades[i].buyer).transfer(trades[i].amount);

            emit TradeExecuted(trades[i].buyer, trades[i].seller, trades[i].amount, trades[i].price);
        }

        // Clear matched trades
        delete matchedTrades[_windowEnd];
    }

    function getOrderBookLength() external view returns (uint256) {
        return orderBook[msg.sender][currentWindowEnd].length;
    }
}
