## Linux File Transfer Methods

### Question 1:

![image-20221121094146436](/home/jim/snap/typora/76/.config/Typora/typora-user-images/image-20221121094146436.png)

For this a couple of quick searches on how to download a file from a URL using python gave me this link:

* https://www.codingem.com/python-download-file-from-url/

From here, I just amended the script:

```python
#!/bin/python3 # lets the system know it is a python file/executable
import requests #importing the requests module that allows you to send HTTP requests 
# https://www.w3schools.com/python/module_requests.asp
url = "http://10.129.200.184/flag.txt" # setting the URL (including the flag.txt)
response = requests.get(url) # setting a variable called "response" that holds the data we requested
open("flag.txt", "wb").write(response.content) # opening a new file called "flag.txt" and setting it in write and binary mode
# https://www.w3schools.com/python/ref_func_open.asp
```

Then just read the flag:

```shell
➜  academy cat flag.txt
5d21cf3da9c0ccb94f709e2559f3ea50
```

If you wanted to John Hammond the backside off it ........ you could run that from the python file so it prints out the flag without having to read the file. Just add this to the bottom of the script.

```python
print(response.content)
```

However you will notice that when you run it you get the answer in bytes with a new line at the end.

```shell
➜  academy python3 getFlag.py
b'5d21cf3da9c0ccb94f709e2559f3ea50\n'
```

The answer is there and you can expand your python to remove the new line and bytes. This is done by decoding the answer in "utf-8":

```python
print(response.content.decode("utf-8"))
```

So the completed sscript is:

```python
#!/bin/python3
import requests
url = "http://10.129.200.184/flag.txt"
response = requests.get(url)
open("flag.txt", "wb").write(response.content)
print(response.content.decode("utf-8"))
```

And the result:

```shell
➜  academy python3 getFlag.py
5d21cf3da9c0ccb94f709e2559f3ea50
```

### Question 2:

![image-20221121094232972](/home/jim/snap/typora/76/.config/Typora/typora-user-images/image-20221121094232972.png)

#### login

```shell
➜  ~ ping $IP -c 4
PING 10.129.200.184 (10.129.200.184) 56(84) bytes of data.
64 bytes from 10.129.200.184: icmp_seq=1 ttl=63 time=9.88 ms
64 bytes from 10.129.200.184: icmp_seq=2 ttl=63 time=9.93 ms
64 bytes from 10.129.200.184: icmp_seq=3 ttl=63 time=9.81 ms
64 bytes from 10.129.200.184: icmp_seq=4 ttl=63 time=10.0 ms

--- 10.129.200.184 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3006ms
rtt min/avg/max/mdev = 9.811/9.914/10.038/0.082 ms
➜  ~ ssh htb-student@$IP
htb-student@10.129.200.184's password:
Welcome to Ubuntu 20.04 LTS (GNU/Linux 5.4.0-47-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

 System information disabled due to load higher than 1.0

74 updates can be installed immediately.
0 of these updates are security updates.
To see these additional updates run: apt list --upgradable


The list of available updates is more than a week old.
To check for new updates run: sudo apt update

Last login: Wed Sep  9 22:42:43 2020 from 10.10.14.4
htb-student@nix04:~$ 
```

#### upload file

```shell
htb-student@nix04:~$ wget http://10.10.16.27:8888/upload_nix.zip
--2022-11-21 09:22:44--  http://10.10.16.27:8888/upload_nix.zip
Connecting to 10.10.16.27:8888... connected.
HTTP request sent, awaiting response... 200 OK
Length: 194 [application/zip]
Saving to: ‘upload_nix.zip’

upload_nix.zip                                           100%[=================================================================================================================================>]     194  --.-KB/s    in 0s

2022-11-21 09:22:44 (19.2 MB/s) - ‘upload_nix.zip’ saved [194/194]
```

#### unzip file

This took me about ten minutes as there was no zip/unzip installed. Found gzip/gunzip and had to look for the syntax for it to work.

```shell
htb-student@nix04:~$ gzip -cd upload_nix.zip > upload_nix.txt
htb-student@nix04:~$ cat upload_nix.txt
048090bc7ed04f758658975df8f862c8
```

#### hasher

Then finally running `hasher` against the extracted text file.

```shell
htb-student@nix04:~$ hasher upload_nix.txt
159cfe5c65054bbadb2761cfa359c8b0
```













