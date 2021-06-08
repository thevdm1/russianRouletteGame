pragma solidity ^0.6.0;

import "OpenZeppelin/openzeppelin-contracts@3.4.0/contracts/token/ERC20/ERC20.sol";

contract rrToken is ERC20{
	constructor(uint initialSupply) public ERC20('rrToken', 'RRT'){
		_mint(msg.sender, initialSupply);
	}
	function faucet(uint _amount) public payable{
		_mint(msg.sender, _amount);
	}
}