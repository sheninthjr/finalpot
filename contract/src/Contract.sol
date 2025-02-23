// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Contract { 
    address public lastDepositor;
    uint256 public lastDepositTime;
    uint256 public constant TIME_LIMIT = 24 hours;

    event Deposit(address indexed user, uint256 amount, uint256 timestamp);
    event Withdraw(address indexed user, uint256 amount);

    function deposit() public payable {
        require(msg.value > 0, "Must send ETH");
        lastDepositor = msg.sender;
        uint256 timestamp = block.timestamp;
        lastDepositTime = timestamp;
        emit Deposit(msg.sender, msg.value, timestamp);
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function claimRewards() public {
        require(msg.sender == lastDepositor, "You're not the last depositor");
        require(block.timestamp >= lastDepositTime + TIME_LIMIT, "24 Hours not passed");
        uint256 balance = address(this).balance;
        require(balance > 0, "No Eth in the contract");
        payable(lastDepositor).transfer(balance);
        emit Withdraw(lastDepositor, balance);
        lastDepositor = address(0);
        lastDepositTime = 0;
    }
}
