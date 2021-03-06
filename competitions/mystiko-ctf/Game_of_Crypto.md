## challenge - Game of Crypto

This was the challenge description:

*Hodor want to give you the flag but can you understand it.*

We were given a flag.txt file that contained the following:
```
HODOR... HODOR!?! Hodor hodor. Hodor? hodor?! o{HoOodoOorHODOR _d3Hodor? HODOR? hodor?! _@HODOR? d_HoOodoOorHODOR _hodor?! HODOR? 0HODOR!? _hodor. hHodor? HODOR? hodor! Hodor }
```

I will admit I have seen a similar challenge before, but if we look at the clues, there are some good pointers:
- Game of "Crypto" could indicate a theme of Game of Thrones.
- Code with the words "Hodor" throughout the text refers to a character in Game of Thrones.
- The challenge is in the cryptography section.

As always remember Google is our friend. So with this in mind let's search.

![](./images/image010a.png)

Google provides us with a link to a Hodor encode and decode site. From here we simply paste in our original cipher text and hit decrypt.

![](./images/image010b.png)

This now gives us the result!

Mystiko{?????????????}

https://decode.fr is a great site for cryptographic tools (dCode has a huge library of scripts for decoding or encoding messages with standard cryptography techniques.) Code and Alphabet Tools as well as mathmatical tools.

Keep it in your arsenal as a bookmark.
