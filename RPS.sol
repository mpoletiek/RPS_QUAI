// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract RockPaperScissors {
    enum Move { None, Rock, Paper, Scissors }

    struct PlayerStats {
        uint256 wins;
        uint256 losses;
        uint256 gamesPlayed;
    }

    mapping(address => PlayerStats) public leaderboard;
    uint256 public gameFee = 0.1 ether;

    event GamePlayed(address indexed player, Move playerMove, Move botMove, bool playerWon);

    function play(uint8 _playerMove) external payable {
        require(msg.value == gameFee, "Invalid game fee");
        require(_playerMove >= 1 && _playerMove <= 3, "Invalid move");

        Move playerMove = Move(_playerMove);
        Move botMove = getBotMove(playerMove);

        bool playerWon = determineWinner(playerMove, botMove) == msg.sender;

        leaderboard[msg.sender].gamesPlayed++;
        if (playerWon) {
            leaderboard[msg.sender].wins++;
            payable(msg.sender).transfer(address(this).balance);
        } else {
            leaderboard[msg.sender].losses++;
        }

        emit GamePlayed(msg.sender, playerMove, botMove, playerWon);
    }

    function getBotMove(Move _playerMove) internal view returns (Move) {
        uint256 rand = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, blockhash(block.number - 1))));
        uint256 chance = rand % 100;

        if (chance < 80) {
            if (_playerMove == Move.Rock) return Move.Paper;
            if (_playerMove == Move.Paper) return Move.Scissors;
            if (_playerMove == Move.Scissors) return Move.Rock;
        }
        return Move((rand % 3) + 1);
    }

    function determineWinner(Move player, Move bot) internal view returns (address) {
        if (player == bot) return address(0);
        if ((player == Move.Rock && bot == Move.Scissors) ||
            (player == Move.Paper && bot == Move.Rock) ||
            (player == Move.Scissors && bot == Move.Paper)) {
            return msg.sender;
        }
        return address(this);
    }

    function getPlayerStats(address player) external view returns (PlayerStats memory) {
        return leaderboard[player];
    }

    receive() external payable {}
}