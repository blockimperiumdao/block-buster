// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.6;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";

import "./BlockBuster.sol";

contract Movie is Initializable, ERC721Upgradeable {
    struct MovieData {
        uint runningLength; // running length of the movie in minutes
        string picture; // IPFS hash of the movie poster picture
        uint starRating; // star rating of the movie out of 5
        string description; // brief description of the movie
    }

    mapping(uint => MovieData) private movies;

    function initialize() public initializer {
        __ERC721_init("Movie", "MOV");
    }

    function addMovie(uint movieId, uint _runningLength, string memory _picture, uint _starRating, string memory _description) public {
        require(!_exists(movieId), "Movie: movie ID already exists");
        movies[movieId] = MovieData(_runningLength, _picture, _starRating, _description);
        _safeMint(msg.sender, movieId);
    }

    function getMovie(uint movieId) public view returns (uint, string memory, uint, string memory) {
        require(_exists(movieId), "Movie: movie ID does not exist");
        MovieData memory movie = movies[movieId];
        return (movie.runningLength, movie.picture, movie.starRating, movie.description);
    }
}