/*
    �������� TRIM : ����, LTRIM : ����, RTRIM : ������
    ���ڿ� ���� ���߱� LPAD  ; ���ʺ���, RPAD : ������ ����
*/

SELECT LTRIM(' ABC '),
RTRIM(' ABC '),
TRIM(' ABC ')
FROM dual;

-- LPAD(1,5,'0') --> 00001 �Է��� 50�̸� ->00050
SELECT LPAD(123, 5, '0'),
LPAD(12310, 5, '0'),
RPAD(1, 5, '0'),
LPAD(111111, 5, '0') -- ���� ����� ������ 2��° �Ű����� ���� ��ŭ
FROM dual;           -- Ÿ���� ���ϰ��� ������ varchar Ÿ��.


-- �߿� REPLACE
SELECT REPLACE('���� �ʸ� �𸣴µ� �ʴ� ���� �˰ڴ°�?' ,'����', '�ʸ�') rep, -- ġȯ�ϴ°�
TRANSLATE('���� �ʸ� �𸣴µ� �ʴ� ���� �˰ڴ°�?' ,'����', '�ʸ�') trn       -- �ѱ��ھ� �ٲ۴�.
FROM dual;

-- LENGTH ���ڿ� ����, LENGTHBũ��
SELECT LENGTH('���ѹα�'),
     LENGTHB('���ѹα�'),  -- �ѱ� 1���� 3byte
     LENGTH('1234'),
     LENGTB('1234')       -- ����, ���� 1byte
FROM dual;    

/*��¥ �Լ�*/
SELECT SYSDATE,
SYSTIMESTAMP      --����ð�
FROM dual;
--ADD_MONTHS �� + -
SELECT ADD_MONTHS(SYSDATE, 1),
ADD_MONTHS(SYSDATE, -1)
FROM dual;

-- LAST_DAY, NEXT_DAY
SELECT LAST_DAY(SYSDATE),
NEXT_DAY(SYSDATE, '�ݿ���'),
NEXT_DAY(SYSDATE, '�����'),
SYSDATE + 1 - SYSDATE AS days,
SYSDATE - 2
FROM dual;

--�̹����� ��ĥ ���������?
SELECT 'd-day:'||(LAST_DAY(SYSDATE) - SYSDATE )||'��'as d_day
FROM dual;

/*  �����Լ� (�Ű����� ������)
    ABS : ���밪
    ROUND : �ݿø�
    TRUNC : ����
*/

SELECT ABS(-10)
    ,ABS(10)
    ,ROUND(10.155,1)
    ,ROUND(10.155,2)
    ,ROUND(10) -- ����Ʈ 0       
    ,TRUNC(114.999,1)
FROM dual;


-- MOD(m,n) m�� n���� ���������� ������ ��ȯ
-- SQRT ������ ��ȯ
SELECT MOD(4,2)
    , MOD(5,2)
    , SQRT(4)
FROM dual;    
/* ��ȯ TO_CHAR : ����������, TO_NUMBER : ����������, TO_DATE : ��¥������*/
SELECT TO_CHAR(1234566, '999,999,999')
        ,TO_CHAR(SYSDATE, 'YYYY-MM-DD')
        ,TO_CHAR(SYSDATE, 'YYYY')
        ,TO_CHAR(SYSDATE, 'YYYYMMDD HH:MI:SS')
        ,TO_CHAR(SYSDATE, 'YYYYMMDD HH24:MI:SS')
        ,TO_CHAR(SYSDATE,'day')
        ,TO_CHAR(SYSDATE,'dd')
        ,TO_CHAR(SYSDATE,'d')
FROM dual;

SELECT TO_DATE('230713','YYMMDD')
        --TO_DATE�� ��¥ ������ Ÿ������ �� ��ȯ
        -- �Է� ����� �����ϰ� ǥ���ؾ� DATE�� �ٲ�
      ,TO_DATE('23 08 12 10:00:00','YYYY MM DD HH24:MI:SS')
FROM dual;
CREATE TABLE tb_myday(
    title VARCHAR2(200) 
    ,d_day  DATE
);
INSERT INTO tb_myday VALUES ('������', '20231226');
INSERT INTO tb_myday VALUES ('������', '2023.12.26');
INSERT INTO tb_myday VALUES ('������', '23.12.26');
INSERT INTO tb_myday VALUES ('������', '23|12|26');
INSERT INTO tb_myday VALUES ('������', '23|12|26|18');
INSERT INTO tb_myday VALUES ('������', TO_DATE('231226 18', 'YYMMDD HH24'));
SELECT * FROM tb_myday;

