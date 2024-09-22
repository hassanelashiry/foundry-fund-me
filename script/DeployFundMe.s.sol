// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {FundMe} from "../src/FundMe.sol";
import {Script} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        HelperConfig helperConfig = new HelperConfig();
        address ethUsdPriceFeed = helperConfig.activeNetworkConfig();
        // Before startbraodcast -> not real transaction
        // After startbraodcast ->  real transaction

        vm.startBroadcast();
        FundMe FundMeVar = new FundMe(ethUsdPriceFeed);
        vm.stopBroadcast();
        return FundMeVar;
    }
}
