// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "openzeppelin-contracts/token/ERC20/ERC20.sol";
import "openzeppelin-contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "openzeppelin-contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "openzeppelin-contracts/access/Ownable.sol";

/**
 * @title RussianRuble
 * @dev Implementation of the Russian Ruble (RUB) stablecoin
 */
contract RussianRuble is ERC20, ERC20Burnable, ERC20Pausable, Ownable {
    // Number of decimals for the token
    uint8 private constant _decimals = 18;

    constructor() ERC20("Russian Ruble", "RUB") Ownable(msg.sender) {
        // Initial supply can be minted during deployment if needed
        // _mint(msg.sender, initialSupply);
    }

    /**
     * @dev Returns the number of decimals used for token precision
     */
    function decimals() public pure override returns (uint8) {
        return _decimals;
    }

    /**
     * @dev Mints new tokens. Can only be called by the owner.
     * @param to The address that will receive the minted tokens
     * @param amount The amount of tokens to mint
     */
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    /**
     * @dev Pauses all token transfers.
     * Requirements:
     * - The caller must be the owner.
     */
    function pause() public onlyOwner {
        _pause();
    }

    /**
     * @dev Unpauses all token transfers.
     * Requirements:
     * - The caller must be the owner.
     */
    function unpause() public onlyOwner {
        _unpause();
    }

    /**
     * @dev Overrides _update from ERC20 to include the whenNotPaused modifier
     */
    function _update(address from, address to, uint256 value) internal override(ERC20, ERC20Pausable) {
        super._update(from, to, value);
    }
} 