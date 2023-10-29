# Hyperlane WormholeHook

This project contains a Hyperlane WormholeHook and WormholeISM for sending Hyperlane messages via Wormhole.

## Table of Contents

- [Hyperlane WormholeHook](#hyperlane-wormholehook)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [WormholeHook.sol](#wormholehooksol)
  - [WormholeISM.sol](#wormholeismsol)
  - [Installation](#installation)
  - [Deployment](#deployment)
  - [Tx Hashes](#tx-hashes)
  - [License](#license)

## Overview

The WormholeHook contract inherits Hyperlane's IPostDispatch, and Wormhole's IWormholeRelayer contract. The WormholeISM contract inherits Hyperlane's IInterchainSecurityModule contract, and Wormhole's IWormholeRelayer and IWormholeReceiver contracts.

## WormholeHook.sol

The `WormholeHook.sol` contract has a `postDispatch()` function that is intended to be called by a Hyperlane Mailbox contract, passing it a "message" as bytesdata. This function calls the `wormholeRelayer.sendPayloadToEvm()` using the message data and sends it to the WormholeISM contract on another chain.

[Goerli deployment](https://goerli.etherscan.io/address/0xd93dc9b1294a4ea80f9e1c828f1f9222cb7b9077#code)

## WormholeISM.sol

The `WormholeISM.sol` contract has a `receiveWormholeMessages()` function for receiving messages sent by the Hook contract on the other chain, and emits a `MessageReceived` event.

[Fuji deployment](https://testnet.snowtrace.io/address/0xd76c8f9d77788d12bb93c70e89d52544fa4c4e91#code)

## Installation

To install the necessary dependencies, first ensure that you have [Foundry](https://book.getfoundry.sh/getting-started/installation) installed by running the following command:

```
curl -L https://foundry.paradigm.xyz | bash
```

Then run the following commands in the project's root directory:

```
foundryup
```

```
forge install
```

## Deployment

You will need to have a `.env` file in each directory with your `$PRIVATE_KEY`.

Replace `$PRIVATE_KEY`, `$SEPOLIA_RPC_URL` and `$FUJI_RPC_URL` in the `.env` with your respective private key and rpc url.

Deploy the `WormholeHook.sol` and `WormholeISM.sol` contracts to their chains by running the following commands:

```
source .env
```

```
forge script script/DeployWormholeISM.s.sol --rpc-url $FUJI_RPC_URL --private-key $PRIVATE_KEY --broadcast
```

Update the deploy script to include the ISM address in the Hook's constructor.

```
forge script script/DeployWormholeHook.s.sol --rpc-url $GOERLI_RPC_URL --private-key $PRIVATE_KEY --broadcast
```

## Tx Hashes

[Goerli Tx](https://goerli.etherscan.io/tx/0xc1b75cc2c973eb0018d97e6843c52f87a8edfcbb8ce6a13e3ce8e3d4c61d5b1d)

[Fuji Tx](https://testnet.snowtrace.io/tx/0x812109c579956f937296c64ea531f4d1986bc32bd5740889c3d35a940ae3f4d6)

## License

This project is licensed under the [MIT License](https://opensource.org/license/mit/).
