# name of room

## enumeration

### ping
ping $IP -c 4
```shell

```
### rustscan
rustscan -a $IP --ulimit 5000
```shell

```
### masscan
masscan -p1-65535,U:1-65535 $IP --rate=1000 -e tun0
```shell

```
### nmap all ports
nmap -A -sC -sV $IP -p-
```shell

```
### nikto
nikto -h $IP -Display 2
```shell

```
### gobuster
#### initial
gobuster dir -u $IP -w /usr/share/wordlists/dirb/common.txt
```shell

```
#### secondary
gobuster dir -u $IP -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt
```shell

```
### feroxbuster
feroxbuster --url http://$IP --depth 2 --wordlist /usr/share/wordlists/wfuzz/general/megabeast.txt
```shell

```
### wpscan
wpscan --url $IP
```shell

```
### ftp
```shell

```
### ssh
``` shell

```
## website

### overview

### robots.txt
```html

```
### sitemap
```xml

```
### cookies
```text

```
### sourcecode
```html

```
## initial summary
After the initial review of the server, we have the following to investigate.

1.
1.
1.
1.

### steganography if required

Utilise the following techniques on images and steganography challenges.

1. file
1. strings
1. exiftool
1. binwalk
1. steghide
1. stegsolve
1. stegcracker

## secondary summary
After the secondary review of the server, we have the following to investigate.

2.
2.
2.
2.

## review 
