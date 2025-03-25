//SPDF-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    //if we are on a local anvil, we deploy mocks
    //otherwise, grab the existing address drom the live network

    struct NetworkConfig {
        address priceFeed; //ETH/USD price feed address
    }

    NetworkConfig public activeNetworkConfig;
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        //prcie feed address
        NetworkConfig memory sepoliaConfig = NetworkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return sepoliaConfig;
    }

    //如果想加到任何chain著需要再复制一个函数，更改地址，加上rpc-url即可

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        {
            if (activeNetworkConfig.priceFeed != address(0)) {
                return activeNetworkConfig;
            }
            //it is different than the exist network
            //Deploy the mocks (fake contract),own pricefeed
            //return the mock address
            vm.startBroadcast();
            MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE); // constructor(uint8 _decimals, int256 _initialAnswer)
            vm.stopBroadcast();

            NetworkConfig memory anvilConfig = NetworkConfig({priceFeed: address(mockPriceFeed)});

            return anvilConfig;
        }
    }
}
