// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title MetaVault Protocol
 * @dev A simple vault system to deposit, withdraw, and check balance.
 */
contract Project {
    mapping(address => uint256) private balances;
    address public owner;

    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    /// @notice Deposit ETH into the vault
    function deposit() external payable {
        require(msg.value > 0, "Deposit must be greater than zero");
        balances[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    /// @notice Withdraw a specific amount from the vault
    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        emit Withdrawn(msg.sender, amount);
    }

    /// @notice Get the ETH balance of a user
    function getBalance(address user) external view returns (uint256) {
        return balances[user];
    }
}
