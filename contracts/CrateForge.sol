// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract CrateForge {
    address public owner;
    uint256 public cratePrice;

    struct Item {
        string name;
        uint256 weight;
    }

    Item[] public lootPool;

    event CrateOpened(address indexed player, string itemName);

    constructor(uint256 _cratePrice) {
        owner = msg.sender;
        cratePrice = _cratePrice;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function addItem(string memory name, uint256 weight) external onlyOwner {
        lootPool.push(Item(name, weight));
    }

    function updateCratePrice(uint256 newPrice) external onlyOwner {
        cratePrice = newPrice;
    }

    function openCrate() external payable {
        require(msg.value == cratePrice, "Incorrect ETH sent");
        require(lootPool.length > 0, "No items in crate");

        uint256 totalWeight = 0;
        for (uint i = 0; i < lootPool.length; i++) {
            totalWeight += lootPool[i].weight;
        }

        uint256 rand = uint256(
            keccak256(abi.encodePacked(block.timestamp, msg.sender, block.difficulty))
        ) % totalWeight;

        uint256 cumulativeWeight = 0;
        for (uint i = 0; i < lootPool.length; i++) {
            cumulativeWeight += lootPool[i].weight;
            if (rand < cumulativeWeight) {
                emit CrateOpened(msg.sender, lootPool[i].name);
                break;
            }
        }
    }

    function withdrawFunds() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    function getAllItems() external view returns (Item[] memory) {
        return lootPool;
    }
}
