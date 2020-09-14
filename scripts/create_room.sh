#!/bin/bash

read -p "what is the name of the new room? " new_room

mkdir ~/CTF/tryhackme/$new_room

mkdir ~/CTF/tryhackme/$new_room/nmap

cd  ~/CTF/tryhackme/$new_room

cp ~/CTF/base_notes.md $new_room.md

read -p "what is the IP address? " ip_address
export IP=$ip_address

subl $new_room.md 

terminator -l CTF

break
