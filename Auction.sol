// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract AuctionHouse {
    address public owner;
    string public item;
    uint public auctionEndTime;
    address private highestBidder; //so nobody knows who is the highest bidder
    bool public ended;
    uint256 private highestBid;

    mapping(address => uint256) public bids;
    address[] public bidders;

    constructor(string memory _item, uint256 _biddingTime) {
        owner = msg.sender;
        item = _item;
        auctionEndTime = block.timestamp + _biddingTime; //time is in seconds
    }

    function bid(uint256 amount) external {
        require(block.timestamp < auctionEndTime, "Auction has ended");
        require(amount > 0, "Bid must not be zero");
        require(
            amount > bids[msg.sender],
            "Bid must be higher than your previous bid"
        ); //so you can't bid twice)
        //if you want to make it so that you can't bid twice, you can use this line of code
        //require(amount > bids[msg.sender], "Bid must be higher than your previous bid");

        if (bids[msg.sender] == 0) {
            bidders.push(msg.sender);
        }

        bids[msg.sender] = amount;
        if (amount > highestBid) {
            highestBid = amount;
            highestBidder = msg.sender;
        }
    }

    function endAuction() external {
        require(block.timestamp >= auctionEndTime, "Auction is over");
        require(!ended, "Auction has already been called");
        ended = true;
    }

    function getWinner() external view returns (address, uint256) {
        require(ended, "Auction has not ended yet");
        return (highestBidder, highestBid);
    }

    function getAllBidders() external view returns (address[] memory) {
        return bidders;
    }
}
