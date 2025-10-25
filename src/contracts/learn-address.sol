// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract LearnAddress {
    address public owner;
    address public gardener;

    constructor() {
        owner = msg.sender;
    }

    function setGardener(address _address) public {
        gardener = _address;
    }
}
