// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

error Raffle__NotEnoughETHEntered();

contract Raffle {
  uint256 private immutable i_entranceFee;
  address payable[] private s_players;

  /** Events */
  event RaffleEnter(address indexed player);

  constructor(uint256 entranceFee) {
    i_entranceFee = entranceFee;
  }

  function enterRaffle() public payable {
    if (msg.value < i_entranceFee) {
      revert Raffle__NotEnoughETHEntered();
    }

    s_players.push(payable(msg.sender));

    emit RaffleEnter(msg.sender);
  }

  function pickRandomWinner() public pure {

  }

  function getEntranceFee() public view returns (uint256) {
    return i_entranceFee;
  }

  function getPlayer(uint16 index) public view returns (address) {
    return s_players[index];
  }
}