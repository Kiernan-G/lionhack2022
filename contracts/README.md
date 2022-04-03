## Running in Remix instructions

1. deploy contracts/MyToken.sol, copy contract address
2. switch to staking contract tab, compile and deploy that with the address you copied
3. deploy Timelock.sol, copy contract addr
4. deploy GovernerAlphaTime.sol using timelock contract address and the mytoken contract address
5. approve (contracts/timeandbal.sol), 100000000000000000000 with address you copied
6. in new contract stake 80000000000000000000
7. and then unstake 70000000000000000000
8. mint tokens to address2, stake 10e18
9. make proposal
10. castvote address 1
11. castevote address 2
12. get status (address 1 should have more voting power for the previous transaction

