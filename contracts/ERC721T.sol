// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { ERC721 } from "@openzeppelin/contracts-v0.7/token/ERC721/ERC721.sol";

contract ERC721T is ERC721 {

    address public leagueLedger;

    constructor() ERC721("Trophy", "TROPHY") {
        leagueLedger = msg.sender;
    }

    modifier onlyLeadgueLedger {
        if (msg.sender != leagueLedger) {
            revert("Only the league ledger can call this function.");
        }
    }

    function changeLeagueLedger public onlyLeadgueLedger {
        leagueLedger = newLeagueLedger;
    }
    
    function safeMint(address to, uint256 tokenId) public onlyLeadgueLedger {
        _safeMint(to, tokenId);
    }

    function _transfer(address from, address to, uint256 tokenId) internal override onlyLeadgueLedger {
        super._transfer(from, to, tokenId);
    }
    
}
