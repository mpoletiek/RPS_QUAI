// SPDX-License-Identifier: MIT

pragma solidity ^0.8.22;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @dev Implementation of the ERC20 token with permit functionality and ownership.
 */
contract MyToken is ERC20, ERC20Permit, Ownable {
    constructor(
        string memory name_,
        string memory symbol_,
        uint256 totalSupply_,
        address initialOwner_
    ) ERC20(name_, symbol_) ERC20Permit(name_) Ownable(initialOwner_) {
        _mint(initialOwner_, totalSupply_);
    }

    /**
     * @dev Mints tokens to a specified address. Only callable by the owner.
     * @param to The address to mint tokens to
     * @param amount The amount of tokens to mint
     */
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    /**
     * @dev Burns tokens from a specified address. Only callable by the owner.
     * @param from The address to burn tokens from
     * @param amount The amount of tokens to burn
     */
    function burn(address from, uint256 amount) public onlyOwner {
        _burn(from, amount);
    }

    /**
     * @dev Returns the version of the contract.
     */
    function version() public pure returns (string memory) {
        return "1";
    }
}
