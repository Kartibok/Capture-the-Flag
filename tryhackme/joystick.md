# joystick CTF

IP = 10.10.142.101

## nmap
```
~/CTF/tryhackme/joystick$ nmap -sC -sV -A 10.10.142.101
Starting Nmap 7.80 ( https://nmap.org ) at 2020-08-06 09:21 BST
Nmap scan report for 10.10.142.101
Host is up (0.040s latency).
Not shown: 997 closed ports
PORT   STATE SERVICE VERSION
21/tcp open  ftp     vsftpd 3.0.3
|_ftp-anon: got code 500 "OOPS: vsftpd: refusing to run with writable root inside chroot()".
22/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 c7:ce:5d:fa:24:68:3a:10:63:f9:28:1b:f4:6d:e5:bc (RSA)
|   256 6b:7b:f5:12:e0:db:bb:b0:ca:f8:f8:c0:84:bc:27:e6 (ECDSA)
|_  256 1b:d4:20:23:d0:5b:32:16:ad:c2:a9:cd:99:1c:e6:6e (ED25519)
80/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
|_http-server-header: Apache/2.4.18 (Ubuntu)
|_http-title: JoyStick Gaming
Service Info: OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 12.05 seconds

```
So we see that we have three ports open, 21, 22 and 80.

## nikto
```
~/CTF/tryhackme/joystick$ nikto  -h 10.10.142.101
- Nikto v2.1.6
---------------------------------------------------------------------------
+ Target IP:          10.10.142.101
+ Target Hostname:    10.10.142.101
+ Target Port:        80
+ Start Time:         2020-08-06 09:21:45 (GMT1)
---------------------------------------------------------------------------
+ Server: Apache/2.4.18 (Ubuntu)
+ The anti-clickjacking X-Frame-Options header is not present.
+ The X-XSS-Protection header is not defined. This header can hint to the user agent to protect against some forms of XSS
+ The X-Content-Type-Options header is not set. This could allow the user agent to render the content of the site in a different fashion to the MIME type
+ No CGI Directories found (use '-C all' to force check all possible dirs)
+ Server may leak inodes via ETags, header found with file /, inode: 23c, size: 58814a0eea52b, mtime: gzip
+ Apache/2.4.18 appears to be outdated (current is at least Apache/2.4.37). Apache 2.2.34 is the EOL for the 2.x branch.
+ Allowed HTTP Methods: OPTIONS, GET, HEAD, POST 
+ OSVDB-3233: /icons/README: Apache default file found.
+ 7889 requests: 0 error(s) and 7 item(s) reported on remote host
+ End Time:           2020-08-06 09:29:03 (GMT1) (438 seconds)
---------------------------------------------------------------------------
+ 1 host(s) tested

```
Nothing really jumps out with this report.

## gobuster

```
~/CTF/tryhackme/joystick$ gobuster dir -u 10.10.142.101 -w /usr/share/wordlists/dirbuster/directory-list-2.3-small.txt
===============================================================
Gobuster v3.0.1
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@_FireFart_)
===============================================================
[+] Url:            http://10.10.142.101
[+] Threads:        10
[+] Wordlist:       /usr/share/wordlists/dirbuster/directory-list-2.3-small.txt
[+] Status codes:   200,204,301,302,307,401,403
[+] User Agent:     gobuster/3.0.1
[+] Timeout:        10s
===============================================================
2020/08/06 10:23:44 Starting gobuster
===============================================================

```

Again not much of interest here.

## website enumeration

Pretty a blank webpage so lets check out the source.

```
<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <meta charset="utf-8">
    <title>JoyStick Gaming</title>
  </head>
  <body>
    <p>JoyStick gaming minecraft server, open shortly to the public!</p>
    <!-- Zach, I don't care that you named your user steve. You still need to
      finish making the website -->
    <!-- Great, and now the FTP server just doesn't work. Just another great idea after
	your failed irc chat. Why would we use that when we have in game chat? 
	Not to mention that I know you still haven't reset your password.  -->
  </body>
</html> 
```
Looks like we have possible usernames - steve and maybe zach. With Steve not changing his password it could be a simple easy to crack one. Lets try hydra for ftp first.

