// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract CloneFactoryEventsAndErrors {
    event ClonedLeagueLedger(address newLedger);
    event ClonedERC721T(address newToken);
    event UsernameChanged(address owner, string username);
    event OwnerShipChanged(address newOwner, address leagueContract);

    error OwnershipUpdateError(address existingContract);
}
