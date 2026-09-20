// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Escrow {
    address public immutable buyer;
    address payable public immutable seller;
    enum State { Created, Funded, Delivered, Refunded }
    State public state;
    event Deposited(uint256 amount);
    event Released(uint256 amount);
    event Refunded(uint256 amount);
    modifier onlyBuyer() { require(msg.sender == buyer, "Solo comprador"); _; }
    constructor(address payable sellerAddress) { buyer = msg.sender; seller = sellerAddress; state = State.Created; }
    function deposit() external payable onlyBuyer { require(state == State.Created && msg.value > 0, "Depósito inválido"); state = State.Funded; emit Deposited(msg.value); }
    function confirmDelivery() external onlyBuyer { require(state == State.Funded, "No financiado"); uint256 amount = address(this).balance; state = State.Delivered; seller.transfer(amount); emit Released(amount); }
    function cancel() external onlyBuyer { require(state == State.Funded, "No financiado"); uint256 amount = address(this).balance; state = State.Refunded; payable(buyer).transfer(amount); emit Refunded(amount); }
}
