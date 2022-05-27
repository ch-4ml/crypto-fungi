// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "./FungusFeeding.sol";

contract FungusOwnership is FungusFeeding {

    // 각 토큰에 대해 대리 전송 승인받은 주소를 mapping
    mapping (uint => address) private operatorApproval;

    // 토큰 전송 시 발생하는 event
    event Transfer(address indexed from, address indexed to, uint256 tokenId);
    // 토큰 전송 승인 시 발생하는 event
    event Approval(address indexed owner, address indexed approved, uint256 tokenId);

    function balanceOf(address owner) public view returns (uint balance) {
        return ownerFungusCount[owner];
    }

    function ownerOf(uint tokenId) public view returns (address owner) {
        return fungusToOwner[tokenId];
    }

    function transferFrom(address from, address to, uint tokenId) public {
        // 토큰의 소유자 또는 운영자만 호출할 수 있음
        require(_msgSender() == operatorApproval[tokenId] || _msgSender() == ownerOf(tokenId), "transferFrom caller is not owner nor approved operator");
        _transfer(from, to, tokenId);
    }

    // 토큰 소유자 대신 transfer를 호출할 수 있는 (토큰 전송 승인받은) 운영자 지정
    function approveToken(address to, uint256 tokenId) public {
        address owner = ownerOf(tokenId);

        require(to != owner, "approval to current owner");
        // 토큰의 소유자 또는 운영자만 호출할 수 있음
        require(
            _msgSender() == owner || _msgSender() == operatorApproval[tokenId],
            "approve caller is not owner nor approved operator"
        );

        _approveToken(to, tokenId);
    }

    // 토큰 전송
    function _transfer(address from, address to, uint tokenId) private {
        // 반드시 보내는 주소는 해당 토큰의 소유자여야 함
        require(ownerOf(tokenId) == from, "transfer from incorrect owner");
        // 받는 주소는 zero address가 아니어야 함, 즉 수신자가 있어야 함
        require(to != address(0), "transfer to the zero address");
        
        // 전송한 토큰의 소유자가 변경되었기 때문에 approve를 초기화
        _approveToken(address(0), tokenId);
        
        // 토큰의 보유량과 소유권 변경
        ownerFungusCount[from]--;
        ownerFungusCount[to]++;
        fungusToOwner[tokenId] = to;

        // Transfer 이벤트 발생
        emit Transfer(from, to, tokenId);
    }

    function _approveToken(address to, uint tokenId) private {
        operatorApproval[tokenId] = to;
        emit Approval(ownerOf(tokenId), to, tokenId);
    }
}