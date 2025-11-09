# 💰 CyptoBank Smart Contract

A simple **multi-user Ethereum bank** contract that allows users to **deposit and withdraw Ether** safely with per-user balance limits and admin controls.

---

## 🧾 Overview

The `CyptoBank` contract provides a minimalistic decentralized bank where:

- Users can **deposit and withdraw Ether** anytime.  
- Each user has a **maximum balance limit** (default: `5 ether`, configurable by admin).  
- Only the **admin** can modify the maximum balance or view the total funds held by the bank.  
- Every deposit and withdrawal emits an **event** for transparency.

---

## ⚙️ Features

- ✅ Multi-user deposits  
- ✅ Individual balance tracking  
- ✅ Withdrawal limited to own balance  
- ✅ Adjustable max balance per user  
- ✅ Admin-protected management functions  
- ✅ Informative revert messages  
- ✅ Event logs for all Ether movements  

---

## 📄 Contract Structure

| Section | Purpose |
|----------|----------|
| **State Variables** | Store balances, admin, and configuration |
| **Events** | Emit on deposit and withdrawal |
| **Modifiers** | Restrict access to admin-only functions |
| **Constructor** | Initialize `maxBalance` and `admin` address |
| **Functions** | Deposit, withdraw, and manage balance limits |

---

## 🔑 Functions

### `constructor(uint256 _maxBalance, address _admin)`
Initializes the contract with the maximum allowed balance per user and sets the admin address.

---

### `depositEther() external payable`
Allows any user to deposit Ether.  
- Requires `msg.value > 0`  
- Fails if total balance exceeds `maxBalance`  
- Emits `EtherDepositAmountEvent`

---

### `withdrawEther(uint _amount) external`
Lets users withdraw their own Ether.  
- Requires sufficient balance  
- Sends Ether using `.call{value: _amount}("")`  
- Emits `EtherWithdrawAmountEvent`

---

### `getBankBalance() public view adminOnly returns (uint)`
Returns the total Ether balance across all users.  
- **Admin-only**

---

### `modifyMoxBalance(uint _newMaxBalance) external adminOnly`
Allows admin to adjust the per-user max balance limit.

---

## 🧩 Events

| Event | Description |
|--------|--------------|
| `EtherDepositAmountEvent(address user, uint256 etherAmount)` | Triggered when a user deposits Ether |
| `EtherWithdrawAmountEvent(address user, uint256 etherAmount)` | Triggered when a user withdraws Ether |

---

## 🔒 Access Control

| Role | Permissions |
|-------|--------------|
| **Admin** | Modify `maxBalance`, view total bank funds |
| **User** | Deposit and withdraw own funds |

---

## 🧰 Dependencies

- [OpenZeppelin Contracts](https://github.com/OpenZeppelin/openzeppelin-contracts)
  ```solidity
  import "@openzeppelin/contracts/utils/Strings.sol";


## 🧪 Testing
**Example test flow in Remix:**
1. Deploy the contract  
   - `_maxBalance`: `5000000000000000000` (5 ether in wei)  
   - `_admin`: your wallet address  
2. Call `depositEther()` with **Value (ETH)** set to `1`  
3. Call `getBankBalance()` (as admin)  
4. Call `withdrawEther(0.5 ether)`  
5. Observe events and balances updating correctly