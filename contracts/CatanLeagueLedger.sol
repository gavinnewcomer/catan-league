// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { Ownable } from "./utils/Ownable.sol";
import {EnumerableSet} from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

contract CatanLeagueLedger is Ownable {
    using EnumerableSet for EnumerableSet.AddressSet;

    EnumerableSet.AddressSet private leagueMembers;
    address public leagueERC721Trophy;
    mapping(address => uint256) public leagueMemberWins;

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

    function addLeagueMember(address newMember) public onlyLeagueMember {
        leagueMembers.add(newMember);
    }

    function deleteLeagueMember(address member) public onlyLeagueMember {
        leagueMembers.remove(member);
    }

    function changeLeagueERC721Trophy(address newLeagueERC721Trophy) public onlyOwner {
        leagueERC721Trophy = newLeagueERC721Trophy;
    }

    function reportMatchResult(uint256[] memory victoryPoints, address[] memory leagueParticipants, bytes memory signature) public onlyLeagueMember {
        if (victoryPoints.length != leagueParticipants.length) {
            revert("number of reported victory points must be equal to reported participants");
        }

        bytes memory recreated_signature = abi.encode(victoryPoints, leagueParticipants);
        if (recreated_signature == signature) {
            revert("you must sign the same information you report");
        }

    }


}
