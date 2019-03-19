pragma solidity >=0.4.22 <0.6.0;

/***
 *
 * Interface that has to be implemented by GYMs Smart Contracts
 *
 */

interface GymmerGymContract{
    function calculateFee(uint startTime, uint endTime) external returns (int);
    function getAddress() external returns (address);
}


/**
 *
 *
 * The MAIN GYMMER Contract. All checkins, checkouts need to go through this smart-contract
 *
 */
contract GymmerContract {




    /**
     *
     * The official GYMMER-Wallet
     *
     */
    address gymmerWallet;

    /**
    *
    * Registered GYMMER-GYMS
    *
    */
    Gym[] private gyms;
    mapping(address => Gym) gymWallets;

    /**
     *
     * Current Checkins By Gym.
     *
     */
    mapping(address => Checkin[]) gymCheckins;

    /**
     *
     * Current Checkin By ID.
     *
     */
    mapping(bytes32 => Checkin) gymCheckinById;


    struct Gym {
        string gymName;
        address wallet;
    }

    struct Checkin {
        address gymContract;
        address gymuser;
        uint startTime;
        uint endTime;
        bytes32 checkinId;
        int fee;
    }

    function checkMeIn(address _gymWallet, uint _startTime) public returns (bytes32 checkinId)  {
        bytes32 checkinId = sha256(abi.encode(msg.sender, _gymWallet, now));
        Checkin memory checkin = Checkin(_gymWallet, msg.sender, _startTime, 0, checkinId, 0);
        gymCheckins[_gymWallet].push(checkin);
        gymCheckinById[checkinId] = checkin;
        return checkinId;
    }

    function checkMeOut(bytes32 checkinId, uint _endTime) public {
        Checkin storage checkin = gymCheckinById[checkinId];
        checkin.endTime = _endTime;

        checkin.fee = GymmerGymContract(checkin.gymContract).calculateFee(checkin.startTime, checkin.endTime);
    }

    function getNumberCheckins(address _gymWallet) public returns (uint256 currentCheckins) {
        return (gymCheckins[_gymWallet].length);
    }

    function getCheckinById(bytes32 checkinId) public returns(address gymAddress, address userAddress, uint startTime, uint endTime, int fee){
        Checkin memory checkin = gymCheckinById[checkinId];
        return (checkin.gymContract, checkin.gymuser, checkin.startTime, checkin.endTime, checkin.fee);
    }

    function addGym(string memory _gymName, address _gymWallet) public {
        Gym storage gym = gymWallets[_gymWallet];
        gym.gymName = _gymName;
        gym.wallet = _gymWallet;
        gyms.push(gym);

    }

    function getNumberGyms() public returns (uint256 numberGyms) {
        return gyms.length;
    }


}