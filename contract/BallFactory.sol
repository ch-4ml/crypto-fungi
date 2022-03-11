// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

contract BallFactory {

    event NewBall(uint ballId, string name, uint design);

    // RED: 3, GREEN: 3, BLUE: 3, ALPHA: 3
    uint designDigits = 12;
    uint designModulus = 10 ** designDigits;

    struct Ball {
        string name;
        uint design;
    }

    Ball[] public balls;

    mapping (uint => address) public ballToOwner;
    mapping (address => uint) ownerBallCount;

    function _createBall(string calldata _name, uint _design) private {
        balls.push(Ball(_name, _design));
        uint id = balls.length - 1;
        ballToOwner[id] = msg.sender;
        ownerBallCount[msg.sender]++;
        emit NewBall(id, _name, _design);
    }

    function _generateRandomDesign(string calldata _str) private view returns (uint) {
        uint rand = uint(keccak256(bytes(_str)));
        return rand % designModulus;
    }

    function createRandomBall(string calldata _name) public {
        require(ownerBallCount[msg.sender] == 0);
        uint randDesign = _generateRandomDesign(_name);
        _createBall(_name, randDesign);
    }
}
