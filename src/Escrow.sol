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

    struct DisputeReason {
        address sender;
        string message;
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
    DisputeReason[] private disputeReasons;

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
        //require confirm paymnt;
        if (isPayer) {
            uint amountApproved = IERC20(_token).allowance(user, address(this));
            require(
                amountApproved >= _amount,
                "approved amount not match with escrow amount."
            );
        }
    }

    modifier approvedUsers() {
        for (uint i = 0; i < disputeResolver.length; i++) {
            require(
                msg.sender == disputeResolver[i] ||
                    msg.sender == useer2 ||
                    msg.sender == user
            );
        }
        _;
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
                useer2,
                address(this),
                amount
            );
            require(success);
            contratctState = ContractState.IS_ACTIVE;
        }
    }

    function releaseFund() external {
        require(contratctState == ContractState.IS_ACTIVE, "escrow not active");
        if (isCreatorPaying) {
            require(msg.sender == user, "only payer can perform this action");
            IERC20(token).transfer(useer2, amount);
        } else {
            require(msg.sender == useer2, "only payer can perform this action");
            IERC20(token).transfer(user, amount);
        }
    }

    function createDispute(string memory _message) external {
        require(contratctState == ContractState.IS_ACTIVE, "escrow not active");
        require(msg.sender == user || msg.sender == useer2);
        disputeReasons.push(
            DisputeReason({sender: msg.sender, message: _message})
        );
        contratctState = ContractState.DISPUTE;
    }

    function answerDispute(string memory _message) external approvedUsers {
        require(
            contratctState == ContractState.IS_ACTIVE,
            "only disputed escrow can be treated here"
        );
        disputeReasons.push(
            DisputeReason({sender: msg.sender, message: _message})
        );
    }

    function getEscrowDisputeReasons()
        external
        view
        returns (DisputeReason[] memory reasons)
    {
        reasons = disputeReasons;
    }
}
