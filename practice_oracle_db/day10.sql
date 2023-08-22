/*
    �� VIEW 338p
    �ϳ� �̻��� ���̺��� ������ ��ġ ���̺��� �� ó�� ����ϴ� ��ü
    ���� �����ʹ� �並 �����ϴ� ���̺� ��� ������ ���̺�ó�� ��밡��
    ��� ���� : 1. ���� ����ϴ� ������ SQL���� �Ź� �ۼ��� �ʿ� ���� ��� ����� ���
              2. ������ ���� ����(��� �÷��� �����͸� �������� ��õ ���̺� ���� �� ����.)
*/

CREATE OR REPLACE VIEW emp_dept AS -- �� ���� ����
SELECT a.employee_id
      ,a.emp_name
      ,a.department_id
FROM employees a, departments b
WHERE a.department_id = b.department_id;
-- system �������� java������ �並 ���� �� �ִ� ���� �ο�
GRANT CREATE VIEW to java;  -- system �������� ����
SELECT *
FROM emp_dept;


-- �ٸ� ������ emp_dept �並 ��ȸ�� �� �ִ� ���� �ο�
GRANT SELECT ON emp_dept TO study; --java �������� ����

SELECT *
FROM java.emp_dept; -- study �������� ��ȸ �ٸ� �������� ��Ȼ�Ҷ��� ��Ű��(����). �� or ���̺�


/*  �� Ư¡
     * �ܼ� �� (���̺� 1���� ����)
     - �׷� �Լ� ��� �Ұ�
     - dinstinct ��� �Ұ�
     - insert/update/delete ��� ����
     
     * ���� �� (���̺� �������� ����)
     - �׷� �Լ� ��� ����
     - dinstinct ��� ����
     - insert/update/delete �Ұ���
*/

 -- �� ����
DROP VIEW emp_dept; -- ������ �������� ����

/* �ó�� synonim : ���Ǿ�� ������ ��ü ������ ������ �̸��� ���� ���Ǿ ����°�
   public synonim : ��� ����� ����
   private synonim : Ư�� ����ڸ� ����
   �ó�� ������ public �� �����ϸ� private �ó������ ������
   public �ó���� ���� ������ DBA �����ִ� ����ڸ� ����
   ��� ���� : 1. ���� ���� ������� ���� �߿��� ������ ����� ���� ��Ī�� ����
             2. ���� ���Ǽ� ���� ���̺��� ������ ����Ǿ ��Ī���� ����� �ߴٸ�
                �ڵ� ������ ���ص� ��. 
*/
-- �ó�� ���� ���� �ο�
GRANT CREATE SYNONYM to java;
CREATE OR REPLACE SYNONYM empl FOR employees;
SELECT *
FROM empl;
GRANT SELECT ON empl TO study; -- ���Ǿ�� ���̺��� ��ȸ�� �� �ִ� ���� �ο�
SELECT *
FROM java.empl;

-- public synonim dba ������ �־����.
CREATE OR REPLACE PUBLIC SYNONYM empl2 FOR java.employees; -- system �������� ����
SELECT *
FROM empl2; -- � ���������� ��ȸ����(public �̱� ����)
            -- �� ���������� �ش� ���̺��� ��� ������ �ִ��� �� �� ����. (����)
            
--dba ���� public synonym ���� ����
DROP PUBLIC SYNONYM empl2;

/* ������ SEQUENCE 348p : ��Ģ�� ���� �ڵ� ������ ��ȯ�ϴ� ��ü
   ������ : pk �� ����� �����Ͱ� ������� �������� ���� ���
        ex ) �Խ����� �Խñ� ��ȣ ( 1�� �����Ͽ� ~~ 999 ����)
    ��������.CURRVAL -- ���� ������ ��
    ��������.NEXTVAL -- ���� ������ ��
*/
DROP SEQUENCE my_seq1;
CREATE SEQUENCE my_seq1
INCREMENT BY 1 -- ��������
START WITH 1   -- ���ۼ���
MINVALUE 1     -- �ּҰ�
MAXVALUE 999999    -- �ִ�  
NOCYCLE        --�ִ볪 �ּҰ��� �����ϸ� ���� ���� ����Ʈ(nocycle)
NOCACHE ;      -- �޸𸮿� ������ ���� �̸� �Ҵ����� ���� ����Ʈ (nocache)
--          my_seq1.NEXTVAL
SELECT my_seq1.CURRVAL
FROM dual;

