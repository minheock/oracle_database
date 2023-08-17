/* INNER JOIN ��������(��������)*/

SELECT * FROM �л�;
SELECT * FROM ��������;

SELECT �л�.�й�
      ,�л�.�̸�
      ,�л�.����
      ,��������.����������ȣ
      ,��������.�����ȣ
      ,����.�����̸�
FROM �л�,��������, ����
WHERE �л�.�й� = ��������.�й�
AND �л�.�̸� = '�ּ���'
AND ��������.�����ȣ = ����.�����ȣ;


-- �ּ����� ���� �� ������ ����Ͻÿ�
SELECT * FROM �л�;
SELECT * FROM ����;
SELECT * FROM ��������;
SELECT �л�.�й�
    ,  �л�.�̸�
    ,  �л�.����
    ,  SUM(����.����) as ������
FROM �л�, ����, ��������
WHERE �л�.�̸� = '�ּ���'
AND �л�.�й� = ��������.�й�
AND ����.�����ȣ = ��������.�����ȣ
GROUP BY �л�.�й�, �л�.�̸�, �л�.����;

/*
    OUTER JOIN �ܺ�����
    ��� ���ʿ� NULL ���� ���Խ��Ѿ� �Ҷ�
    (������ ������ ���̺��� ������ ���Խ��Ѿ��ϸ� �ƿ��� ������ ��.)
*/

SELECT �л�.�й�
    ,  �л�.�̸�    
FROM �л�, ��������
WHERE �л�.�й� = ��������.�й�
AND �л�.�̸� = '������';

SELECT �л�.�й�
    ,  �л�.�̸�    
FROM �л�, ��������               -- NULL �� ���Խ�ų ���̺� ��.
WHERE �л�.�й� = ��������.�й�(+)-- (+) <-- ���ʿ��� �� �� ����.
AND �л�.�̸� = '������';

-- �л��� �����̷� �Ǽ��� ����Ͻÿ�
-- ��� �л� ��� NULL �̸� 0����
SELECT * FROM �л�;
SELECT * FROM ����;
SELECT * FROM ��������;
--DISTINCT
SELECT DISTINCT �л�.�̸�
    ,  COUNT(��������.����������ȣ) as �����Ǽ�
    , NVL(SUM(����.����),0) as ������
FROM �л�, ��������, ����             
WHERE �л�.�й� = ��������.�й�(+)
AND ��������.�����ȣ = ����.�����ȣ(+)
GROUP BY ROLLUP(�л�.�й�, �л�.�̸�);


SELECT * FROM �л�;
SELECT * FROM ����;
SELECT * FROM ��������;
SELECT �л�.�й�
    ,  �л�.�̸�
    ,  �л�.����
    ,  ��������.����������ȣ
    ,  (SELECT �����̸�         -- ��Į�� ��������
        FROM ����
        WHERE �����ȣ = ��������.�����ȣ) as �����̸�
FROM �л�, ��������
WHERE �л�.�̸� = '�ּ���'
AND �л�.�й� = ��������.�й�;

/*�л��� ������ �ο����� ����Ͻÿ�.*/
SELECT * FROM �л�;
SELECT * FROM ����;
SELECT * FROM ��������;
SELECT * FROM ���ǳ���;
SELECT �л�.����
     , COUNT(*) AS �л���
FROM �л�
GROUP BY ����;

/* �л��� ������� ���� ���� �л��� ����Ͻÿ�. */
SELECT �й�
      ,�̸�
      ,����
FROM �л�
WHERE �л�.���� > (SELECT AVG(����)
                  FROM �л�)          -- ��ø ���� ����
ORDER BY 3 desc;

-- ���������� ���� �л���?
SELECT DISTINCT �л�.�̸�
FROM �л�, ��������
WHERE �л�.�й� NOT IN(SELECT ��������.�й�
                        FROM ��������);

/*  �ζ��� �� (FROM ��)
    SELECT  ���� ���� ����� ���̺�ó�� ���
*/                        

SELECT ROWNUM as rnum
      ,�й�, �̸�, ����
FROM �л�                 -- �ӽ��÷��̾ Ư�������� ����.
WHERE ROWNUM <= 5;         -- ��) =1 �������� =2�� �ȵ�.


SELECT * 
FROM (SELECT ROWNUM as rnum
      ,�й�, �̸�, ����
    FROM �л�) a  -- select ���� ���̺�ó�� ���
WHERE a.rnum BETWEEN 2 AND 5; 


SELECT *                -- �������ֱ����� rownum�� from ���� �����.             
FROM(                   -- 10�Ǿ� �ڸ�����. ����) �������� �Խ��� �̵� 10������.
SELECT ROWNUM as rnum   -- �̷��� ���°� ���� �ϳ��� ��.
      , a.*
      FROM(SELECT employee_id
         , emp_name
         , salary
         FROM employees
--         WHERE emp_name LIKE 'K%'
         ORDER BY emp_name) a
         )
