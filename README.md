# FundMe Smart Contract

## Overview

The `FundMe` contract is a decentralized funding platform that allows users to fund the contract using Ether, which is then managed by the contract owner. It integrates Chainlink oracles for real-time ETH/USD price feeds to ensure that funding meets a minimum value requirement.

## Features

- **Funding**: Users can fund the contract with Ether, provided they meet a minimum USD equivalent.
- **Withdrawals**: Only the contract owner can withdraw the funds.
- **Price Conversion**: Utilizes Chainlink's price feed to convert ETH to USD.
- **Testing**: Comprehensive test suite using Foundry to ensure contract functionality.

## Prerequisites

Make sure you have the following installed:

- [Foundry](https://book.getfoundry.sh/) (for smart contract development and testing)
- A local Ethereum development environment (like Anvil)
- Node.js (if you want to run any additional scripts)

## Installation

Clone this repository:

```bash
git clone <repository-url>
cd FundMe
```

Install dependencies:

```bash
forge install
```

## Configuration

You need to set up your `.env` file with the following variables:

```
SEPOLIA_RPC_URL=<your_sepolia_rpc_url>
PRIVATE_KEY=<your_private_key>
ETHERSCAN_API_KEY=<your_etherscan_api_key>
```

## Usage

### Deploying the Contract

1- To deploy the `FundMe` contract on the Sepolia network, run:

```bash
make deploy-sepolia
```

2- To deploy the FundMe contract, run the deployment script:
```bash
forge script script/DeployFundMe.s.sol
```

### Funding the Contract

You can fund the deployed contract by executing the script:

```bash
forge script script/Interactions.s.sol:FundFundMe --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast
```

### Withdrawing Funds

The owner can withdraw funds using the following script:

```bash
forge script script/Interactions.s.sol:WithdrawFundMe --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast
```

## Testing

Run the test suite to ensure all functionalities work as intended:

```bash
forge test
```

## Contract Structure

### Contracts

- **FundMe**: Main contract for funding and withdrawals.
- **PriceConverter**: Library for converting ETH to USD using Chainlink price feeds.
- **HelperConfig**: Helper contract to manage network configurations.
- **MockV3Aggregator**: Mock for price feed, used during testing.
- **DeployFundMe**: Script for deploying the `FundMe` contract.
- **Interactions**: Scripts for funding and withdrawing from the `FundMe` contract.

### Tests

The tests are organized to cover various scenarios:

- Funding contract
- Withdrawals by owner
- Price feed accuracy
- Edge cases for funding requirements

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any enhancements or bug fixes.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
```

### Notes:
- Replace `<repository-url>` with the actual URL of your GitHub repository.
- Adjust any descriptions or sections according to your project needs.
- Make sure to include a `LICENSE` file if you reference it in the README. 

This README should provide a clear overview of your project, making it easier for other developers or users to understand and interact with your code. Let me know if you need any more adjustments!