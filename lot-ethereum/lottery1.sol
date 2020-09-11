/* Orchid - WebRTC P2P VPN Market (on Ethereum)
 * Copyright (C) 2017-2019  The Orchid Authors
*/

/* GNU Affero General Public License, Version 3 {{{ */
/* SPDX-License-Identifier: AGPL-3.0-or-later */
/*
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.

 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
**/
/* }}} */


pragma solidity 0.7.0;

import "./include.sol";

contract OrchidLottery1 {

    function safe(uint256 value) internal pure returns (uint128) {
        uint128 result = uint128(value);
        require(uint256(result) == value);
        return result;
    }


    struct Pot {
        uint128 amount_;
        uint128 escrow_;

        uint128 warned_;
        uint128 unlock_;

        OrchidVerifier verify_;
        bytes32 codehash_;
        bytes shared_;
    }

    event Update(address indexed funder, address indexed signer);


    struct Lottery {
        mapping(address => Pot) pots_;
    }

    mapping(address => Lottery) internal lotteries_;


    function find(address funder, address signer) private view returns (Pot storage) {
        return lotteries_[funder].pots_[signer];
    }

    function kill(address signer) external {
        address funder = msg.sender;
        Lottery storage lottery = lotteries_[funder];
        Pot storage pot = lottery.pots_[signer];
        if (pot.verify_ != OrchidVerifier(0))
            emit Bound(funder, signer);
        delete lottery.pots_[signer];
        emit Update(funder, signer);
    }


    function look(address funder, address signer) external view returns (uint128, uint128, uint128, uint256, OrchidVerifier, bytes32, bytes memory) {
        Pot storage pot = lotteries_[funder].pots_[signer];
        return (pot.amount_, pot.escrow_, pot.warned_, pot.unlock_, pot.verify_, pot.codehash_, pot.shared_);
    }


    function push(address signer, uint128 recover, uint128 transfer, uint128 destroy) external payable {
        address funder = msg.sender;
        Pot storage pot = find(funder, signer);

        uint256 escrow = pot.escrow_;
        uint256 amount = pot.amount_ + msg.value;

        if (recover != 0) {
            uint128 warned = pot.warned_;
            require(pot.unlock_ - 1 < block.timestamp);
            require(recover <= warned);
            amount += recover;
            escrow -= recover;
            warned -= recover;
            if (warned == 0)
                pot.unlock_ = 0;
            pot.warned_ = warned;
        }

        require(transfer <= amount);
        amount -= transfer;
        escrow += transfer;

        require(destroy <= escrow);
        escrow -= destroy;

        uint128 temp = safe(amount);
        pot.escrow_ = safe(escrow);
        pot.amount_ = temp;

        emit Update(funder, signer);
    }

    event Bound(address indexed funder, address indexed signer);

    function bind(address signer, OrchidVerifier verify, bytes calldata shared) external {
        address funder = msg.sender;
        Pot storage pot = find(funder, signer);
        require(pot.escrow_ == 0);

        bytes32 codehash;
        assembly { codehash := extcodehash(verify) }

        pot.verify_ = verify;
        pot.codehash_ = codehash;
        pot.shared_ = shared;

        emit Bound(funder, signer);
    }


    struct Track {
        uint256 until_;
    }

    mapping(address => mapping(bytes32 => Track)) internal tracks_;


    function take(address funder, address signer, address payable recipient, uint128 amount, bytes calldata receipt) private {
        Pot storage pot = find(funder, signer);

        uint128 cache = pot.amount_;

        if (cache >= amount) {
            cache -= amount;
            pot.amount_ = cache;
            emit Update(funder, signer);
        } else {
            amount = cache;
            pot.amount_ = 0;
            pot.escrow_ = 0;
            emit Update(funder, signer);
        }

        OrchidVerifier verify = pot.verify_;
        bytes32 codehash;
        bytes memory shared;
        if (verify != OrchidVerifier(0)) {
            codehash = pot.codehash_;
            shared = pot.shared_;
        }

        if (amount != 0)
            require(recipient.send(amount));

        if (verify != OrchidVerifier(0)) {
            bytes32 current; assembly { current := extcodehash(verify) }
            if (codehash == current)
                verify.book(shared, recipient, receipt);
        }
    }

    // the arguments to this function are carefully ordered for stack depth optimization
    function grab(
        bytes32 reveal, uint256 issued, bytes32 nonce,
        uint8 v, bytes32 r, bytes32 s,
        uint128 amount, uint128 ratio,
        uint256 start, uint128 range,
        address funder, address payable recipient,
        bytes calldata receipt, bytes32[] memory old
    ) external {
        require(start + range > block.timestamp);
        require(uint128(uint256(keccak256(abi.encode(reveal, issued, nonce)))) <= ratio);

        // this variable is being reused because I do not have even one extra stack slot
        bytes32 ticket; assembly { ticket := chainid() } ticket = keccak256(abi.encode(
            keccak256(abi.encode(keccak256(abi.encode(reveal)), nonce, recipient, receipt)),
            issued, address(this), ticket, amount, ratio, start, range, funder));
        address signer = ecrecover(ticket, v, r, s);

        {
            mapping(bytes32 => Track) storage tracks = tracks_[recipient];

            {
                Track storage track = tracks[keccak256(abi.encode(signer, ticket))];
                require(track.until_ == 0);
                track.until_ = start + range;
            }

            for (uint256 i = 0; i != old.length; ++i) {
                Track storage track = tracks[old[i]];
                if (track.until_ <= block.timestamp)
                    delete track.until_;
            }
        }

        if (start < block.timestamp) {
            uint128 limit = uint128(uint256(amount) * (range - (block.timestamp - start)) / range);
            if (amount > limit)
                amount = limit;
        }

        take(funder, signer, recipient, amount, receipt);
    }

    function give(address funder, address payable recipient, uint128 amount, bytes calldata receipt) external {
        address signer = msg.sender;
        take(funder, signer, recipient, amount, receipt);
    }


    function warn(address signer, uint128 warned) external {
        address funder = msg.sender;
        Pot storage pot = find(funder, signer);
        pot.warned_ = warned;
        pot.unlock_ = safe(block.timestamp + 1 days);
        emit Update(funder, signer);
    }

    function lock(address signer) external {
        address funder = msg.sender;
        Pot storage pot = find(funder, signer);
        pot.warned_ = 0;
        pot.unlock_ = 0;
        emit Update(funder, signer);
    }

    function pull(address signer, address payable target, bool autolock, uint128 amount, uint128 escrow) external {
        address funder = msg.sender;
        Pot storage pot = find(funder, signer);
        if (amount > pot.amount_)
            amount = pot.amount_;
        if (escrow > pot.escrow_)
            escrow = pot.escrow_;

        if (escrow != 0) {
            require(pot.warned_ >= escrow);
            require(uint256(pot.unlock_) - 1 < block.timestamp);
        }

        uint128 total = amount + escrow;
        pot.amount_ -= amount;
        pot.escrow_ -= escrow;

        if (autolock && pot.escrow_ == 0) {
            pot.warned_ = 0;
            pot.unlock_ = 0;
        }

        emit Update(funder, signer);
        if (total != 0)
            require(target.send(total));
    }
}