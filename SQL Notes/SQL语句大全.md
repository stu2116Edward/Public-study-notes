# 常用SQL语句大全

## DDL(Data Definition Language)数据定义语言

**连接数据库**
使用以下命令连接到 MySQL 数据库：
```bash
mysql -u 用户名 -p -h 主机名 -P 端口号
```
-u 用户名：指定登录数据库的用户名。
-p：提示输入用户密码。
-h 主机名：指定数据库服务器的主机名或 IP 地址，默认为 localhost。
-P 端口号：指定数据库服务器的端口号，默认为 3306。
例如，连接到本地 MySQL 数据库，用户名为 root，可以使用以下命令：
```bash
mysql -u root -p
```


### 一、操作库

创建库：
```sql
CREATE DATABASE 数据库名;
```
创建库，如果不存在则创建：
```sql
CREATE DATABASE IF NOT EXISTS 数据库名;
```
查看所有数据库：
```sql
SHOW DATABASES;
```
进入某个数据库：
```sql
USE 数据库名;
```
查看某个数据库的定义信息：
```sql
SHOW CREATE DATABASE 数据库名;
```
修改数据库字符信息：
```sql
ALTER DATABASE 数据库名 CHARACTER SET utf8;
```
删除数据库：
```sql
DROP DATABASE 数据库名;
```


### 二、操作表

创建表：
```sql
CREATE TABLE student(
    id INT,
    name VARCHAR(32),
    age INT,
    score DOUBLE(4,1),
    birthday DATE,
    insert_time TIMESTAMP
);
```
查看数据库中的表：
```sql
SHOW TABLES;
```
查看表结构：
```sql
DESC 表名;
```
查看创建表的SQL语句：
```sql
SHOW CREATE TABLE 表名;
```
修改表名：
```sql
ALTER TABLE 表名 RENAME TO 新的表名;
```
添加一列：
```sql
ALTER TABLE 表名 ADD 列名 数据类型;
```
删除列：
```sql
ALTER TABLE 表名 DROP 列名;
```
删除表：
```sql
DROP TABLE 表名;
```
如果指定的表存在，则删除该表；如果表不存在，则不会报错，也不会执行任何操作：
```sql
DROP TABLE IF EXISTS 表名;
```


## DML(Data Manipulation Language)数据操作语言

### 一、增加 insert into

插入部分数据：
```sql
INSERT INTO 表名(列名1,列名2) VALUES(值1,值2);
```
写全所有列名插入数据：
```sql
INSERT INTO 表名(列名1,列名2,...列名n) VALUES(值1,值2,...值n);
```
不写列名（所有列全部添加）：
```sql
INSERT INTO 表名 VALUES(值1,值2,...值n);
```


### 二、删除 delete

删除表中特定的数据：
```sql
DELETE FROM 表名 WHERE 列名 = 值;
```
删除表中所有数据：
```sql
DELETE FROM 表名;
```
删除表中所有数据（高效 先删除表，然后再创建一张一样的表）：
```sql
TRUNCATE TABLE 表名;
```

### 三、修改 update

不带条件的修改(会修改所有行)：
```sql
UPDATE 表名 SET 列名 = 值;
```
带条件的修改：
```sql
UPDATE 表名 SET 列名 = 值 WHERE 列名=值;
```

## DQL(Data Query Language)数据查询语言

### 一、基础关键字

#### BETWEEN...AND 和 IN

查询年龄大于等于20 小于等于30：
```sql
SELECT * FROM student WHERE age >= 20 AND age <= 30;
```
```sql
SELECT * FROM student WHERE age BETWEEN 20 AND 30;
```

查询年龄22岁，18岁，25岁的信息：
```sql
SELECT * FROM student WHERE age = 22 OR age = 18 OR age = 25;
```
```sql
SELECT * FROM student WHERE age IN (22, 18, 25);
```

#### is not null 和 like

查询英语成绩不为null：
```sql
SELECT * FROM student WHERE english IS NOT NULL;
```
查询姓马的有哪些？：
```sql
SELECT * FROM student WHERE NAME LIKE '马%';
```
查询姓名第2个字是化的人：
```sql
SELECT * FROM student WHERE NAME LIKE '_化%';
```
查询姓名是3个字的人：
```sql
SELECT * FROM student WHERE NAME LIKE '___';
```
查询姓名中包含德的人：
```sql
SELECT * FROM student WHERE NAME LIKE '%德%';
```
关键词 DISTINCT 用于返回唯一不同的值：
```sql
SELECT DISTINCT NAME FROM student;
```

### 二、排序查询 order by

默认升序：
```sql
SELECT * FROM 表名 ORDER BY 字段;
```
降序：
```
SELECT * FROM 表名 ORDER BY 字段 DESC;
```

### 三、聚合函数

- `COUNT`：计算个数
- `MAX`：计算最大值
- `MIN`：计算最小值
- `SUM`：计算和
- `AVG`：计算平均数

### 四、分组查询 group by

