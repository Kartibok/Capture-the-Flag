## infiltration

This was the challenge description:

*Someone has hacked into our school! Try to find out what happened.*

We are provided by a Wireshark .pcapng file

![[neton001a.png]]

Normally I check to see if any files are visible by:
```
File > Export
```

The options we have to export from are :
- DICOM
- HTTP
- IMF
- SMB
- TFTP

Within HTTP we find a large number of files. These are downloaded to investigate.

![[neton001b.png]]

Checking through the files, we find that the action(6).php provides the flag!

```html
<!DOCTYPE html>
<html lang="es">
    <head>
        <title>IES</title>
        <meta charset="utf-8">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css" integrity="sha384-TX8t27EcRE3e/ihU7zmQxVncDAy5uIKz4rEkgIXeMed4M0jlfIDPvg6uqKI2xXr2" crossorigin="anonymous">
        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js" integrity="sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.min.js" integrity="sha384-w1Q4orYjBQndcko6MimVbzY0tgp4pWB4lZ7lr30WKz0vr/aWKhXdBNmNb5D92v7s" crossorigin="anonymous"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <meta name="viewport" content="width=device-width, initial-scale=1">
    </head>
    <body class="bg-dark">
        <div class="container-fluid" style="height: 100vh;">
            <div class="row" style="padding-top: 20%;">
                <div class="col-12 text-center">
                    <h1 class="display-1 text-white">NETON{N1c3_4n4l1s1s!}</h1>
                </div>
            </div>
        </div>
    </body>
</html>
```

As I am trying to improve my grep skills, I attempted to check the files within the folder to see if there was an easier way to search, rather than visually check each file.

My initial check was to 'cat' all the files in the directory and pipe it into 'grep' which proved that there was an answer, however, it did not actually show it. 

```shell
:~/Downloads/wireshark$ cat * | grep -oE "NETON{.?*}"
Binary file (standard input) matches
```

After some checks using our best friend Google. 

![[neton001c.png]]

So we need to add '-a' to improve the search, giving us the flag.

```shell
:~/Downloads/wireshark$ cat * | grep -oEa NETON{.*?}
NETON{N1c3_4n4l1s1s!}
```

### flag
NETON{N1c3_4n4l1s1s!}



