## challenge - Simple Stego

This was the challenge description:

*"Someone messed with this file can you fix it?"*

We have a file:
- steg.pdf

Let's complete some initial investigation.

```shell
┌──(karti㉿kali001)-[~/Downloads/mystikoCTF]
└─$ file steg.pdf                                                 
steg.pdf: RAR archive data, v5
```

Although it has the .pdf extension the "magic bytes" are telling us that it is actually an archive. 

For further reading on "magic bytes"
https://en.wikipedia.org/wiki/List_of_file_signatures

That being the case - let's extract it.

```shell
┌──(karti㉿kali001)-[~/Downloads/mystikoCTF]
└─$ unrar e steg.pdf                                                                             7 ⨯
UNRAR 6.00 freeware      Copyright (c) 1993-2020 Alexander Roshal
Extracting from steg.pdf
Extracting  steg.jpg                                                  OK 
All OK
```

Once again check what the file is that has been extracted.

```shell
┌──(karti㉿kali001)-[~/Downloads/mystikoCTF]
└─$ file steg.jpg                                                                              130 ⨯
steg.jpg: PNG image data, 800 x 450, 8-bit/color RGBA, non-interlaced
```

This time we know it is an image, however the extension is a .jpg but the "magic bytes" are telling us it is a .png. Lets have a look.

![[image019a.png]]

Within Kali, we can see an image without any problem, so we don't need to change the extension.

In order to reveal if anything is hidden in the image we would normally use two basic tools.
- steghide for .jpg
- zsteg for .png

So as we know the file is actually a .png, let's run zsteg. Now we get the flag.

```shell
┌──(karti㉿kali001)-[~/Downloads/mystikoCTF]
└─$ zsteg steg.jpg 
b1,r,msb,xy         .. file: MGR bitmap, old format, 1-bit deep, 32-bit aligned
b1,rgb,lsb,xy       .. text: "Mystiko{????????????}"
b1,bgr,msb,xy       .. file: PARIX T9000 object
b2,g,msb,xy         .. file: MPEG ADTS, layer II, v2, 144 kbps, 24 kHz, Monaural
b3,g,lsb,xy         .. file: MPEG ADTS, layer II, v1, 224 kbps, Monaural
b4,r,lsb,xy         .. file: AIX core file fulldump 64-bit
b4,abgr,msb,xy      .. file: RDI Acoustic Doppler Current Profiler (ADCP)
```
