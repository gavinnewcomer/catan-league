// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { Ownable } from "./utils/Ownable.sol";

contract ERC721T is ERC721, Ownable {

    address public leagueLedger;
    uint256 public lastTokenIdMinted;

    constructor() ERC721("Trophy", "TROPHY") {}

    modifier onlyLeagueMember {
        if (msg.sender != leagueLedger) {
            revert("Only the league ledger can call this function");
        }
        _;
    }
    
    function changeLeagueLedger(address newLeagueLedger) external onlyOwner {
        leagueLedger = newLeagueLedger;
    }

    function mint(uint256 numTokensToMint) external onlyLeagueMember {
        for (uint i = lastTokenIdMinted; i < numTokensToMint + 1; ++i) {
            _mint(leagueLedger, i);
        }
        lastTokenIdMinted+=numTokensToMint;
    }

    function _transfer(address from, address to, uint256 tokenId) internal override {
        if (from != leagueLedger) {
            revert("Trophies cannot be moved once gifted.");
        }
        super._transfer(from, to, tokenId);
    }
    
}
