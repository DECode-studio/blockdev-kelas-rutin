// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract LearnNumber {
    uint256 public plantId;
    uint256 public waterLevel;

    constructor() {
        plantId = 1;
        waterLevel = 100;
    }

    function changePlatId(uint256 _plantId) public {
        plantId = _plantId;
    }

    function addWater(uint256 _waterLevel) public {
        waterLevel = _waterLevel;
    }

    function sumData() public view returns (uint256) {
        return plantId + waterLevel;
    }

    function sumParam(uint256 a, uint256 b) public pure returns (uint256) {
        return a + b;
    }
}
