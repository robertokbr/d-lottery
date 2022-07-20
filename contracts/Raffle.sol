// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

error Raffle__NotEnoughETHEntered();
error Raffle__TransferFailed();

/**
 * @dev this is going to use Chainlink Verifiable Random Function:
 * https://docs.chain.link/docs/intermediates-tutorial/#:~:text=vrf; 
 * @dev this is going to use Chainlink keepers to trigger the lottery winner function;
 */
contract Raffle is VRFConsumerBaseV2 {
  // State variables
  uint256 private immutable i_entranceFee;
  address payable[] private s_players;

  // Lotery variables
  address payable private s_Lastwinner;

  /** Events */
  event RaffleEnter(address indexed player);
  event RequestedRafflewinner(uint256 indexed requestId);
  event WinnerPicked(address indexed winner);

  constructor(
    address vrfCordinatorV2, 
    uint256 entranceFee
  ) VRFConsumerBaseV2(vrfCordinatorV2) {
    i_entranceFee = entranceFee;
  }

  function enterRaffle() public payable {
    if (msg.value < i_entranceFee) {
      revert Raffle__NotEnoughETHEntered();
    }

    s_players.push(payable(msg.sender));

    emit RaffleEnter(msg.sender);
  }

  function requestRandomWinner() external {}

  function fulfillRandomWords(
    uint256 /*requestId*/, 
    uint256[] memory randomWords
  ) internal override {
    uint256 indexOfWinner =  s_players.length % randomWords[0];
    address payable winner = s_players[indexOfWinner];
    s_Lastwinner = winner;

    (bool success, ) = winner.call{value: address(this).balance}("");

    if (!success) {
      revert Raffle__TransferFailed();
    }

    emit WinnerPicked(winner);
  }

  /** Pure | View functions */
  function getEntranceFee() public view returns (uint256) {
    return i_entranceFee;
  }

  function getPlayer(uint16 index) public view returns (address) {
    return s_players[index];
  }

  function getLastWinner() public view returns (address) {
    return s_Lastwinner;
  }
}