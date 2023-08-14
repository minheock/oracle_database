

CREATE TABLE ex4_1 (
    irum VARCHAR2(100) NOT NULL,
    point NUMBER(5),
    gender CHAR(1),
    reg_date DATE
);
--�÷��� ����
ALTER TABLE ex4_1 RENAME COlUMN irum TO nm;
--Ÿ�� ���� (Ÿ�� ������ ���̺� �����Ͱ� �ִٸ� �����ؾ���)
ALTER TABLE ex4_1 MODIFY point NUMBER(10);
-- ���� ���� �߰�
ALTER TABLE ex4_1 ADD CONSTRAINTS pk_ex4 PRIMARY KEY(nm);
--�÷� �߰�
ALTER TABLE ex4_1 ADD hp VARCHAR2(20);
-- �÷� ����
ALTER TABLE ex4_1 DROP COLUMN hp;

-- ���̺� comment
COMMENT ON TABLE tb_info IS '�츮��';
COMMENT ON COLUMN tb_info.info_no IS '�⼮��ȣ';
COMMENT ON COLUMN tb_info.pc_no IS '��ǻ�͹�ȣ';
COMMENT ON COLUMN tb_info.nm IS '�̸�';
COMMENT ON COLUMN tb_info.email IS '�̸���';
COMMENT ON COLUMN tb_info.hobby IS '���';
COMMENT ON COLUMN tb_info.mbti IS '�긯��������ǥ';

-- ���̺� comment
SELECT *
FROM all_tab_comments
WHERE OWNER = 'JAVA';

SELECT *
FROM all_col_comments
WHERE comments LIKE '%�̸�%';
--WHERE comments LIKE '%%'
/*
INSERT ������ ���� (DML��)
    1. �⺻ ���� �÷��� ���
*/
CREATE TABLE ex4_2(
val1 VARCHAR2(10),
val2 NUMBER,
val3 DATE
);
INSERT INTO ex4_2(val1, val2 ,val3)
VALUES ('hi', 10, SYSDATE); --���ڿ� '' number Ÿ���� ����
INSERT INTO ex4_2( val2 ,val3)
VALUES (10, SYSDATE);       --���� �ۼ��� �÷� �������
                            --value �� INSERT
SELECT *
FROM ex4_2;
-- ���̺� ��ü�� ���� �����͸� �����Ҷ��� �÷��� �Ƚᵵ ��.
INSERT INTO ex4_2
VALUES ('hello', 20, SYSDATE); 
INSERT INTO ex4_2
VALUES (20, SYSDATE); --����
CREATE TABLE ex4_3(
emp_id NUMBER,
emp_name VARCHAR2(1000)
);
-- SELECT ~ INSERT
INSERT INTO ex4_3 (emp_id, emp_name)
SELECT employee_id,
emp_name
FROM employees
WHERE salary > 5000;
/*
�ؼ� : ex43 ���̺� ���÷��� employee ���̺��� ���÷��� ���� salary�� 5000�̻��ΰ͸� �־���.
*/
select * from ex4_3;

--���̺���
CREATE TABLE ex4_4 AS
SELECT nm, email
FROM tb_info;

select * from ex4_4;
/*UPDATE ������ ����*/
SELECT *
FROM tb_info;
UPDATE tb_info
SET hobby = '����',
email = 'abc@gmail.com'
WHERE info_no = 1;

SELECT *
FROM tb_info;
UPDATE tb_info
SET hobby = '�ڹ�',
email = 'minhyeock0713@gmail.com'
WHERE nm = '�ֹ���';

select * from tb_info;

SELECT *
FROM ex4_4;
DELETE ex4_4; -- ��ü����

DELETE ex4_4
WHERE nm = '���ؼ�';
SELECT *
FROM products;


-- �ߺ����� ������ ����
SELECT DISTINCT prod_category
FROM products;
-- �ǻ� �÷� (���̺��� ������ �ִ°� ó�� ���)
SELECT ROWNUM, --��ǥ �־������
emp_name,
email
FROM employees
WHERE ROWNUM <= 10;

-- NULL (IS NULL or IS NOT NULL)
SELECT *
FROM employees
WHERE manager_id IS NULL; -- null�� �ֵ��� ����

