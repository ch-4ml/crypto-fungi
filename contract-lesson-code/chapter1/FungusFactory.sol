// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

contract FungusFactory {

    // RED: 3, GREEN: 3, BLUE: 3, ALPHA: 3, Species: 2
    uint dnaDigits = 14;
    uint dnaModulus = 10 ** dnaDigits;

    struct Fungus {
        string name;
        uint dna;
    }

    Fungus[] public fungi;

    mapping (uint => address) public fungusToOwner;
    mapping (address => uint) public ownerFungusCount;

    function _createFungus(string memory name, uint dna) private {
        fungi.push(Fungus(name, dna));
        uint id = fungi.length - 1;
        fungusToOwner[id] = msg.sender;
        ownerFungusCount[msg.sender]++;
    }

    function _generateRandomDna(string calldata _str) private view returns (uint) {
        uint rand = uint(keccak256(bytes(_str)));
        uint dna = rand % dnaModulus;
        dna = dna - dna % 100;
        return dna;
    }

    function createRandomFungus(string calldata name) public {
        require(ownerFungusCount[msg.sender] == 0, "a fungus already exists");
        uint randDna = _generateRandomDna(name);
        _createFungus(name, randDna);
    }
}

contract FungusFeeding is FungusFactory {}
