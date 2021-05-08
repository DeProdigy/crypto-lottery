pragma solidity ^0.4.17;

contract Lottery {
    address public manager;
    address[] public players;
    uint constant requiredEth = 0.01 ether;

    constructor() public {
        manager = msg.sender;
    }

    function enter() public payable {
        require(msg.value == requiredEth);
        players.push(msg.sender);
    }

    function sendWinningsToWinner() public {
        require(msg.sender == manager);
        pickWinner().transfer(address(this).balance);
        players = new address[](0); // reset the players array
    }

    function pickWinner() private view returns (address) {
        uint index = random() % players.length;
        return players[index];
    }

    function random() private view returns (uint) {
        return uint(
            keccak256(
               abi.encodePacked(block.difficulty, now, players)
            )
        );
    }
}
