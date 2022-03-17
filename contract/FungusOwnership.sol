// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "./FungusFeeding.sol";

contract FungusOwnership is FungusFeeding {

    mapping (uint => address) fungusApprovals;

    event Transfer(address indexed from, address indexed to, uint256 tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 tokenId);

    function balanceOf(address owner) public view returns (uint balance) {
        return ownerFungusCount[owner];
    }

    function ownerOf(uint tokenId) public view returns (address owner) {
        return fungusToOwner[tokenId];
    }

    function transferFrom(address from, address to, uint tokenId) public {
        require(msg.sender == ownerOf(tokenId) || msg.sender == fungusApprovals[tokenId]);
        _transfer(from, to, tokenId);
    }

    function approve(address to, uint256 tokenId) public onlyOwnerOf(tokenId) {
        _approve(to, tokenId);
    }

    function _transfer(address from, address to, uint tokenId) private {
        ownerFungusCount[from]++;
        ownerFungusCount[to]--;
        fungusToOwner[tokenId] = to;
        emit Transfer(from, to, tokenId);
    }

    function _approve(address to, uint tokenId) private {
        fungusApprovals[tokenId] = to;
        emit Approval(ownerOf(tokenId), to, tokenId);
    }
}