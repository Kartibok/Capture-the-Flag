## challenge - UFO

This was the challenge description:

*The FBI keeps declassifying UFO files. No leaks seem to contain evidence for extraterrestrial life so far. Agent Scully still wants to believe, though. She thinks new evidence can be found in one of the declassified files, but it's not evident. Also, the FBI has started to use digital graphics to censor relevant terms, since they can achieve scalable resolution and looking through the paper against a strong source of light no longer works, as used to happen in the old days.*

We are provided by what appears to be an FBI declassified document (pdf file) containing details of UFOs with some text redacted and a number of images.

![](./images/image0015a.png)

If you read my MystikoCTF "Me and the Boys" write up, then you will be aware that I messed up in a number of ways, especially now that I have a new quote "Do something, record it, check it again."

I went through the usual commands such as file and strings. I also reviewed the document properties, but nothing really jumped out. 

So lets start using that idea of back to basics and ensure we record the details.

Let's be more thoughtful and look at the properties of the file again. You can use the explorer GUI or command line. In this case I will use the command exiftool.

```shell                                                                    
┌──(karti㉿kali001)-[~/Downloads/mystikoCTF]
└─$ exiftool UFO_leak.pdf                                    
ExifTool Version Number         : 12.16
File Name                       : UFO_leak.pdf
Directory                       : .
File Size                       : 1213 KiB
File Modification Date/Time     : 2021:04:02 09:09:49+01:00
File Access Date/Time           : 2021:04:02 09:15:33+01:00
File Inode Change Date/Time     : 2021:04:02 09:15:07+01:00
File Permissions                : rw-r--r--
File Type                       : PDF
File Type Extension             : pdf
MIME Type                       : application/pdf
PDF Version                     : 1.5
Linearized                      : No
Page Count                      : 1
Producer                        : cairo 1.17.4 (https://cairographics.org)
Creator                         : **This is the application that created the original PDF**
Create Date                     : 2021:02:28 12:35:24+01:00
```

So now we know what application created the PDF. Let's open the PDF file using it and see what it looks like.

If you play about with the file and manipulate the layers/items within it you find that the documents has a number of secrets. 

![](./images/image0015b.png)

Look closely and you will see what appears to be excrypted text.

It looks like it may be encrypted with a base notation. Either check with one of the online tools like GCHQ's CyberChef or explore how to do it with the command line.

```shell
┌──(karti㉿kali001)-[~/Downloads/mystikoCTF]
└─$ echo "T*****************************9" | base?? --decode
Mystiko{*******************}  
```

Now we have the flag!!

