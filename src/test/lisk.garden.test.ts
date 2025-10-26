import { SignerWithAddress } from "@nomicfoundation/hardhat-ethers/signers";
import { ethers } from "hardhat";
import { PlantGame } from "../../typechain-types";
import { ContractTransactionResponse, EventLog, Log } from "ethers";
import { expect } from "chai";

describe("LiskGarden", () => {
    let owner: SignerWithAddress;
    let player1: SignerWithAddress;
    let player2: SignerWithAddress;
    let contract: PlantGame & { deploymentTransaction(): ContractTransactionResponse };

    before(async () => {
        [owner, player1, player2] = await ethers.getSigners();
        const contractFactory = await ethers.getContractFactory("PlantGame");
        contract = await contractFactory.deploy();
    });

    it("should deploy contract", async () => {
        const deployer = await contract.owner();
        expect(deployer).to.equal(owner.address);
    });

    it("should allow owner to deposit reward", async () => {
        const depositTx = await contract.connect(owner).depositReward({ value: ethers.parseEther("1") });
        await depositTx.wait();

        const contractAddress = await contract.getAddress();
        const balance = await ethers.provider.getBalance(contractAddress);
        expect(balance).to.equal(ethers.parseEther("1"));
    });

    it("should revert if non-owner tries to deposit reward", async () => {
        await expect(
            contract.connect(player1).depositReward({ value: ethers.parseEther("1") })
        ).to.be.revertedWith("Only owner!");
    });

    it("should allow player to add plant", async () => {
        const tx = await contract.connect(player1).addPlant("The Tormentor", {
            value: ethers.parseEther("0.001"),
        });
        await tx.wait();

        const plant = await contract.plants(player1.address);
        expect(plant.name).to.equal("The Tormentor");
        expect(plant.stage).to.equal(0);
        expect(plant.isAlive).to.be.true;
    });

    it("should revert when adding plant without deposit", async () => {
        await expect(
            contract.connect(player2).addPlant("NoMoney", { value: 0 })
        ).to.be.revertedWith("You should deposit 0.001 ETH");
    });

    it("should revert watering when player has no plant", async () => {
        await expect(
            contract.connect(player2).water({ value: ethers.parseEther("0.001") })
        ).to.be.revertedWith("Your plant is not found");
    });

    it("should allow watering and emit event", async () => {
        const tx = await contract.connect(player1).water({ value: ethers.parseEther("0.001") });
        const receipt = await tx.wait();

        const event = receipt?.logs.find((log: Log | EventLog) => (log as EventLog).fragment?.name === "PlantWatered");
        expect((event as EventLog)?.args?.owner).to.equal(player1.address);

        const plant = await contract.plants(player1.address);
        expect(plant.waterLevel).to.be.greaterThan(0);
        expect(plant.stage).to.be.oneOf([0n, 1n]);
    });

    it("should return correct age of plant", async () => {
        const age = await contract.connect(player1).calculateAge();
        expect(age).to.be.a("bigint");
    });

    it("should not be dead right after watering", async () => {
        const dead = await contract.connect(player1).isDead();
        expect(dead).to.be.false;
    });
});
