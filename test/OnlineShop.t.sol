// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {Test, console} from "forge-std/Test.sol";

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IAccessControl} from "@openzeppelin/contracts/access/IAccessControl.sol";

import {OnlineShop} from "../src/OnlineShop.sol";

// import {NFT} from "../src/NFT.sol";

contract OnlineShopTest is Test {
    event Purchase(uint256 productId);

    OnlineShop onlineShop;
    // NFT _nft;
    address Alice = makeAddr("Alice");
    address Bob = makeAddr("Bob");
    bytes32 public constant MINTER = keccak256("MINTER");

    function setUp() public {
        // _nft = new NFT();
        // onlineShop = new OnlineShop(address(_nft));
        onlineShop = new OnlineShop();
        onlineShop.addProduct("Apple", 0.1 ether, "image1", 100);
        // _nft.grantRole(MINTER, address(onlineShop));
        vm.deal(address(this), 100 ether);
    }

    // Create
    function test_add_product() public {
        onlineShop.addProduct("Banana", 200, "image2", 100);
        (
            uint256 productId2,
            string memory name2,
            uint256 price2,
            ,
            ,
            ,
            string memory image2,

        ) = onlineShop.products(2);

        assertEq(productId2, 2);
        assertEq(name2, "Banana");
        assertEq(price2, 200);
        assertEq(image2, "image2");
    }

    function test_add_multiple_products() public {
        onlineShop.addProduct("Banana", 0.2 ether, "image2", 100);
        onlineShop.addProduct("Orange", 0.3 ether, "image3", 100);
        (
            uint256 productId2,
            string memory name2,
            uint256 price2,
            ,
            ,
            ,
            string memory image2,

        ) = onlineShop.products(2);

        assertEq(productId2, 2);
        assertEq(name2, "Banana");
        assertEq(price2, 0.2 ether);
        assertEq(image2, "image2");

        (
            uint256 productId3,
            string memory name3,
            uint256 price3,
            ,
            ,
            ,
            string memory image3,

        ) = onlineShop.products(3);

        assertEq(productId3, 3);
        assertEq(name3, "Orange");
        assertEq(price3, 0.3 ether);
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
            string memory image2,

        ) = onlineShop.products(1);

        assertEq(productId1, 1);
        assertEq(name1, "Apple");
        assertEq(price1, 0.1 ether);
        assertEq(image2, "image1");
    }

    function test_get_all_products() public {
        test_add_multiple_products();

        OnlineShop.Product[] memory products = onlineShop.getAllProducts();

        assertEq(products.length, 3);
    }

    // Update
    function test_update_product() public {
        (, string memory name_before, , , , , , ) = onlineShop.products(1);
        assertEq(name_before, "Apple");

        onlineShop.updateProductName(1, "Fuji Apple");

        (, string memory name_after, , , , , , ) = onlineShop.products(1);

        assertEq(name_after, "Fuji Apple");
    }

    function test_update_price() public {
        (, , uint256 price, , , , , ) = onlineShop.products(1);
        assertEq(price, 0.1 ether);

        onlineShop.updateProductPrice(1, 0.2 ether);

        (, , uint256 price_after, , , , , ) = onlineShop.products(1);
        assertEq(price_after, 0.2 ether);
    }

    // Delete
    function test_delete_product() public {
        onlineShop.deleteProduct(1);
        (, , , , , uint256 deletedAt, , ) = onlineShop.products(1);
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
        onlineShop.addProduct("Banana", 200, "image2", 100);
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

    // NFT

    // function test_nft_safe_mint_without_permission_1() public {
    //     vm.expectRevert(
    //         abi.encodeWithSelector(
    //             IAccessControl.AccessControlUnauthorizedAccount.selector,
    //             address(this),
    //             MINTER
    //         )
    //     );
    //     _nft.safeMint(Alice);
    // }

    // function test_nft_safe_mint_without_permission_2() public {
    //     vm.startPrank(Alice);
    //     vm.expectRevert(
    //         abi.encodeWithSelector(
    //             IAccessControl.AccessControlUnauthorizedAccount.selector,
    //             address(Alice),
    //             MINTER
    //         )
    //     );
    //     _nft.safeMint(Alice);
    // }

    function test_purchase_item_1() public {
        uint256 price = onlineShop.getProductPrice(1);

        vm.expectEmit(address(onlineShop));
        emit Purchase(1);

        onlineShop.purchase{value: price}(1);
        assertEq(address(this).balance, 99.9 ether);

        (, , , , , , , uint256 amount) = onlineShop.products(1);
        assertEq(amount, 99);
    }

    function test_purchase_item_1_2() public {
        uint256 price = onlineShop.getProductPrice(1);

        onlineShop.purchase{value: price}(1);
        assertEq(address(this).balance, 99.9 ether);
        (, , , , , , , uint256 amount) = onlineShop.products(1);
        assertEq(amount, 99);

        onlineShop.purchase{value: price}(1);
        assertEq(address(this).balance, 99.8 ether);
        (, , , , , , , uint256 amount2) = onlineShop.products(1);
        assertEq(amount2, 98);
    }

    function testFail_purchase_item_without_money() public {
        onlineShop.purchase{value: 0}(1);
    }

    function testFuzz_purchase_item_1(uint8 n) public {
        uint256 price = onlineShop.getProductPrice(1);
        (, , , , , , , uint256 amount) = onlineShop.products(1);
        vm.assume(n <= amount);
        while (n > 0) {
            uint256 balance = address(this).balance;
            onlineShop.purchase{value: price}(1);
            assertEq(balance - price, address(this).balance);
            n -= 1;
        }
    }

    function test_purchase_item_2() public {
        test_add_multiple_products();

        uint256 price = onlineShop.getProductPrice(2);

        onlineShop.purchase{value: price}(2);
        assertEq(address(this).balance, 99.8 ether);
    }

    function test_withdraw() public {
        test_purchase_item_1();
        onlineShop.withdraw();
        assertEq(address(this).balance, 100 ether);
    }

    function test_withdraw_without_permission() public {
        test_purchase_item_1();
        vm.startPrank(Alice);
        vm.expectRevert(
            abi.encodeWithSelector(
                Ownable.OwnableUnauthorizedAccount.selector,
                Alice
            )
        );
        onlineShop.withdraw();
    }

    receive() external payable {}

    fallback() external payable {}

    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) external pure returns (bytes4) {
        return this.onERC721Received.selector;
    }
}
