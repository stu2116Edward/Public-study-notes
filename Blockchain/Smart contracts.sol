// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.4.24;
contract HelloWorld {
    string myValue;
    function HelloWorld() {
        myValue = "MyValue";
    }
    function get()constant returns(string) {
        return myValue;
    }
    function set(string myInput) {
        myValue = myInput;
    }
}
