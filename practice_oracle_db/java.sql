/*
 �ּ� ����
 table ���̺�
 1. ���̺�� �÷����� �ִ� ũ��� 30 ����Ʈ
 2. ���̺�� �÷������� ������ ����� �� ����.
 3. ���̺�� �÷������� ����, ����, _, $, # �� 
    ��� �� �� ������ ù ���ڴ� ���ڸ� �� �� ����.
 4. �� ���̺� ��밡���� �÷��� �ִ� 255�� ����
*/

CREATE TABLE ex2_1(
    col1 CHAR(10)
    ,col2 VARCHAR2(10) --�÷���, <--�� ����
--    �ϳ��� �÷����� �ϳ��� Ÿ�԰� ����� ����
    );
    
-- INSERT ������ Ÿ��

INSERT INTO ex2_1(col1, col2)
VALUES('abc', 'abc');-- ���ڿ��� '' <-- ���� ����ǥ�� ǥ��

--SELECT ������ ��ȸ
SELECT col1
, LENGTH(col1)
, col2
, LENGTH(col2)
FROM ex2_1;

SELECT * --��ü �÷��� �ǹ���
FROM employees;
--Ư�� �÷��� ��ȸ
SELECT emp_name
    ,email
FROM employees;

-- alias(��Ī, ����) as
SELECT emp_name as nm
    , hire_date hd               -- ��Ī�� as�� ���̰� ������ ����Ʈ�� �νĵ�
    , salary ����                 -- �ѱ۵� ��� ���������� ���� ����
    , department_id "�μ� ���̵�"  -- ���⸦ �����Ϸ��� "" <- ���
FROM employees;                  --����� �Ⱦ��°� ���� _ ����� ���
-- �˻� ������ �ִٸ� where�� ���
SELECT emp_name
    ,salary
    ,department_id
FROM employees
WHERE salary >= 12000 --salary �� 12000�̻�
AND department_id = 90;
-- ���� ���� ORDER BY default [ASC ��������], ������������ ������ DESC
SELECT *
FROM departments
ORDER BY department_id; -- ����Ʈ ASC

SELECT *
FROM departments
ORDER BY department_id DESC; --��������

SELECT emp_name, salary
FROM employees
ORDER BY salary DESC, emp_name DESC;

SELECT emp_name, salary
FROM employees
ORDER BY hire_date;
-- ���� ������ : + = * /
SELECT employee_id as �������̵�
    ,emp_name as �����̸�
    ,salary/30 as �ϴ�
    ,salary as ����
    ,salary - salary * 0.1 as �Ǽ��ɾ�
    ,salary * 12 as ����
FROM employees;    
-- �� ������
SELECT * FROM employees WHERE salary = 2600; --����
SELECT * FROM employees WHERE salary <> 2600; --�����ʴ�
SELECT * FROM employees WHERE salary != 2600; --�����ʴ�
SELECT * FROM employees WHERE salary < 2600; --�̸�
SELECT * FROM employees WHERE salary > 2600; --�ʰ�
SELECT * FROM employees WHERE salary <= 2600; --����
SELECT * FROM employees WHERE salary >= 2600; --�̻�
-- departments ���̺��� 30�μ��� ��ȸ�Ͻÿ�
SELECT * FROM departments 
WHERE department_id = 30 
OR department_id = 60;
-- PRODUCTS ���̺� '��ǰ �����ݾ�(PROD_MIN_PRICE)'��
-- 30�� "�̻�" 50�� "�̸�" �� ��ǰ���, ī�װ�, �����ݾ��� ����Ͻÿ�
SELECT PROD_NAME,PROD_CATEGORY,PROD_MIN_PRICE
FROM PRODUCTS 
WHERE PROD_MIN_PRICE >= 30
AND PROD_MIN_PRICE < 50
ORDER BY PROD_CATEGORY,PROD_MIN_PRICE DESC;
-- ǥ����: ���ϴ� ǥ������ ���� CASW WHEN ����1 THEN �ش����Ǻ���ǥ��
--                               WHEN ����2 THEN �ش����Ǻ���ǥ��
--                          END AS ��Ī
select cust_name from customers;
SELECT cust_name, cust_gender
    ,CASE WHEN cust_gender = 'M' THEN '����'
    WHEN cust_gender = 'F' THEN '����'
    ELSE '??'
    END AS gender
