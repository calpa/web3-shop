// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract OnlineShop is Ownable {
    // Struct to represent a product
    struct Product {
        uint256 productId;
        string name;
        uint256 price;
        uint256 createdAt;
        uint256 updatedAt;
        uint256 deletedAt;
        string image; // Assuming image is stored as a string (e.g., IPFS hash)
    }

    uint256 productId;

    // Mapping to store products by their ID
    mapping(uint => Product) public products;

    // Event to emit when a new product is added
    event ProductAdded(
        uint productId,
        string name,
        uint256 price,
        string image
    );

    // Constructor to set the contract owner
    constructor() Ownable(msg.sender) {}

    // Function to add a new product, restricted to the owner
    function addProduct(
        string memory _name,
        uint256 _price,
        string memory _image
    ) external onlyOwner {
        uint256 _productId = productId + 1;

        // Check if the product already exists
        require(!isProductExist(_productId), "Product already exists");

        // Add the product
        products[_productId] = Product({
            productId: _productId,
            name: _name,
            price: _price,
            createdAt: block.timestamp,
            updatedAt: block.timestamp,
            deletedAt: 0,
            image: _image
        });

        // Emit an event
        emit ProductAdded(_productId, _name, _price, _image);

        productId++;
    }

    // Function to check if a product exists
    function isProductExist(uint _productId) public view returns (bool) {
        return products[_productId].createdAt != 0;
    }

    // Function to get all products
    function getAllProducts() external view returns (Product[] memory) {
        Product[] memory allProducts = new Product[](productId);
        for (uint i = 1; i <= productId; i++) {
            if (isProductExist(i)) {
                allProducts[i - 1] = products[i];
            }
        }
        return allProducts;
    }

    function updateProductName(
        uint _productId,
        string memory name
    ) public onlyOwner {
        products[_productId].name = name;
    }

    function updateProductPrice(
        uint _productId,
        uint256 _price
    ) public onlyOwner {
        products[_productId].price = _price;
    }

    function deleteProduct(uint _productId) public onlyOwner {
        products[_productId].deletedAt = block.timestamp;
    }
}
