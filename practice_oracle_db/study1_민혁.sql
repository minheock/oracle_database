/*
 STUDY ������ create_table ��ũ��Ʈ�� �����Ͽ� 
 ���̺� ������ 1~ 5 �����͸� ����Ʈ�� �� 
 �Ʒ� ������ ����Ͻÿ� 
 (������ ���� ��¹��� �̹��� ����)
*/
-----------1�� ���� ---------------------------------------------------
--1988�� ���� ������� ������ �ǻ�,�ڿ��� ���� ����Ͻÿ� (� ������ ���)
SELECT *
FROM customer
WHERE job IN('�ǻ�', '�ڿ���')
AND birth > 19880101
ORDER BY 7 desc;
-----------------------------------------------------------------
-----------2�� ���� ---------------------------------------------------
--�������� ��� ���� �̸�, ��ȭ��ȣ�� ����Ͻÿ� 
SELECT a.customer_name
    ,  a.phone_number
FROM customer a,address b
WHERE a.zip_code = b.zip_code
AND b.address_detail = '������';
---------------------------------------------------------------------
----------3�� ���� ---------------------------------------------------
--CUSTOMER�� �ִ� ȸ���� ������ ȸ���� ���� ����Ͻÿ� (���� NULL�� ����)
SELECT DISTINCT job
    ,  COUNT(job)
FROM customer
GROUP BY job
HAVING COUNT(job) >= 1
ORDER BY 2 desc;

SELECT DISTINCT job
    ,  COUNT(job)
FROM customer
WHERE job IS NOT NULL
GROUP BY job
ORDER BY 2 desc;
---------------------------------------------------------------------
----------4-1�� ���� ---------------------------------------------------
-- ���� ���� ����(ó�����)�� ���ϰ� �Ǽ��� ����Ͻÿ� 
SELECT ����, �Ǽ� 
FROM(
SELECT ROWNUM rnum
      ,a.*
FROM(
SELECT TO_CHAR(first_reg_date,'day') as ����
      ,COUNT(TO_CHAR(first_reg_date,'day')) as �Ǽ�
FROM customer
GROUP BY TO_CHAR(first_reg_date,'day')
ORDER BY 2 desc) a
)
WHERE rnum = 1;
---------------------------------------------------------------------
----------4-2�� ���� ---------------------------------------------------
-- ���� �ο����� ����Ͻÿ� 
SELECT NVL(decode(sex_code, 'M', '����', 'F', '����', '�̵��'),'�հ�') as gender
    ,  COUNT(decode(sex_code, 'M', '����', 'F', '����', '�̵��')) as ȸ��
FROM customer
GROUP BY ROLLUP(decode(sex_code, 'M', '����', 'F', '����', '�̵��'));


SELECT NVL(gender, '�հ�') as gender
    ,  count(*) as cnt
FROM (
        SELECT DECODE(sex_code, 'M', '����', 'F', '����', '�̵��') as gender
        FROM customer
)    
GROUP BY ROLLUP(gender)
;
-- grouping_id : group by ������ �׷�ȭ�� ������ ��, ���� �÷��� ����
--                 ���� ��Ż�� ���� �����ϱ� ���� �Լ�
SELECT sex_code
    ,  GROUPING_ID(sex_code) as groupid
    ,  count(*) as cnt
FROM customer
GROUP BY ROLLUP(sex_code);



SELECT CASE WHEN sex_code = 'F' THEN '����'
            WHEN sex_code = 'M' THEN '����'
            WHEN sex_code IS NOT NULL AND groupid = 0 THEN '�̵��'
            ELSE '�հ�'
            END as gender
            ,cnt
FROM(SELECT sex_code
    ,  GROUPING_ID(sex_code) as groupid
    ,  COUNT(*) as cnt 
FROM customer
GROUP BY ROLLUP(sex_code)
);            
            

---------------------------------------------------------------------
----------5�� ���� ---------------------------------------------------
--���� ���� ��� �Ǽ��� ����Ͻÿ� (���� �� ���� ���)
SELECT SUBSTR(SUBSTR(reserv_date,5,6),1,2)as ��
      ,COUNT(SUBSTR(SUBSTR(reserv_date,5,6),1,2)) as ��ҰǼ�
FROM reservation
WHERE cancel = 'Y'
GROUP BY SUBSTR(SUBSTR(reserv_date,5,6),1,2)
ORDER BY 2 desc;

---------------------------------------------------------------------
