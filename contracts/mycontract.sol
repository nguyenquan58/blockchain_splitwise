// SPDX-License-Identifier: UNLICENSED

// DO NOT MODIFY BELOW THIS
pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract Splitwise {
// DO NOT MODIFY ABOVE THIS

// ADD YOUR CONTRACT CODE BELOW
    struct IOU {
        address debtor;
        address creditor;
        uint32 amount;
    }

    mapping(address => mapping(address => uint32)) debt;
    IOU[] listIOU;

    function addtolistIOU(address debtor, address creditor,uint32 amount, bool res) public {
        IOU memory _IOU = IOU({debtor: debtor, creditor: creditor, amount: amount});
        if (listIOU.length==0) {
            listIOU.push(_IOU);
            return;
        }
        for (uint32 i=0; i<listIOU.length; i++) {
            if (listIOU[i].debtor==debtor && listIOU[i].creditor==creditor) {
                if (res==true)
                    listIOU[i].amount += amount;
                else 
                    listIOU[i].amount -= amount;
                return;
            }
        }
        listIOU.push(_IOU);
    }

    function add_IOU(address creditor, uint32 amount, bool res) public {
        require(msg.sender != creditor, "Cannot owe to yourself");
        if (res==true) {
            debt[msg.sender][creditor] += amount;
            addtolistIOU(msg.sender, creditor, amount, res);
        }
        else {
            require(debt[msg.sender][creditor]-amount>=0, "Debt must positive");
            debt[msg.sender][creditor] -= amount;
            addtolistIOU(msg.sender, creditor, amount, res);
        }
    }

    function lookup(address debtor, address creditor) public view returns (uint32 ret) {
        return debt[debtor][creditor];
    }

    function getlistIOU() public view returns (IOU[] memory ret) {
        return listIOU;
    }
}