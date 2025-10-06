// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract adminOnly {
    address public owner;
    uint256 public treasureAmount;
    mapping(address => uint256) public withdrawlAllowance;
    mapping(address => bool) hasWithdrawn;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function AddTreasure(uint256 amount) public onlyOwner {
        treasureAmount += amount;
    }

    function approveWithdrawl(
        address recipient,
        uint256 amount
    ) public onlyOwner {
        require(amount <= treasureAmount, "not enough");
        withdrawlAllowance[recipient] = amount;
    }

    function withdraw(uint256 amount) public {
        if (msg.sender == owner) {
            require(withdrawlAllowance[msg.sender] >= amount, "no allowance");
            require(hasWithdrawn[msg.sender] == false, "already withdrawn");
        }

        uint256 allowance = withdrawlAllowance[msg.sender];

        require(allowance > 0, "you don't have it");
        require(!hasWithdrawn[msg.sender], "already withdrawn");
        require(allowance <= treasureAmount, "not enough funds");
        require(allowance >= amount, "you can't withdraw more than allowed");

        hasWithdrawn[msg.sender] = true;
        treasureAmount -= allowance;
        withdrawlAllowance[msg.sender] = 0;
    }

    function resetWithdrawlStatus(address user) public {
        hasWithdrawn[user] = false;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "zero address");
        owner = newOwner;
    }

    function getTreasure() public view onlyOwner returns (uint256) {
        return treasureAmount;
    }
}
