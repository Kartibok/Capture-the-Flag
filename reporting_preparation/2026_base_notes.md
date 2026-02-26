# 🛡️ Name Box | [Platform: HTB/THM]
**IP:** `0.0.0.0`  
**OS:** [Linux/Windows]  
**Difficulty:** [Easy/Med/Hard]
---
## Visual Recon and Metadata

> [!abstract] Target Description and Mission Brief
> Brief overview of the machine's intended path or flavor (e.g., "CI/CD Pipeline Exploitation").
---
## 1.0 Enumeration (Discovery Phase)

### ⚡ 1.1 Infrastructure Scanning

### ping
ping $IP -c 4
```shell

```
### rustscan
rustscan -a $IP --ulimit 5000
```shell

```
### masscan
masscan -p1-65535,U:1-65535 $IP --rate=1000 -e tun0
```shell

```
### nmap all ports
nmap -A -sC -sV $IP -p-
```shell

```
#### nmap vulnerabilities
nmap --script "vuln" -Pn -n $IP
```shell

```

### 🕸️ 1.2 Web Recon

### whatweb
whatweb $IP
```shell

```
### nikto
nikto -h $IP -Display 2
```shell

```
### gobuster
#### initial
gobuster dir -u $IP -w /usr/share/wordlists/dirb/common.txt
```shell

```
#### secondary
gobuster dir -u $IP -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt
```shell

```
#### virtual hosts
gobuster vhost -w  ~/wordlists/subdomain.txt -u http://address.htb/ --append-domain
```shell

```
### feroxbuster
feroxbuster --url http://$IP --depth 2 --wordlist /usr/share/wordlists/wfuzz/general/megabeast.txt -x php,txt,html,sh
```shell

```
### wpscan
wpscan --url $IP
```shell

```

### ftp
```shell

```

### ssh
``` shell

```
### ⚙️ 1.3 Service Specific Checks

### robots.txt
```html

```
### sitemap
```xml

```
### cookies
```text

```
### sourcecode
```html

```

## 📝 Initial Summary
After the initial review of the server, we have the following to investigate. Include application service versions.

1.
1.
1.
1.



---
## 2.0 Foothold (Initial Access)

### 🎯 2.1 Exploitation Path

* **Findings:** [Identify the vulnerability or misconfiguration.]
* **Exploit/Payload:** [Link to exploit or paste code snippet used.]
### 🐚 2.2 Shell Execution

```bash
# Listener
nc -lvnp 4444

# Payload used
# [Insert Payload Here]

```

---
## 📝 Secondary Summary

1. 2. 3.

---
## 3.0 Privilege Escalation

### 3.1 🕵️ Local Recon

- [ ] **Automated:** `linpeas.sh` or `winPEAS.exe`


- [ ] **Manual:** Check `sudo -l`, SUID Bits, and `netstat -antup`


- [ ] **Filesystem:** Search for config files, hidden directories, or backup scripts.

### 3.2 👑 System Access (Root/Admin)

- **Method:** [Describe the escalation path.]


- **Flag:** `cat /root/root.txt` or `cat C:\Users\Administrator\Desktop\root.txt`



---
## 4.0 Post-Exploitation & Stego

### 4.1 📦 Artifact Analysis

- [ ] `file`, `strings`, `exiftool`


- [ ] `binwalk -e`, `steghide`, `stegsolve`, `stegcracker`

---

#review #pentest #active-labs


