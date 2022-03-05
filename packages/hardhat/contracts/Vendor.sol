// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

import "./YourToken.sol";

contract Vendor is Ownable {

  YourToken yourToken;

  uint256 public constant tokenPrice = 100;
  uint256 public constant weiPerEth= 1e18;

  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
  event SellTokens(address seller, uint256 amountOfTokens, uint256 amountOfETH);

  constructor(address tokenAddress) {
    yourToken = YourToken(tokenAddress);
  }

  //ToDo: create a payable buyTokens() function:
  function buyTokens() public payable returns (uint256) {
    require(msg.value > 0, "value must be greater than 0");
    uint256 value=msg.value;
    uint256 tokenAmount = value * tokenPrice;
    console.log(tokenAmount);
    uint256 vendorBalance = yourToken.balanceOf(address(this));
    require(vendorBalance >= tokenAmount, "Vendor contract has no enough tokens");

    bool sent = yourToken.transfer(msg.sender, tokenAmount);
    require(sent, "Failed to transfer token to user");
    emit BuyTokens(msg.sender, value, tokenAmount);
    return tokenAmount;
  }

  //ToDo: create a sellTokens() function: 
  function sellTokens(uint256 tokenAmount) public {
    // let youToken contract approve Vendor to take some token from one account;
    
    require(tokenAmount > 0, "tokenAmount must be greater than 0");
    console.log(tokenAmount);

    // uint256 tokenBalance = yourToken.balanceOf(msg.sender);
    // require(tokenBalance > tokenAmount, "User has no enough token");
     uint256 allowance = yourToken.allowance(msg.sender, address(this));
    console.log(allowance);
    require(allowance >= tokenAmount, "Check the token allowance");

    uint ethBalance = address(this).balance;

    uint256 ethAmount = tokenAmount / tokenPrice;
    console.log(ethAmount);
    require(ethBalance > ethAmount , "Vendor has no enough eth");

    // bool approve = yourToken.approve(address(this), tokenAmount);
    // require(approve, "User deny to approve");
    (bool sent) = yourToken.transferFrom(msg.sender, address(this), tokenAmount);
    console.log(address(this));

    console.log(sent);
    require(sent, "Failed to transfer token from user to Vendor");
    (sent, ) = msg.sender.call{value: ethAmount}("");
  require(sent, "Failed to pay eth");
    console.log(msg.sender, tokenAmount, ethAmount);
    emit SellTokens(msg.sender, tokenAmount, ethAmount);
  }

  //ToDo: create a withdraw() function that lets the owner, you can 
  //use the Ownable.sol import above:
  function withdraw() public onlyOwner {
    uint256 balance = address(this).balance;
    console.log(balance);
    require(balance >=0, "Balance is not enough");
    (bool sent,) = msg.sender.call{value: balance}("");
    require(sent, "Failed to withdraw");
  }
}
