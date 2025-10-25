// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract LearnEnum {
    enum GrowthStage {
        Seed,
        Sprout,
        Mature,
        Bloom
    }

    GrowthStage public currentStage;

    constructor() {
        currentStage = GrowthStage.Seed;
    }

    function grow() public {
        if (currentStage == GrowthStage.Seed) {
            currentStage = GrowthStage.Sprout;
        } else if (currentStage == GrowthStage.Sprout) {
            currentStage = GrowthStage.Mature;
        } else if (currentStage == GrowthStage.Mature) {
            currentStage = GrowthStage.Bloom;
        }
    }
}
