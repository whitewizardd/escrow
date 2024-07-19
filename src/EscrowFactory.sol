// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import {Escrow} from "../src/Escrow.sol";

contract EscrowFactory {
    Escrow[] public escrows;
    address[] public escrowsAddresses;
    address[] public resolvers;
    address public allowedToken;
    mapping(address => address[]) public usersEscrow;
    mapping(address => mapping(address => address[])) public userUserEscrow;

    address public owner;

    struct NewEscrow {
        address _user2;
        uint256 _amount;
        // address[] memory _resolver,
        bool isNFT;
        bool isPayer;
    }

    constructor(address _token) {
        owner = msg.sender;
        resolvers.push(msg.sender);
        allowedToken = _token;
    }

    function createEscrow(
        NewEscrow memory _newEscrow
    ) external returns (address) {
        Escrow escrow = new Escrow(
            msg.sender,
            _newEscrow._user2,
            _newEscrow._amount,
            resolvers,
            _newEscrow.isNFT,
            _newEscrow.isPayer,
            allowedToken
        );
        address newEscrow = address(escrow);
        escrows.push(escrow);
        escrowsAddresses.push(newEscrow);
        usersEscrow[msg.sender].push(newEscrow);
        userUserEscrow[msg.sender][_newEscrow._user2].push(newEscrow);
        return newEscrow;
    }

    function getAllEscrow() external view returns (address[] memory) {
        return escrowsAddresses;
    }

    function getEscrowsWithAddress(
        address userAddress
    ) external view returns (address[] memory) {
        return userUserEscrow[msg.sender][userAddress];
    }

    function addResolver(address _resolver) external {
        require(msg.sender == owner, "only owner can perform this action");
        resolvers.push(_resolver);
    }

    function addResolvers(address[] memory _resolver) external {
        require(msg.sender == owner, "only owner can perform this action");
        for (uint i = 0; i < _resolver.length; i++) {
            resolvers.push(_resolver[i]);
        }
    }

    function changeAllowedToken(address newTokenAddress) external {
        require(msg.sender == owner, "only owner can perform this action");
        // require(newTokenAddress.code.length > 0, "not a contract address");
        require(isContract(newTokenAddress), "not a contract address");
        allowedToken = newTokenAddress;
    }

    function isContract(address _token) private view returns (bool) {
        uint codeSize = 0;
        assembly {
            codeSize := extcodesize(_token)
        }
        return codeSize > 0;
    }
}
