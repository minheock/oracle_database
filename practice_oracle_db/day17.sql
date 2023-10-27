--q1
ALTER SESSION SET "_ORACLE_SCRIPT"=true;
CREATE USER java2 IDENTIFIED BY oracle;
--q2
GRANT CONNECT, RESOURCE TO java2;
GRANT UNLIMITED TABLESPACE TO java2;
drop user java2 cascade;
DROP TABLE EX_MEM;
--q3
CREATE TABLE EX_MEM(
     MEM_ID VARCHAR2(10) NOT NULL
    ,MEM_NAME VARCHAR2(20) NOT NULL
    ,MEM_JOB VARCHAR2(30)
    ,MEM_MILEAGE NUMBER(8,2)
    ,MEM_REG_DATE DATE
);
ALTER TABLE EX_MEM ADD CONSTRAINT PK_EX_MEM PRIMARY KEY (MEM_ID);
--q4
ALTER TABLE EX_MEM MODIFY MEM_NAME VARCHAR2(50);

--q5
CREATE SEQUENCE seq_code START WITH 1000 INCREMENT BY 9999;
--q6
INSERT INTO EX_MEM(mem_id, mem_name, mem_job, mem_reg_date)VALUES('hong','È«±æµ¿', 'ÁÖºÎ', SYSDATE);
select*from member;

--q7
INSERT INTO EX_MEM(mem_id, mem_name, mem_job, mem_mileage)
            SELECT mem_id
                 , mem_name
                 , mem_job
                 , mem_mileage
            FROM member
            WHERE mem_like IN('µ¶¼­', 'µî»ê', '¹ÙµÏ');

DESC EX_MEM;
SELECT*FROM EX_MEM;

SELECT mem_name
FROM ex_mem
WHERE substr(mem_name, 0, 1) = '±è';
--q8
DELETE FROM ex_mem
    WHERE substr(mem_name, 0, 1) = '±è';

--q9
SELECT * FROM member;
SELECT mem_id
    ,  mem_name
    ,  mem_job
    ,  mem_mileage
FROM member
WHERE mem_job = 'ÁÖºÎ'
AND mem_mileage <= 3000
AND mem_mileage >= 1000
ORDER BY 4 desc;     
-- q11
SELECT prod_id, prod_name, prod_sale
FROM prod
WHERE prod_sale = 23000 
OR prod_sale =  26000 
OR prod_sale = 33000;

SELECT * FROM MEMBER;
SELECT * FROM È¸¿ø;

-- q12
SELECT mem_job
     , count(mem_job) as MEM_CNT
     , TO_CHAR(max(mem_mileage),'9,999') as MAX_MLG
     , TO_CHAR(round(avg(mem_mileage)), '9,999') as AVG_MLG
FROM MEMBER
GROUP BY mem_job
HAVING count(mem_job) >= 3;

select* from member;
select * from
cart;

--q13
select a.mem_id
    ,  a.mem_name
    ,  a.mem_job
    ,  b.cart_prod
    ,  b.cart_qty
from member a, cart b
where a.mem_id = b.cart_member
and substr(b.cart_no, 0,8) = '20050728';

--q14
select mem_id
    ,  mem_name
    ,  mem_job
    ,  cart_prod
    ,  cart_qty
from member
INNER JOIN cart
ON(member.mem_id = cart.cart_member)
WHERE substr(cart_no, 0,8) = '20050728';

--q15
SELECT mem_id
    ,  mem_name
    ,  mem_job
    ,  mem_mileage
    , rank() over (PARTITION by mem_job ORDER BY mem_mileage desc)
FROM MEMBER;


