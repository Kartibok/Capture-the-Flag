# name of room

## rustscan
rustscan -a $IP --ulimit 5000
```shell

```
### nmap all ports
nmap -A -sC -sV $IP -p-
```shell

```
## nikto
nikto -h $IP -Display 2
```shell

```
## gobuster
### initial
gobuster dir -u $IP -w /usr/share/wordlists/dirb/common.txt
```shell

```
### secondary
gobuster dir -u $IP -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt
```shell

```
## website

### overview

### robots.txt

```shell

```
### cookies

```shell

```
### sourcecode

## initial summary
After the external review of the server, we have the following to investigate.

1.
1.
1.
1.


## ftp
```shell

```
## ssh
``` shell

```
## steganography

Utilise the following techniques on images and steganography challenges.

1. file
1. strings
1. exiftool
1. binwalk
1. steghide
1. stegsolve
1. stegcracker

## what is next


## review 
