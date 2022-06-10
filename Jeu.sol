// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.14;

contract Jeu {
    mapping (address => uint) public tries;
    string word;
    string public hint;
    address owner;
    address winner;
    bool gameInProgress;
    
    modifier onlyOwner {
        require(owner == msg.sender, "only the owner can change words");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function CompareStrings(string memory _str1, string memory _str2) private pure returns(bool) {
        bool same;
        if(keccak256(abi.encodePacked(_str1)) == keccak256(abi.encodePacked(_str2))) {
            same = true;
        }
        return same;
    }

    function resetGame() public onlyOwner{
        gameInProgress = false;
        word = "";
        hint = "";
    }

    function newWordHint(string calldata _word, string calldata _hint) public onlyOwner {
        require(!gameInProgress, "the game has to end before starting a new one");
        require(!CompareStrings(_word, "") && !CompareStrings(_hint, ""), "you need to enter both word and hint");
        word = _word;
        hint = _hint;
        winner = address(0);
        gameInProgress = true;
    }

    function guessWord(string calldata _answer) public returns(bool) {
    bool guessed;
    require(gameInProgress, "current word has already been found");
    tries[msg.sender] += 1; 
    if(CompareStrings(_answer, word)) {
        winner = msg.sender;
        guessed = true;
        resetGame();
        }
    return guessed;
    }

    function getWinner() public view returns(address) {
        require(winner != address(0), "no winner yet");
        return winner;
    }

}
