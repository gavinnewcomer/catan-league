// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IERC721TManager {
    function mint(uint256 numTrophiesToMint) external;
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
}