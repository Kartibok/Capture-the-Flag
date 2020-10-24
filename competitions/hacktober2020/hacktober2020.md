# Hacktober CTF 2020

## Introduction
This was only my second CTF and first as a team, in this case for the John Hammond Discord group. Although four people entered only two actually took part, so for my position in the final line line up I need to say a thank you to RoOt for getting a lot of the big number questions!!

This write up will encompass all the challenges that I have completed, although initially this will be the SQL ones as I have just started to focus on the database jepardy questions. I hoope they are helpful in some way and if you come back they will be updated as and when I get time. With better note taking in the next CTF, I'm hoping that it will be more helpful to people.

Lets get started. 

### null and void

#### the write up

Using the Shallow Grave SQL dump, which field(s) in the users table accepts NULL values? Submit the field name followed by the single command used to show the information (separated by a comma). Submit the flag as flag{column-name, command}.

#### my solution

First I have to utilise the database file that they provided to for analysis. 

Lets log in with root to mysql.

```sql
mysql -u root -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 11
Server version: 8.0.21 MySQL Community Server - GPL

Copyright (c) 2000, 2020, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
```
Now let's create a database, in this case NullAndVoid
```sql
mysql> create database NullAndVoid;
Query OK, 1 row affected (0.01 sec)

mysql> exit
Bye
```
OK we have the database instance installed and ready - lets review it.
```sql
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| NullAndVoid        |
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
5 rows in set (0.00 sec)
```
Here we can see that the file has been imported. Let's now use it for the challenge.
```sql
mysql> use NullAndVoid;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
```
Now we are in the database we can look at the tables.
```sql
mysql> show tables;
+-----------------------+
| Tables_in_NullAndVoid |
+-----------------------+
| countries             |
| courses               |
| degree_types          |
| enrollments           |
| passwords             |
| payment_statuses      |
| programs              |
| roles                 |
| roles_assigned        |
| states                |
| term_courses          |
| terms                 |
| users                 |
+-----------------------+
13 rows in set (0.01 sec)

```
So if we remember the question, what field accepts a NULL value, lets see how users table is set up.

```sql 

mysql> describe users;
+----------+-------------+------+-----+---------+----------------+
| Field    | Type        | Null | Key | Default | Extra          |
+----------+-------------+------+-----+---------+----------------+
| user_id  | int         | NO   | PRI | NULL    | auto_increment |
| username | varchar(52) | NO   | UNI | NULL    |                |
| first    | varchar(52) | NO   |     | NULL    |                |
| last     | varchar(52) | NO   |     | NULL    |                |
| middle   | varchar(24) | YES  |     | NULL    |                |
| email    | varchar(52) | NO   | UNI | NULL    |                |
| street   | varchar(52) | NO   |     | NULL    |                |
| city     | varchar(52) | NO   |     | NULL    |                |
| state_id | int         | NO   | MUL | NULL    |                |
| zip      | varchar(10) | NO   |     | NULL    |                |
| gender   | varchar(8)  | NO   |     | NULL    |                |
| dob      | date        | NO   |     | NULL    |                |
+----------+-------------+------+-----+---------+----------------+
12 rows in set (0.01 sec)

```
Now we see that the 'middle' field is NULL YES, so that is part of our answer. Add that to the command we used and we have our points!

flag{middle, describe}






















```
~/CTF/tryhackme/agentsudo$ nmap -sC -sV 10.10.133.196
Starting Nmap 7.80 ( https://nmap.org ) at 2020-08-04 20:11 BST
Nmap scan report for 10.10.133.196
Host is up (0.038s latency).
Not shown: 997 closed ports
PORT   STATE SERVICE VERSION
21/tcp open  ftp     vsftpd 3.0.3
22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 ef:1f:5d:04:d4:77:95:06:60:72:ec:f0:58:f2:cc:07 (RSA)
|   256 5e:02:d1:9a:c4:e7:43:06:62:c1:9e:25:84:8a:e7:ea (ECDSA)
|_  256 2d:00:5c:b9:fd:a8:c8:d8:80:e3:92:4f:8b:4f:18:e2 (ED25519)
80/tcp open  http    Apache httpd 2.4.29 ((Ubuntu))
|_http-server-header: Apache/2.4.29 (Ubuntu)
|_http-title: Annoucement
Service Info: OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 10.93 seconds
```

## nikto
```