#!/bin/bash

read -p "what account are you using for the new room? " account

read -p "what is the name of the new room? " new_room

mkdir ~/CTF/$account/$new_room

mkdir ~/CTF/$account/$new_room/nmap

cd  ~/CTF/$account/$new_room

cp ~/CTF/base_notes.md $new_room.md

read -p "what is the IP address? " ip_address

export IP=$ip_address

subl $new_room.md 

terminator -l CTF