## hydra ftp
```
~/CTF/tryhackme/joystick$ hydra -l steve -P /usr/share/wordlists/rockyou.txt ftp://10.10.142.101
Hydra v9.0 (c) 2019 by van Hauser/THC - Please do not use in military or secret service organizations, or for illegal purposes.

Hydra (https://github.com/vanhauser-thc/thc-hydra) starting at 2020-08-06 09:33:08
[DATA] max 16 tasks per 1 server, overall 16 tasks, 14344399 login tries (l:1/p:14344399), ~896525 tries per task
[DATA] attacking ftp://10.10.142.101:21/
[STATUS] 201.00 tries/min, 201 tries in 00:01h, 14344198 to do in 1189:25h, 16 active
[STATUS] 206.33 tries/min, 619 tries in 00:03h, 14343780 to do in 1158:38h, 16 active
[STATUS] 204.57 tries/min, 1432 tries in 00:07h, 14342967 to do in 1168:33h, 16 active
[STATUS] 221.15 tries/min, 3321 tries in 00:15h, 14341078 to do in 1080:47h, 16 active
[21][ftp] host: 10.10.142.101   login: steve   password: changeme
1 of 1 target successfully completed, 1 valid password found
Hydra (https://github.com/vanhauser-thc/thc-hydra) finished at 2020-08-06 09:50:44

```
So after a cup of tea we have the username and password. Lets check out the FTP.

```
ftp 10.10.142.101
Connected to 10.10.142.101.
220 (vsFTPd 3.0.3)
Name (10.10.142.101:): steve
331 Please specify the password.
Password:
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> ls
200 PORT command successful. Consider using PASV.
150 Here comes the directory listing.
drwxr-xr-x    2 ftp      ftp          4096 May 03  2019 Desktop
drwxr-xr-x    2 ftp      ftp          4096 May 03  2019 Documents
drwxr-xr-x    2 ftp      ftp          4096 May 03  2019 Downloads
drwxr-xr-x    2 ftp      ftp          4096 May 03  2019 Music
drwxr-xr-x    2 ftp      ftp          4096 May 03  2019 Pictures
drwxr-xr-x    2 ftp      ftp          4096 May 03  2019 Public
drwxr-xr-x    2 ftp      ftp          4096 May 03  2019 SteveStuff
drwxr-xr-x    2 ftp      ftp          4096 May 03  2019 Templates
drwxr-xr-x    2 ftp      ftp          4096 May 03  2019 Videos
-rw-r--r--    1 ftp      ftp          8980 May 03  2019 examples.desktop
-rw-rw-r--    1 ftp      ftp        589485 May 03  2019 snes.png
-rw-r--r--    1 ftp      ftp            19 May 03  2019 user.txt
```
I also had a look at the actual home directory and find we have two other users.
```
tp> pwd
257 "/home/steve" is the current directory
ftp> cd ..
250 Directory successfully changed.
ftp> pwd
257 "/home" is the current directory
ftp> ls
200 PORT command successful. Consider using PASV.
150 Here comes the directory listing.
drwxr-xr-x    4 ftp      ftp          4096 May 04  2019 minecraft
drwxr-xr-x   18 ftp      ftp          4096 May 04  2019 notch
drwxr-xr-x   17 ftp      ftp          4096 May 04  2019 steve
226 Directory send OK.
ftp> 

```
Looking at Steve's home directory we can see the user.txt for the flag. 

I did try the anonymous access to the FTP but it errored.

```
~/CTF/tryhackme/joystick$ ftp 10.10.142.101
Connected to 10.10.142.101.
220 (vsFTPd 3.0.3)
Name (10.10.142.101:): anonymous
500 OOPS: vsftpd: refusing to run with writable root inside chroot()
```
I did some research on this and it appears that the ftp structure that we are trying to access is set to writeable.

I then thought that if the FTP has been set up incorrectly, that I may be able to fully access the file structure from the browser. This I was able to do but for the life of me I can't replicate it, though I was able to get the root flag as it was in the notch folder.

Checking with the username and password I also tried it on SSH and it worked.

My second completed - on my own!!

I must be getting better :)

Regards

K

![](/images/Karti.png)
