// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract CampaignFactory {

struct CampaignDetails {
    address campaignAddress;
    uint minimumContribution;
    string title;
    string description;
    string imageUrl;
}

    CampaignDetails[] public deployedCampaigns;


    function createCampaign(uint minimum,string memory title,string memory description,string memory imageUrl) public {
        address newCampaign = address(new Campaign(minimum,msg.sender,title,description,imageUrl)); 
        deployedCampaigns.push(CampaignDetails({
            campaignAddress:newCampaign,
            minimumContribution:minimum,
            title:title,
            description:description,
            imageUrl:imageUrl
        }));
    }

    function getDeployedCampaigns() public view returns (CampaignDetails[] memory) {
        return deployedCampaigns;
    } 
}

contract Campaign {

    struct Request {
        string description;
        uint value;
        address recipient;
        bool complete;
        uint approvalCount;
        mapping(address => bool) approvals;
    }

    address public manager;
    string public imageUrl;
    string public title;
    string public description;
    uint public minimumContribution;
    mapping(address => bool) public approvers;
    uint public approversCount;
    uint public numRequests;
    mapping(uint => Request) public requests;

    modifier restricted(){
        require(msg.sender == manager);
        _;
    }

    constructor(uint minimum,address creator,string memory _title, string memory _description,string memory _imageUrl){
        manager = creator;
        imageUrl = _imageUrl;
        title = _title;
        description = _description;
        minimumContribution= minimum;
    }

    function contribute() public payable {
        require(msg.value >= minimumContribution);

        approvers[msg.sender] = true;
        approversCount++;
    }

    function createRequest(string memory _description,uint _value, address  _recipient) public restricted {
        Request storage r = requests[numRequests++];
        r.description = _description;
        r.value = _value;
        r.recipient = _recipient;
        r.complete = false;
        r.approvalCount = 0;
    }

    function approveRequest(uint index) public  {
        Request storage request = requests[index];

        require(approvers[msg.sender]);
        require(!request.approvals[msg.sender]);

        request.approvals[msg.sender] = true;
        request.approvalCount++;
    }

    function finalizeRequest(uint index) public restricted {
        Request storage request = requests[index];

        require(request.approvalCount > (approversCount / 2));
        require(!request.complete);

        payable(request.recipient).transfer(request.value);
        request.complete = true;
    }

    function getSummary()public view returns (
        uint,uint,uint,uint,address, string memory,string memory,string memory
        ) {
        return (
            minimumContribution,
            address(this).balance,
            numRequests,
            approversCount,
            manager,
            title,
            description,
            imageUrl
            );
    }
}