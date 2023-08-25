/*
    �μ��� ������ salary �� ���� ���� ������ ����Ͻÿ�
*/

SELECT * FROM(
SELECT emp_name
    ,  salary
    ,  department_id
    ,  RANK() OVER(PARTITION BY department_id ORDER BY salary DESC) as rnk
FROM employees   
)
WHERE rnk = 1;

-- �л��� ������ ������ ���� ���� �л��� ������ ����Ͻÿ�
select * from �л�;
SELECT * FROM(
SELECT a.*
    ,  RANK() OVER(PARTITION BY a.���� ORDER BY ���� DESC) as rnk   
    ,  RANK() OVER(ORDER BY a.���� DESC) as all_rnk    
    ,  COUNT(*) OVER() as ��ü�л���
    ,  ROUND(AVG(a.����) OVER (), 2) as ��ü���
FROM �л� a
)
WHERE rnk =1
ORDER BY ���� DESC;

/*
    �ο�ս� ���� ���谪 ����
    partition by ���� window ���� Ȱ���Ͽ� ���� ���踦 �� �� ����.
    AVG, SUM, MAX, MIN, COUNT, RANK, DENSE_RANK, LAG, ROW_NUMBER...
    PARTITON BY �� : ��� ��� �׷�
    ORDER BY �� : ��� �׷쿡 ���� ����
    WINDOW �� : ��Ƽ������ ���ҵ� �׷쿡 ���� �� ���� �׷����� ����
*/


-- CART, PROD ��ǰ�� prod_sale �հ��� ���� 10�� ��ǰ�� ����Ͻÿ�.
SELECT * FROM cart;
SELECT * FROM prod;

-- �Ϲ� ���
SELECT * FROM(
SELECT c.*
    ,  RANK() OVER(ORDER BY sale_sum) as rnk   
FROM(    
SELECT a.cart_prod -- ��ǰ���̵�
    ,  b.prod_name -- ��ǰ�̸�
    ,  SUM(b.prod_sale * a.cart_qty) as sale_sum
FROM cart a
    ,prod b
WHERE a.cart_prod = b.prod_id
GROUP BY a.cart_prod, b.prod_name
 ) c 
)
WHERE rnk <= 10;    


SELECT *
FROM(
SELECT a.cart_prod -- ��ǰ���̵�
    ,  b.prod_name -- ��ǰ�̸�
    ,  RANK() OVER(ORDER BY sum(b.prod_sale * a.cart_qty) DESC)as rnk
FROM cart a
    ,prod b
WHERE a.cart_prod = b.prod_id
GROUP BY a.cart_prod, b.prod_name
)
WHERE rnk <= 10;


/*
    NTILE(expr) ��Ƽ�Ǻ��� expr ��õ� �� ��ŭ ������ ����� ��ȯ
    NTILE(3) 1 ~ 3 �� ���� ��ȯ(�����ϴ� ���� ��Ŷ �� �����)
    NTILE(4) -> 100/4 -> 25% �� ���� ����

*/

SELECT emp_name, salary, department_id
    ,  NTILE(2) OVER(PARTITION BY department_id ORDER BY salary DESC) as group_num
    ,  COUNT(*) OVER(PARTITION BY department_id ) as �μ�������
FROM employees
WHERE department_id IN (30,60);

-- ��ü ������ �޿��� 10 ������ ���������� 1������ ���ϴ� ������ ��ȸ�Ͻÿ�
SELECT emp_name, salary
    ,  NTILE(10) OVER(ORDER BY salary DESC) as ����
FROM employees;

SELECT *
FROM tb_info;

SELECT nm
    ,  NTILE(6) OVER(ORDER BY DBMS_RANDOM.VALUE) as team
FROM tb_info;    

CREATE TABLE tb_sample AS
SELECT ROWNUM as seq
    ,  '2023' || LPAD(CEIL(ROWNUM / 1000), 2, '0') as month
    ,  ROUND(DBMS_RANDOM.VALUE(100, 1000)) as amt
FROM dual
CONNECT BY LEVEL <= 12000;
SELECT * FROM
tb_sample;


-- ���ĺ� �빮�� 5�ڸ� ���� ����
SELECT DBMS_RANDOM.STRING('U', 5) -- ���ĺ� �빮�� 5�ڸ� ��������
    ,  DBMS_RANDOM.STRING('L', 5) -- �ҹ���
    ,  DBMS_RANDOM.STRING('A', 5) -- ��ҹ���
    ,  DBMS_RANDOM.STRING('X', 5) -- ���ĺ� �빮�� & ����
    ,  DBMS_RANDOM.STRING('P', 5) -- ��ҹ���, ����, Ư������
