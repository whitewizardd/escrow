// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import {Escrow} from "../src/Escrow.sol";

contract EscrowFactory {
    Escrow public escrows;
    address[] public resolvers;

    struct NewEscrow {
        address _user2;
        uint256 _amount;
        // address[] memory _resolver,
        bool isNFT;
        bool isPayer;
    }
    function createEscrow(NewEscrow memory _newEscrow) external {}
}
