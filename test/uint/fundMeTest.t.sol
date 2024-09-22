// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract fundMeTest is Test {
    FundMe FundMeVar;
    address USER = makeAddr("user"); //make a fake user address

    function setUp() external {
        // fundMeVar = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe DeployFundMeVar = new DeployFundMe();
        FundMeVar = DeployFundMeVar.run();
        vm.deal(USER, 1000e18); // giving fake USER 1000 ETH
    }

    function testMinUSD_IsFive() public view {
        assertEq(FundMeVar.minUSD(), 5e18);
        console.log("Min USD = 5");
    }

    function testOwnerIsMsgDotSender() public view {
        assertEq(FundMeVar.getOwner(), msg.sender);
        console.log("fundMeTest address Is the Owner");
        // not msg.sender is thw owner
    }

    function testPriceFeedVersionIsAccurate() public view {
        uint256 version = FundMeVar.getVersion();
        console.log(version);
        assertEq(version, 4);
    }

    function testFundFailedWithoutEnoughEth() public {
        vm.expectRevert(); // the next line should revert
        // assert this tx fails/reverts
        FundMeVar.fund(); // empty means send 0 value | invalid
    }

    modifier funded() {
        vm.prank(USER); // the next tx will be send by USER
        FundMeVar.fund{value: 10e18}();
        _;
    }

    function testFundUpdatesFundedDataStructure() public funded {
        uint256 amountFunded = FundMeVar.getAddressToAmontFunded(USER);
        assertEq(amountFunded, 10e18);
    }

    function testAddFunderToArrayOfFunders() public funded {
        address funder = FundMeVar.getFunder(0);
        assertEq(funder, USER);
    }

    function testOnlyOwnerCanWithdraw() public funded {
        // fund with some money using funded Modifier

        // withdraw
        vm.prank(USER);
        vm.expectRevert(); // the next line it should revert
        FundMeVar.withdraw();
    }

    function testWithdrawWithASingleFunder() public funded {
        // Arrange
        uint256 startingOwnerBalance = FundMeVar.getOwner().balance;
        uint256 startingFundMeBalance = address(FundMeVar).balance;
        console.log("startingOwnerBalance  = ", startingOwnerBalance);
        console.log("startingFundMeBalance = ", startingFundMeBalance);

        // Act
        uint256 gasStart = gasleft();
        vm.txGasPrice(1);
        vm.prank(FundMeVar.getOwner());
        FundMeVar.withdraw(); // cost gas, (1) the gas price amount

        uint256 gasEnd = gasleft();
        uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice;
        console.log(gasUsed);

        // Assert
        uint256 endingOwnerBalance = FundMeVar.getOwner().balance;
        uint256 endingFundedMeBalance = address(FundMeVar).balance;
        console.log("endingOwnerBalance    = ", endingOwnerBalance);
        console.log("endingFundedMeBalance = ", endingFundedMeBalance);

        assertEq(endingFundedMeBalance, 0);
        assertEq(startingOwnerBalance + startingFundMeBalance, endingOwnerBalance);
    }

    function testWithdrawFromMultipleFunders() public funded {
        // Arrange setup
        uint160 numberOfFunders = 10; //uint160 for addresses
        uint160 startingFunderIndex = 1; // sometimes 0 revert with address
        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            // vm.prank create new address
            // vm.deal create new address
            // hoax setup a prank from an address that has ether
            hoax(address(i), 1e18);
            FundMeVar.fund{value: 1e18}();
            //fund the FundMe
        }

        uint256 startingOwnerBalance = FundMeVar.getOwner().balance;
        uint256 startingFundMeBalance = address(FundMeVar).balance;
        console.log("startingOwnerBalance  = ", startingOwnerBalance);
        console.log("startingFundMeBalance = ", startingFundMeBalance);

        // Act setup
        vm.startPrank(FundMeVar.getOwner());
        FundMeVar.withdraw();
        vm.stopPrank();

        // Assert setup
        assert(address(FundMeVar).balance == 0);
        assert(startingOwnerBalance + startingFundMeBalance == FundMeVar.getOwner().balance);
    }

    function testWithdrawFromMultipleFundersCheaper() public funded {
        // Arrange setup
        uint160 numberOfFunders = 10; //uint160 for addresses
        uint160 startingFunderIndex = 1; // sometimes 0 revert with address
        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            // vm.prank create new address
            // vm.deal create new address
            // hoax setup a prank from an address that has ether
            hoax(address(i), 1e18);
            FundMeVar.fund{value: 1e18}();
            //fund the FundMe
        }

        uint256 startingOwnerBalance = FundMeVar.getOwner().balance;
        uint256 startingFundMeBalance = address(FundMeVar).balance;
        console.log("startingOwnerBalance  = ", startingOwnerBalance);
        console.log("startingFundMeBalance = ", startingFundMeBalance);

        // Act setup
        vm.startPrank(FundMeVar.getOwner());
        FundMeVar.cheaperWithdraw();
        vm.stopPrank();

        // Assert setup
        assert(address(FundMeVar).balance == 0);
        assert(startingOwnerBalance + startingFundMeBalance == FundMeVar.getOwner().balance);
    }
}
