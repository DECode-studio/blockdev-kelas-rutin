// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract LiskGarden {
    address public owner;
    uint256 public constant MIN_DEPOSIT = 0.001 ether;
    uint256 public constant WATER_THRESHOLD = 500;

    enum GrowthStage {
        SEED,
        SPROUT,
        GROWING,
        BLOOMING
    }

    struct Plant {
        address owner;
        uint32 id;
        string name;
        GrowthStage stage;
        uint16 waterLevel;
        uint256 plantedTime;
        uint256 lastWatered;
        uint256 deposited;
        bool isAlive;
    }

    uint32 public plantCounter;
    mapping(address => Plant) public plants;

    event RewardGranted(address to, uint256 amount);
    event PlantAdded(uint32 plantId, address owner);
    event PlantWatered(
        uint32 plantId,
        address owner,
        uint16 newWaterLevel,
        GrowthStage newStage
    );

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner!");
        _;
    }

    modifier minimumDeposit() {
        require(msg.value >= MIN_DEPOSIT, "You should deposit 0.001 ETH");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function depositReward() public payable onlyOwner {}

    function addPlant(string memory _name) public payable minimumDeposit {
        require(bytes(_name).length > 0, "Plant name cannot be empty");

        plantCounter++;
        plants[msg.sender] = Plant({
            owner: msg.sender,
            id: plantCounter,
            name: _name,
            stage: GrowthStage.SEED,
            waterLevel: 0,
            plantedTime: block.timestamp,
            lastWatered: 0,
            deposited: msg.value,
            isAlive: true
        });

        emit PlantAdded(plantCounter, msg.sender);
    }

    function water() public payable minimumDeposit {
        Plant storage plant = plants[msg.sender];

        require(plant.owner != address(0), "Your plant is not found");
        require(plant.isAlive, "Your plant is not alive");
        require(
            plant.stage != GrowthStage.BLOOMING,
            "Yor plant has already BOOMING"
        );

        bool dead = isDead();
        if (dead) {
            plant.isAlive = false;
        }
        require(!dead, "Your plant is dead, you can't water it");

        uint256 depoValue = (msg.value / MIN_DEPOSIT) * 100;
        plant.waterLevel += uint16(depoValue);
        plant.lastWatered = block.timestamp;

        if (
            plant.waterLevel >= (WATER_THRESHOLD * (1)) &&
            plant.stage == GrowthStage.SEED
        ) {
            plant.stage = GrowthStage.SPROUT;
        } else if (
            plant.waterLevel >= (WATER_THRESHOLD * (2)) &&
            plant.stage == GrowthStage.SPROUT
        ) {
            plant.stage = GrowthStage.GROWING;
        } else if (
            plant.waterLevel >= (WATER_THRESHOLD * (3)) &&
            plant.stage == GrowthStage.GROWING
        ) {
            plant.stage = GrowthStage.BLOOMING;
            sendReward();
        }

        emit PlantWatered(plant.id, msg.sender, plant.waterLevel, plant.stage);
    }

    function calculateAge() public view returns (uint256) {
        Plant storage plant = plants[msg.sender];
        require(plant.owner != address(0), "Plant not found");

        uint256 currentTime = block.timestamp;
        uint256 age = currentTime - plant.plantedTime;

        return age;
    }

    function isDead() public view returns (bool) {
        Plant storage plant = plants[msg.sender];
        require(plant.owner != address(0), "Plant not found");

        uint256 lastWatered = plant.lastWatered;
        GrowthStage stage = plant.stage;

        if (lastWatered == 0 || stage == GrowthStage.BLOOMING) {
            return false;
        }

        uint256 timeSinceWatered = block.timestamp - lastWatered;
        return timeSinceWatered >= 3 minutes;
    }

    function sendReward() private {
        Plant storage plant = plants[msg.sender];
        require(plant.owner != address(0), "Your plant is not found");

        uint16 multiply = uint16(plant.waterLevel / 1500);
        require(multiply > 0, "No reward yet");

        uint256 reward = MIN_DEPOSIT * multiply;
        require(address(this).balance >= reward, "Not enough ETH in contract");

        (bool sent, ) = payable(msg.sender).call{value: reward}("");
        require(sent, "Failed to send reward");

        emit RewardGranted(msg.sender, reward);
    }
}
