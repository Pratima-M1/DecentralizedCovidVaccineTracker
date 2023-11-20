// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract Hospital {
    //state Variables
    address private Admin;
    address[] private hospitalAddresses;
    mapping(address => HospitalDetails) private hospitals;

    //Structure Definition
    //Hospital Details
    struct HospitalDetails {
        string hospitalName;
        address hospitalId;
        string vaccineName;
        uint256 vaccineReferenceId;
    }

    //constructor
    constructor() {
        Admin = msg.sender;
    }

    //modifiers
    modifier onlyAdmin() {
        require(msg.sender == Admin, "only Admin can call this function");
        _;
    }

    modifier isRegisteredHospital(address _hospitalId) {
        require(
            hospitals[_hospitalId].hospitalId != address(0),
            "Hospital is not registered"
        );
        _;
    }

    //functions

    //Add new Hospital
    function addHospital(
        string memory _hospitalName,
        address _hospitalId,
        string memory _vaccineName,
        uint256 _vaccineReferenceId
    ) public onlyAdmin {
        require(
            hospitals[_hospitalId].hospitalId == address(0),
            "Hospital already registered"
        );

        hospitals[_hospitalId] = HospitalDetails(
            _hospitalName,
            _hospitalId,
            _vaccineName,
            _vaccineReferenceId
        );
        hospitalAddresses.push(_hospitalId); //add hospital address into an indexed array
    }

    //Remove the hospital for given hospital Id(Address)
    function removeHospital(address _hospitalId)
        public
        onlyAdmin
        isRegisteredHospital(_hospitalId)
    {
        delete hospitals[_hospitalId];
    }

    //get total number of Hospitals registered
    function getTotalNumberOfHospitalRegistered()
        public
        view
        returns (uint256)
    {
        return hospitalAddresses.length;
    }

    //Get Hospital Details for the fgiven hospital Address
    function getHospitalDetails(address _hospitalId)
        public
        view
        isRegisteredHospital(_hospitalId)
        returns (
            string memory,
            address,
            string memory,
            uint256
        )
    {
        return (
            hospitals[_hospitalId].hospitalName,
            hospitals[_hospitalId].hospitalId,
            hospitals[_hospitalId].vaccineName,
            hospitals[_hospitalId].vaccineReferenceId
        );
    }

    //to check if hospital is already registered
    function isHospistalRegistered(address _hospitalId)
        public
        view
        returns (bool)
    {
        if (hospitals[_hospitalId].hospitalId == _hospitalId) return true;
        return false;
    }
}
