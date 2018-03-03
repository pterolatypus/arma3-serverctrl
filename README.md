# ArmA 3 ServerCtrl
By Pterolatypus

This is a fairly simple utility designed for managing multiple modded ArmA 3 servers simultaneously.

## Features:
- Support for installing and updating ArmA 3 server with ease
- Support for installing and updating workshop mods with ease
- Keeps server configurations & logs separate

## Installation:
- For best results install in an otherwise empty folder
- Download steamcmd.exe and place in a subfolder (recommended is 'steam')
- Run steamcmd.exe to install steam in the same folder
- Open serverctrl.bat and set the variables there to configure your installation (see Program Variables).
- Run serverctrl.bat and enjoy

## Usage

### Setting Up Servers:
Under ServerCtrl a 'server' is a folder containing:
- runserver.bat - the script used to actually run the server
- server.cfg - the ArmA server config file
- a profiles folder where the logs and userdata for that server is stored
- (optionally) a mods.txt file containing a list of mods to be run on the server

The profiles folder is created automatically by the server application; examples of the rest can be found in the scripts/server_template folder.

Within ServerCtrl a server is referred to by its folder name. These folders are expected to be next to the Steam and Arma installation folders in the 'server home' directory. Usually this will be wherever your serverctrl.bat file is.

### Commands:
The utility functions as a simple command-line interface. A small prompt will be displayed and commands can be typed to do various things. A list of commands is available in-app using the "help" or "h" command. Additionally, some commands have their own help pages which can be accessed with "help command".

#### Additional command parameters:
Adding 'switches' onto commands such as 'update-server -auto' can affect their behaviour.

##### Auto Mode
The '-auto' switch will run the command in Auto Mode. In this mode, commands that usually ask for user input will instead just use the values set in the program variables. Auto Mode is not available if any of the program variables are unset (you can check this with 'var list').

##### Quiet Mode
The '-q' switch will run certain commands in quiet mode, which produces no console output. This can be particularly useful when writing your own scripts to interface with or extend the utility.

### Program variables
The utility uses a collection of environment variables to store important information. Some of these variables are used for configuration information; those are shown in the serverctrl.bat file and can be viewed and altered from within the application using the 'var' command (and sub-commands)

- STEAMUSER = Your steam username, for downloading the server files or mods. This is used for Auto Mode, but you can leave it unset and enter it manually every time instead.
- STEAMPASS = Your steam password. As above.
- STEAMDIR = Subfolder containing Steam installation and steamcmd.exe
- ARMADIR = Subfolder to install ArmA 3 and mods to.
- BRANCH = ArmA 3 branch to install from. It's recommended to leave this as it is.
- MODFILE = File containing a list of workshop files to download. More details below.
- MODFOLDER = Path to a folder containing mods.

### Modfile:
The modfile is a plain-text file containing references to workshop files. Each line is one item in the format:
"modname modid"
Where modname is a human-readable name of your choice which you will use to refer to the mod, and modid is the Steam Workshop ID to associate it with. The two are separated with a single space.
Additionally, comments may be inserted by beginning a line with '//' - these lines will be ignored during parsing.
