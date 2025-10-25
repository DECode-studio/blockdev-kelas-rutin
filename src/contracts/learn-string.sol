// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract LearnString {
    string private plantName;

    constructor() {
        plantName = "Rose";
    }

    function getName() public view returns (string memory) {
        return plantName;
    }

    function changeName(string memory newName) public {
        plantName = newName;
    }
    
}