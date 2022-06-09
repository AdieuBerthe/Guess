/*Faire un "deviner c'est gagné!"

Un administrateur va placer un mot, et un indice sur le mot

Les joueurs vont tenter de découvrir ce mot en faisant un essai

Le jeu doit donc 

1) instancier un owner

2) permettre a l'owner de mettre un mot et un indice

3) les autres joueurs vont avoir un getter sur l'indice

4) ils peuvent proposer un mot, qui sera comparé au mot référence, return un boolean

5) les joueurs seront inscrit dans un mapping qui permet de savoir si il a déjà joué

6) avoir un getter, qui donne si il existe le gagnant.

7) facultatif (necessite un array): faire un reset du jeu pour relancer une instance
*/

// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.14;

contract Jeu {
    mapping (address => uint) public tries;
    string[] word;
    string[] hint;
    address owner;
    bool gameInProgress;
    address winner;
    

    modifier onlyOwner {
        require(owner == msg.sender, "only the owner can change words");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function newWordHint(string calldata _word, string calldata _hint) public onlyOwner {
        string memory empty = "";
        require(!gameInProgress, "the game has to end before starting a new one");
        require(keccak256(abi.encodePacked(_word)) != keccak256(abi.encodePacked(empty)) && keccak256(abi.encodePacked(_hint)) != keccak256(abi.encodePacked(empty)), "you need to enter both word and hint");
        word.push(_word);
        hint.push(_hint);
        gameInProgress = true;
    }

    function guessWord(string calldata _answer) public returns(bool) {
    bool guessed;
    require(gameInProgress, "current word has already been found");
    tries[msg.sender] += 1; 
    if(keccak256(abi.encodePacked(_answer)) == keccak256(abi.encodePacked(word[0]))) {
        winner = msg.sender;
        guessed = true;
        gameInProgress = false;
        word.pop();
        hint.pop();
        }
    return guessed;
    }

    function getHint() public view returns(string[] memory) {
        return hint;
    }

    function getWinner() public view returns(address) {
        require(winner != address(0), "no winner yet");
        return winner;
    }

    


}