FROM customers;

SELECT cust_name, cust_gender
    ,CASE WHEN cust_gender = 'M' THEN '����'
    ELSE '����'
    END AS gender
FROM customers;

SELECT employee_id
,emp_name
,CASE WHEN salary <= 5000 THEN 'c���'
WHEN salary > 5000 AND salary <= 15000 THEN 'B���'
ELSE 'A���'
END as grade
FROM employees;

FROM employees;
-- BETWEEN AND ���ǽ�
SELECT employee_id, salary
FROM employees --2000 ~2500
WHERE salary BETWEEN 2000 AND 2500;
--IN ���ǽ� or �� �ǹ�
SELECT employee_id, salary, department_id
FROM employees
WHERE department_id IN(90,80,10); --90 or 80 or 10
-- ���ڿ� ������ || <-- +
SELECT emp_name || ' : ' || employee_id as �̸����
FROM employees;
-- ** ���� ��� LIKE
SELECT emp_name
FROM employees
WHERE emp_name LIKE 'A%'; --A�� �����ϴ�

SELECT emp_name
FROM employees
WHERE emp_name LIKE 'A%sa%n'; 

SELECT emp_name
FROM employees
WHERE emp_name LIKE '%na%'; 


SELECT emp_name
FROM employees
WHERE department_id = :a 
OR department_id = :b;      -- �ݷ� : �̸� <-- ���ε�
                            -- ���� ���� �׽�Ʈ �غ� �� ���.
                            
SELECT emp_name
FROM employees
WHERE emp_name LIKE '%'||:val||'%';  --%��%

CREATE TABLE ex2_2(
    nm VARCHAR2(20)
);
INSERT INTO ex2_2 VALUES('�浿');
INSERT INTO ex2_2 VALUES('ȫ�浿');
INSERT INTO ex2_2 VALUES('�浿ȫ');
INSERT INTO ex2_2 VALUES('ȫ�浿��');

SELECT *
FROM ex2_2
WHERE nm LIKE '__';

CREATE TABLE students (
stu_id VARCHAR2(12) /* �й� */
, stu_grade NUMBER(1)/* �г� */
, stu_semester NUMBER(1) /* �б� */
, stu_name VARCHAR2(10) /* �л� �̸� */
, stu_birth VARCHAR2(10) /* �л� ������� */
, stu_kor NUMBER(3) /* ���� ���� */
, stu_eng NUMBER(3) /* ���� ���� */
, stu_math NUMBER(3) /* ���� ���� */
, CONSTRAINTS stu_pk PRIMARY KEY (stu_id, stu_grade, stu_semester)
);

SELECT stu_name, stu_grade, (stu_kor + stu_eng + stu_math)/3 as subject_avg
FROM students -- 1�г� �达�� ��ȸ�Ͻÿ�
--WHERE stu_name LIKE '��%'
WHERE stu_grade = 1 
AND (stu_kor + stu_eng + stu_math)/3 >= 90;

/*
    CUSTOMERS
    ���� : Los Angeles
    ��ȥ : single
    ���� : ����
    1983 ���� �����
    �������� ����⵵ �������� �̸� ��������
*/
select * from customers;
SELECT cust_name,
cust_gender,
cust_year_of_birth,
cust_marital_status,
cust_street_address,
cust_food
FROM customers
WHERE cust_gender = 'F'
AND cust_year_of_birth >= 1983
AND cust_marital_status = 'single'
AND cust_city = 'Los Angeles'
ORDER BY cust_year_of_birth DESC, cust_name;

--alter table [���̺��] add [�÷���] [Ÿ��] [�ɼ�]; 
ALTER TABLE customers 
ADD (cust_food VARCHAR2(30));




