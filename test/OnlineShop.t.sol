// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// import "forge-std/console.sol";
import {Test, console} from "forge-std/Test.sol";

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

import {OnlineShop} from "../src/OnlineShop.sol";

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

contract OnlineShopTest is Test {
    OnlineShop onlineShop;
    address Alice = makeAddr("Alice");

    function setUp() public {
        onlineShop = new OnlineShop();
        onlineShop.addProduct("Apple", 100, "image1");
    }

    // Create
    function test_add_product() public {
        onlineShop.addProduct("Banana", 200, "image2");
        (
            uint256 productId2,
            string memory name2,
            uint256 price2,
            ,
            ,
            ,
            string memory image2
        ) = onlineShop.products(2);

        assertEq(productId2, 2);
        assertEq(name2, "Banana");
        assertEq(price2, 200);
        assertEq(image2, "image2");
    }

    function test_add_multiple_products() public {
        // test_add_product();

        onlineShop.addProduct("Banana", 200, "image2");
        onlineShop.addProduct("Orange", 300, "image3");
        (
            uint256 productId2,
            string memory name2,
            uint256 price2,
            ,
            ,
            ,
            string memory image2
        ) = onlineShop.products(2);

        assertEq(productId2, 2);
        assertEq(name2, "Banana");
        assertEq(price2, 200);
        assertEq(image2, "image2");

        (
            uint256 productId3,
            string memory name3,
            uint256 price3,
            ,
            ,
            ,
            string memory image3
        ) = onlineShop.products(3);

        assertEq(productId3, 3);
        assertEq(name3, "Orange");
        assertEq(price3, 300);
        assertEq(image3, "image3");
    }

    // Read
    function test_get_proudct() public {
        (
            uint256 productId1,
            string memory name1,
            uint256 price1,
            ,
            ,
            ,
            string memory image2
        ) = onlineShop.products(1);

        assertEq(productId1, 1);
        assertEq(name1, "Apple");
        assertEq(price1, 100);
        assertEq(image2, "image1");
    }

    function test_get_all_products() public {
        test_add_multiple_products();

        OnlineShop.Product[] memory products = onlineShop.getAllProducts();

        assertEq(products.length, 3);
    }

    // Update
    function test_update_product() public {
        (, string memory name_before, , , , , ) = onlineShop.products(1);
        assertEq(name_before, "Apple");

        onlineShop.updateProductName(1, "Fuji Apple");

        (, string memory name_after, , , , , ) = onlineShop.products(1);

        assertEq(name_after, "Fuji Apple");
    }

    function test_update_price() public {
        (, , uint256 price, , , , ) = onlineShop.products(1);
        assertEq(price, 100);

        onlineShop.updateProductPrice(1, 200);

        (, , uint256 price_after, , , , ) = onlineShop.products(1);
        assertEq(price_after, 200);
    }

    // Delete
    function test_delete_product() public {
        onlineShop.deleteProduct(1);
        (, , , , , uint256 deletedAt, ) = onlineShop.products(1);
        assertGt(deletedAt, 0);
    }

    // Access Control

    function test_add_product_without_permission() public {
        vm.startPrank(Alice);
        vm.expectRevert(
            abi.encodeWithSelector(
                Ownable.OwnableUnauthorizedAccount.selector,
                Alice
            )
        );
        // test_add_product();
        onlineShop.addProduct("Banana", 200, "image2");
    }

    function test_update_product_price_without_permission() public {
        vm.startPrank(Alice);
        vm.expectRevert(
            abi.encodeWithSelector(
                Ownable.OwnableUnauthorizedAccount.selector,
                Alice
            )
        );
        onlineShop.updateProductPrice(1, 200);
    }

    function test_delete_product_without_permission() public {
        vm.startPrank(Alice);
        vm.expectRevert(
            abi.encodeWithSelector(
                Ownable.OwnableUnauthorizedAccount.selector,
                Alice
            )
        );

        onlineShop.deleteProduct(1);
    }
}
