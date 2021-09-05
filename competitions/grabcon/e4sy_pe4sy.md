Web - E4sy Pe4sy
Description:

Hack admin user!

Link

Author: r3curs1v3_pr0xy

If we follow the link, we get a food based website.

![](./Pasted image 20210905135636.png)

Here us the Login page within the menu.

Pasted image 20210905135810.png

As we are after admin, let's try straight away with sql injection. I normally look to test with the PayloadsAllTheThings by Swisskyrepo:
https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/SQL%20Injection

I did get in with admin' or '1'='1'#

Pasted image 20210905140244.png

However after the end of the CTF, I did run the Payloads in Zap and found there were a few that could have got you the admin flag.

The response with 1648 bytes were all successful.

Pasted image 20210905142326.png

Flag:

GrabCON{E4sy_pe4sy_SQL_1nj3ct10n}
