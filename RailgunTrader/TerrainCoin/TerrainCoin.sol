// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@optimism/smartcontracts-core/contracts/libraries/token/OVM/ERC20/OVM_ProxyableERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./RailgunTrader.sol";

contract TerrainCoin is OVM_ProxyableERC20, Ownable {
    // Address of the RailgunTrader contract for rebate and fee coverage
    address public railgunTrader;

    // Rate of TerrainCoin minting per ETH
    uint256 public constant MINT_RATE = 1000;

    // Events
    event MintTerrainCoin(address indexed account, uint256 ethAmount, uint256 terrainCoinAmount);
    event BorrowUSDC(address indexed borrower, uint256 usdcAmount);
    event TerrainRebate(address indexed account, uint256 rebateAmount);
    event TerrainBack(address indexed account, uint256 terrainCoinAmount);

    // Constructor
    constructor(address _railgunTrader) OVM_ProxyableERC20("TerrainCoin", "TERRAIN") {
        railgunTrader = _railgunTrader;
    }

    
    contract TerrainCoin is OVM_ProxyableERC20, Ownable {
    // (Contract code)
    }

    // Function to mint TerrainCoin by sending ETH to the TerrainTreasury contract
    function mintTerrainCoin(uint256 _ethAmount) external {
        require(msg.sender == owner, "Only the owner can mint TerrainCoin");
        uint256 terrainCoinAmount = _ethAmount * MINT_RATE;
        _mint(msg.sender, terrainCoinAmount);
        emit MintTerrainCoin(msg.sender, _ethAmount, terrainCoinAmount);
    }

    // Function to borrow USDC using TerrainCoin as collateral
    function borrowUSDC(uint256 _usdcAmount) external {
        require(_usdcAmount > 0, "Borrowed amount must be greater than 0");
        require(balanceOf(msg.sender) >= _usdcAmount, "Insufficient TerrainCoin balance");

        // Transfer USDC from the RailgunTrader to the borrower
        require(RailgunTrader(railgunTrader).transferUSDC(msg.sender, _usdcAmount), "USDC transfer failed");

        // Burn TerrainCoin from the borrower's balance
        _burn(msg.sender, _usdcAmount);

        emit BorrowUSDC(msg.sender, _usdcAmount);
    }

    // Function to check if an account is eligible for TerrainRebate
    function checkTerrainRebateEligibility(address _account) external view returns (bool) {
        return RailgunTrader(railgunTrader).getTotalETHTraded(_account) > 10 ether;
    }

    // Function to claim TerrainCoin rebate
    function claimTerrainRebate() external {
        require(RailgunTrader(railgunTrader).getTotalETHTraded(msg.sender) > 10 ether, "Not eligible for rebate");
        uint256 rebateAmount = RailgunTrader(railgunTrader).getTradeFee(msg.sender) / 5; // 20% rebate
        _mint(msg.sender, rebateAmount);
        emit TerrainRebate(msg.sender, rebateAmount);
    }

    // Function to cover trade fees using TerrainCoin
    function terrainBack(uint256 _terrainCoinAmount) external {
        require(_terrainCoinAmount > 0, "TerrainCoin amount must be greater than 0");
        require(balanceOf(msg.sender) >= _terrainCoinAmount, "Insufficient TerrainCoin balance");

        // Burn TerrainCoin from the sender's balance
        _burn(msg.sender, _terrainCoinAmount);

        // Cover trade fees in the RailgunTrader contract
        RailgunTrader(railgunTrader).coverTradeFees(msg.sender, _terrainCoinAmount);

        emit TerrainBack(msg.sender, _terrainCoinAmount);
    }

    // Function to update the address of the RailgunTrader contract
    function setRailgunTrader(address _railgunTrader) external onlyOwner {
        railgunTrader = _railgunTrader;
    }
}
