example: 5% APY simulation

    struct Vault {
        uint256 id;
        address owner;
        address token;
        uint256 balance;
        uint256 lastUpdated;
        bool active;
    }

    mapping(uint256 => Vault) public vaults;
    mapping(address => uint256[]) public userVaults;

    event VaultCreated(uint256 indexed id, address indexed owner, address indexed token);
    event Deposited(uint256 indexed id, uint256 amount);
    event Withdrawn(uint256 indexed id, uint256 amount);
    event YieldGenerated(uint256 indexed id, uint256 yieldAmount);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin allowed");
        _;
    }

    modifier onlyOwner(uint256 _vaultId) {
        require(vaults[_vaultId].owner == msg.sender, "Not the vault owner");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    /**
     * @notice Create a new vault for a specific ERC20 token
     * @param _token Address of the ERC20 token
     */
    function createVault(address _token) external {
        require(_token != address(0), "Invalid token address");
        vaultCount++;

        vaults[vaultCount] = Vault({
            id: vaultCount,
            owner: msg.sender,
            token: _token,
            balance: 0,
            lastUpdated: block.timestamp,
            active: true
        });

        userVaults[msg.sender].push(vaultCount);

        emit VaultCreated(vaultCount, msg.sender, _token);
    }

    /**
     * @notice Deposit ERC20 tokens into a vault
     * @param _vaultId Vault ID
     * @param _amount Amount of tokens to deposit
     */
    function deposit(uint256 _vaultId, uint256 _amount) external onlyOwner(_vaultId) {
        Vault storage vault = vaults[_vaultId];
        require(vault.active, "Vault inactive");
        require(_amount > 0, "Invalid amount");

        IERC20 token = IERC20(vault.token);
        require(token.transferFrom(msg.sender, address(this), _amount), "Transfer failed");

        vault.balance += _amount;
        vault.lastUpdated = block.timestamp;

        emit Deposited(_vaultId, _amount);
    }

    /**
     * @notice Withdraw tokens from the vault
     * @param _vaultId Vault ID
     * @param _amount Amount to withdraw
     */
    function withdraw(uint256 _vaultId, uint256 _amount) external onlyOwner(_vaultId) {
        Vault storage vault = vaults[_vaultId];
        require(vault.balance >= _amount, "Insufficient balance");

        IERC20 token = IERC20(vault.token);
        require(token.transfer(msg.sender, _amount), "Withdraw failed");

        vault.balance -= _amount;
        vault.lastUpdated = block.timestamp;

        emit Withdrawn(_vaultId, _amount);
    }

    /**
     * @notice Generate and compound simulated yield (mock yield logic)
     * @param _vaultId Vault ID
     */
    function generateYield(uint256 _vaultId) external onlyAdmin {
        Vault storage vault = vaults[_vaultId];
        require(vault.active, "Vault inactive");

        uint256 timeElapsed = block.timestamp - vault.lastUpdated;
        if (timeElapsed == 0) return;

        uint256 yieldAmount = (vault.balance * YIELD_RATE * timeElapsed) / (100 * 365 days);
        vault.balance += yieldAmount;
        vault.lastUpdated = block.timestamp;

        emit YieldGenerated(_vaultId, yieldAmount);
    }

    /**
     * @notice Deactivate a vault permanently (admin only)
     * @param _vaultId Vault ID
     */
    function deactivateVault(uint256 _vaultId) external onlyAdmin {
        vaults[_vaultId].active = false;
    }

    /**
     * @notice View all vault IDs owned by a user
     * @param _owner Address of the user
     */
    function getVaultsByOwner(address _owner) external view returns (uint256[] memory) {
        return userVaults[_owner];
    }
}
// 
End
// 
