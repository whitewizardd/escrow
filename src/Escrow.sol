// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import {IERC20} from "../src/interfaces/IERC20.sol";

contract Escrow {
    enum ContractState {
        IS_AWAITING_CONFIRMATION,
        IS_ACTIVE,
        IS_CLOSED,
        DISPUTE
    }

    address public user;
    address public useer2;
    uint256 public amount;
    address[] public disputeResolver;
    uint256 public timeCreated;
    uint256 public timeConfirmed;
    bool public nftDeal;
    bool public isCreatorPaying;
    address public token;
    ContractState public contratctState;

    constructor(
        address _user1,
        address _user2,
        uint256 _amount,
        address[] memory _resolver,
        bool isNFT,
        bool isPayer,
        address _token
    ) payable {
        user = _user1;
        user = _user2;
        amount = _amount;
        disputeResolver = _resolver;
        timeCreated = block.timestamp;
        nftDeal = isNFT;
        isCreatorPaying = isPayer;
        token = _token;
        contratctState = ContractState.IS_AWAITING_CONFIRMATION;
        if (isPayer) IERC20(_token).approve(address(this), amount);
    }

    function confirmEscrow() external {
        require(
            msg.sender == useer2,
            "only the other party spcified can perform this action."
        );
        if (isCreatorPaying) {
            bool success = IERC20(token).transferFrom(
                user,
                address(this),
                amount
            );
            require(success);
            contratctState = ContractState.IS_ACTIVE;
        } else {
            bool success = IERC20(token).transferFrom(
                user,
                address(this),
                amount
            );
            require(success);
            contratctState = ContractState.IS_ACTIVE;
        }
    }
}
