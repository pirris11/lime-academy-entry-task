pragma solidity ^0.8.0;

contract Ownable {

address private _owner;

  constructor() {
      _owner = msg.sender;
  }

  modifier onlyOwner() {
    require(isOwner());
    _;
  }

  function isOwner() public view returns(bool) {
    return msg.sender == _owner;
  }
    
    }