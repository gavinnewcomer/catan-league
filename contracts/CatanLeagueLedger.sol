// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { Ownable } from "./utils/Ownable.sol";
import { EnumerableSet } from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import { LeagueLedgerStructs } from "./structs/LeagueLedgerStructs.sol";
import { IERC721TManager } from "./interfaces/IERC721TManager.sol";

contract CatanLeagueLedger is Ownable, LeagueLedgerStructs {
    using EnumerableSet for EnumerableSet.AddressSet;

    EnumerableSet.AddressSet private leagueMembers;
    address public leagueERC721Trophy;
    uint256 public matchCount;
    mapping(address => uint256) public leagueMemberWins;
    mapping(bytes => ProposedMatchResult) public stagedMatchResults;

    event MatchResult(uint256[] victoryPoints, address[] leagueParticipants);

    constructor() {
        leagueMembers.add(msg.sender);
    }

    modifier onlyLeagueMember {
        if (!leagueMembers.contains(msg.sender)) {
            revert("Only league members can call this function.");
        }
        _;
    }

    function addLeagueMember(address newMember) external onlyLeagueMember {
        leagueMembers.add(newMember);
    }

    function deleteLeagueMember(address member) external onlyOwner {
        leagueMembers.remove(member);
    }

    function changeLeagueERC721Trophy(address newLeagueERC721Trophy) external onlyOwner {
        leagueERC721Trophy = newLeagueERC721Trophy;
        matchCount = 0;
    }

    function mintTrophy(uint256 numTrophiesToMint) external onlyOwner {
        IERC721TManager(leagueERC721Trophy).mint(numTrophiesToMint);
    }

    function proposeMatchResult(uint256[] memory victoryPoints, address[] memory leagueParticipants) external onlyLeagueMember {
        if (victoryPoints.length != leagueParticipants.length) {
            revert("number of reported victory points must be equal to reported participants");
        }
        bytes memory data = encodeTransactionData(victoryPoints, leagueParticipants);
        stagedMatchResults[data] = ProposedMatchResult(msg.sender, 0);
    }

    function confirmMatchResult(uint256[] memory victoryPoints, address[] memory leagueParticipants) external onlyLeagueMember {
        if (victoryPoints.length != leagueParticipants.length) {
            revert("number of reported victory points must be equal to reported participants");
        }
        bytes memory data = encodeTransactionData(victoryPoints, leagueParticipants);
        if (stagedMatchResults[data].originalProposer == msg.sender){
            revert("you proposed this match therefore you cannot confirm it");
        }
        commitMatchResult(victoryPoints, leagueParticipants);
        delete stagedMatchResults[data];
    }

    function commitMatchResult(uint256[] memory victoryPoints, address[] memory leagueParticipants) internal {
        address winner = leagueParticipants[0];
        uint256 winningPoints = victoryPoints[0];
        for (uint i=1; i<victoryPoints.length; ++i) {
            if (victoryPoints[i] > winningPoints) {
                winner = leagueParticipants[i];
                winningPoints = victoryPoints[i];
            }
        }
        leagueMemberWins[winner]++;
        matchCount++;
        IERC721TManager(leagueERC721Trophy).safeTransferFrom(address(this), winner, matchCount);
        emit MatchResult(victoryPoints, leagueParticipants);
    }

    function encodeTransactionData(
        uint256[] memory victoryPoints,
        address[] memory leagueParticipants
    ) internal view returns (bytes memory) {
        bytes32 safeTxHash =
            keccak256(
                abi.encode(
                    victoryPoints,
                    leagueParticipants,
                    matchCount
                )
            );
        return abi.encodePacked(safeTxHash);
    }

}
