SELECT department_id
      -- level ���󿭷μ� Ʈ�������� � �ܰ����� ��Ÿ���� ������
      ,LPAD(' ', 3 * (level-1)) || department_name as �μ���
      ,parent_id
      ,level
FROM departments
START WITH parent_id IS NULL                    -- ����
CONNECT BY PRIOR department_id = parent_id;     -- ������ ��� ��������(����) ���������� ������ ����. 
                                                -- department id �� 30�̸� parent id�� 30�� �ֵ��� ������ ����
                                                

-- department ���̺� 230 IT ��������ũ ���� �μ���
--                       IT �������� INSERT INTO�� �־�� 
--                   280 IT �������� �������ּ���
select * from departments;
SELECT MAX(department_id) + 10
FROM departments;
INSERT INTO departments(department_id, department_name, parent_id) VALUES(280, 'IT ������', 230);


/* ������ �������� ������ �Ϸ��� SIBLINGS BY �� �߰��ؾ���.*/
SELECT department_id
      ,LPAD(' ', 3 * (level-1)) || department_name as �μ���
      ,parent_id
      ,level
FROM departments
START WITH parent_id IS NULL
CONNECT BY PRIOR department_id = parent_id
--ORDER BY �μ���;   -- �̷��� �ϸ� ������ ����
-- SIBLINGS ���ÿ��� ���� �÷����θ� ���İ���
ORDER SIBLINGS BY department_name;             



SELECT department_id
      -- level ���󿭷μ� Ʈ�������� � �ܰ����� ��Ÿ���� ������
      ,LPAD(' ', 3 * (level-1)) || department_name as �μ���
      ,parent_id
      ,level
      ,CONNECT_BY_ISLEAF -- ������ ���� 1, �ڽ��� ������ 0
      ,SYS_CONNECT_BY_PATH(department_name, '>') -- ��Ʈ ��忡�� �ڽ������ ��������
      ,CONNECT_BY_ISCYCLE -- ���ѷ����� ������ ã���� 
      --(�ڽ��� �ִµ� �� �ڽ� �ο찡 �θ��̸� 1, �ƴϸ� 0)
      -- �ؿ� ���� NOCYCLE �Ⱦ��� ������.
FROM departments
START WITH parent_id IS NULL                    
CONNECT BY NOCYCLE PRIOR department_id = parent_id;


-- ���� ���� �ɸ����� ����
UPDATE departments
SET parent_id = 10
WHERE department_id = 30;


-- �������� �������踦 ����Ͻÿ�(����, ������, �̸�, ��������)
SELECT employee_id
    ,  LPAD(' ', 3 * (level-1)) || emp_name as �μ���
    ,  SYS_CONNECT_BY_PATH(emp_name, '>') as ��������
FROM employees
START WITH manager_id IS NULL
CONNECT BY PRIOR employee_id = manager_id
ORDER SIBLINGS BY emp_name;

CREATE TABLE ȸ�� (
       ���̵� NUMBER(10),
       �̸�   VARCHAR2(10),
       ��å   VARCHAR2(80),
       �������̵� NUMBER(10));
DROP TABLE ȸ��;       
INSERT INTO ȸ��(���̵�, �̸�, ��å, �������̵�) VALUES(1,'�̻���', '����', null);
INSERT INTO ȸ��(���̵�, �̸�, ��å, �������̵�) VALUES(2,'�����', '����', 1);
INSERT INTO ȸ��(���̵�, �̸�, ��å, �������̵�) VALUES(3,'������', '����', 2);
INSERT INTO ȸ��(���̵�, �̸�, ��å, �������̵�) VALUES(4,'�����', '����', 3);
INSERT INTO ȸ��(���̵�, �̸�, ��å, �������̵�) VALUES(5,'�̴븮', '�븮', 4);
INSERT INTO ȸ��(���̵�, �̸�, ��å, �������̵�) VALUES(6,'�ֻ��', '���', 5);
INSERT INTO ȸ��(���̵�, �̸�, ��å, �������̵�) VALUES(7,'�����', '���', 5);
INSERT INTO ȸ��(���̵�, �̸�, ��å, �������̵�) VALUES(8,'�ڰ���', '����', 3);
INSERT INTO ȸ��(���̵�, �̸�, ��å, �������̵�) VALUES(9,'��븮', '�븮', 8);
INSERT INTO ȸ��(���̵�, �̸�, ��å, �������̵�) VALUES(10,'�ֻ��', '���', 9);

