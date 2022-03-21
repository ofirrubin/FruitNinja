# FruitNinja
Fruit Ninja in Assembly 8086 [2020 Project]

## Project description
The project was created in 2020 in Assembly 8086. It's the final project for high-school Assembly class.


## How to run

### Prepare your environment
To run the program you will need 8086 simulator such as [DOSBox](https://dosbox.com)
You'll need to compile the program before running it.

The program is tested using  ```tasm``` and  ```tlink```

#### The following description is based on tests using ```DOSBox```

Copy the program to the compiler & linker root folder referred as ```root``` directory.
Make sure you either  ```root``` directory using ```mount c: <root>```, then navigate there using ```c:```

Change CPU cycles to max using ```cycles=MAX```

### Run
* Compile using: 

```tasm fNinja.asm```

* Then link using:

```tlink fNinja.obj```

* Run using: 

```fNinja```

### Run & Debug
* Compile using:

```tasm /zi fNinja.asm```

* Then link using:

```tlink /v fNinja.obj```

* Debug using debugger such as Turbo Debugger (```td```): 

```td fNinja```


### Reset the game score
From the main menu hit ```RESET GAME```
The high score is simply saved in binary form at file named ```HIGH.TXT``` removing the file will also reset the game.

