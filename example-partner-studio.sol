pragma solidity >=0.4.22 <0.6.0;
import "./gymmer-main.sol";

contract ExamplePartnerStudio is GymmerGymContract {

    function calculateFee(uint startTime, uint endTime) external returns (int){
        return 666;
    }

    function getAddress() external returns (address){
        return address(this);
    }
}