DESC ȸ��;       
SELECT * FROM ȸ��;
SELECT �̸�
    ,  LPAD(' ', 3 * (level-1)) || ��å as ��å
    ,  level
    ,  �������̵�
FROM ȸ��
START WITH �������̵� IS NULL
CONNECT BY PRIOR ���̵� = �������̵�
;

SELECT period
    ,  sum(loan_jan_amt) as �����հ�
FROM kor_loan_status
WHERE substr(period, 1, 4) = 2013
GROUP BY period;

/* level �� ���� - ���μ� (connect by ���� �Բ� ���)
   ������ �����Ͱ� �ʿ��Ҷ� ���� ���.
*/
-- 2013�� 1~12 �� ������
SELECT '2013'|| LPAD(LEVEL, 2, '0') as ���
FROM dual
CONNECT BY LEVEL <= 12;


-- �������� ���� ���� �����.
SELECT a.���
     , nvl(b.�����հ�, '0') as �����հ�
FROM   (SELECT '2013'|| LPAD(LEVEL, 2, '0') as ���
        FROM dual
        CONNECT BY LEVEL <= 12
        ) a
        --
     , (SELECT period as ���
     ,  sum(loan_jan_amt) as �����հ�
        FROM kor_loan_status
        WHERE substr(period, 1, 4) = 2013
        GROUP BY period
        ) b
WHERE a.��� = b.���(+);    

-- 202301 ~ 202312
SELECT '2023'|| LPAD(LEVEL, 2, '0') as ���
FROM dual
CONNECT BY LEVEL <= 12;
--
select TO_CHAR(SYSDATE, 'YYYY')||LPAD(LEVEL, 2, '0') as ����
from dual
CONNECT BY LEVEL <= 12;

-- �̹��� 1�� ���� ������������ ���
-- (�� �ش� select ���� �����޿� ����� �ش���� ������������ ��µǵ���)
-- 20230801
-- 20230802
-- 20230803
-- 20230801
-- ...
-- 20230831
SELECT TO_CHAR(SYSDATE, 'YYYYMM')||LPAD(LEVEL, 2, '0') as �ȿ�  
FROM dual
CONNECT BY LEVEL <= SUBSTR(LAST_DAY(SYSDATE), 7,8);

-- member ȸ���� ���� (mem_bir) �� ���� ȸ������ ����Ͻÿ� (��� ���� ��������)
-- a.��||'��' , ȸ����

select * from member;
-- �׳�Ǯ��
SELECT DISTINCT nvl(a.����_��||'��','�հ�') as ����_��
    ,  COUNT( b.����) as ȸ����
FROM   (SELECT LPAD(LEVEL, 2, '0') as ����_��
        FROM dual
        CONNECT BY LEVEL <= 12
        ) a
        ,
        (SELECT substr(substr(mem_bir, 4),1, 2) as ����
        FROM member
        ) b
        WHERE a.����_�� = b.����(+)
        GROUP BY ROLLUP(a.����_��||'��', b.����)
        ORDER BY 1;
        
-- ���Ͽ����� Ǯ��
SELECT * FROM(
SELECT a.����_��||'��' as ����_��
    ,  nvl(b.ȸ����, '0') as ȸ����
FROM   (SELECT LPAD(LEVEL, 2, '0') as ����_��
        FROM dual
        CONNECT BY LEVEL <= 12
        ) a
        ,
        (SELECT TO_CHAR(mem_bir, 'MM') as ����
        ,COUNT(substr(substr(mem_bir, 4),1, 2)) as ȸ����
        FROM member
        GROUP BY TO_CHAR(mem_bir, 'MM')
        order by 1
        ) b
WHERE a.����_�� = b.����(+)
UNION
SELECT  '�հ�' as ����_��
      , COUNT(TO_CHAR(mem_bir, 'MM'))as ȸ����
        FROM member
        order by 1
);
        
        
        
        
SELECT  '�հ�' as ����_��
     ,  count(substr(substr(mem_bir, 4),1, 2))as ȸ����
        FROM member
        order by 1;
        
SELECT  nvl(TO_CHAR(mem_bir, 'MM')||'��','�հ�') as ����_��
        ,COUNT(substr(substr(mem_bir, 4),1, 2)) as ȸ����
        FROM member
        GROUP BY ROLLUP(TO_CHAR(mem_bir, 'MM')||'��')
        order by 1;        
              