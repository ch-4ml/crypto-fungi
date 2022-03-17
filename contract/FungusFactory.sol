// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/access/Ownable.sol";

contract FungusFactory is Ownable {

    event NewFungus(uint fungusId, string name, uint dna);

    // RED: 3, GREEN: 3, BLUE: 3, ALPHA: 3, Species: 2
    uint dnaDigits = 14;
    uint dnaModulus = 10 ** dnaDigits;
    uint cooldownTime = 10 minutes;

    struct Fungus {
        string name;
        uint dna;
        uint32 readyTime;
    }

    Fungus[] public fungi;

    mapping (uint => address) public fungusToOwner;
    mapping (address => uint) ownerFungusCount;

    function _createFungus(string memory name, uint dna) internal {
        fungi.push(Fungus(name, dna, uint32(block.timestamp + cooldownTime)));
        uint id = fungi.length - 1;
        fungusToOwner[id] = msg.sender;
        ownerFungusCount[msg.sender]++;
        emit NewFungus(id, name, dna);
    }

    function _generateRandomDna(string calldata _str) private view returns (uint) {
        uint rand = uint(keccak256(bytes(_str)));
        return rand % dnaModulus;
    }

    function createRandomFungus(string calldata name) public {
        require(ownerFungusCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(name);
        _createFungus(name, randDna);
    }

    function getFungiByOwner(address _owner) external view returns(uint[] memory) {
        uint[] memory result = new uint[](ownerFungusCount[_owner]);

        uint counter = 0;
        for (uint i = 0; i < fungi.length; i++) {
            if (fungusToOwner[i] == _owner) {
                result[counter] = i;
                unchecked { counter++; }
            }
        }
        return result;
    }
}
