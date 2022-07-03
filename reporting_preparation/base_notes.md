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
2. pngcheck
3. zsteg
4. binwalk
5. steghide
6. stegsolve
7. stegcracker
8. SmartDeblur
9. tesseract
10. foremost

https://futureboy.us/stegano/decinput.html
http://stylesuxx.github.io/steganography/
https://www.mobilefish.com/services/steganography/steganography.php
https://manytools.org/hacker-tools/steganography-encode-text-into-image/
https://steganosaur.us/dissertation/tools/image
https://georgeom.net/StegOnline

Compressed file
Unzip it.
Use zipdetails -v command to display details about the internal structure of a Zip file.
Use zipinfo command to know details info about Zip file.
Use zip -FF input.zip --out output.zip attempt to repair a corrupted zip file.
Brute-force the zip password using fcrackzip -D -u -p rockyou.txt  filename.zip

To crack 7z run 7z2hashcat32-1.3.exe filename.7z. Then john --wordlist=/usr/share/wordlists/rockyou.txt hash
Music file
Use binwalk first. They may embedded something in the file.
Use Audacity.
Use Sonic Visualizer. Look at spectogram and other few Pane.
Use Deepsound.
Use SilentEye.
Some of online stegano decoder for music:-
https://steganosaur.us/dissertation/tools/audio
Text
Use http://www.spammimic.com/ that can decode hide message in spam text.
## secondary summary
After the secondary review of the server, we have the following to investigate.

2.
2.
2.
2.

## review 
