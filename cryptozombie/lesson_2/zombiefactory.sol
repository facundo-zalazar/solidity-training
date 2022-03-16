pragma solidity ^0.4.19;

contract ZombieFactory {

    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    mapping (uint => address) public zombieToOwner; //Un mapeo es esencialmente una asociación valor-clave 
    //para guardar y ver datos. 
    mapping (address => uint) ownerZombieCount; //Key - value

    function _createZombie(string _name, uint _dna) private {
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        //Ahora que tenemos nuestros mapeos para seguir el rastro del propietario de un zombi, 
        //queremos actualizar el metodo _createZombie para que los utilice.
        //Para poder hacer esto, necesitamos algo llamado msg.sender.
        //msg.sender hace referencia a la dirección de la persona (o el contrato inteligente) 
        //que ha llamado a esa función.  la única forma de que otra persona edite la información de 
        //esta sería robandole la clave privada asociada a la dirección Ethereum
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        NewZombie(id, _name, _dna);
    }

    function _generateRandomDna(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % dnaModulus;
    }

    function createRandomZombie(string _name) public {
        //require hace que la función lanze un error y pare de ejecutarse si la condición no es verdadera.
        //no queremos que un usuario pueda crear zombis ilimitados en su ejército llamado a createRandomZombie — 
        //esto haría que el juego no fuese muy divertido.
        //Vamos a usar require para asegurarnos que esta función solo pueda ser ejecutada una vez por 
        //usuario, cuando vayan a crear a su primer zombi.
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}
