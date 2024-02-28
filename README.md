# Online Shop Solidity Contracts

Welcome to the Online Shop Solidity Contracts repository! If you're new to coding or Solidity, this guide will help you understand and contribute to this project.

## Overview

This repository contains Solidity contracts for an online shop that operates on the Ethereum blockchain. These contracts handle the creation, management, and purchasing of products within the online shop environment.

## Functionality

### OnlineShop.sol

The `OnlineShop` contract offers the following features:

- **Product Management**:
  - Adding new products with details like name, price, and image.
  - Viewing product information including price and availability.
  - Updating product details such as name and price.
  - Removing products from the shop.

- **Purchasing**:
  - Users can buy products by sending the required amount of Ether.
  - The contract verifies the purchase's validity by checking product availability and the user's sent amount.

- **Withdrawal**:
  - The contract owner can withdraw the accumulated balance from product purchases.

### OnlineShopTest.sol

The `OnlineShopTest` contract serves as a testing suite to ensure the correctness and reliability of the `OnlineShop` contract. It covers various scenarios such as:

- Adding, updating, and deleting products.
- Access control to ensure only authorized users can execute specific actions.
- Testing interactions with the associated NFT contract.
- Testing purchase functionality under different conditions like insufficient funds and multiple purchases.

## Usage

Let's get you started on using and testing the contracts:

1. **Clone the Repository**: Open your terminal and run the following command to clone the repository to your local machine:

    ```bash
    git clone https://github.com/calpa/web3-shop.git
    ```

2. **Install Foundry**: Foundry is a tool that simplifies the development process. You can install it by running this command:

    ```bash
    curl -L https://foundry.paradigm.xyz | bash
    ```

    Foundry will handle much of the setup for you.

3. **Run Tests**: Testing is crucial to ensure the contracts work as expected. Navigate to the project directory and execute the following command:

    ```bash
    forge test --watch -vv
    ```

    This command will continuously run the tests and provide verbose output (`-vv`) so you can see what's happening.

4. **Learn by Example**: You can also learn by deleting the `OnlineShop.sol` contract, running the tests, and completing all green lights.

    ```bash
    rm ./src/OnlineShop.sol
    ```

## Dependencies

The project relies on the following dependency:

- [OpenZeppelin Contracts](https://github.com/OpenZeppelin/openzeppelin-contracts): These are reusable Solidity smart contracts for Ethereum.

## License

This project is licensed under the MIT License. You can find more details in the [LICENSE](LICENSE) file.

---

Feel free to modify and enhance this guide to suit your needs and provide additional clarity for beginners. Happy coding!
