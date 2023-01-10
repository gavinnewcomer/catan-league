// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {CloneFactoryStructs} from "../structs/CloneFactoryStructs.sol";
import {Ownable} from "../utils/Ownable.sol";
import {CloneFactoryEventsAndErrors} from "../utils/CloneFactoryEventsAndErrors.sol";
import {IERC721TManager} from "../interfaces/IERC721TManager.sol";
import {ICatanLeagueLedger} from "../interfaces/ICatanLeagueLedger.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";

contract CatanLeagueCloneFactory is
    CloneFactoryStructs,
    CloneFactoryEventsAndErrors,
    Ownable
{
    mapping(address => ContractOwner) public ownershipLedger;

    constructor() {}

    function ownershipUpdateCallback(
        address newOwner,
        address existingContract
    ) external {
        if (ownershipLedger[existingContract].ownerAddress != msg.sender) {
            revert OwnershipUpdateError(existingContract);
        }
        ownershipLedger[existingContract].ownerAddress = newOwner;
        emit OwnerShipChanged(newOwner, existingContract);
    }

    function cloneERC721T(
        address implementation,
        address ledger,
        string calldata name_,
        string calldata symbol_
    ) internal returns (address) {
        address clone = Clones.clone(implementation);
        emit ClonedERC721T(clone);
        IERC721TManager(clone).initalizeERC721T(name_, symbol_, ledger);
        return clone;
    }

    function cloneLeagueLedger(
        address implementation,
        string calldata leagueName
    ) internal returns (address) {
        address clone = Clones.clone(implementation);
        emit ClonedLeagueLedger(clone);

        ownershipLedger[clone] = ContractOwner(msg.sender, leagueName);
        emit OwnerShipChanged(msg.sender, clone);
        ICatanLeagueLedger(clone).inializeLedger(address(this));
        return clone;
    }

    function createFreshLeagueTemplate(
        address erc721Implementation,
        address ledgerImplementation,
        string calldata name_,
        string calldata symbol_,
        string calldata leagueName
    ) external {
        address clonedLeagueLedger = cloneLeagueLedger(
            ledgerImplementation,
            leagueName
        );
        address clonedERC721T = cloneERC721T(
            erc721Implementation,
            clonedLeagueLedger,
            name_,
            symbol_
        );
        ICatanLeagueLedger(clonedLeagueLedger).changeLeagueERC721Trophy(
            clonedERC721T
        );
    }
}
