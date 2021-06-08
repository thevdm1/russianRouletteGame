pragma solidity ^0.6.0;

import "OpenZeppelin/openzeppelin-contracts@3.4.0/contracts/access/Ownable.sol";
import "OpenZeppelin/openzeppelin-contracts@3.4.0/contracts/math/SafeMath.sol";
import "OpenZeppelin/openzeppelin-contracts@3.4.0/contracts/token/ERC20/ERC20.sol";
import './rrToken.sol';
//https://iamdefinitelyahuman.medium.com/using-openzeppelin-contracts-with-python-and-brownie-ff7053d63bbe

contract russianRoulette is Ownable{
	//ERC20 public ERC20Interface;
	rrToken public rrtInterface;
	int bulletLocation;
	uint shotsFired;
	uint casinoProfit;
	uint initialFunding;
	//address[] deadAddresses;
	mapping(address => bool) public blacklisted;

	constructor() public payable {
		require(msg.value > 10, "You need at least 10 ETH to start a casino fren...");
		initialFunding = msg.value;
	}
	//if an address dies they shouldn't be allowed to play again!
	modifier notBlacklisted() {
    require(!blacklisted[msg.sender], 'Address is blacklisted!'); //nice easy syntax to denote false (!)
    _;                      
	}
	//can remove duplicates in function below
	function setTokenAddress(address _addr) public onlyOwner{
		//needs to be set once contract deployed
		//ERC20Interface = ERC20(_addr);
		rrtInterface = rrToken(_addr);
	}

	function loadChamber() internal returns(int){
		uint blockNum = block.number;
		bytes32 random = keccak256(abi.encodePacked(blockNum));
		bulletLocation = int(uint(random) % 8) + 1;
		shotsFired += 1;
		return bulletLocation;
	}
	function pullTrigger(int _guess) notBlacklisted public payable returns(uint){
		require(_guess > 0, "Choose a number between 1 and 8");
		require(msg.value == 1000000000000000000, 'You need to bet 1 ETH before trying to play');  //bet cap on for now
		require(address(this).balance > 125000000000000000, 'Casino is effectively bankrupt fren sorry about that');
		uint survival; //1 represents life and 0 represents death
		int bulletLoc = loadChamber();
		if (bulletLoc == _guess){
			survival = 0;
			//no payout sorry dead man!
			casinoProfit += 1000000000000000000;
			blacklisted[msg.sender] = true;
			//deadAddresses.push(msg.sender);

		}
		else {
   			survival = 1;
   			//payout the degen
   			msg.sender.transfer(1250000000000000000); // 1/8 is fair odds as chamber has 8 slots
   			casinoProfit -= 125000000000000000;
		}
		return survival;
	}
	//SECOND VERSION OF PULLTRIGGER
	function pullTrigger_ii(int _guess, uint _betAmount) notBlacklisted public payable returns(uint){
		require(_guess > 0, "Choose a number between 1 and 8");
		//ERC20Interface.approve(address(this), _betAmount);
		//approval not done in this contract- actual token contract
		rrtInterface.transferFrom(msg.sender, address(this), _betAmount);
		uint survival; //1 represents life and 0 represents death
		int bulletLoc = loadChamber();
		if (bulletLoc == _guess){
			survival = 0;
			//no payout sorry dead man!
			//casinoProfit += 1000000000000000000;
			blacklisted[msg.sender] = true;
			//deadAddresses.push(msg.sender);

		}
		else {
   			survival = 1;
   			//payout the degen
   			rrtInterface.faucet(_betAmount/8);
   			rrtInterface.transfer(msg.sender, (_betAmount + (_betAmount/8)));
		}
		return survival;
	}
	//END SECOND VERSION OF PULLTRIGGER
	function wwtb() onlyOwner public view returns(int){
		return bulletLocation;
	}
	function shotsTaken() public view returns(uint){
		return shotsFired;
	}
	//function below unecessarily modfies state of BC refactor this
	//this function is also not working correctly
	function casinoGains() onlyOwner public returns(uint){
		uint prof;
		prof = address(this).balance - initialFunding;
		return prof;
	}
	function casinoBalance() public view returns(uint){
		return address(this).balance;
	}
	function isDeadTest(address _address) public view returns(bool){
		if (blacklisted[_address] == true){
			return true;
		}
		else{
			return false;
		}
	}
}