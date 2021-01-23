#! /bin/bash

VPN1=thm

read -p "What vpn will you be using? " VPN

if [ $VPN = $VPN1 ];
then
sudo openvpn ~/CTF/tryhackme/Karti.ovpn
else
sudo openvpn ~/CTF/hackthebox/Karti.ovpn
fi
