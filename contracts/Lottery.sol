pragma solidity ^0.4.17;

contract Lottery {
  address public manager;
  address[] private players;
  uint constant requiredEth = 0.01 ether;

  constructor() public {
    manager = msg.sender;
  }

  function enter() public payable {
    require(msg.value == requiredEth);
    players.push(msg.sender);
  }

  function allPlayers() public view returns (address[]) {
    return players;
  }

  function sendWinningsToWinner() public resrticted {
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

  modifier resrticted() {
    require(msg.sender == manager);
    _;
  }
}