SELECT *
FROM departments
WHERE department_id IN (30, 60);

SELECT *
FROM departments
WHERE department_id NOT IN (30, 60);


/*
oracle ������ ���̽� �����Լ�
���� ����

*/
SELECT LOWER('I like mac') as lowers
,UPPER('I like mac') as uppers
,INITCAP('I like mac') as initcaps-- �ܾ� ù���� �빮��
FROM dual; -- �ӽ����̺�

SELECT *
FROM employees
WHERE UPPER(emp_name) LIKE '%'||:S||'%';

SELECT 'HI', emp_name
FROM employees;

-- SUBSTR (char, pos, len) ��� ���ڿ� char �� pos��°����
-- len ���� ��ŭ �ڸ� �� ��ȯ
-- pos ������ 0�� ���� ����Ʈ �� 1 �� ù��° ���ڿ�
-- ������ ���� ���ڿ��� �� ������ ������ ����� ��ġ
-- len ���� �����Ǹ� pos ��° ���ں��� ������ ��� ���ڸ� ��ȯ
SELECT SUBSTR('ABCD EFG', 1, 4),
        SUBSTR('ABCD EFG', -3, 3),
        SUBSTR('ABCD EFG', -3, 1),
        SUBSTR('ABCD EFG', 5)
FROM dual;
/* INSERT ��� ���ڿ����� ã�� ���ڿ��� ��ġ*/
SELECT INSTR('���� ���� �ܷο� ����, ���� ���� ���ο� ����', '����'), --����Ʈ 1, 1
        INSTR('���� ���� �ܷο� ����, ���� ���� ���ο� ����', '����',5), 
        INSTR('���� ���� �ܷο� ����, ���� ���� ���ο� ����', '����',1,2),
        INSTR('���� ���� �ܷο� ����, ���� ���� ���ο� ����', '��')
FROM dual;

/* ���� �̸��� �ּ��� �̸��� �������� �и��Ͽ� ����Ͻÿ�
ex leeapgil@gmaul.com -> id : leeapgil, domain:gmail.com
*/
SELECT SUBSTR('leeapgil@gmaul.com', 1, 8),
        SUBSTR('leeapgil@gmaul.com', 10)
FROM customers;



SELECT cust_id ,
cust_name,
cust_email,
SUBSTR(cust_email, 1, INSTR(cust_email,'@')-1) as ID, --substr�� 2��° ���ں��� 3��° ���ڱ��� �ڸ��� �޼����̰�
SUBSTR(cust_email, INSTR(cust_email,'@')+1) as DOMAIN -- instr�� 1��° ���ڿ��ִ� ���ڿ��ȿ� 2��° ���ڿ��ִ� ���� 
FROM customers                                        --���� ���� �ε����� ã���ִ� �޼����̱⶧���� ���� Ȱ���ϸ� ���ϴ� ��ġ�� �߶� �÷��� 
ORDER BY cust_name;                                   -- ����� �ִ�.





ALTER TABLE tb_info ADD ���������� VARCHAR2(20);
ALTER TABLE tb_info ADD �νĹ�� VARCHAR2(20);
ALTER TABLE tb_info ADD �Ǵ��� VARCHAR2(20);
ALTER TABLE tb_info ADD ��Ȱ��� VARCHAR2(20);
ALTER TABLE tb_info DROP COLUMN ����������;
ALTER TABLE tb_info DROP COLUMN �νĹ��;
ALTER TABLE tb_info DROP COLUMN �Ǵ���;
ALTER TABLE tb_info DROP COLUMN ��Ȱ���;
SELECT 
nm,
mbti,
CASE WHEN mbti LIKE '%I%' THEN '������'
          else '������' END AS ����������,
     CASE WHEN mbti LIKE '%S%' THEN '������'
          else '������' END AS �νĹ��,
     CASE WHEN mbti LIKE '%T%' THEN '�����'
          else '������' END AS �Ǵ���,
     CASE WHEN mbti LIKE '%J%' THEN '������'
          else '��ȹ��' END AS ��Ȱ���                        
FROM tb_info;
