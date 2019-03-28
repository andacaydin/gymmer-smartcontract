/*
*   This Example SmartContract returns a hardcoded fee of 200 GYMMER-Coins, for any given time.
*   
*   This is the simplest way to "calculate" a fee.
*   startTime and endTime parameters are not used at all for calculation.
*
*/

pragma solidity >=0.4.22 <0.6.0;

import "./gymmer-main.sol";

contract ExamplePartnerStudioFixedRate is GymmerGymContract {


    function calculateFee(uint startTime, uint endTime) public returns (uint){
        return 200;
    }

    function getAddress() external returns (address){
        return address(this);
    }

}
