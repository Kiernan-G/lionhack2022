// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.7;

import "./ThingToGetTimesAndBalancesV1.sol";

contract VotePower {
    
    function GetVotePower(address dataSource, address voter) external view returns(uint) {
        ThingToGetTimesAndBalancesV1.HistoricalBalance memory hb = ThingToGetTimesAndBalancesV1(dataSource).getHistoricalBalances(voter);
        return calculateArea(hb.timestamps, hb.balances, 0, block.timestamp);
    }

    function calculateArea(uint[] memory timestamps, uint[] memory balances, uint lowerTimeBound, uint upperTimeBound) public pure returns (uint) {
        require(upperTimeBound > lowerTimeBound);
        require(timestamps.length >= 1);
        require(balances.length == timestamps.length);
        
        uint area = 0;

        // if only 1 entry
        if (timestamps.length == 1) {
            if (timestamps[0] < upperTimeBound) {
                if (timestamps[0] < lowerTimeBound) { // t [ ]
                    
                    return (upperTimeBound - lowerTimeBound) * balances[0];
                }
                else { // [ t ]
                    return (upperTimeBound - timestamps[0]) * balances[0];
                }
            }
            else { // [ ] t
                return 0;
            }
        }

        // all but last entry
        for(uint i = 0; i < timestamps.length-1; i++){
            // i j [ ]
            if (timestamps[i+1] <= lowerTimeBound) {
                continue;
            }
            // i [ j ]
            else if (timestamps[i] <= lowerTimeBound && timestamps[i+1] >= lowerTimeBound && timestamps[i+1] <= upperTimeBound) {
                area += (timestamps[i+1]-lowerTimeBound) * balances[i];
            }
            // i [ ] j
            else if (timestamps[i] <= lowerTimeBound && timestamps[i+1] >= upperTimeBound) {
                area += (upperTimeBound - lowerTimeBound) * balances[i];
                break;
            }
            // [ i j ]
            else if (timestamps[i] >= lowerTimeBound && timestamps[i+1] <= upperTimeBound) {
                area += (timestamps[i+1] - timestamps[i]) * balances[i];
            }
            // [ i ] j
            else if (timestamps[i] >= lowerTimeBound && timestamps[i] <= upperTimeBound && timestamps[i+1] >= lowerTimeBound) {
                area += (upperTimeBound - timestamps[i]) * balances[i];
                break;
            }
            // [ ] i j
            else if (timestamps[i] >= upperTimeBound) {
                break;
            }
            else {
                // how did you get here?
            }
        }

        // last entry
        if (upperTimeBound > timestamps[timestamps.length-1]) {
            area += (upperTimeBound - timestamps[timestamps.length-1]) * balances[timestamps.length-1];
        }

        return area;
    }

}
