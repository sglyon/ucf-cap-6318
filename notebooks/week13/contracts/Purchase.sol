// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22;

contract Purchase {
    uint256 public price;
    address payable public seller;
    address payable public buyer;

    enum State {
        Created, // 0
        Locked, // 1
        Released, // 2
        Inactive // 3
    }
    // The state variable has a default price of the first member, `State.created`
    State public state;

    modifier condition(bool _condition) {
        require(_condition);
        _;
    }

    modifier onlyBuyer() {
        // @assert
        require(msg.sender == buyer, "Only buyer can call this.");
        _;
    }

    modifier onlySeller() {
        require(msg.sender == seller, "Only seller can call this.");
        _;
    }

    modifier inState(State _state) {
        require(state == _state, "Invalid state.");
        _;
    }

    event Aborted();
    event PurchaseConfirmed();
    event ItemReceived();
    event SellerPaid(uint256 value);

    // Ensure that `msg.price` is an even number.
    // Division will truncate if it is an odd number.
    // Check via multiplication that it wasn't an odd number.
    constructor() payable {
        buyer = payable(msg.sender);
        price = msg.value / 2;
        require((2 * price) == msg.value, "Value has to be even.");
    }

    /// Abort the purchase and reclaim the ether.
    /// Can only be called by the seller before
    /// the contract is locked.
    function abort() public onlyBuyer inState(State.Created) {
        emit Aborted();
        state = State.Inactive;
        buyer.transfer(address(this).balance);
    }

    /// Confirm the purchase as buyer.
    /// Transaction has to include `2 * price` ether.
    /// The ether will be locked until confirmReceived
    /// is called.
    function confirmPurchase()
        public
        payable
        inState(State.Created)
        condition(msg.value == (2 * price))
    {
        emit PurchaseConfirmed();
        seller = payable(msg.sender);
        state = State.Locked;
    }

    /// Confirm that you (the buyer) received the item.
    /// This will release the locked ether.
    function confirmReceived() public onlyBuyer inState(State.Locked) {
        emit ItemReceived();
        state = State.Released;

        buyer.transfer(price);
    }

    /// This function refunds the seller, i.e.
    /// pays back the locked funds of the seller.
    function finalizePurchase() public onlySeller inState(State.Released) {
        state = State.Inactive;

        seller.transfer(3 * price);

        emit SellerPaid(3 * price);
    }
}
