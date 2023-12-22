// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract TerrainTreasury is ERC20("TerrainCoin", "TERRAIN"), Ownable {
    using SafeMath for uint256;

    address public railgunTrader;
    uint256 public minEthForMint = 30 ether; // Minimum ETH required to trigger minting
    uint256 public terrainPerEth = 1000; // Terrain to ETH mint ratio
    uint256 public nextMintThreshold;

    event MintTerrainCoin(address indexed recipient, uint256 ethAmount, uint256 terrainAmount);

    
    function mintTerrainCoin() external {
    //(Minting logic)
    TerrainCoin(RailgunTrader(railgunTrader).terrainCoin()).mintTerrainCoin{value: address(this).balance}(terrainCoinAmount);
    }

    constructor(address _railgunTrader) {
        railgunTrader = _railgunTrader;
        nextMintThreshold = minEthForMint;
    }

    modifier onlyRailgunTrader() {
        require(msg.sender == railgunTrader, "Only RailgunTrader can call this function");
        _;
    }

    function mintTerrainCoin(uint256 _ethAmount) external onlyOwner {
        require(_ethAmount >= nextMintThreshold, "Insufficient ETH for minting");

        uint256 terrainAmount = _ethAmount.mul(terrainPerEth);
        _mint(msg.sender, terrainAmount);

        emit MintTerrainCoin(msg.sender, _ethAmount, terrainAmount);

        // Update next mint threshold
        nextMintThreshold = nextMintThreshold.add(minEthForMint);
    }

    function sellTerrainCoin(uint256 _ethAmount) external onlyRailgunTrader {
        require(_ethAmount > 0, "ETH amount must be greater than 0");
        require(balanceOf(msg.sender) >= _ethAmount.mul(terrainPerEth), "Insufficient TerrainCoin balance");

        // Burn TerrainCoin
        _burn(msg.sender, _ethAmount.mul(terrainPerEth));

        // Trigger trade logic in RailgunTrader.sol
        RailgunTrader(railgunTrader).sellTerrainCoin(_ethAmount);
    }

    function setRailgunTrader(address _railgunTrader) external onlyOwner {
        railgunTrader = _railgunTrader;
    }

    function setMinEthForMint(uint256 _minEthForMint) external onlyOwner {
        minEthForMint = _minEthForMint;
    }

    function setTerrainPerEth(uint256 _terrainPerEth) external onlyOwner {
        terrainPerEth = _terrainPerEth;
    }
}
