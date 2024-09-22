// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

error notOwner();

contract FundMe {
    using PriceConverter for uint256;

    mapping(address => uint256) private s_addressToAmountFunded;
    address[] private s_funders;

    address private immutable i_owner;
    uint256 public constant minUSD = 5 * 1e18;
    AggregatorV3Interface private s_priceFeed;

    constructor(address priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    function fund() public payable {
        require(msg.value.getConversionRate(s_priceFeed) >= minUSD, "You need to spend more ETH!");
        s_addressToAmountFunded[msg.sender] += msg.value;
        s_funders.push(msg.sender);
    }

    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    modifier onlyOwner() {
        if (msg.sender != i_owner) revert notOwner();
        _;
    }

    /*////////////////////////////////////////////////////////
            this function not withdraw the fund! 
    ////////////////////////////////////////////////////////// 

    function withdraw() public onlyOwner {
        for (
            uint256 funderIndex =0; funderIndex < s_funders.length;
            funderIndex ++
            ){
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);
    }
    */

    /*////////////////////////////////////////////////////////
                Withdraw Function Adjustment
    ////////////////////////////////////////////////////////*/

    function withdraw() public onlyOwner {
        for (uint256 funderIndex = 0; funderIndex < s_funders.length; funderIndex++) {
            address funder = s_funders[funderIndex];
            uint256 amount = s_addressToAmountFunded[funder];
            s_addressToAmountFunded[funder] = 0;
            payable(i_owner).transfer(amount);
        }
        s_funders = new address[](0);
    }

    function cheaperWithdraw() public onlyOwner {
        uint256 funderLength = s_funders.length;
        for (uint256 funderIndex = 0; funderIndex < funderLength; funderIndex++) {
            address funder = s_funders[funderIndex];
            uint256 amount = s_addressToAmountFunded[funder];
            s_addressToAmountFunded[funder] = 0;
            payable(i_owner).transfer(amount);
        }
        s_funders = new address[](0);
    }

    function getAddressToAmontFunded(address fundingAddress) external view returns (uint256) {
        return s_addressToAmountFunded[fundingAddress];
    }

    function getFunder(uint256 index) external view returns (address) {
        return s_funders[index];
    }

    function getOwner() external view returns (address) {
        return i_owner;
    }
}