CREATE TABLE ex5_1(
    seq VARCHAR2(100) 
    ,seq2 NUMBER
);
INSERT INTO ex5_1 VALUES ('1234', '1234');
INSERT INTO ex5_1 VALUES ('99', '99');
INSERT INTO ex5_1 VALUES ('123456', '123456');
SELECT * FROM ex5_1
ORDER BY TO_NUMBER(seq) DESC; --1 desc �� ������ ����Ÿ�Կ��� 9�� ũ�ٰ� ���� 99���� ����. 
                              --�ѹ�Ÿ������ �ٲ���߸� �ùٸ��� ���������� ��.
                              
SELECT * FROM students;
-- students ���̺��� Ȱ���Ͽ� �ѹ�, �л��̸�, ���̸� ����Ͻÿ�
SELECT stu_id as �й�
    ,stu_name as �̸�
    ,TRUNC((SYSDATE - TO_DATE(stu_birth))/365, 0) ||'��' as ���� 
    ,stu_birth as �������
FROM students;
DESC customers;
SELECT cust_name
    ,cust_year_of_birth
    ,TO_CHAR(SYSDATE, 'YYYY') - cust_year_of_birth as ����
FROM customers
ORDER BY ���� asc;


-- �Էµ� ���ڸ� ���� ���� 50~ �̻��̸� 20����� �ؼ� 49���ϸ� 21����� �ؼ�.
SELECT stu_name, TO_DATE(stu_birth, 'YYMMDD') 
                ,TO_CHAR(TO_DATE(stu_birth, 'YYMMDD'), 'YYYY') 
                ,TO_DATE(stu_birth, 'RRMMDD') 
                ,TO_CHAR(TO_DATE(stu_birth, 'RRMMDD'), 'YYYY') 
                ,(SYSDATE - TO_DATE('19940713','YYYY/MM/DD'))/365 as ��
FROM students;


--employees �� hire_date �÷��� Ȱ���Ͽ� �ټ� ����� ����Ͻÿ�.
desc employees;
SELECT emp_name
,TO_CHAR(hire_date, 'YYYY') as �Ի�⵵ 
,TO_CHAR(SYSDATE, 'YYYY') - TO_CHAR(hire_date, 'YYYY') as �ټӿ���
, ROUND((SYSDATE - hire_date)/365, 1) as �⵵
FROM employees
ORDER BY �ټӿ��� desc, 1;

--SELECT 
--hire_date,
--CASE when substr(hire_date,1,2) > 23 then  
--FROM employees;


--null ����
SELECT emp_name
, salary
, commission_pct
, salary * NVL(commission_pct, 0) -- NVL : null���� 0���� ������� / �� �˾Ƶα�!!
FROM employees;


-- DECODE ��ȯ (case�� ������)
SELECT cust_id ,cust_name
    --decode     ����    ��   ������  �׹ۿ�
    ,DECODE(cust_gender, 'M', '����', '����') as gender
     --         ����    ��   ������  ��2   ������  �׹ۿ�
    ,DECODE(cust_gender,'M', '����', 'F', '����', '??') as gender2
FROM customers;

/*
�� ���̺�(customers)���� ���� ����⵵(cust_year_of_birth) �÷��� �ִ�.
������ �������� �� �÷��� Ȱ���� 30�� 40�� 50�� ������ ����ϰ�,
������ ���ɴ�� "��Ÿ"�� ����ϴ� ������ �ۼ��غ���.
*/
SELECT cust_name
    ,cust_year_of_birth
    ,substr((TO_CHAR(SYSDATE, 'YYYY') - cust_year_of_birth),0,1) as su
      ,RPAD(substr((TO_CHAR(SYSDATE, 'YYYY') - cust_year_of_birth),0,1),2,0)||'��' as ����
     ,DECODE(substr((TO_CHAR(SYSDATE, 'YYYY') - cust_year_of_birth),0,1),'3','30��','4', '40��', '5', '50��', '��Ÿ') as GENERATION
FROM customers;