WHERE rnum BETWEEN 1 AND 10;


SELECT rownum as rnum
    , a.*
FROM employees a
ORDER BY emp_name; -- �̸��� �������� ������ �ٽ��ϱ� ������ �ο���� ����.


/* �л��߿� ���� ���� 5�� ����Ͻÿ�*/
SELECT * 
FROM(
SELECT ROWNUM as rnum
    ,a.*
FROM (SELECT �л�.�̸�
            ,�л�.����
            ,ROUND(�л�.����, 1) as ��������
             FROM �л�
             WHERE �л�.���� > (SELECT AVG(����)
                               FROM �л�) 
             ORDER BY 3 desc) a
)
WHERE rnum <= 5;

--member,cart,prod �� ����Ͽ�
-- ���� īƮ ��� Ƚ��, ��ǰ��ϰǼ�, ��ǰ���ż���, �ѱ��űݾ��� ����Ͻÿ�
-- �����̷��� ���ٸ� 0 <-- ���� ��µǵ���
-- �ƿ��� ����, ���� * ������
select * from member;
select * from cart;
select * from prod;
select * from lprod;






-- ���� ��� ������� ���ջ�ݾ��� ����̻��� ���ջ�ݾ��� ��� �ƴѰ͵��� 0���� ǥ�� 
-- �׸��� �� �ջ�ݾ��� �����ջ�ݾ��� ���.

SELECT m.mem_name
    , NVL(SUM(c.cart_qty),0) as ��ǰ���ż���
    , NVL(CASE WHEN SUM(p.prod_sale * c.cart_qty) > (SELECT ROUND(SUM(p.prod_sale * c.cart_qty)/
                                                     COUNT(DISTINCT m.mem_name), 0)
                                                     FROM member m, cart c, prod p
                                                     WHERE SUBSTR(m.mem_add1, 1, 2) = '����'
                                                     AND m.mem_id = c.cart_member(+)
                                                     AND c.cart_prod = p.prod_id(+))
           THEN SUM(p.prod_sale * c.cart_qty)
           END, 0) as �ջ�ݾ�
    ,  SUM( NVL(CASE WHEN SUM(p.prod_sale * c.cart_qty) > (SELECT ROUND(SUM(p.prod_sale * c.cart_qty)/
                                                     COUNT(DISTINCT m.mem_name), 0)
                                                     FROM member m, cart c, prod p
                                                     WHERE SUBSTR(m.mem_add1, 1, 2) = '����'
                                                     AND m.mem_id = c.cart_member(+)
                                                     AND c.cart_prod = p.prod_id(+))
           THEN SUM(p.prod_sale * c.cart_qty)
           END, 0)) OVER(ORDER BY m.mem_name) as �����ջ�ݾ�
FROM member m, cart c, prod p
WHERE SUBSTR(m.mem_add1, 1, 2) = '����'
AND m.mem_id = c.cart_member(+)
AND c.cart_prod = p.prod_id(+)
GROUP BY m.mem_name
ORDER BY 1;



SELECT ROUND(SUM(p.prod_sale * c.cart_qty)/COUNT(DISTINCT m.mem_name), 0)
FROM member m, cart c, prod p
WHERE SUBSTR(m.mem_add1, 1, 2) = '����'
AND m.mem_id = c.cart_member(+)
AND c.cart_prod = p.prod_id(+);


SELECT ROUND(SUM(p.prod_sale * c.cart_qty)/COUNT(DISTINCT m.mem_name), 0) as ��ձ����ջ�ݾ�
FROM member m, cart c, prod p
WHERE SUBSTR(m.mem_add1, 1, 2) = '����'
AND m.mem_id = c.cart_member(+)
AND c.cart_prod = p.prod_id(+);






SELECT * FROM(
SELECT ROWNUM as rnum
    ,a.*
FROM(
SELECT a.mem_id
    ,  a.mem_name
    ,  NVL(count(DISTINCT b.cart_no), 0) as īƮ���Ƚ��
    ,  NVL(count(c.prod_id),0)as ��ǰǰ��Ǽ�
    ,  NVL(sum(b.cart_qty),0) as ��ǰ���ż���
    ,  NVL(sum(c.prod_sale * b.cart_qty), 0) as �����ջ�ݾ�
FROM member a, cart b, prod c
WHERE a.mem_id = b.cart_member(+)
AND b.cart_prod = c.prod_id(+)
GROUP BY a.mem_id, a.mem_name
ORDER BY 6 desc) a
)
WHERE rnum <= 18;

