// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract SimplePlant {
    string public plantName;
    uint256 public waterLevel;
    bool public isAlive;
    address public owner;
    uint256 public plantedTime;

    constructor() {
        owner = msg.sender;
        plantName = "The Tormentor";
        waterLevel = 0;
        isAlive = true;
        plantedTime = block.timestamp;
    }

    function water() public {
        require(isAlive, "The plant is dead and cannot be watered.");
        waterLevel += 100;
    }

    function getAge() public view returns (uint256) {
        return block.timestamp - plantedTime;
    }
}
