pragma solidity ^0.4.15;

import "./AuctionInterface.sol";

/** @title GoodAuction */
contract GoodAuction is AuctionInterface {
	/* New data structure, keeps track of refunds owed to ex-highest bidders */
	mapping(address => uint) refunds;

	/* Bid function, shifts to push paradigm
	 * Must return true on successful send and/or bid, bidder
	 * reassignment
	 * Must return false on failure and allow people to
	 * retrieve their funds
	 */
	function bid() payable external returns(bool) {
		// YOUR CODE HERE
		if (msg.value > highestBid) {
			if (highestBidder != 0) {
				refunds[highestBidder] = refunds[highestBidder] + highestBid;
			}
						
			highestBid = msg.value;
			highestBidder = msg.sender;
			return true;
		}
		else {
			refunds[msg.sender] = refunds[msg.sender] + msg.value;
			return false;
		}
	}

	/* New withdraw function, shifts to push paradigm */
	function withdrawRefund() external returns(bool) {
		// YOUR CODE HERE
		uint amount = refunds[msg.sender];
		refunds[msg.sender] = 0;
		if (!msg.sender.send(amount)) {
			refunds[msg.sender] = amount; // If return fails, reset refund value
		}
	}

	/* Allow users to check the amount they can withdraw */
	function getMyBalance() constant external returns(uint) {
		return refunds[msg.sender];
	}

	/* Give people their funds back */
	function () payable {
		// YOUR CODE HERE
		msg.sender.transfer(msg.value);
	}
}
