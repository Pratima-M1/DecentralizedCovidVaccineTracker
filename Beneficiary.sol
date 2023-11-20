// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract Beneficiary {
    //state variable declaration
    address private Admin;
    uint256[] private adhaarNumberRegistered;
    mapping(uint256 => BeneficiaryDetails) beneficiaries;
    mapping(uint256 => bool) isAdhaarNoRegistered;

    //Structure Definition
    // BeneficiaryDetails
    struct BeneficiaryDetails {
        string beneficiaryName;
        uint256 bAge;
        string bGender;
        uint256 bAdhaarNo;
        string bVaccineName;
        uint256 vaccineReferenceId;
        uint256 bDateOfVaccine;
        uint256 bDoseNumber;
        address hospitalId;
    }

    //constructor
    constructor() {
        Admin = msg.sender;
    }

    //modifiers

    modifier isBeneficiaryRegistered(uint256 _adhaarNo) {
        require(
            beneficiaries[_adhaarNo].bAdhaarNo == _adhaarNo,
            "benefiary is not registered"
        );
        _;
    }
    modifier onlyAdmin() {
        require(msg.sender == Admin, "only Admin can call the function");
        _;
    }

    //functions

    //Add new beneficiary
    function registerBeneficiaryDetails(
        string memory _name,
        uint256 _age,
        string memory _gender,
        uint256 _AdhaarNo
    ) public onlyAdmin {
        require(
            beneficiaries[_AdhaarNo].bAdhaarNo != _AdhaarNo,
            "Beneficiary is already registered"
        );
        beneficiaries[_AdhaarNo] = BeneficiaryDetails(
            _name,
            _age,
            _gender,
            _AdhaarNo,
            "",
            0,
            0,
            0,
            address(0)
        );
        adhaarNumberRegistered.push(_AdhaarNo);
        isAdhaarNoRegistered[_AdhaarNo] = true;
    }

    //remove the beneficiary
    function removeBeneficiary(uint256 _adhaarNo)
        public
        onlyAdmin
        isBeneficiaryRegistered(_adhaarNo)
    {
        delete beneficiaries[_adhaarNo];
    }

    //get beneficiary details
    function getBeneficiary(uint256 adhaarNo)
        public
        view
        isBeneficiaryRegistered(adhaarNo)
        returns (
            string memory,
            uint256,
            string memory,
            uint256,
            uint256,
            uint256
        )
    {
        return (
            beneficiaries[adhaarNo].beneficiaryName,
            beneficiaries[adhaarNo].bAdhaarNo,
            beneficiaries[adhaarNo].bVaccineName,
            beneficiaries[adhaarNo].vaccineReferenceId,
            beneficiaries[adhaarNo].bDateOfVaccine,
            beneficiaries[adhaarNo].bDoseNumber
        );
    }

    //total number of beneficiaries registered for covid vaccinations
    function totalNumberOfRegBeneficiaries() public view returns (uint256) {
        return adhaarNumberRegistered.length;
    }

    //update the beneficiary details with first details
    function updateBeneficiaryDetialsWithFirstDose(
        uint256 _adhaarNo,
        string memory _vaccineName,
        uint256 _vaccineReferenceId,
        address _hospitalId,
        uint256 _doseNumber
    ) public onlyAdmin isBeneficiaryRegistered(_adhaarNo) {
        require(checkAgeFirstDose(_adhaarNo), "not eligible for first dose");
        require(
            _doseNumber == 1 && beneficiaries[_adhaarNo].bDoseNumber == 0,
            "Please check vaccination details"
        );
        beneficiaries[_adhaarNo].bVaccineName = _vaccineName;
        beneficiaries[_adhaarNo].vaccineReferenceId = _vaccineReferenceId;
        beneficiaries[_adhaarNo].bDateOfVaccine = block.timestamp;
        beneficiaries[_adhaarNo].hospitalId = _hospitalId;
        beneficiaries[_adhaarNo].bDoseNumber = _doseNumber;
    }

    //update beneficiary details with second dose
    function updateBeneficiaryDetialsWithSecondDose(
        uint256 _adhaarNo,
        string memory _vaccineName,
        uint256 _vaccineReferenceId,
        address _hospitalId,
        uint256 _doseNumber
    ) public onlyAdmin isBeneficiaryRegistered(_adhaarNo) {
        require(
            _doseNumber == 2 && beneficiaries[_adhaarNo].bDoseNumber == 1,
            "Please check vaccination details"
        );
        require(checkAgeSecondDose(_adhaarNo), "Not  eligible for second dose");
        require(
            beneficiaries[_adhaarNo].vaccineReferenceId == _vaccineReferenceId,
            "first dose and second dose are different"
        );
        beneficiaries[_adhaarNo].bVaccineName = _vaccineName;
        beneficiaries[_adhaarNo].vaccineReferenceId = _vaccineReferenceId;
        beneficiaries[_adhaarNo].bDateOfVaccine = block.timestamp;
        beneficiaries[_adhaarNo].hospitalId = _hospitalId;
        beneficiaries[_adhaarNo].bDoseNumber = _doseNumber;
    }

    //eligibility check for first dose
    function checkAgeFirstDose(uint256 _adhaarNo)
        public
        view
        isBeneficiaryRegistered(_adhaarNo)
        returns (bool)
    {
        uint256 age = beneficiaries[_adhaarNo].bAge;
        if (age > 10) return true;
        return false;
    }

    //eligibility check for the second dose
    function checkAgeSecondDose(uint256 _adhaarNo)
        public
        view
        isBeneficiaryRegistered(_adhaarNo)
        returns (bool)
    {
        uint256 age = beneficiaries[_adhaarNo].bAge;
        if (age >= 18) return true;
        return false;
    }
}
