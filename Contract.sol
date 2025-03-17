// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract AutomatedCharityDonations {
    address public owner;

    struct Charity {
        address payable charityAddress;
        string name;
        bool isApproved;
    }

    Charity[] public charities;

    mapping(address => uint256) public donations;
    uint256 public totalDonated;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action.");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addCharity(address payable _charityAddress, string memory _name) public onlyOwner {
        charities.push(Charity({
            charityAddress: _charityAddress,
            name: _name,
            isApproved: true
        }));
    }

    function removeCharity(uint256 index) public onlyOwner {
        require(index < charities.length, "Invalid index.");
        charities[index].isApproved = false;
    }

    function donate() external payable {
        require(msg.value > 0, "Donation must be greater than 0.");
        uint256 share = msg.value / getActiveCharityCount();

        for (uint256 i = 0; i < charities.length; i++) {
            if (charities[i].isApproved) {
                charities[i].charityAddress.transfer(share);
            }
        }

        donations[msg.sender] += msg.value;
        totalDonated += msg.value;
    }

    function getActiveCharityCount() public view returns (uint256 count) {
        for (uint256 i = 0; i < charities.length; i++) {
            if (charities[i].isApproved) {
                count++;
            }
        }
    }

    function getCharity(uint256 index) public view returns (address, string memory, bool) {
        Charity memory c = charities[index];
        return (c.charityAddress, c.name, c.isApproved);
    }

    function getCharityCount() public view returns (uint256) {
        return charities.length;
    }
}
