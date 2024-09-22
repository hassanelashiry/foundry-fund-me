// SPDX-License-Identifier: MIT
//we will do here a fund and withdraw script

pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 0.01 ether;

    function fundFundMeVar(address mostRecentlyDeployed) public {
        console.log("mostRecentlyDeployed= ", address(mostRecentlyDeployed).balance);
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).fund{value: SEND_VALUE}();
        vm.stopBroadcast();
        console.log("Funded FundME with =   %s", SEND_VALUE);
        console.log("mostRecentlyDeployed= ", address(mostRecentlyDeployed).balance);

    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        
        // Check the balance of the deployed contract
        console.log("Initial balance of FundMe:", address(mostRecentlyDeployed).balance);
        
        vm.startBroadcast(); // to begin broadcasting your transactions
        fundFundMeVar(mostRecentlyDeployed);
        vm.stopBroadcast();
        
        // Log the balance after funding
        console.log("Balance after funding:", address(mostRecentlyDeployed).balance);
    }
}

contract WithdrawFundMe is Script {
    uint256 constant SEND_VALUE = 0.01 ether;

    function withdrawFundMeVar(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).withdraw();
        vm.stopBroadcast();
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        vm.startBroadcast(); // to begin broadcasting your transactions
        withdrawFundMeVar(mostRecentlyDeployed);
        vm.stopBroadcast();
    }
}
