# pokemon CTF

IP = 10.10.10.88

## nmap

So lets start with nmap and see what we get:
```
~/CTF/tryhackme/pokemon$ nmap -A -sC -sV 10.10.10.88
Starting Nmap 7.80 ( https://nmap.org ) at 2020-08-11 20:54 BST
Nmap scan report for 10.10.10.88
Host is up (0.020s latency).
Not shown: 998 closed ports
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 58:14:75:69:1e:a9:59:5f:b2:3a:69:1c:6c:78:5c:27 (RSA)
|   256 23:f5:fb:e7:57:c2:a5:3e:c2:26:29:0e:74:db:37:c2 (ECDSA)
|_  256 f1:9b:b5:8a:b9:29:aa:b6:aa:a2:52:4a:6e:65:95:c5 (ED25519)
80/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
|_http-server-header: Apache/2.4.18 (Ubuntu)
|_http-title: Can You Find Them All?
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel
```
Looks like we only have the two ports one for ssh and the other for http. What about folder structures - gobuster next.

## gobuster
```
~/CTF/tryhackme/pokemon$ gobuster dir -u thm.thm -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt 
===============================================================
Gobuster v3.0.1
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@_FireFart_)
===============================================================
[+] Url:            http://thm.thm
[+] Threads:        10
[+] Wordlist:       /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt
[+] Status codes:   200,204,301,302,307,401,403
[+] User Agent:     gobuster/3.0.1
[+] Timeout:        10s
===============================================================
2020/08/12 06:19:38 Starting gobuster
===============================================================
/server-status (Status: 403)
===============================================================
2020/08/12 06:27:43 Finished
===============================================================
```
Not much here that is visible, lets move on.

## website enumeration

If we view source, we find two areas of interest: a script and a possible username and password.
```
<script type="text/javascript">
    	const randomPokemon = [
    		'Bulbasaur', 'Charmander', 'Squirtle',
    		'Snorlax',
    		'Zapdos',
    		'Mew',
    		'Charizard',
    		'Grimer',
    		'Metapod',
    		'Magikarp'
    	];
    	const original = randomPokemon.sort((pokemonName) => {
    		const [aLast] = pokemonName.split(', ');
    	});

    	console.log(original);
    </script>
```
My scripting is not so hot, other than it showing me a list of possible pokemon. That might come in handy later. From nmap we know that there is an ssh port. So lets try that with the possible username and password.
```
<pokemon>:<hack_the_pokemon>
        	<!--(Check console for extra surprise!)-->
```
## ssh
So using the password and username we get access to the server. Let's have a look around.
```
pokemon@root:~$ ls
Desktop  Documents  Downloads  examples.desktop  Music  Pictures  Public  Templates  Videos
pokemon@root:~$ cd Desktop
pokemon@root:~/Desktop$ ls
P0kEmOn.zip
pokemon@root:~/Desktop$ unzip P0kEmOn.zip 
Archive:  P0kEmOn.zip
   creating: P0kEmOn/
  inflating: P0kEmOn/grass-type.txt  
pokemon@root:~/Desktop$ cd P0kEmOn/
pokemon@root:~/Desktop/P0kEmOn$ ls
grass-type.txt
pokemon@root:~/Desktop/P0kEmOn$ cat grass-type.txt 
50 6f 4b 65 4d 6f 4e 7b 42 75 6c 62 61 73 61 75 72 7d
```
Starting with Desktop we find a zip file. Unzip that and we get a folder with a text file. This gives us what appears to be a hex code. Using the GCHQ Cyberchef we find it is the first flag. Using the Magic operation within Cyberchef, it confirms that it is more likely to be "From Hex" or "From Hexdump."
```
PoKeMoN{Bulbasaur}
```
Lets check the rest of the folders in his home drive.
```
pokemon@root:~$ ls -lAh *
-rw-r--r-- 1 pokemon pokemon 8.8K Jun 22 19:36 examples.desktop

Desktop:
total 8.0K
drwxrwxr-x 2 pokemon pokemon 4.0K Jun 22 22:37 P0kEmOn
-rw-rw-r-- 1 pokemon pokemon  383 Jun 22 22:40 P0kEmOn.zip

Documents:
total 0

Downloads:
total 0

Music:
total 0

Pictures:
total 0

Public:
total 0

Templates:
total 0

Videos:
total 4.0K
drwxrwxr-x 3 pokemon pokemon 4.0K Jun 22 23:10 Gotta
```
Looks like we have something in his Video folder. More files!!
```
pokemon@root:~$ cd Videos/Gotta/
pokemon@root:~/Videos/Gotta$ ls
Catch
pokemon@root:~/Videos/Gotta$ cd Catch/
pokemon@root:~/Videos/Gotta/Catch$ ls
Them
pokemon@root:~/Videos/Gotta/Catch$ cd Them/
pokemon@root:~/Videos/Gotta/Catch/Them$ ls
ALL!
pokemon@root:~/Videos/Gotta/Catch/Them$ cd ALL\!/
pokemon@root:~/Videos/Gotta/Catch/Them/ALL!$ ls
Could_this_be_what_Im_looking_for?.cplusplus
pokemon@root:~/Videos/Gotta/Catch/Them/ALL!$ file Could_this_be_what_Im_looking_for\?.cplusplus 
Could_this_be_what_Im_looking_for?.cplusplus: C source, ASCII text
pokemon@root:~/Videos/Gotta/Catch/Them/ALL!$ cat Could_this_be_what_Im_looking_for\?.cplusplus 
```
Right the folder structure follows the quote from the game and after some research, the file style is C++.
```
# include <iostream>

int main() {
	std::cout << "ash : pikapika"
	return 0;
}
```
The format however is similar to the pokemon username and password we had from the view source. Lets put this to one side for the moment.

