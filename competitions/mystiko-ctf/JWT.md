## challenge - JWT

This was the challenge description:

*"Can you login as an admin?*

http://173.212.221.197:30000/

Flag format: Mystiko{FLAG}"*

No hints were given on this one, but we are dealing access to a website and from the title - JWT (JSON Web Token)

**Just like to thank both nmcpher2 and AusCryptor for their help in getting me to understand JWT. Much appreciated.**

I was advised to look at:

https://jwt.io/

Which in turn gave me a better idea of what I needed to do. So from the site: What is JSON Web Token? 

*JSON Web Token (JWT) is an open standard (RFC 7519) that defines a compact and self-contained way for securely transmitting information between parties as a JSON object. This information can be verified and trusted because it is digitally signed. JWTs can be signed using a secret (with the HMAC algorithm) or a public/private key pair using RSA or ECDSA.*

*Although JWTs can be encrypted to also provide secrecy between parties, we will focus on signed tokens. Signed tokens can verify the integrity of the claims contained within it, while encrypted tokens hide those claims from other parties. When tokens are signed using public/private key pairs, the signature also certifies that only the party holding the private key is the one that signed it.*

I did some searching for JWT exploits and it appears that if the site is set up incorrectly, it can accept an algorithm of "none," so with that in mind I thought I would give it a go.

Using the jwt.io site again, we can see from the default example that the token is broken down into three stages. 
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
```
 Each part of the token is separated by a "." When decoded, these provide us with with:
 - Header block (containing algorithm and token type)
 - Payload block (containing data)
 - Verify Signature block (indicating how the whole token is created)

At it's very basics, the header + the payload are both encrypted, to create the signature block. It is this third block that verifies the whole token, has not been tampered with.

![](./images/image028a.png)

So how do we get the token? If we look at the webpage we have a login portal and a guest option. We don't know the username and password, so lets try the Guest option.

![](./images/image028b.png)

This puts us into a website as guest.

![](./images/image028c.png)

This puts us into a website as guest. However if we have a look at the cookies they provide, we have a:
- session (decode with base64 to find out what it says)
- JWT (the token, with some interesting details.)

Now we have this we can go back to the login page and investigate further.

As I have already mentioned we get the encoded token and when we use the jwt.io, we can see the header, payload and signature verification.
```
{
  "typ": "JWT",
  "alg": "HS256"
}
```

```
{
  "id": "1",
  "guest": "true",
  "admin": false
}
```

```
HMACSHA256(
  base64UrlEncode(header) + "." +
  base64UrlEncode(payload),
  your-256-bit-secret
) secret base64 encoded
```
Remembering that we can get past some sites by using the algorithm "none" and removing the final signature verification (don't forget to keep the "." otherwise it will fail, as this still indicates that the token has three parts) look at what you can change and amend.
Remember you are trying to log in as admin using these tokens.

My final use of the word "remember" but each of these is base64. Make sure that you only change what you need to change and then amend the cookie and when you hit enter, you will get that flag!! 
