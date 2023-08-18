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

---------------------------------------------------------------------
----------4-1�� ���� ---------------------------------------------------
-- ���� ���� ����(ó�����)�� ���ϰ� �Ǽ��� ����Ͻÿ� 
SELECT * FROM(
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
SELECT case sex_code when 'M' then '����'
                     when 'F' then '����'
                     else '�̵��'
        end as gender
    , case sex_code when 'M' then count('M')
                     when 'F' then count('F')
                     else count(*)- count('M') + count('F')
                     end as cnt
FROM customer
GROUP BY ROLLUP(sex_code);

---------------------------------------------------------------------
----------5�� ���� ---------------------------------------------------
--���� ���� ��� �Ǽ��� ����Ͻÿ� (���� �� ���� ���)
SELECT * FROM address;
SELECT * FROM customer;
SELECT * FROM item;
SELECT * FROM order_info;
SELECT * FROM reservation;
desc reservation;

SELECT SUBSTR(SUBSTR(reserv_date,5,6),1,2)as ��
      ,COUNT(SUBSTR(SUBSTR(reserv_date,5,6),1,2)) as ��ҰǼ�
FROM reservation
WHERE cancel = 'Y'
GROUP BY SUBSTR(SUBSTR(reserv_date,5,6),1,2)
ORDER BY 2 desc;




---------------------------------------------------------------------
