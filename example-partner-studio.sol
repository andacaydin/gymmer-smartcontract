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

        uint fee;

        Rate memory closestRateEndTime = getClosestRateEndTime(startTime);
        uint currentYear;
        uint currentMonth;
        uint currentDay;
        (currentYear, currentMonth, currentDay) = timestampToDate(endTime);
        uint rateEndTimestamp = timestampFromDateTime(currentYear, currentMonth, currentDay, closestRateEndTime.endHour, closestRateEndTime.endMinute, closestRateEndTime.endSecond);

        if (rateEndTimestamp > endTime) {
            fee = (endTime - startTime) / 60 / 60 * closestRateEndTime.rate;
        }
        else {
            fee += calculateFee(rateEndTimestamp, endTime);
        }
        return fee;
    }

    /**
     *
     * Gets the time-wise Rate with closest endtime
     *
     */
    function getClosestRateEndTime(uint startTime) internal returns (Rate memory rate){
        uint weekDay = getDayOfWeek(startTime);
        uint currentYear;
        uint currentMonth;
        uint currentDay;
        (currentYear, currentMonth, currentDay) = timestampToDate(startTime);
        Rate[] memory ratesForWeekday = ratesForWeekdays[weekDay];
        Rate memory closestRate;
        uint closestRateEndTimestamp;

        for (uint index = 0; index < ratesForWeekday.length; index++) {

            Rate memory rateToCheck = ratesForWeekday[index];

            uint rateEndTimestamp = timestampFromDateTime(currentYear, currentMonth, currentDay, rateToCheck.endHour, rateToCheck.endMinute, rateToCheck.endSecond);

            if (closestRateEndTimestamp == 0 || (diffSeconds(startTime, closestRateEndTimestamp) > diffSeconds(startTime, rateEndTimestamp))) {
                closestRate = rateToCheck;
                closestRateEndTimestamp = rateEndTimestamp;
            }

        }
        return closestRate;
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