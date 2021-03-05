## challenge 011 - Blinking Eyes

This was the challenge description:

*care your eyes :)*

We were given a zip file to download. It contained the following files:
```script
~/Downloads/blinking$ ls -la
total 488
drwxrwxr-x  2 jim jim   4096 Mar  2 20:53 .
drwxr----- 26 jim jim  12288 Mar  2 18:15 ..
-rw-rw-r--  1 jim jim  42775 Feb 26 04:54 ceiling_cat.elf
-rw-rw-r--  1 jim jim 437125 Feb 26 04:53 mystiko.jpg
```
So let us have a look at what the files actually are:

```script
~/Downloads/blinking$ file *
ceiling_cat.elf: JPEG image data, JFIF standard 1.01, resolution (DPI), density 95x95, segment length 16, baseline, precision 8, 1200x600, components 3
mystiko.jpg:     PNG image data, 515 x 377, 8-bit/color RGBA, non-interlaced
```

So let us look at the two types, we have:
- .elf file (that is actually a .jpg )
- .jpg file (that is actually a .png)

Lets see if we can actually view the files. In this case I used Eye of Gnome (eog) viewer, where I could see "ceiling_cat.elf"

![[image011a.png]]

I could not see the mystiko.jpg. 

![[image011b.png]]

Now we already know that it is misnamed because the "file" command picked up the magic number of the actual image itself. The magic number is a hex number found within any file, that in turn informs you of its type.

Lets just change it to a .png and see what happens.

![[image011c.png]]

Right we can now see the image. Let us quickly look at the .png file hex view (using hexedit) and check out it's type  against this list of magic numbers held on wikipedia. This list will provide further hex details if you would like to investigate further.

https://en.wikipedia.org/wiki/List_of_file_signatures

Below is the hex implimentation of the first few lines, where we can see that it indicates a .png file.

![[image011d.png]]

We will notice that if we search the wiki page we find the magic number is:

![[image011e.png]]

These hexidecimal extracts match the first eight pairs. This indicates that it is a therefore marked up incorrectly as a jpg.

You will notice that on the edge of the hexedit view, we can see actual human readable strings. This is the translation to text of the hexidecimal numbers. It looks like something could be there. You could continue to stroll down the hexedit view, but lets try the comman strings. This will produce the human readible value for us to view. It may provide some assistance.

```script
~/Downloads/blinking$ strings mystiko.png 
IHDR
%tEXtMystiko
Even Blind people can read me=
P#Tr aYq
SB.q
e|a\
MWOB
:n#'
P,S91
}jp%
H	`:
xu|i
_	\f\r
dVDG
A!nr#
2z`\
IEND
hmmmmmmmmmmm what are you looking for 111010 001111 100100 100000 100110 101100 
```

I have shortened the sequence here, but it provides us with two clues. One about Blind people reading something and what looks like binary.

Some research on how those individuals that are sight impared can read will benefit you here.

If we assume this is a password of sorts, we could then utilise it and try to see if we can get something from the mystiko.jpg.

Remember when extracting from .png, we use "zsteg" and when extracting from .jpg we use "steghide."

Using the password we find from earlier after our reseach, we can access the file and #boom #everyoneisawinner

![[image011f.png]]



