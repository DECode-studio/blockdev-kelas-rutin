// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract LearnArray {
    uint256[] public allPlantIds;

    function addPlantId(uint256 plantId) public {
        allPlantIds.push(plantId);
    }

    function getTotalPlants() public view returns (uint256) {
        return allPlantIds.length;
    }

    function getAllPlants() public view returns (uint256[] memory) {
        return allPlantIds;
    }
}
