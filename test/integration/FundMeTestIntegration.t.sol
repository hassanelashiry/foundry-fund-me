// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract fundMeTestInteractions is Test {
    FundMe FundMeVar;
    address USER = makeAddr("user"); //make a fake user address

    function setUp() external {
        // fundMeVar = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe DeployFundMeVar = new DeployFundMe();
        FundMeVar = DeployFundMeVar.run();
        vm.deal(USER, 1000e18); // giving fake USER 1000 ETH
    }

    function testUserCanFundInteractions() public {
        FundFundMe FundFundMeVar = new FundFundMe();
        FundFundMeVar.fundFundMeVar(address(FundMeVar));
        console.log("FundMeVar balance= ", address(FundMeVar).balance);

        WithdrawFundMe WithdrawFundMeVar = new WithdrawFundMe();
        WithdrawFundMeVar.withdrawFundMeVar(address(FundMeVar));
        assert(address(FundMeVar).balance == 0);
    }
}