FROM DUAL;    

/*
    �־��� �׷�� ������ ���� ROW�� �ִ� ���� �����Ҷ� ���
    LAG(expr, offset, default_value) ����ο��� �� ����
    LEAD(expr, offset, default_value) ����ο��� �� ����
*/

SELECT emp_name, department_id, salary
    ,  LAG(emp_name, 1, '�������') OVER(PARTITION BY department_id
                                   ORDER BY salary DESC) as emp_lag
    ,  LEAD(emp_name, 1, '���峷��') OVER(PARTITION BY department_id
                                    ORDER BY salary desc) as emp_lead
FROM employees;                         

/*
     �л��� ������ �������� �Ѵܰ� ���� �л��� ������ ���̸� ����Ͻÿ�
     ���� �̸�   ����    �����л��̸�  ���������� ����
     1��  �ؼ�   4.5       ����           0
     2��  �浿   4.3       �ؼ�          0.2
     3��  ����   3.0       �浿          1.3      
     LAG(emp_name, 1, '�������') �Ű����� 1, 3�� Ÿ���� ���ƾ���
*/
select * from �л�;

 SELECT �̸�, round(����, 1)
    ,  LAG(�̸�, 1 ,'����') OVER(ORDER BY ���� DESC) as �����л��̸�
    --                   Ÿ���� ���������.
    ,  ROUND(LAG(����, 1, ����) OVER(ORDER BY ���� DESC) - ����, 2) as ������������ 
FROM �л�
order by 2 desc;  

/*
    1. ȸ���� �Խ��ǿ� �Խñ��� ������ �ۼ� �� �� �ִ�.
    2. ȸ���� �ۼ��� �Խñۿ� ����� �ۼ� �� �� �ִ�.
        �Խ��ǿ��� ����, �� ����, �ۼ���, �ۼ���, ������ ������ �־����.
        
    ȸ��  m - n  �Խ������̺�      
    �۹�ȣ       bbs_no        NUMBER          PK  
    ���� �۹�ȣ  parent_no      NUMBER          FK
    ����        bbs_title     varchar2(1000)          NOTNULL
    �۳���      bbs_content   varchar2(4000)          NOTNULL
    �ۼ���      author_id     varchar2(100)    FK     NOTNULL
    ��������    create_dt       timestamp              DEFAULT
    ��������    update_dt       timestamp              DEFAULT
*/
DROP TABLE bbs;
CREATE TABLE bbs (
bbs_no          NUMBER PRIMARY KEY
,parent_no      NUMBER
,bbs_title      VARCHAR2(1000) DEFAULT NULL -- ����� ��� NULL
,bbs_content    VARCHAR2(4000) NOT NULL
,author_id      VARCHAR2(100)
,create_dt      TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- ����� ������ �ð�
,update_dt      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
,CONSTRAINT fk_prent FOREIGN KEY(parent_no) 
 REFERENCES bbs(bbs_no) ON DELETE CASCADE 
 -- �Խñ��� no �� �����ϰ� ���� ������ ������ ���� ����
,CONSTRAINT fk_user  FOREIGN KEY(author_id) 
 REFERENCES tb_user(user_id) ON DELETE CASCADE -- ���� Ż��� ���� ����
);

-- �Խñ� ��ȣ ������
DROP SEQUENCE bbs_seq;
CREATE SEQUENCE bbs_seq START WITH 1 INCREMENT BY 1;

INSERT INTO bbs(bbs_no, bbs_title, bbs_content, author_id)
VALUES(bbs_seq.NEXTVAL, '��������', '������ �ݿ��� �Դϴ�.!!!!', 'a001');

INSERT INTO bbs(bbs_no, bbs_title, bbs_content, author_id)
VALUES(bbs_seq.NEXTVAL, '�Խñ�1', '�Խñ� 1�Դϴ�.', 'b001');

INSERT INTO bbs(bbs_no, parent_no, bbs_content, author_id)
VALUES(bbs_seq.NEXTVAL, 1, '�� �������̿��� ...', 'x001');

SELECT * FROM bbs;
select  level, a.*
FROM bbs a
START WITH parent_no is null
connect by prior bbs_no = parent_no ;    


select a.*
FROM bbs a
START WITH bbs_no =1
connect by prior bbs_no = parent_no ; 





SELECT * 
FROM tb_user;
SELECT * 
FROM user_tab_columns
WHERE table_name = 'TB_USER'

SELECT user_id
    ,  user_nm
    ,  user_pw
    ,  user_mileage
FROM tb_user
WHERE user_id = '';
