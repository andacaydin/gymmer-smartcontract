pragma solidity >=0.4.22 <0.6.0;
pragma experimental ABIEncoderV2;

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
    mapping(address => Gym) public gymWallets;

    /**
     *
     * Current Checkins By Gym.
     *
     */
    mapping(address => Checkin[]) public gymCheckins;

    /**
     *
     * Current Checkin By ID.
     *
     */
    mapping(bytes32 => Checkin) public gymCheckinById;


    struct Gym {
        string gymName;
        address wallet;
    }

    struct Checkin {
        Gym gym;
        address gymuser;
        uint startTime;
        uint endTime;
        bytes32 checkinId;
    }

    function checkMeIn(address _gymWallet) public {
        bytes32 checkinId = sha256(abi.encode(msg.sender, _gymWallet, now));
        Checkin memory checkin = Checkin(gymWallets[_gymWallet], msg.sender, 10, 0, checkinId);
        gymCheckins[_gymWallet].push(checkin);
        gymCheckinById[checkinId] = checkin;
    }

    function checkMeOut(bytes32 checkinId) public {
        Checkin storage checkin = gymCheckinById[checkinId];
        checkin.endTime = now;
    }

    function getCheckins(address _gymWallet) public returns (uint256 currentCheckins, Checkin[] memory checkins) {
        return (gymCheckins[_gymWallet].length, gymCheckins[_gymWallet]);
    }

    function addGym(string memory _gymName, address _gymWallet) public {
        Gym storage gym = gymWallets[_gymWallet];
        gym.gymName = _gymName;
        gyms.push(Gym(_gymName, _gymWallet));

    }

    function getNumberGyms() public returns (uint256 numberGyms) {
        return gyms.length;
    }


}