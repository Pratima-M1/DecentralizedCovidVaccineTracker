// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "./Beneficiary.sol";
import "./Hospital.sol";

contract Vaccine {
    //state variables
    address private Admin;
    event isVaccinated(string);
    Hospital public hospital;
    Beneficiary beneficiary;

    //constructor
    constructor(Beneficiary _beneficiary, Hospital _hospital) {
        Admin = msg.sender;
        beneficiary = Beneficiary(_beneficiary);
        hospital = Hospital(_hospital);
    }

    //modifiers

    //only hospital can update vaccine details of beneficiary
    modifier onlyHospital(address hospitalAdmin) {
        require(
            msg.sender == hospitalAdmin,
            "only registered hospital can call this function"
        );
        _;
    }
    //events
    event vaccinated(string, uint256, uint256, address);

    //functions

    //update beneficiary details with first dose
    function updateBeneficiaryWithFirstDose(uint256 _adhaarNo)
        public
        onlyHospital(msg.sender)
    {
        (, , string memory vaccineName, uint256 vaccineReferenceId) = hospital
            .getHospitalDetails(msg.sender);
        beneficiary.updateBeneficiaryDetialsWithFirstDose(
            _adhaarNo,
            vaccineName,
            vaccineReferenceId,
            msg.sender,
            1
        );
        emit vaccinated(
            "first Dose",
            _adhaarNo,
            vaccineReferenceId,
            msg.sender
        );
    }

    //update the beneficiary details with second dose
    function updateBeneficiaryWithSecondDose(uint256 _adhaarNo)
        public
        onlyHospital(msg.sender)
    {
        (, , string memory vaccineName, uint256 vaccineReferenceId) = hospital
            .getHospitalDetails(msg.sender);
        beneficiary.updateBeneficiaryDetialsWithSecondDose(
            _adhaarNo,
            vaccineName,
            vaccineReferenceId,
            msg.sender,
            2
        );
        emit vaccinated(
            "second dose",
            _adhaarNo,
            vaccineReferenceId,
            msg.sender
        );
    }

    //view Vaccination Details of given Beneficiary adhaar number
    function viewVaccinationStatus(uint256 _adhaarNo) public {
        (, , , , , uint256 doseNumber) = beneficiary.getBeneficiary(_adhaarNo);

        if (doseNumber == 1) {
            emit isVaccinated("first Dose");
        } else if (doseNumber == 2) {
            emit isVaccinated("second dose");
        }
        emit isVaccinated("not vaccinated");
    }
}