Lets continue the enumeration of the /home folder.
```
pokemon@root:/home$ ls -lAh *
-rwx------  1 ash     root       8 Jun 22 23:21 roots-pokemon.txt

ls: cannot open directory 'ash': Permission denied
pokemon:
total 112K
-rw-------  1 pokemon pokemon    0 Aug 11 11:17 .bash_history
-rw-r--r--  1 pokemon pokemon  257 Aug 11 11:09 .bash_logout
-rw-r--r--  1 pokemon pokemon 4.0K Aug 12 01:26 .bashrc
drwx------ 15 pokemon pokemon 4.0K Aug 12 01:26 .cache
drwx------  3 pokemon pokemon 4.0K Jun 22 20:00 .compiz
drwx------ 15 pokemon pokemon 4.0K Jun 22 19:58 .config
drwx------  3 root    root    4.0K Jun 22 22:50 .dbus
drwxr-xr-x  3 pokemon pokemon 4.0K Aug 12 01:27 Desktop
-rw-r--r--  1 pokemon pokemon   25 Jun 22 22:56 .dmrc
drwxr-xr-x  2 pokemon pokemon 4.0K Jun 22 19:46 Documents
drwxr-xr-x  2 pokemon pokemon 4.0K Jun 22 19:46 Downloads
-rw-r--r--  1 pokemon pokemon 8.8K Jun 22 19:36 examples.desktop
drwx------  2 pokemon pokemon 4.0K Jun 22 19:46 .gconf
drwx------  3 pokemon pokemon 4.0K Aug 12 01:15 .gnupg
-rw-------  1 pokemon pokemon 3.4K Aug 12 01:15 .ICEauthority
drwx------  3 pokemon pokemon 4.0K Jun 22 19:46 .local
drwx------  5 pokemon pokemon 4.0K Jun 22 19:52 .mozilla
drwxr-xr-x  2 pokemon pokemon 4.0K Jun 22 19:46 Music
drwxrwxr-x  2 pokemon pokemon 4.0K Aug 11 11:04 .nano
drwxr-xr-x  2 pokemon pokemon 4.0K Jun 22 19:46 Pictures
-rw-r--r--  1 pokemon pokemon  655 Jun 22 19:36 .profile
drwxr-xr-x  2 pokemon pokemon 4.0K Jun 22 19:46 Public
-rw-r--r--  1 pokemon pokemon    0 Jun 22 19:47 .sudo_as_admin_successful
drwxr-xr-x  2 pokemon pokemon 4.0K Jun 22 19:46 Templates
drwxr-xr-x  3 pokemon pokemon 4.0K Jun 22 23:10 Videos
-rw-------  1 pokemon pokemon   49 Aug 12 01:15 .Xauthority
-rw-------  1 pokemon pokemon   82 Aug 12 01:15 .xsession-errors
-rw-------  1 pokemon pokemon 1.3K Aug 11 13:21 .xsession-errors.old
```
We now see another home folder, ash, which we have no access, though the username is teh same as teh coded C++ piece, followed by a new text document belonging to root - roots-pokemon.txt. 

Before we continue with Ash, lets check out the www folders as gobuster never picked up anything exciting.
```
pokemon@root:/home$ cd /var/www/html/
pokemon@root:/var/www/html$ ls
index.html  water-type.txt
pokemon@root:/var/www/html$ cat water-type.txt 
Ecgudfxq_EcGmP{Ecgudfxq}
```
So another flag, again encrpyed. 

This time it looks like a Caesar Cypher. I tried ROT13 using the same Cyberchef tool from GCHQ and was successful in decoding the flag. This was found by moving ROT 13 forward one :)


## privalage escalation 
Let's see what we can do with pokemon , either go up or sideways to view Ash's home drive.

