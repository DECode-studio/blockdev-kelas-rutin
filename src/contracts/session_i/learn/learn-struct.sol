// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract LearnStruct {
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
        bool isLive;
    }

    Plant public myPlant;

    constructor() {
        myPlant = Plant({
            id: 1,
            owner: msg.sender,
            stage: GrowthStage.SEED,
            waterLevel: 0,
            isLive: true
        });
    }

    function water() public {
        myPlant.waterLevel += 100;
    }

    function grow() public {
        if (myPlant.stage == GrowthStage.SEED) {
            myPlant.stage = GrowthStage.SPROUT;
        } else if (myPlant.stage == GrowthStage.SPROUT) {
            myPlant.stage = GrowthStage.GROWING;
        } else if (myPlant.stage == GrowthStage.GROWING) {
            myPlant.stage = GrowthStage.BLOOMING;
        }
    }
}
