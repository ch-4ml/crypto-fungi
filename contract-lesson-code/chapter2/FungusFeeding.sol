// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "./FungusFactory.sol";

interface FeedFactoryInterface {
    function getFeed(uint _id) external view returns (
        string memory name,
        uint dna,
        uint price
    );
}

contract FungusFeeding is FungusFactory {
    
    address feedContractAddress = 0x1591B8Ec36376Cc0D5995977FFe3939eA14936d1;
    FeedFactoryInterface feedContract = FeedFactoryInterface(feedContractAddress);

    function feedAndMultiply(uint fungusId, uint targetDna, string memory species) public {
        Fungus memory myFungus = fungi[fungusId];
        targetDna = targetDna % dnaModulus;
        uint newDna = (myFungus.dna + targetDna) / 2;

        if (keccak256(bytes(species)) == keccak256("feed")) {
            newDna = newDna - newDna % 100 + 1;
        }

        _createFungus("Noname", newDna);
    }

    function feed(uint fungusId, uint feedId) public payable {
        uint feedDna;
        uint feedPrice;
        (,feedDna,feedPrice) = feedContract.getFeed(feedId);
        require(msg.value == feedPrice, "be paid inappropriate expenses");
        feedAndMultiply(fungusId, feedDna, "feed");
    }
}