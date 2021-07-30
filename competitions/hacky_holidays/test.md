## stolen: 3
Description
*Password of the actor
What is the password of the actor?*

Firstly we already have the kernel type from the first task as well as the software that was used. This time we are looking for the password.

If it is available we can extract passwords through JtR if we have both the /etc/passwd and /etc/shadow files.

Using volatility we can try and recover those files. I got a number of errors every time it ran, these are just repeated and bear no impact on the result so I have removed then to keep the space down.

This works in two phases. We find the file by name, which gives us the inode. We then get the inode and save it.

For passwd
```shell
┌──(karti㉿kali-ctf)-[~/git/volatility]
└─$ sudo python vol.py -f ~/Downloads/stolen/memdump.vmem --profile=Linux5_10_0-kali8-amd64x64 linux_find_file -F "/etc/passwd"
Volatility Foundation Volatility Framework 2.6.1
*** Failed to import volatility.plugins.registry.shimcache (ImportError: No module named Crypto.Hash)
WARNING : volatility.debug    : Overlay structure cpuinfo_x86 not present in vtypes
WARNING : volatility.debug    : Overlay structure cpuinfo_x86 not present in vtypes
Inode Number                  Inode File Path
---------------- ------------------ ---------
         2628853 0xffff931202b685e0 /etc/passwd
```                                                                                                                             

```                                                                                                       
┌──(karti㉿kali-ctf)-[~/git/volatility]
└─$ sudo python vol.py -f ~/Downloads/stolen/memdump.vmem --profile=Linux5_10_0-kali8-amd64x64 linux_find_file -i 0xffff931202b685e0 -O ~/Downloads/stolen/passwd                                                                         1 ⨯
Volatility Foundation Volatility Framework 2.6.1
*** Failed to import volatility.plugins.registry.shimcache (ImportError: No module named Crypto.Hash)
WARNING : volatility.debug    : Overlay structure cpuinfo_x86 not present in vtypes
WARNING : volatility.debug    : Overlay structure cpuinfo_x86 not present in vtypes
```

For shadow
```
┌──(karti㉿kali-ctf)-[~/git/volatility]
└─$ sudo python vol.py -f ~/Downloads/stolen/memdump.vmem --profile=Linux5_10_0-kali8-amd64x64 linux_find_file -F "/etc/shadow"
Volatility Foundation Volatility Framework 2.6.1
WARNING : volatility.debug    : Overlay structure cpuinfo_x86 not present in vtypes
WARNING : volatility.debug    : Overlay structure cpuinfo_x86 not present in vtypes
Inode Number                  Inode File Path
---------------- ------------------ ---------
         2621958 0xffff931202980140 /etc/shadow
```

```
┌──(karti㉿kali-ctf)-[~/git/volatility]
└─$ sudo python vol.py -f ~/Downloads/stolen/memdump.vmem --profile=Linux5_10_0-kali9-amd64x64 linux_find_file -i 0xffff931202980140 -O ~/Downloads/stolen/shadow
Volatility Foundation Volatility Framework 2.6.1
*** Failed to import volatility.plugins.registry.shimcache (ImportError: No module named Crypto.Hash)
WARNING : volatility.debug    : Overlay structure cpuinfo_x86 not present in vtypes
WARNING : volatility.debug    : Overlay structure cpuinfo_x86 not present in vtypes
```

Now we have both files we look to use JtR unshadow to get a hash that John can utilse.

```
┌──(karti㉿kali-ctf)-[~/git/volatility]
└─$ unshadow /Downloads/stolen/passwd /Downloads/stolen/shadow > ~/Downloads/stolen/hash.txt
```

This gives us our JtR hash.
```shell
invictus:$y$j9T$i6GkFortXamhKHY0bpTN.0$FLCqzsvVB1ZnfpffqSuvdLgzwLJvkmz6.aHfyoo11NB:1001:1001::/home/invictus:/bin/bash
```

However if you look at the hash id - $y$ it doesn't look like most standard hashes.

Some research indicated i was known as yescrypt, and with hashcat modes in mind I had a look to see what I could do. I found this on github were I found the following details that allowed me to attempt it with the 
--format=crypt
```text
Yescrypt is a notable algorithm:

-   Publicly known, modern algorithm, by Solar Designer ([@solardiz](https://github.com/solardiz))
-   PHC finalist: [https://www.password-hashing.net/](https://www.password-hashing.net/)
-   Interest appears to be increasing in this algorithm - starting to appear in the wild and reported in StackExchange questions, etc.
-   Demonstrating that the hash is hard/slow in hashcat could actually encourage adoption :D
-   Discovering shortcuts/weaknesses could serve to drive improvement in the hash

Where used:

-   Supported by libxcrypt, a drop-in replacement for libcrypt.so.1: [https://github.com/besser82/libxcrypt/](https://github.com/besser82/libxcrypt/)
-   Will soon be an option for Fedora: [https://fedoraproject.org/wiki/Changes/yescrypt_as_default_hashing_method_for_shadow](https://fedoraproject.org/wiki/Changes/yescrypt_as_default_hashing_method_for_shadow)
-   Some discussion of using it in Debian, not yet clear: [https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=978553](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=978553)

Tool coverage:

-   No direct support in john-jumbo (but supported using passthrough `--format=crypt`)
-   Not supported by MDXfind

Limitations:

-   Maximum plaintext length: none
-   Max salt size: 512 bits
-   GPU- and FPGA/ASIC unfriendly, by design

Tech details:

-   Pseudocode: [https://openwall.info/wiki/yescrypt](https://openwall.info/wiki/yescrypt)
-   PHC full documentation: [https://www.password-hashing.net/submissions/specs/yescrypt-v2.pdf](https://www.password-hashing.net/submissions/specs/yescrypt-v2.pdf)
-   Source code: [https://github.com/openwall/yescrypt](https://github.com/openwall/yescrypt)
-   Official doc (yescrypt): [https://www.openwall.com/yescrypt/](https://www.openwall.com/yescrypt/)
-   Official doc (john-jumbo): [https://github.com/openwall/john/tree/bleeding-jumbo/src/yescrypt](https://github.com/openwall/john/tree/bleeding-jumbo/src/yescrypt)
-   More details from Debian manpage ([https://manpages.debian.org/experimental/libcrypt1-dev/crypt.5.en.html](https://manpages.debian.org/experimental/libcrypt1-dev/crypt.5.en.html)):
```

I did try with my default john build on my Ubuntu, but I couldn't find anything. I reinstalled Jumbo John with the latest and got the password.

```shell
~/src/john/run$ ./john --format=crypt --wordlist=/home/jim/rockyou-75.txt ~/stolen_hash.txt 
Using default input encoding: UTF-8
Loaded 1 password hash (crypt, generic crypt(3) [?/64])
Cost 1 (algorithm [1:descrypt 2:md5crypt 3:sunmd5 4:bcrypt 5:sha256crypt 6:sha512crypt]) is 0 for all loaded hashes
Cost 2 (algorithm specific iterations) is 1 for all loaded hashes
Will run 12 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
security1        (invictus)     
1g 0:00:00:53 DONE (2021-07-07 15:31) 0.01885g/s 505.0p/s 505.0c/s 505.0C/s 020585..pimp10
Use the "--show" option to display all of the cracked passwords reliably
Session completed. 
```

Then a check with --show
```
~/src/john/run$ ./john --show ~/stolen_hash.txt 
invictus:security1:1001:1001::/home/invictus:/bin/bash
```

Flag
security1
