// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./Movie.sol";

contract BlockBuster is ReentrancyGuard {
    struct Rental {
        address renter;
        uint movieId;
        uint rentalTime;
        uint returnTime;
    }

    mapping(uint => Rental[]) private rentals;

    function rentMovie(uint movieId) public payable nonReentrant {
        require(msg.value > 0, "BlockBuster: rental fee must be greater than zero");
        require(Movie(msg.sender).ownerOf(movieId) == address(this), "BlockBuster: movie ID does not exist or is not owned by Movie contract");

        Rental memory rental;
        rental.renter = msg.sender;
        rental.movieId = movieId;
        rental.rentalTime = block.timestamp;
        rental.returnTime = 0;

        rentals[movieId].push(rental);
    }

    function returnMovie(uint movieId) public nonReentrant {
        Rental[] storage rentalList = rentals[movieId];
        require(rentalList.length > 0, "BlockBuster: no rental exists for this movie ID");

        Rental storage rental = rentalList[rentalList.length - 1];
        require(rental.renter == msg.sender, "BlockBuster: rental can only be returned by the renter");
        require(rental.returnTime == 0, "BlockBuster: rental has already been returned");

        rental.returnTime = block.timestamp;
        //payable(rental.renter).transfer(msg.value);
    }

    function getRental(uint movieId, uint rentalIndex) public view returns (address, uint, uint) {
        Rental storage rental = rentals[movieId][rentalIndex];
        return (rental.renter, rental.rentalTime, rental.returnTime);
    }

    function getRentalsCount(uint movieId) public view returns (uint) {
        return rentals[movieId].length;
    }
}
