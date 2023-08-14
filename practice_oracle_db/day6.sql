SELECT mbti
    , COUNT(*)
FROM tb_info
GROUP BY mbti
ORDER BY 2 DESC;

SELECT hobby
    , COUNT(*) as cnt
FROM tb_info
GROUP BY hobby
ORDER BY 2 DESC;

/* ���� �Լ� ��� �����͸� Ư�� �׷����� ���� ���� �׷쿡 ����
    ����, ���, �ִ�, �ּڰ� ���� ���ϴ� �Լ�.
    COUNT(expr) �ο� ���� ��ȯ�ϴ� �����Լ�.
*/ 
SELECT COUNT(*)                    --null ����
    ,COUNT(department_id)          -- default ALL
    ,COUNT(ALL department_id)      --�ߺ� ���� null X
    ,COUNT(DISTINCT department_id) --�ߺ� ����
    ,COUNT(employee_id)
    --, employee_id  <-- �̰� ������ ���� �׷���̰� �ƴ϶�.
    FROM employees;
    
SELECT department_id 
      ,SUM(salary)            --�հ�
      ,ROUND(AVG(salary),2)   --���
      ,MAX(salary)            --�ִ�
      ,MIN(salary)            --�ּ�
FROM employees
GROUP BY department_id        --�μ����� �����ǰ�.
ORDER BY 1;        
    
--50�� �μ��� �ִ�, �ּ� �޿��� ����Ͻÿ�
SELECT MAX(salary)
    ,  MIN(salary)
FROM employees
WHERE department_id = 50;


 --Q. member ���̺��� Ȱ���Ͽ�
 --ȸ���� ������ ȸ������ ����Ͻÿ�
 --����(ȸ���� ��������)
 
SELECT *
FROM member;
 
SELECT DISTINCT mem_job as ����
  ,COUNT(mem_id) as ȸ����
FROM member
GROUP BY mem_job
ORDER BY 2 desc; 

-- 2013�⵵ �Ⱓ�� �� �����ܾ�
select *
from kor_loan_status;


SELECT period
    ,  SUM(loan_jan_amt) as ���ܾ�
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY period
ORDER BY 1;
-- 2013�⵵ ������ �� �����ܾ�
DESC kor_loan_status;

SELECT DISTINCT region as ����
    ,  SUM(loan_jan_amt) as ���ܾ�
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY region
ORDER BY 1;

-- 2013�⵵ ������, ���� ������ �� �����ܾ�    
-- SELECT ���� ���� �÷��� ���� �Լ��� �����ϰ�
-- GROUB by ���� �ݵ�� ���ԵǾ����. �ȱ׷��� ������.
-- ������ SELECT ���� �������� �ʴ��� group by�� ������ ������ �ȳ�.
SELECT DISTINCT region as ����
    ,  gubun
    ,  SUM(loan_jan_amt) as ���ܾ�
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY region, gubun
ORDER BY 1;


--�⵵�� ������ �� �հ�
SELECT SUBSTR(period, 1,4) as �⵵
    , region as ����
    , SUM(loan_jan_amt) as ���ܾ�
FROM kor_loan_status
GROUP BY SUBSTR(period, 1,4), region
ORDER BY 1;

-- employees �������� ��� �⵵�� ������ ���.
select *
from employees;

-- Ʋ���� �� ����§ ����.
-- substr ���� desc�� Ÿ��Ȯ���ϰ� to_char ���� ����.
SELECT SUBSTR(hire_date,1,2) as �Ի�⵵
     ,COUNT(employee_id) as ȸ����
FROM employees
GROUP BY SUBSTR(hire_date,1,2)
ORDER BY 1;

-- �°� �� ����.
-- �׷��� ����� �����Ϳ� ���� �˻������� ������
-- HAVING ���
-- �Ի������� 10�� �̻��� �⵵�� ������
-- **** select �� �������
-- from -> where -> group by -> habing -> select -> order by
SELECT TO_CHAR(hire_date, 'YYYY') as �Ի�⵵
     ,COUNT(employee_id) as ȸ����
FROM employees
GROUP BY TO_CHAR(hire_date, 'YYYY')
HAVING COUNT(employee_id) >= 10
ORDER BY 1;

