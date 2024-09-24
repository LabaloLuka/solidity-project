// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

contract Auction {
    address payable public beneficiary;
    uint public auctionEndTime;
    string private secretMessage;

    address public highestBidder;
    uint public highestBid;

    mapping (address=>uint) pendingReturns;
    bool isEnded;

    event HighestBidIncreased(address bidder, uint amount);
    event AuctionEnded(address winner, uint amount);

    constructor(uint biddingTime, address payable beneficiaryAddress, string memory secret) {
        beneficiary = beneficiaryAddress;
        auctionEndTime = block.timestamp + biddingTime;
        secretMessage = secret;
    }

    function bid() external payable {
        if (isEnded){
            revert("Aukcija je zavrsena!!");
        }
        if (msg.value <= highestBid) {
            revert("vec postoji veca ponuda");
        }
        if (highestBid!=0){
            pendingReturns[highestBidder] = highestBid;
        }
        if (msg.sender == highestBidder){
            revert("vec si najveci bider");
        }
        highestBid = msg.value;
        highestBidder = msg.sender;
        emit HighestBidIncreased(msg.sender, msg.value);
    }

    function withdraw() external returns (bool){
        uint amount = pendingReturns[msg.sender];
        if(amount > 0){
            pendingReturns[msg.sender] = 0;
            bool isTransactionSuccessful = payable (msg.sender).send(amount);
            if (!isTransactionSuccessful){
                pendingReturns[msg.sender]=amount;
                return false;
            }
        }
        return true;
    }

    function getSicretMessage() external view returns (string memory){
        require(isEnded, "aukscija nije gotova");
        require(msg.sender == highestBidder, "samo pobednik moye da dobije poruku");
        return secretMessage;
    }

    function auctionEnd() external {
        if(block.timestamp < auctionEndTime) {
            revert("Aukcija jos uek traje");
        }
        if (isEnded){
            revert("Aukcija se vec yavrsila");
        }
        isEnded = true;
        emit AuctionEnded(highestBidder, highestBid);
        beneficiary.transfer(highestBid);
    }
}