//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {FundMe} from "../src/FundMe.sol";
import {Script} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        //Before startBroadcast is not a transaction,no spend gas
        HelperConfig helpConfig = new HelperConfig();
        address ethUsdPriceFeed = helpConfig.activeNetworkConfig();

        //after startBroadcast is a real transaction
        vm.startBroadcast();
        FundMe fundMe = new FundMe(ethUsdPriceFeed); //0x694AA1769357215DE4FAC081bf1f309aDC325306;
        vm.stopBroadcast();
        return fundMe;
    }
}
