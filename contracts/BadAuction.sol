pragma solidity ^0.4.15;

import "./AuctionInterface.sol";

/** @title BadAuction */
contract BadAuction is AuctionInterface {
	/* Bid function, vulnerable to attack
	 * Must return true on successful send and/or bid,
	 * bidder reassignment
	 * Must return false on failure and send people
	 * their funds back
	 */
	function bid() payable external returns (bool) {
		// YOUR CODE HERE
		if (msg.value > highestBid) {
			if (highestBidder != 0 && !highestBidder.send(highestBid)) { // this transfer may fail if poisoned
				msg.sender.transfer(msg.value); // On failure, returns funds to sender and returns false
				return false;
			}

			highestBidder = msg.sender;
			highestBid = msg.value;

			return true;
		}
		else {
			msg.sender.transfer(msg.value); // On failure, returns funds to sender and returns false
			return false;
		}
	}

	/* Give people their funds back -- fallback function*/
	function () payable {
		// YOUR CODE HERE
		msg.sender.transfer(msg.value);
	}
}