CREATE TABLE temp_tb(
    seq NUMBER
    ,dt TIMESTAMP DEFAULT SYSTIMESTAMP
);
INSERT INTO temp_tb(seq) VALUES(my_seq1.NEXTVAL);
SELECT *
FROM temp_tb;
drop table temp_tb;
SELECT nvl(MAX(seq),0)+1
FROM temp_tb;

INSERT INTO temp_tb(seq) VALUES((SELECT nvl(MAX(seq),0)+1
                                 FROM temp_tb));

SELECT TO_CHAR(SYSDATE, 'YYYYMMDD')||LPAD(nvl(MAX(seq),0)+1, 4, '0') -- �ߺ����� �ʴ� ���� �ֱ����� �̷������� ���� �־���.
FROM temp_tb;


/* MERGE�� oracle 10g ���� ��밡��
   Ư�� ���ǿ� ���� INSERT or UPDATE DELETE ���� 
*/
-- �������ǰǰ� ������ �ִٸ� ������ 3����
--                   ���ٸ� ����
SELECT *
FROM ����;
INSERT INTO ���� (�����ȣ, �����̸�, ����) VALUES(509,'�������ǰǰ�',2); -- �ߺ��̶� ����.
MERGE INTO ���� a
USING dual              -- �񱳴�� ���̺� (dual�� into ���̺�� ������)
ON(a.�����̸� = '�������ǰǰ�')
WHEN MATCHED THEN       -- on�� ������ �����Ҷ�
    UPDATE SET a.���� = 3  
WHEN NOT MATCHED THEN  -- on�� ������ �������� ������
    INSERT (a.�����ȣ, a.�����̸�, a.����) -- matched�� notmatched�� �ϳ��� ���� ��.
    VALUES (509, '�������ǰǰ�', 2);
    
        
/* SELECT �� ��Ȯ and �ӵ�*/        
SELECT a.employee_id
      ,(SELECT emp_name
        FROM employees
        WHERE employee_id = a.employee_id)
      ,a.cust_id
      ,(SELECT cust_name
        FROM customers
        WHERE cust_id = a.cust_id)      
FROM sales a
GROUP BY a.cust_id, a.employee_id;

-- 2000�⵵ �Ǹſ��� ����Ͻÿ�
-- employees, sales ���̺� ��� �Ǹűݾ� (amount_sold) �Ǹż��� (quantity_sold)
SELECT *
FROM employees;
SELECT *
FROM sales;

SELECT �̸�
    ,  ���
    ,  �Ǹűݾ�
    ,  �Ǹż���
FROM(    
SELECT ROWNUM rnum 
    ,  a.*
FROM(    
SELECT e.emp_name as �̸�
    ,  e.employee_id as ���
    ,  SUM(s.amount_sold) as �Ǹűݾ�
    ,  count(s.quantity_sold) as �Ǹż���
FROM employees e, sales s
WHERE e.employee_id = s.employee_id
AND TO_CHAR(s.sales_date, 'YYYY') = 2000
GROUP BY e.emp_name, e.employee_id
ORDER BY 3 desc) a
)
where rnum = 1;

SELECT e.emp_name 
    ,sum(s.amount_sold) as �Ǹűݾ�
    ,count(s.quantity_sold) as �Ǹż���
FROM employees e, sales s
WHERE e.employee_id = s.employee_id
AND TO_CHAR(s.sales_date, 'YYYY') = 2000
GROUP BY e.emp_name
HAVING sum(s.amount_sold) > (SELECT sum(s.amount_sold)
                            FROM employees e, sales s
                            WHERE e.employee_id = s.employee_id
                            AND TO_CHAR(s.sales_date, 'YYYY') = 2000 
                            GROUP BY e.emp_name                       
                            )
;

SELECT sum(count(s.quantity_sold) * s.amount_sold)
    ,  SUM(s.amount_sold) as �Ǹűݾ�
    ,  SUM(s.quantity_sold) as �Ǹż���
FROM employees e, sales s
WHERE e.employee_id = s.employee_id
AND TO_CHAR(s.sales_date, 'YYYY') = 2000;