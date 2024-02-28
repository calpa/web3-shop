// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import {NFT} from "./NFT.sol";

contract OnlineShop is Ownable {
    NFT public _nft;

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

    constructor(address nft_address) Ownable(msg.sender) {
        _nft = NFT(nft_address);
    }

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

    function getProductPrice(uint _productId) public view returns (uint256) {
        return products[_productId].price;
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

    function purchase(uint256 _productId) public payable {
        require(msg.value > 0, "You should give more than 0 dollars");
        require(msg.value >= products[_productId].price, "Not enough money");
        _nft.safeMint(msg.sender);
    }

    function withdraw() public payable onlyOwner {
        (bool success, ) = owner().call{value: address(this).balance}("");
        require(success, "Failed to withdraw");
    }
}
