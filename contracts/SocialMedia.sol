// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

contract SocialMedia {
    address public benefactory;
    mapping (address=>string) status; //Status je povezan sa korisničkom adresom, tj. za svaku adresu korisnika pamtimo njegov status.

    event ChangeStatus(address user, string status);

    constructor(address benefactoryAdr) { //u konstruktoru imamo samo adresu banofaktora za pokretanje ugovora
        benefactory = benefactoryAdr;
    }

    function newStatus(string memory newStatusStr) external returns (string memory) { // Funkcija za menjanje Statusa
        address adr = msg.sender; // storujemo u pomocnu promenljivu
        status[adr] = newStatusStr; // u mapu na abresu sendera upisujemo novi status
        emit ChangeStatus(adr, newStatusStr); // poyivamo emit ya obavestenje promene Statusa
        return "Status updated successfully!"; // YaYYYYY
    }

    function checkStatus(address checkAdr) view public returns(string memory) { //funkcija za prikayivanje statusa odredjene adrese
        string memory readStatus = status[checkAdr];
        return readStatus; // vracamo status te adrese
    }
}