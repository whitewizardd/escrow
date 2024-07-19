// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Escrow {
    address public user;
    address public useer2;
    uint256 public amount;
    address[] public disputeResolver;
    uint8 immutable escrowCommission;

    constructor(address _user1, address _user2, uint256 _amount, address[] memory _resolver, uint8 commission) {
        user = _user1;
        user = _user2;
        amount = _amount;
        disputeResolver = _resolver;
        escrowCommission = commission;
    }
}
