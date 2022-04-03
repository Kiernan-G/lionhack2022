// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./IERC20.sol";

/**
 * @title ThingToGetTimesAndBalancesV1
 * @dev ?
 */
contract ThingToGetTimesAndBalancesV1 {

    struct HistoricalBalance {
        uint[] balances;
        uint[] timestamps; // unix timestamps since block.timestamp is uint
    }

    address governanceToken;
    mapping (address => uint) currentStake;
    mapping (address => HistoricalBalance) historicalBalances;

    constructor(address _governanceToken) {
        governanceToken = _governanceToken;
    }

    function stake(uint _amount) external {
        require(_amount > 0);

        currentStake[msg.sender] += _amount;
        historicalBalances[msg.sender].balances.push(currentStake[msg.sender]);
        historicalBalances[msg.sender].timestamps.push(block.timestamp);
        // TODO: will multiple txns per block give weird results?

        IERC20(governanceToken).transferFrom(msg.sender, address(this), _amount);

    }

    function unStake(uint _amount) external {
        require(_amount > 0);
        require(currentStake[msg.sender] > _amount);

        currentStake[msg.sender] -= _amount;
        historicalBalances[msg.sender].balances.push(currentStake[msg.sender]);
        historicalBalances[msg.sender].timestamps.push(block.timestamp);

        IERC20(governanceToken).transfer(msg.sender, _amount);

    }

    function getHistoricalBalances(address _address) external view returns(HistoricalBalance memory) {
        return historicalBalances[_address];
    }

}