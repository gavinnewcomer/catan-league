// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IERC721TManager {
    function mint(address winner, uint256 tokenId) external;

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    function initalizeERC721T(
        string calldata name_,
        string calldata symbol_,
        address leagueLedger_
    ) external;
}
