// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

import {IPostDispatchHook} from "@hyperlane-xyz/core/contracts/interfaces/hooks/IPostDispatchHook.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IWormholeRelayer} from "wormhole-solidity-sdk/interfaces/IWormholeRelayer.sol";

contract WormholeHook is Ownable {
    error WormholeHook__NoValueSent();
    error WormholeHook__NoValueSent__NeedsMorePayment(uint256 valueSent, uint256 calculatedFees);

    uint256 private constant GAS_LIMIT = 1000000;

    IWormholeRelayer public wormholeRelayer;
    address public ism; // targetAddress
    uint16 private targetChain;

    constructor(IWormholeRelayer _wormholeRelayer, address _ism, uint16 _targetChain) Ownable(msg.sender) {
        wormholeRelayer = _wormholeRelayer;
        ism = _ism;
        targetChain = _targetChain;
    }

    /**
     * @notice Post action after a message is dispatched via the Mailbox
     * param metadata The metadata required for the hook
     * @param message The message passed from the Mailbox.dispatch() call
     */
    function postDispatch(
        bytes calldata,
        /*metadata*/
        bytes calldata message
    ) external payable {
        if (msg.value == 0) revert WormholeHook__NoValueSent();
        (uint256 cost,) = wormholeRelayer.quoteEVMDeliveryPrice(targetChain, 0, GAS_LIMIT);
        if (msg.value < cost) revert WormholeHook__NoValueSent__NeedsMorePayment(msg.value, cost);
        if (msg.value > cost) {
            payable(msg.sender).transfer(msg.value - cost);
        }

        wormholeRelayer.sendPayloadToEvm{value: cost}(targetChain, ism, message, 0, GAS_LIMIT);
    }

    /**
     * @notice Compute the payment required by the postDispatch call
     * param metadata The metadata required for the hook
     * @param message The message passed from the Mailbox.dispatch() call
     * @return Quoted payment for the postDispatch call
     */
    function quoteDispatch(
        bytes calldata,
        /*metadata*/
        bytes calldata message
    ) public view returns (uint256) {
        (uint256 cost,) = wormholeRelayer.quoteEVMDeliveryPrice(targetChain, 0, GAS_LIMIT);
        return cost;
    }

    ///////// Setter Functions /////////////

    function setIsm(address _ism) public onlyOwner {
        ism = _ism;
    }

    function setWormholeRelayer(IWormholeRelayer _wormholeRelayer) public onlyOwner {
        wormholeRelayer = _wormholeRelayer;
    }

    function setTargetChain(uint16 _targetChain) public onlyOwner {
        targetChain = _targetChain;
    }
}
