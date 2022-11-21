## Windows File Transfer Methods

### Question 1:

![image-20221121065518537](/home/jim/snap/typora/76/.config/Typora/typora-user-images/image-20221121065518537.png)

```shell

➜  ~ export IP=10.129.201.55
➜  ~ ping $IP -c 4
PING 10.129.201.55 (10.129.201.55) 56(84) bytes of data.
64 bytes from 10.129.201.55: icmp_seq=1 ttl=127 time=9.80 ms
64 bytes from 10.129.201.55: icmp_seq=2 ttl=127 time=9.68 ms
64 bytes from 10.129.201.55: icmp_seq=3 ttl=127 time=12.2 ms
64 bytes from 10.129.201.55: icmp_seq=4 ttl=127 time=11.4 ms
--- 10.129.201.55 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3005ms
rtt min/avg/max/mdev = 9.682/10.761/12.195/1.062 ms

➜  ~ wget http://$IP/flag.txt ; cat flag.txt
--2022-11-21 06:53:23--  http://10.129.201.55/flag.txt
Connecting to 10.129.201.55:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 32 [text/plain]
Saving to: ‘flag.txt’

flag.txt          100%[===================>]      32  --.-KB/s    in 0s

2022-11-21 06:53:23 (923 KB/s) - ‘flag.txt’ saved [32/32]

b1a4ca918282fcd96004565521944a3b%

```

### Question 2:

![image-20221121065742005](/home/jim/snap/typora/76/.config/Typora/typora-user-images/image-20221121065742005.png)

```shell
➜  ~ xfreerdp /v:$IP /u:htb-student /p:'HTB_@cademy_stdnt!' /cert:ignore
[07:01:30:506] [8844:8845] [INFO][com.freerdp.gdi] - Local framebuffer format  PIXEL_FORMAT_BGRX32
[07:01:30:506] [8844:8845] [INFO][com.freerdp.gdi] - Remote framebuffer format PIXEL_FORMAT_BGRA32
[07:01:30:526] [8844:8845] [INFO][com.freerdp.channels.rdpsnd.client] - [static] Loaded fake backend for rdpsnd
[07:01:30:526] [8844:8845] [INFO][com.freerdp.channels.drdynvc.client] - Loading Dynamic Virtual Channel rdpgfx
```

![image-20221121070243049](/home/jim/snap/typora/76/.config/Typora/typora-user-images/image-20221121070243049.png)

```shell
➜  ~ ls academy
exploit.sh  getFlag.py      upload_nix.zip
flag.txt    upload_nix.txt  upload_win.zip
➜  ~ cd academy
➜  academy www
Serving HTTP on 0.0.0.0 port 8888 (http://0.0.0.0:8888/) ...
```

```powershell
Windows PowerShell
Copyright (C) 2016 Microsoft Corporation. All rights reserved.

PS C:\Users\htb-student> wget http://10.10.16.27:8888/upload_win.zip -o upload_win.zip
PS C:\Users\htb-student> dir
    Directory: C:\Users\htb-student
Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-r---         9/9/2020   1:55 PM                Contacts
d-r---         9/9/2020   1:56 PM                Desktop
d-r---         9/9/2020   1:55 PM                Documents
d-r---         9/9/2020   1:55 PM                Downloads
d-r---         9/9/2020   1:55 PM                Favorites
d-r---         9/9/2020   1:55 PM                Links
d-r---         9/9/2020   1:55 PM                Music
d-r---         9/9/2020   1:55 PM                Pictures
d-r---         9/9/2020   1:55 PM                Saved Games
d-r---         9/9/2020   1:55 PM                Searches
d-r---         9/9/2020   1:55 PM                Videos
-a----       11/20/2022  11:04 PM            194 upload_win.zip
PS C:\Users\htb-student> Expand-Archive -Path .\upload_win.zip -DestinationPath .
PS C:\Users\htb-student> dir
    Directory: C:\Users\htb-student
Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-r---         9/9/2020   1:55 PM                Contacts
d-r---         9/9/2020   1:56 PM                Desktop
d-r---         9/9/2020   1:55 PM                Documents
d-r---         9/9/2020   1:55 PM                Downloads
d-r---         9/9/2020   1:55 PM                Favorites
d-r---         9/9/2020   1:55 PM                Links
d-r---         9/9/2020   1:55 PM                Music
d-r---         9/9/2020   1:55 PM                Pictures
d-r---         9/9/2020   1:55 PM                Saved Games
d-r---         9/9/2020   1:55 PM                Searches
d-r---         9/9/2020   1:55 PM                Videos
-a----         9/9/2020   4:34 PM             32 upload_win.txt
-a----       11/20/2022  11:04 PM            194 upload_win.zip
PS C:\Users\htb-student> hasher .\upload_win.txt
f458303ea783c224c6b4e7ef7f17eb9d
```









