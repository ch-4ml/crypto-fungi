// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

contract FeedFactory {

    struct Feed {
        string name;
        uint dna;
        uint price;
    }
    
    // RED: 3, GREEN: 3, BLUE: 3, ALPHA: 3, Species: 2
    uint dnaDigits = 14;
    uint dnaModulus = 10 ** dnaDigits;

    Feed[] public feeds;

    function createRandomFeed(string calldata name) public {
        uint randDna = _generateRandomDna(name);
        _createFeed(name, randDna);
    }

    function getFeed(uint _id) external view returns (string memory, uint, uint) {
        Feed memory feed = feeds[_id];
        return (feed.name, feed.dna, feed.price);
    }

    function _generateRandomDna(string calldata str) private view returns (uint) {
        uint rand = uint(keccak256(bytes(str)));
        uint dna = rand % dnaModulus;
        dna = dna - dna % 100 + 99;
        return dna;
    }
    
    function _createFeed(string calldata name, uint dna) private {
        uint price = 0.0001 ether;
        feeds.push(Feed(name, dna, price));
    }
}