```
pokemon@root:/home$ sudo -l
[sudo] password for pokemon: 
Sorry, user pokemon may not run sudo on root.
```
Looks like no Sudo for Pokemon. What about SUID files:
```
pokemon@root:/home$ find / -perm -4000 2>/dev/null
/bin/umount
/bin/ping6
/bin/ping
/bin/su
/bin/fusermount
/bin/mount
/usr/bin/sudo
/usr/bin/passwd
/usr/bin/chsh
/usr/bin/gpasswd
/usr/bin/chfn
/usr/bin/newgrp
/usr/bin/pkexec
/usr/lib/eject/dmcrypt-get-device
/usr/lib/xorg/Xorg.wrap
/usr/lib/x86_64-linux-gnu/oxide-qt/chrome-sandbox
/usr/lib/dbus-1.0/dbus-daemon-launch-helper
/usr/lib/openssh/ssh-keysign
/usr/lib/snapd/snap-confine
/usr/lib/policykit-1/polkit-agent-helper-1
/usr/sbin/pppd
```
Nothing jumps out for me at the moment, so lets try the possible password for Ash we found in the C++ file.
```
pokemon@root:/home$ su ash
Password: 
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

bash: /home/ash/.bashrc: Permission denied
ash@root:/home$ id
uid=1001(ash) gid=1001(ash) groups=1001(ash),27(sudo)
ash@root:/home$ 
```
OK So we now have access to Ash's area and we can see he has sudo privilages. Lets look around first. Looks like we can't use cd as a command so lets ls everything as root.
```
ash@root:/home$ sudo ls -lAh *
-rwx------  1 ash     root       8 Jun 22 23:21 roots-pokemon.txt

ash:
total 16K
drwx------ 3 root root 4.0K Jun 24 14:14 .cache
drwx------ 5 root root 4.0K Jun 24 14:14 .config
drwx------ 3 root root 4.0K Jun 24 14:13 .dbus
drwxr-xr-x 3 root root 4.0K Jun 24 14:14 .local

pokemon:
total 112K
-rw-------  1 pokemon pokemon    0 Aug 11 11:17 .bash_history
-rw-r--r--  1 pokemon pokemon  257 Aug 11 11:09 .bash_logout
-rw-r--r--  1 pokemon pokemon 4.0K Aug 12 01:26 .bashrc
drwx------ 15 pokemon pokemon 4.0K Aug 12 01:26 .cache
drwx------  3 pokemon pokemon 4.0K Jun 22 20:00 .compiz
drwx------ 15 pokemon pokemon 4.0K Jun 22 19:58 .config
drwx------  3 root    root    4.0K Jun 22 22:50 .dbus
drwxr-xr-x  3 pokemon pokemon 4.0K Aug 12 01:27 Desktop
-rw-r--r--  1 pokemon pokemon   25 Jun 22 22:56 .dmrc
drwxr-xr-x  2 pokemon pokemon 4.0K Jun 22 19:46 Documents
drwxr-xr-x  2 pokemon pokemon 4.0K Jun 22 19:46 Downloads
-rw-r--r--  1 pokemon pokemon 8.8K Jun 22 19:36 examples.desktop
drwx------  2 pokemon pokemon 4.0K Jun 22 19:46 .gconf
drwx------  3 pokemon pokemon 4.0K Aug 12 01:15 .gnupg
-rw-------  1 pokemon pokemon 3.4K Aug 12 01:15 .ICEauthority
drwx------  3 pokemon pokemon 4.0K Jun 22 19:46 .local
drwx------  5 pokemon pokemon 4.0K Jun 22 19:52 .mozilla
drwxr-xr-x  2 pokemon pokemon 4.0K Jun 22 19:46 Music
drwxrwxr-x  2 pokemon pokemon 4.0K Aug 11 11:04 .nano
drwxr-xr-x  2 pokemon pokemon 4.0K Jun 22 19:46 Pictures
-rw-r--r--  1 pokemon pokemon  655 Jun 22 19:36 .profile
drwxr-xr-x  2 pokemon pokemon 4.0K Jun 22 19:46 Public
-rw-r--r--  1 pokemon pokemon    0 Jun 22 19:47 .sudo_as_admin_successful
drwxr-xr-x  2 pokemon pokemon 4.0K Jun 22 19:46 Templates
drwxr-xr-x  3 pokemon pokemon 4.0K Jun 22 23:10 Videos
-rw-------  1 pokemon pokemon   49 Aug 12 01:15 .Xauthority
-rw-------  1 pokemon pokemon   82 Aug 12 01:15 .xsession-errors
-rw-------  1 pokemon pokemon 1.3K Aug 11 13:21 .xsession-errors.old

```
Nothing showing within Ash's home drive so lets read the roots-pokemon.txt
```
ash@root:/home$ sudo cat roots-pokemon.txt 
Pikachu!
```
This looks like it could be the answer to root's favorite pokemon!!

So now we have his favorite, the grass and water pokemon, so we just need to find the last one - the fire pokemon.

I couldn't find anythingthat jumped out so I tried a search with fire as root and for a txt file and was lucky first time.

```
ash@root:/$ sudo find / -name fire*.txt 2>/dev/null
/etc/why_am_i_here?/fire-type.txt
ash@root:/$ cat /etc/why_am_i_here\?/fire-type.txt 
UDBrM20wbntDaGFybWFuZGVyfQ==a

ash@root:/$ echo UDBrM20wbntDaGFybWFuZGVyfQ==a | base64 --decode
P0k3m0n{Charmander}base64: invalid input
ash@root:/$ 
```
So decoding this gave us the last pokemon. I thoroughy enjoyed this CTF and look forward  to others that are brought out.
