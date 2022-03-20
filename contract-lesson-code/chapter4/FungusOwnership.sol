// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "./FungusFeeding.sol";

contract FungusOwnership is FungusFeeding {

    mapping (uint => address) private operatorApproval;

    event Transfer(address indexed from, address indexed to, uint256 tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 tokenId);

    function balanceOf(address owner) public view returns (uint balance) {
        return ownerFungusCount[owner];
    }

    function ownerOf(uint tokenId) public view returns (address owner) {
        return fungusToOwner[tokenId];
    }

    function transferFrom(address from, address to, uint tokenId) public {
        require(_msgSender() == operatorApproval[tokenId] || _msgSender() == ownerOf(tokenId), "transferFrom caller is not owner nor approved operator");
        _transfer(from, to, tokenId);
    }

    // 토큰 소유자 대신 transfer를 호출할 수 있는 운영자 지정
    function approve(address to, uint256 tokenId) public onlyOwnerOf(tokenId) {
        address owner = ownerOf(tokenId);
        require(to != owner, "approval to current owner");
        require(
            _msgSender() == owner || _msgSender() == operatorApproval[tokenId],
            "approve caller is not owner nor approved operator"
        );

        _approve(to, tokenId);
    }

    function _transfer(address from, address to, uint tokenId) private {
        require(ownerOf(tokenId) == from, "transfer from incorrect owner");
        require(to != address(0), "transfer to the zero address");
        
        _approve(address(0), tokenId);
        
        ownerFungusCount[from]--;
        ownerFungusCount[to]++;
        fungusToOwner[tokenId] = to;
        emit Transfer(from, to, tokenId);
    }

    function _approve(address to, uint tokenId) private {
        operatorApproval[tokenId] = to;
        emit Approval(ownerOf(tokenId), to, tokenId);
    }
}