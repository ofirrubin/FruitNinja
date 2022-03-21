# FruitNinja
Fruit Ninja in Assembly 8086 [2020 Project]

## Project description
The project was created in Assembly 8086. It's the final project for high-school Assembly class [early 2020].

![menub](https://user-images.githubusercontent.com/45829637/159379810-2b45f941-4f4f-4083-bef4-20b30d7912f4.jpg)


## How to run

### Prepare your environment
To run the program you will need 8086 simulator such as [DOSBox](https://dosbox.com)

The program created using  ```tasm``` and  ```tlink``` while debugged using ```td``` (turbo debugger)

#### The following description is based on tests using ```DOSBox```
The ```root``` directory is a directory contains all the program files.
Make sure you mount ```root``` directory using ```mount c: <root>```, then navigate there using ```c:```

Change CPU cycles to max using ```cycles=MAX```

### Run
Simply run using the executable name: ```fNinja```

### Debug

Copy the program to the compiler & linker to the ```root``` directory.

#### Compile for running
* Compile using:      ```tasm fNinja.asm```

* Then link using:      ```tlink fNinja.obj```

* Run using:      ```fNinja```

#### Compile for debugging
* Compile using:      ```tasm /zi fNinja.asm```

* Then link using:      ```tlink /v fNinja.obj```

* Debug using debugger such as turbo debugger (```td```):       ```td fNinja```


### Reset the game score
From the main menu hit ```RESET GAME```
The high score is simply saved in binary form at file named ```HIGH.TXT``` removing the file will also reset the game.

