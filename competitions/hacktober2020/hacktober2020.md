<a href="https://twitter.com/CHacktics"><img src="images/deadface.png" alt="Deadface" width="200"/></a> <a href="https://twitter.com/CHacktics"><img src="images/participant.png" alt="Deadface" width="200"/></a>

# Hacktober CTF 2020

## Introduction
This was only my second CTF and first as a team, in this case for the John Hammond Discord group. Although four people entered only two actually took part, so for my position in the final line line up I need to say a thank you to RoOt for getting a lot of the big number questions!!

This write up will encompass all the challenges that I have completed, although initially this will just be the SQL ones as I have just started to focus on the database jepardy questions. I hope they are helpful in some way and if you do come back they will be updated as and when I get time. With better note taking in the next CTF, I'm hoping that it will be more helpful to people.

Lets get started. 

## null and void

### the write up

Using the Shallow Grave SQL dump, which field(s) in the users table accepts NULL values? Submit the field name followed by the single command used to show the information (separated by a comma). Submit the flag as flag{column-name, command}.

### my solution

First I have to utilise the database file that they provided to us for analysis. 

Lets log in with root to mysql.

```sql
$ mysql -u root -p
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
Now let's create a database, in this case NullAndVoid to make it easy.
```sql
mysql> create database NullAndVoid;
Query OK, 1 row affected (0.01 sec)

mysql> exit
Bye
```
So now that has been created we can import the file into the prepared database.
```sql
$ mysql -u root -p NullAndVoid < shallowgraveu.sql 
Enter password: 
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

As I mentioned earlier I have started to show an interest in the MySQL side and actually enjoying it. This also goes out to the sqlite3 challenge we have later. In the meantime I have been using MySql Workbench and find that it is a simple GUI interface. 

The best point about learning this is that it not only helps with database questions but also the sqli on websites, which were always (in that Halloween moment) scary. #tickinthebox  

## body count

### the write up

How many users exist in the Shallow Grave University database?

Submit the flag in the following format: flag{#}

### my solution
In this challenge we already have the database loaded from before so we can use the NullAndVoid tables. Follow the instructions above to add the database if you have not already done so. Let's see what we have.
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
13 rows in set (0.00 sec)
```
Now let us look at the actual user table for familiarity.
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
Now we could just use the straightforward "select * from users" that will give us every row with a total number of rows in a set:
```sql
+----------+------------+---------+
900 rows in set (0.00 sec)
```
However to get the number we can just use the count() function.
```sql
mysql> select count(*) from users;
+----------+
| count(*) |
+----------+
|      900 |
+----------+
1 row in set (0.01 sec)

mysql> 
```
Remembering the flag format we have flag{900}
## address book

### the write up
Shallow Grave University has provided us with a dump of their database. Find luciafer’s email address and submit
it as the flag in this format: flag{username@email.com}

### my solution
Once again we already have the NullAndVoid database loaded. As before follow the instructions for the null and void question to get to this stage.
Lets remind ourself what the users table is like.
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
12 rows in set (0.00 sec)
```
Now we can see that the field we know (luciafer's first name) is called 'first' as well as a field called email.
With that in mind lets us get teh query ready. So in English, it wil be something like. "Select the email from users where the first name is Luciafer"
If we add this to SQL is comes out very similar but let us check at the start how many first names begin with 'l'
```sql
mysql> select count(*) from users where first like 'l%';
+----------+
| count(*) |
+----------+
|       65 |
+----------+
1 row in set (0.00 sec)
```
Lets us add a character each time.
```sql
mysql> select count(*) from users where first like 'lu%';
+----------+
| count(*) |
+----------+
|        7 |
+----------+
1 row in set (0.00 sec)

mysql> select count(*) from users where first like 'luc%';
+----------+
| count(*) |
+----------+
|        4 |
+----------+
1 row in set (0.00 sec)

mysql> select count(*) from users where first like 'luci%';
+----------+
| count(*) |
+----------+
|        1 |
+----------+
1 row in set (0.00 sec)
```
Now we know there is one, we can amend the query to show the single result.
```sql
mysql> select email from users where first like 'luci%';
+-----------------------------------+
| email                             |
+-----------------------------------+
| luc1afer.h4vr0n@shallowgraveu.com |
+-----------------------------------+
1 row in set (0.00 sec)

mysql> 
```
Knowing the flag, we can add it to the correct format.

flag{luc1afer.h4vr0n@shallowgraveu.com}

Third one in a row!!



