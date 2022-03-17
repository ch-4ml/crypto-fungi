// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "./FungusFactory.sol";

interface FeedFactoryInterface {
    function getFeed(uint _id) external view returns (
        string memory name,
        uint dna
    );
}

contract FungusFeeding is FungusFactory {
    
    FeedFactoryInterface feedContract;

    modifier onlyOwnerOf(uint fungusId) {
        require(msg.sender == fungusToOwner[fungusId]);
        _;
    }
    
    function setFeedFactoryContractAddress(address address_) external onlyOwner {
        feedContract = FeedFactoryInterface(address_);
    }

    function _triggerCooldown(Fungus memory fungus) internal view {
        fungus.readyTime = uint32(block.timestamp + cooldownTime);
    }

    function _isReady(Fungus memory fungus) internal view returns (bool) {
        return (fungus.readyTime <= block.timestamp);
    }

    function feedAndMultiply(uint fungusId, uint targetDna, string memory species) internal onlyOwnerOf(fungusId) {
        Fungus memory myFungus = fungi[fungusId];
        require(_isReady(myFungus));
        targetDna = targetDna % dnaModulus;
        uint newDna = (myFungus.dna + targetDna) / 2;

        if (keccak256(bytes(species)) == keccak256("feed")) {
            newDna = newDna % 100 + 99;
        }

        _createFungus("Noname", newDna);
        _triggerCooldown(myFungus);
    }

    function feed(uint fungusId, uint _feedId) public {
        uint feedDna;
        (,feedDna) = feedContract.getFeed(_feedId);
        feedAndMultiply(fungusId, feedDna, "feed");
    }
}