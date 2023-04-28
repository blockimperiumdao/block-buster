// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.16;

import "./BlockBuster.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableMapUpgradeable.sol";

contract Movie is Initializable, ERC721Upgradeable {
    using EnumerableMapUpgradeable for EnumerableMapUpgradeable.UintToAddressMap;

    enum MovieGenre
    { 
        Action,
        Adventure,
        Comedy,
        Crime,
        Drama,
        Fantasy,
        Historical,
        Horror,
        Mystery,
        Political,
        Romance,
        Satire,
        ScienceFiction,
        Thriller,
        Western    
    }

    function convertMovieGenreToString( MovieGenre genre ) public
    pure returns ( string memory )
    {
        if ( genre == MovieGenre.Action )
        {
            return "Action";
        }
        else if ( genre == MovieGenre.Adventure )
        {
            return "Adventure";
        }
        else if ( genre == MovieGenre.Comedy )
        {
            return "Comedy";
        }
        else if ( genre == MovieGenre.Crime )
        {
            return "Crime";
        }
        else if ( genre == MovieGenre.Drama )
        {
            return "Drama";
        }
        else if ( genre == MovieGenre.Fantasy )
        {
            return "Fantasy";
        }
        else if ( genre == MovieGenre.Historical )
        {
            return "Historical";
        }
        else if ( genre == MovieGenre.Horror )
        {
            return "Horror";
        }
        else if ( genre == MovieGenre.Mystery )
        {
            return "Mystery";
        }
        else if ( genre == MovieGenre.Political )
        {
            return "Political";
        }
        else if ( genre == MovieGenre.Romance )
        {
            return "Romance";
        }
        else if ( genre == MovieGenre.Satire )
        {
            return "Satire";
        }
        else if ( genre == MovieGenre.ScienceFiction )
        {
            return "ScienceFiction";
        }
        else if ( genre == MovieGenre.Thriller )
        {
            return "Thriller";
        }
        else if ( genre == MovieGenre.Western )
        {
            return "Western";
        }
        else
        {
            return "Unknown";
        }
    }


    struct MovieData {
        uint runningLength; // running length of the movie in minutes
        string picture; // IPFS hash of the movie poster picture
        string contentIPFS; // IPFS hash of the movie content
        uint starRating; // star rating of the movie out of 5
        string description; // brief description of the movie
        string mpaaRating;  // MPAA rating of the movie
        MovieGenre genre; // genre of the movie
    }

    mapping(uint => MovieData) private movies;
    EnumerableMapUpgradeable.UintToAddressMap private movieIds;

    function initialize() public initializer {
        __ERC721_init("Movie", "MOV");
    }

    function addMovie(uint _movieId, uint _runningLength, string memory _picture, uint _starRating, string memory _description, string memory _mpaaRating, string memory _movieContent, MovieGenre _genre ) public {
        require(!movieIds.contains(_movieId), "Movie: movie ID already exists");
        movies[_movieId] = MovieData(_runningLength, _picture, _movieContent, _starRating, _description, _mpaaRating, _genre );
        movieIds.set(_movieId, msg.sender);
        _safeMint(msg.sender, _movieId);
    }

    function getMovie(uint _movieId) public view returns (uint, string memory, uint, string memory, string memory, MovieGenre) {
        require(movieIds.contains(_movieId), "Movie: movie ID does not exist");
        address owner = movieIds.get(_movieId);
        require(owner != address(0), "Movie: movie owner cannot be zero address");
        require(owner == ownerOf(_movieId), "Movie: movie owner does not match NFT owner");
        MovieData memory movie = movies[_movieId];
        return (movie.runningLength, movie.picture, movie.starRating, movie.description, movie.mpaaRating, movie.genre);
    }
}
