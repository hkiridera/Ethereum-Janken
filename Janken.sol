pragma solidity ^0.4.0;

// bet is wei
// if you send wei, you can get double with the probability of 1/3.
// and, It triples with a probability of 1/7.
contract Janken {
    address owner;
    address contract_address;
    
    event Send(address from, address to, uint value);
    function Janken() {
        owner = msg.sender;
        contract_address = address(this);
    }
    //Return balance of the contract 
    function getBalance() constant returns (uint) {
        return contract_address.balance;
    }
    //Execute when remitting to the contract
    function () payable {
        // check your bet
        uint bet = msg.value;

        // if you bet more than contract balance, finish this program.
        if ( getBalance()/4 < bet) {
            msg.sender.transfer(bet);
        } else {
            //get chalenger address.
            address challenger = msg.sender;
        
            //Use timestamps instead of random values
            uint rnd = now;
        
            //Jactpot
            //If it is divisible 7 times, it will be tripled
            if ( rnd % 7 == 0 ) {
                msg.sender.transfer(bet*3);
            }
        
            //If it is divisible 3 times, it will be douobles
            if ( rnd % 3 == 0 ) {
                // send wei
                if ( challenger.send(bet*2)) {
                    //win event
                    Send(contract_address, challenger, bet * 2);
                }
            } else {
                //lose event
                Send(contract_address, challenger, 0);
            }
        }
    }
    // delete smartcontract
    function kill() {
        if (msg.sender == owner) {
            selfdestruct(owner);
        }
     }
}