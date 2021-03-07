## infiltration

This was the challenge description:

*I have left a secret file in a place you will never find!*

We are provided by a 640Mb zip file (dump.zip.)

I extract this to a folder and it is just over 2Gb data.

Perhaps the hint means we should use 'find', but lets jump straight in with 'grep' and to my surprise, we actually find the flag - three times. 

```shell
~/Downloads/dump$ cat dump.raw | grep -oEa NETON{.?*}
NETON{7h15_w1ll_n07_b3_7h3_ncl}
NETON{7h15_w1ll_n07_b3_7h3_ncl}
NETON{7h15_w1ll_n07_b3_7h3_ncl}

```

How fast was that!! Using 'time' we can check:
```shell
~/Downloads$ time cat dump/dump.raw | grep -oEa NETON{.?*}
NETON{7h15_w1ll_n07_b3_7h3_ncl}
NETON{7h15_w1ll_n07_b3_7h3_ncl}
NETON{7h15_w1ll_n07_b3_7h3_ncl}

real	0m1.299s
user	0m0.320s
sys	0m1.737s

```
### grep quantifiers
- . is the wildcard
-  ? indicates _zero or one_ occurrences of the preceding element.
-  * indicates _zero or more_ occurrences of the preceding element.

### flag
NETON{7h15_w1ll_n07_b3_7h3_ncl}



