pragma solidity ^0.4.25;    //Versión de Solidity

//Crear contrato
contract ZombieFactory {

    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;    //ADN del zombie
    uint dnaModulus = 10 ** dnaDigits;  //Para asegurarnos de que el ADN de nuestro Zombi 
    //tiene solo 16 dígitos, creemos un número entero sin signo igual a 10^16 y usémoslo 
    //para calcular el módulo cualquiera.

    struct Zombie { //Estructura de cada zombie
        string name;
        uint dna;
    }

    Zombie[] public zombies;    //Vamos a guardar un ejército de zombis en nuestra 
    //aplicación. Y vamos a querer mostrar todos nuestros zombis a otras aplicaciones, 
    //así que lo queremos público.
    //Otros contratos entonces podrán leer (pero no escribir) de este array. 
    //Es un patrón de uso muy útil para guardar datos públicos en tu contrato.

    function _createZombie(string _name, uint _dna) private {   //Crear zombies
        //zombies.push(Zombie(_name, _dna)); //Agregar nuevo zombie al array
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        emit NewZombie(id, _name, _dna);
    }

    function _generateRandomDna(string _str) private view returns (uint) {  //Generar ADN random
        uint rand = uint(keccak256(_str));  //SHA3
        return rand % dnaModulus;   //Queremos que nuestro ADN tenga solamente 16 dígitos 
        //(¿Recuerdas nuestra variable dnaModulus?). Así que la segunda línea de código debería 
        //devolver el módulo del valor de arriba (%) dnaModulus.
    }

    function createRandomZombie(string _name) public {
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}