-- member ���̺� Ȱ���Ͽ�
-- ������ ���ϸ��� ��ձݾ��� ���Ͻÿ� 
--(�Ҽ��� ��° �ڸ����� �ݿø� �Ͽ� ���)
-- (1) ���� ��� ���ϸ��� ��������
-- (2) ��� ���ϸ����� 3000�̻��� �����͸� ���
select *
from member;

SELECT mem_job
,ROUND(AVG(mem_mileage),2) as ���
FROM member
GROUP BY mem_job
HAVING AVG(mem_mileage) >= 3000
ORDER BY 2 DESC;
-------------------------------------------------

-- Q. ������ ���ϸ��� �հ� ���ϸ��� ��ü�հ踦 ����Ͻÿ�
SELECT NVL(mem_job, '�հ�') as ����
     , COUNT(mem_id) as ȸ����
     , SUM(mem_mileage) as �հ�
FROM member
GROUP BY ROLLUP(mem_job); -- �Ѿ� ���ƿø��� ��� ������ 
                          -- �������� ���� �����.   
                          
-- Q. products ��ǰ ���̺��� / ī�װ��� ã��. ī�װ��� / ��ǰ�� ī��Ʈ����. ��ǰ���� / �Ѿ�����. ��ü ��ǰ ���� ����Ͻÿ�

select *
from products;

SELECT NVL(prod_category, '�� ��')
    ,  prod_subcategory as ����ī�װ�
    ,  COUNT(prod_name)
FROM products
GROUP BY ROLLUP(prod_category, prod_subcategory);
--HAVING COUNT(prod_name) >= 10
--ORDER BY 2;


SELECT SUBSTR(period, 1,4) as �⵵
    , region as ����
    , SUM(loan_jan_amt) as ���ܾ�
FROM kor_loan_status
GROUP BY ROLLUP(SUBSTR(period, 1,4), region)
ORDER BY 1;

SELECT *
FROM customers;

-- �⵵�� ȸ������ ����Ͻÿ� �� (��, �� �����Ͽ���)
-- DECODE(cust_gender, 'M', 'M') as ����
--    ,  DECODE(cust_gender, 'F', 'F') as ����

-- ���� § �ڵ�
SELECT cust_year_of_birth as ���ϳ⵵
    , COUNT(DECODE(cust_gender, 'M', 'M')) as ����
    , COUNT(DECODE(cust_gender, 'F', 'F')) as ����
    , COUNT(cust_gender) as ��ü
FROM customers
GROUP BY ROLLUP(cust_year_of_birth)
ORDER BY 1;

-- ���۷��� �ڵ�
SELECT cust_year_of_birth as ���ϳ⵵
    , SUM(DECODE(cust_gender, 'M',1 ,0)) as ����
    , SUM(DECODE(cust_gender, 'F',1 ,0)) as ����
    , COUNT(cust_gender) as ��ü
FROM customers
GROUP BY ROLLUP(cust_year_of_birth)
ORDER BY 1;


-- ������ �� ������ ���� �� �ܾ��� ���ϴ� ������ �ۼ��� ����.(KOR LOAN STATU)
-- 2013�⵵ ������ �� �����ܾ�
DESC kor_loan_status;
SELECT *
FROM kor_loan_status;

SELECT region as ����
--      ,DECODE(period,'2011%',period) as amt_2011
      ,SUM(CASE WHEN SUBSTR(period, 1,4)='2011' THEN loan_jan_amt 
       END) AS AMT_2011
      ,SUM(DECODE(SUBSTR(period, 1,4),'2012', loan_jan_amt)) as amt_2012
--      ,SUM(DECODE(period,'2013%', loan_jan_amt)) as amt_2013 -- LIKE�� ������������
      ,SUM(DECODE(SUBSTR(period, 1,4),'2013', loan_jan_amt)) as amt_2013
FROM kor_loan_status
GROUP BY ROLLUP(region);

--SELECT DECODE(period LIKE '2013%','2013', loan_jan_amt)
FROM kor_loan_status;
SELECT DISTINCT region as ����
    ,  SUM(loan_jan_amt) as ���ܾ�
FROM kor_loan_status
WHERE period LIKE '2011%'
GROUP BY region
ORDER BY 1;