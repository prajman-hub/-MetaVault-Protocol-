@notice Deposit ETH into the vault
    function deposit() external payable {
        require(msg.value > 0, "Deposit must be greater than zero");
        balances[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    /@notice Get the ETH balance of a user
    function getBalance(address user) external view returns (uint256) {
        return balances[user];
    }
}
// 
update
// 
