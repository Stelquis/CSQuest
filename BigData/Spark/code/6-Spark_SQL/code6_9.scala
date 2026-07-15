mysql> create database student;
mysql> use student;
mysql>create table stu(id int(10) auto_increment not null primary key,name varchar(10),country varchar(20),Height Double,Weight Double);
mysql> describe stu;
+------------+------------------+-------+------+-----------+----------------------+
| Field   | Type       | Null | Key | Default | Extra         |
+------------+------------------+-------+------+-----------+----------------------+
| id      |int(10)     |  NO| PRI | NULL  | auto_increment |
| name   | varchar(10) |  YES|   | NULL  |              |
|country  | varchar(20) |  YES|   | NULL  |              |
| Height  |double     |  YES|   | NULL  |              |
|Weight  |double     |  YES|   | NULL  |              |
+------------+------------------+--------+-----+-----------+----------------------+
5 rows in set (0.00 sec)
mysql> insert into stu values(null,'MI','china','180','60');
mysql> insert into stu values(null,'UI','UK','160','50'); 
mysql> insert into stu values(null,'DI','UK','165','55'); 
mysql> insert into stu values(null,'Bo','china','167','45'); 
mysql> select * from stu;
+---+-------+----------+----------+---------+                                                
| id|name|country| Height|Weight|
+---+-------+----------+----------+---------+
| 1 |MI  | china  |  180 |   60 |
| 2 | UI  | UK    |  160 |   50 |
| 3 | DI  | UK    |  165 |   55 |
| 4 |Bo  | china  |  167 |   45 |
+---+-------+----------+----------+---------+
4 rows in set (0.00 sec)