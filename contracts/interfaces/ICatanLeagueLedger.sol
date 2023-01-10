// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

interface ICatanLeagueLedger {
    function inializeLedger(address leagueFactory_) external;

    function changeLeagueERC721Trophy(address erc721T) external;
}
