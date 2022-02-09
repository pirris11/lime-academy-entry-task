pragma solidity ^0.8.0;

import "./ownable.sol";

contract Library is Ownable {
    
    struct Book {
        string name;
        string author;
        uint stock;
    }

    struct Rent {
        bool now;
        bool ever;
    }


    Book[] private books;
    
    mapping (uint => address[]) public everRentingUsers;
    mapping (uint => mapping (address => Rent)) public rents;
    

    modifier onlyExistingBook(uint _id) {
        require(_id < books.length);
        _;   
    }
    
    event BookAdded(uint id, string name, string author, uint stock);
    event BookBorrowed(uint  id, address  user);
    event BookReturned(uint  id, address  user);
    
    function addBook(string  memory _name, string  memory _author, uint _stock) external onlyOwner returns(uint id) {
        require(_stock > 0);
        id = books.length;
        books.push(Book(_name, _author, _stock));
        emit BookAdded(id, _name, _author, _stock);
    }

    function borrowBook(uint _id) external onlyExistingBook(_id) {
        Book storage book = books[_id];
        require(book.stock > 0);

        Rent storage rent = rents[_id][msg.sender];
        require(!rent.now);
        
        book.stock--;
        rent.now = true;
        emit BookBorrowed(_id, msg.sender);

        if (!rent.ever) {
            rent.ever = true;
            everRentingUsers[_id].push(msg.sender);
        }
    }

    function returnBook(uint _id) external onlyExistingBook(_id) {
        Rent storage rent = rents[_id][msg.sender];
        require(rent.now);

        books[_id].stock++;
        rent.now = false;
        emit BookReturned(_id, msg.sender);
    }
}