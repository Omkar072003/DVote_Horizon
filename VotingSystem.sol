// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract VotingSystem {
    struct Candidate {
        string name;
        uint256 voteCount;
    }
    
    mapping(uint256 => Candidate) public candidates;
    mapping(address => bool) public hasVoted;
    
    uint256 public candidateCount;
    address public owner;
    
    event CandidateAdded(uint256 candidateId, string name);
    event VoteCast(address voter, uint256 candidateId);
    
    constructor() {
        owner = msg.sender;
    }
    
    function addCandidate(string calldata _name) external {
        require(msg.sender == owner, "Only owner can add candidates");
        candidateCount++;
        candidates[candidateCount] = Candidate(_name, 0);
        emit CandidateAdded(candidateCount, _name);
    }
    
    function vote(uint256 _candidateId) external {
        require(_candidateId > 0 && _candidateId <= candidateCount, "Invalid candidate");
        require(!hasVoted[msg.sender], "Already voted");
        
        hasVoted[msg.sender] = true;
        candidates[_candidateId].voteCount++;
        
        emit VoteCast(msg.sender, _candidateId);
    }
    
    function getCandidateVotes(uint256 _candidateId) external view returns (string memory name, uint256 voteCount) {
        require(_candidateId > 0 && _candidateId <= candidateCount, "Invalid candidate");
        Candidate storage candidate = candidates[_candidateId];
        return (candidate.name, candidate.voteCount);
    }
}