// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract MultiplePlants {
    enum GrowthStage {
        SEED,
        SPROUT,
        GROWING,
        BLOOMING
    }

    struct Plant {
        uint256 id;
        address owner;
        GrowthStage stage;
        uint8 waterLevel;
        bool exists;
    }

    mapping(uint256 => Plant) public plants;
    uint256 public plantCounter;

    function addPlant() public returns (uint256) {
        plantCounter++;
        plants[plantCounter] = Plant({
            id: plantCounter,
            owner: msg.sender,
            stage: GrowthStage.SEED,
            waterLevel: 0,
            exists: true
        });

        return plantCounter;
    }

    function waterPlant(uint256 _plantId) public {
        require(plants[_plantId].exists, "Plant does not exist");
        require(plants[_plantId].owner == msg.sender, "Not the owner");

        plants[_plantId].waterLevel += 100;
    }

    function getPlant(uint256 _plantId) public view returns (Plant memory) {
        require(plants[_plantId].exists, "Plant does not exist");
        require(plants[_plantId].owner == msg.sender, "Not the owner");

        return plants[_plantId];
    }
}
