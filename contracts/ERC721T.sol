// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { Ownable } from "./utils/Ownable.sol";
import { GenericErrorsAndEvents } from "./utils/GenericErrorsAndEvents.sol";

contract ERC721T is ERC721, Ownable, GenericErrorsAndEvents {

    address public leagueLedger;
    uint256 public lastTokenIdMinted;
    bool initalized;

    constructor() {}

    modifier onlyLeagueLedger {
        if (msg.sender != leagueLedger) {
            revert("Only the league ledger can call this function");
        }
        _;
    }

    function initalizeERC721T(
        string calldata name_,
        string calldata symbol_,
        address leagueLedger_
    ) public onlyOwner {
        if (initalized) {
            revert AlreadyInitialized();
        }
        _name = name_; 
        _symbol = symbol_;
        leagueLedger = leagueLedger_;
        initalized = true;
    }
    
    function changeLeagueLedger(address newLeagueLedger) external onlyOwner {
        leagueLedger = newLeagueLedger;
    }

    function mint(address winner, uint256 tokenId) external onlyLeagueLedger{
        _mint(winner, tokenId);
    }

    function _transfer(address from, address to, uint256 tokenId) internal override {
        if (from != address(0)) {
            revert("Trophies cannot be moved once gifted.");
        }
        super._transfer(from, to, tokenId);
    }
    
}
