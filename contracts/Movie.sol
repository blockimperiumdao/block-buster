// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.6;

import "./BlockBuster.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableMapUpgradeable.sol";

contract Movie is Initializable, ERC721Upgradeable {
    using EnumerableMapUpgradeable for EnumerableMapUpgradeable.UintToAddressMap;

    struct MovieData {
        uint runningLength; // running length of the movie in minutes
        string picture; // IPFS hash of the movie poster picture
        uint starRating; // star rating of the movie out of 5
        string description; // brief description of the movie
        string mpaaRating;  // MPAA rating of the movie
    }

    mapping(uint => MovieData) private movies;
    EnumerableMapUpgradeable.UintToAddressMap private movieIds;

    function initialize() public initializer {
        __ERC721_init("Movie", "MOV");
    }

    function addMovie(uint _movieId, uint _runningLength, string memory _picture, uint _starRating, string memory _description, string memory _mpaaRating) public {
        require(!movieIds.contains(_movieId), "Movie: movie ID already exists");
        movies[_movieId] = MovieData(_runningLength, _picture, _starRating, _description, _mpaaRating);
        movieIds.set(_movieId, msg.sender);
        _safeMint(msg.sender, movieId);
    }

    function getMovie(uint _movieId) public view returns (uint, string memory, uint, string memory) {
        require(movieIds.contains(_movieId), "Movie: movie ID does not exist");
        address owner = movieIds.get(_movieId);
        require(owner != address(0), "Movie: movie owner cannot be zero address");
        require(owner == ownerOf(movieId), "Movie: movie owner does not match NFT owner");
        MovieData memory movie = movies[movieId];
        return (movie.runningLength, movie.picture, movie.starRating, movie.description);
    }
}