按照性别分组。分别查询男、女同学的平均分：
```sql
SELECT sex, AVG(math) FROM student GROUP BY sex;
```
按照性别分组。分别查询男、女同学的平均分,人数：
```sql
SELECT sex, AVG(math), COUNT(id) FROM student GROUP BY sex;
```
按照性别分组。分别查询男、女同学的平均分,人数 要求：分数低于70分的人，不参与分组：
```sql
SELECT sex, AVG(math), COUNT(id) FROM student WHERE math > 70 GROUP BY sex;
```
按照性别分组。分别查询男、女同学的平均分,人数 要求：分数低于70分的人，不参与分组,分组之后。人数要大于2个人：
```
SELECT sex, AVG(math), COUNT(id) FROM student WHERE math > 70 GROUP BY sex HAVING COUNT(id) > 2;
SELECT sex, AVG(math), COUNT(id) 人数 FROM student WHERE math > 70 GROUP BY sex HAVING 人数 > 2;
```

### 五、分页查询

每页显示3条记录：  
第1页
```sql
SELECT * FROM student LIMIT 0,3;
```
第2页
```
SELECT * FROM student LIMIT 3,3;
```
第3页
```
SELECT * FROM student LIMIT 6,3;
```

### 六、内连接查询

#### 1.隐式内连接

查询员工表的名称，性别。部门表的名称
```sql
SELECT emp.name, emp.gender, dept.name FROM emp, dept WHERE emp.dept_id = dept.id;
```

```
SELECT 
    t1.name, -- 员工表的姓名
    t1.gender, -- 员工表的性别
    t2.name -- 部门表的名称
FROM
    emp t1,
    dept t2
WHERE 
    t1.dept_id = t2.id;
```

#### 2.显式内连接

语法： 
```sql
SELECT 字段列表 FROM 表名1 [INNER] JOIN 表名2 ON 条件
```
例子：
```sql
SELECT * FROM emp INNER JOIN dept ON emp.dept_id = dept.id;   
SELECT * FROM emp JOIN dept ON emp.dept_id = dept.id;
```

### 七、外连接查询

#### 1.左外连接

语法：
```sql
SELECT 字段列表 FROM 表1 LEFT [OUTER] JOIN 表2 ON 条件；
```
查询所有员工信息，如果员工有部门，则查询部门名称，没有部门，则不显示部门名称：
```sql
SELECT t1.*, t2.name FROM emp t1 LEFT JOIN dept t2 ON t1.dept_id = t2.id;
```

#### 2.右外连接

语法：
```sql
SELECT 字段列表 FROM 表1 RIGHT [OUTER] JOIN 表2 ON 条件；
```
例子：
```sql
SELECT * FROM dept t2 RIGHT JOIN emp t1 ON t1.dept_id = t2.id;
```

### 八、子查询

查询工资最高的员工信息：
```sql
SELECT MAX(salary) FROM emp;
```
查询员工信息，并且工资等于9000的：
```sql
SELECT * FROM emp WHERE emp.salary = 9000;
```
一条sql就完成这个操作。这就是子查询：
```sql
SELECT * FROM emp WHERE emp.salary = (SELECT MAX(salary) FROM emp);
```

#### 1.子查询的结果是单行单列的

```sql
-- 查询员工工资小于平均工资的人
SELECT * FROM emp WHERE emp.salary < (SELECT AVG(salary) FROM emp);
```

#### 2.子查询的结果是多行单列的

```sql
-- 查询'财务部'和'市场部'所有的员工信息
SELECT id FROM dept WHERE NAME = '财务部' OR NAME = '市场部';
SELECT * FROM emp WHERE dept_id = 3 OR dept_id = 2;

-- 子查询
SELECT * FROM emp WHERE dept_id IN (SELECT id FROM dept WHERE NAME = '财务部' OR NAME = '市场部');
```

#### 3.子查询的结果是多行多列的


查询员工入职日期是2011-11-11日之后的员工信息和部门信息：  
子查询：
```sql
SELECT * FROM dept t1, (SELECT * FROM emp WHERE emp.join_date > '2011-11-11') t2 WHERE t1.id = t2.dept_id;
```

普通内连接：
```sql
SELECT * FROM emp t1, dept t2 WHERE t1.dept_id = t2.id AND t1.join_date > '2011-11-11';
```


## DCL(Data Control Language)数据控制语言

### 管理用户

### 添加用户

语法：
```sql
CREATE USER '用户名'@'主机名' IDENTIFIED BY '密码';
```

### 删除用户

语法：
```sql
DROP USER '用户名'@'主机名';
```

### 权限管理

#### 查询权限

查询权限：
```sql
SHOW GRANTS FOR '用户名'@'主机名';
SHOW GRANTS FOR 'lisi'@'%';
```

#### 授予权限

授予权限：
```sql
GRANT 权限列表 ON 数据库名.表名 TO '用户名'@'主机名';
```

给张三用户授予所有权限，在任意数据库任意表上：
```sql
GRANT ALL ON *.* TO 'zhangsan'@'localhost';
```

#### 撤销权限

撤销权限：
```sql
REVOKE 权限列表 ON 数据库名.表名 FROM '用户名'@'主机名';
REVOKE UPDATE ON 数据库名.表名 FROM 'lisi'@'%';
```
