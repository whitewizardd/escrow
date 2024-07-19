// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import {Escrow} from "../src/Escrow.sol";

contract EscrowFactory {
    Escrow[] public escrows;
    address[] public escrowsAddresses;
    address[] public resolvers;
    address public allowedToken;

    struct NewEscrow {
        address _user2;
        uint256 _amount;
        // address[] memory _resolver,
        bool isNFT;
        bool isPayer;
    }
    function createEscrow(NewEscrow memory _newEscrow) external {
        Escrow escrow = new Escrow(
            msg.sender,
            _newEscrow._user2,
            _newEscrow._amount,
            resolvers,
            _newEscrow.isNFT,
            _newEscrow.isPayer,
            allowedToken
        );
        escrows.push(escrow);
        escrowsAddresses.push(address(escrow));
    }
}
