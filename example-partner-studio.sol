pragma solidity >=0.4.22 <0.6.0;

import "./gymmer-main.sol";
import "./BokkyPooBahsDateTimeLibrary.sol";

contract ExamplePartnerStudio is GymmerGymContract {

    struct Rate {
        string name;
        uint weekDay;
        uint startHour; uint startMinute; uint startSecond;
        uint endHour; uint endMinute; uint endSecond;
        uint256 rate;
    }

    Rate[] rates;
    mapping(uint => Rate[]) ratesForWeekdays;

    function addRate(string memory name, uint8 weekDay, uint startHour, uint startMinute, uint startSecond,
        uint endHour, uint endMinute, uint endSecond, uint256 rate) public {
        Rate memory rate = Rate(name, weekDay, startHour, startMinute, startSecond,
            endHour, endMinute, endSecond, rate);
        rates.push(rate);
        ratesForWeekdays[weekDay].push(rate);

    }

    function calculateFee(uint startTime, uint endTime) public returns (uint){
        return calculateFeeInternal(startTime, endTime, 0, 0);
    }
    
    function calculateFeeInternal(uint startTime, uint endTime, int callNo, uint fee) private returns (uint){
        
        callNo++;
        if(callNo > 2){
            revert("More then 2 recursive calls!");
        }
        Rate memory closestRateEndTime = getEffectiveRate(startTime);
        uint currentYear;
        uint currentMonth;
        uint currentDay;
        (currentYear, currentMonth, currentDay) = timestampToDate(endTime);
        uint rateEndTimestamp = timestampFromDateTime(currentYear, currentMonth, currentDay, closestRateEndTime.endHour, closestRateEndTime.endMinute, closestRateEndTime.endSecond);

        if (rateEndTimestamp < endTime) {
              fee += calculateFeeInternal(rateEndTimestamp +1 , endTime, callNo, fee); //add a second so the next rate will be used
              log1(uinttoBytes(fee), "incoming fee");
              endTime = rateEndTimestamp;
        }
    
        fee += (endTime - startTime) / 60 / 60 * closestRateEndTime.rate;
        log1(uinttoBytes(closestRateEndTime.rate), "used rate");
    
        log1(uinttoBytes(fee), "returning fee");
        return fee;
    }

    /**
     *
     * Gets the time-wise Rate with closest endtime
     *
     */
    function getEffectiveRate(uint startTime) internal returns (Rate memory rate){
        uint weekDay = getDayOfWeek(startTime);
        uint currentYear;
        uint currentMonth;
        uint currentDay;
        (currentYear, currentMonth, currentDay) = timestampToDate(startTime);
        Rate[] memory ratesForWeekday = ratesForWeekdays[weekDay];
        Rate memory effectiveRate;

        for (uint index = 0; index < ratesForWeekday.length; index++) {

            Rate memory rateToCheck = ratesForWeekday[index];
            uint rateStartTimestamp = timestampFromDateTime(currentYear, currentMonth, currentDay, rateToCheck.startHour, rateToCheck.startMinute, rateToCheck.startSecond);
            uint rateEndTimestamp = timestampFromDateTime(currentYear, currentMonth, currentDay, rateToCheck.endHour, rateToCheck.endMinute, rateToCheck.endSecond);
            
            if (startTime >= rateStartTimestamp && startTime <= rateEndTimestamp) {
                effectiveRate = rateToCheck;
            }
        }
        log1(stringToBytes32(effectiveRate.name), "chosen effectiveRate");
        return effectiveRate;
    }

    function uinttoBytes(uint256 x) private returns (bytes32 b) {
        return bytes32(x);
    }
    
    function stringToBytes32(string memory source) private returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }
        
        assembly {
            result := mload(add(source, 32))
        }
    }

    function getAddress() external returns (address){
        return address(this);
    }


    //BokkyPooBahsDateTimeLibrary uses

    function timestampToDate(uint timestamp) public pure returns (uint year, uint month, uint day) {
        (year, month, day) = BokkyPooBahsDateTimeLibrary.timestampToDate(timestamp);
    }

    function timestampToDateTime(uint timestamp) public pure returns (uint year, uint month, uint day, uint hour, uint minute, uint second) {
        (year, month, day, hour, minute, second) = BokkyPooBahsDateTimeLibrary.timestampToDateTime(timestamp);
    }

    function getDayOfWeek(uint timestamp) public pure returns (uint dayOfWeek) {
        dayOfWeek = BokkyPooBahsDateTimeLibrary.getDayOfWeek(timestamp);
    }

    function diffSeconds(uint fromTimestamp, uint toTimestamp) public pure returns (uint _seconds) {
        _seconds = BokkyPooBahsDateTimeLibrary.diffSeconds(fromTimestamp, toTimestamp);
    }

    function timestampFromDateTime(uint year, uint month, uint day, uint hour, uint minute, uint second) public pure returns (uint timestamp) {
        return BokkyPooBahsDateTimeLibrary.timestampFromDateTime(year, month, day, hour, minute, second);
    }


}
