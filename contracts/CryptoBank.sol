// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

/*
Main Functions:
    - Deposit ether
    - Withdraw ether
Rules:
    - Multiuser
    - Can only deposit ether
    - User can only withdraw from its own balance
    - Max balance -> 5 ether (or set by admin)
    - Max balance can be modified by admin
*/

import "@openzeppelin/contracts/utils/Strings.sol";
using Strings for uint256;

contract CyptoBank {
    // --- State variables ---
    uint256 public maxBalance; // Maximum ether a user can hold in the bank
    address admin; // Contract administrator (owner)

    address[] private users; // List of all users who have deposited
    mapping(address => uint256) public userBalance; // Tracks each user's ether balance
    mapping(address => bool) private added; // Prevents duplicate users in array

    // --- Events ---
    event EtherDepositAmountEvent(address user, uint256 etherAmount);
    event EtherWithdrawAmountEvent(address user, uint256 etherAmount);

    // --- Modifiers ---
    // Restricts certain functions to be executed only by the admin
    modifier adminOnly() {
        require(msg.sender == admin, "You are not admin");
        _;
    }

    // Initializes contract with a maximum balance limit and sets the admin address
    constructor(uint256 _maxBalance, address _admin) {
        maxBalance = _maxBalance;
        admin = _admin;
    }

    /**
     * @notice Returns total ether held by all users in the bank
     * @dev Only admin can call this function
     */
    function getBankBalance() public view adminOnly returns (uint) {
        uint256 totalBalance = 0;

        // Sum all user balances
        for (uint256 x = 0; x < users.length; x++) {
            totalBalance += userBalance[users[x]];
        }

        return totalBalance;
    }

    /**
     * @notice Allows users to deposit ether into their balance
     * @dev Enforces maxBalance per user and emits deposit event
     */
    function depositEther() external payable {
        require(msg.value > 0, "Value must be greater than 0");

        // Prevent exceeding max balance
        require(
            userBalance[msg.sender] + msg.value <= maxBalance,
            string.concat(
                "Max balance is ",
                maxBalance.toString(),
                " and your total balance would be ",
                (userBalance[msg.sender] + msg.value).toString()
            )
        );

        // Update user's balance
        userBalance[msg.sender] += msg.value;

        // Add user to list if not already present
        if (!added[msg.sender]) {
            users.push(msg.sender);
            added[msg.sender] = true;
        }

        // Emit deposit event
        emit EtherDepositAmountEvent(msg.sender, msg.value);
    }

    /**
     * @notice Allows users to withdraw ether from their own balance
     * @param _amount The amount of ether to withdraw
     */
    function withdrawEther(uint _amount) external {
        // Check user has enough balance
        require(
            userBalance[msg.sender] >= _amount,
            "Balance is lower than requested value"
        );

        // Deduct before sending to prevent reentrancy
        userBalance[msg.sender] -= _amount;

        // Transfer ether to user
        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "Transfer failed");

        // Emit withdraw event
        emit EtherWithdrawAmountEvent(msg.sender, _amount);
    }

    /**
     * @notice Allows admin to modify the maximum allowed balance per user
     * @param _newMaxBalance The new max balance limit
     */
    function modifyMoxBalance(uint _newMaxBalance) external adminOnly {
        maxBalance = _newMaxBalance;
    }
}
