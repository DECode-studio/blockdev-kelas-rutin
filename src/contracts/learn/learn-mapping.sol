// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract LearnMapping {
    mapping(uint256 => uint8) public plantWater;
    mapping(uint256 => address) public plantOwner;

    struct Plant {
        uint256 id;
        address owner;
        uint8 waterLevel;
    }

    constructor() {}

    function getPlant(uint256 _plantId) public view returns (Plant memory) {
        require(plantOwner[_plantId] != address(0), "Plant does not exist");

        return
            Plant({
                id: _plantId,
                owner: plantOwner[_plantId],
                waterLevel: plantWater[_plantId]
            });
    }

    function addPlant(uint256 _plantId) public {
        require(plantOwner[_plantId] == address(0), "Plant dois exist");
        plantWater[_plantId] = 0;
        plantOwner[_plantId] = msg.sender;
    }

    function waterPlant(uint256 _plantId) public {
        plantWater[_plantId] = 100;
    }
}
