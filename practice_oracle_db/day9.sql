--ANSI OUTER JOIN
SELECT a.mem_id
      ,a.mem_name
      ,COUNT(DISTINCT b.cart_no) as īƮ���Ƚ��
      ,COUNT(c.prod_id) as ǰ���
FROM member a
LEFT OUTER JOIN cart b
ON(a.mem_id = b.cart_member)
LEFT OUTER JOIN prod c
ON(b.cart_prod = c.prod_id)
GROUP BY a.mem_id, a.mem_name;

-- ���� ������ UNION ------------------------------------------------------------------------

CREATE TABLE exp_goods_asia (
       country VARCHAR2(10),
       seq     NUMBER,
       goods   VARCHAR2(80));

INSERT INTO exp_goods_asia VALUES ('�ѱ�', 1, '�������� ������');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 2, '�ڵ���');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 3, '��������ȸ��');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 4, '����');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 5,  'LCD');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 6,  '�ڵ�����ǰ');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 7,  '�޴���ȭ');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 8,  'ȯ��źȭ����');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 9,  '�����۽ű� ���÷��� �μ�ǰ');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 10,  'ö �Ǵ� ���ձݰ�');

INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 1, '�ڵ���');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 2, '�ڵ�����ǰ');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 3, '��������ȸ��');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 4, '����');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 5, '�ݵ�ü������');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 6, 'ȭ����');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 7, '�������� ������');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 8, '�Ǽ����');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 9, '���̿���, Ʈ��������');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 10, '����');

COMMIT;

----------------------------------------------------------
----------------------------------------------------------
select * from exp_goods_asia;


SELECT seq, goods
FROM exp_goods_asia
WHERE country = '�ѱ�'
UNION -- �ܼ� ���Ͽ��� �ߺ��� ������. �ߺ��� 5���� ���ϰ� 15�� ���.
SELECT seq, goods
FROM exp_goods_asia
WHERE country = '�Ϻ�'
UNION
SELECT 10, '��ǻ��'
FROM dual;
----------------------------------------------------------
----------------------------------------------------------

SELECT goods
FROM exp_goods_asia
WHERE country = '�ѱ�'
UNION ALL -- ��°���� ���� ����. �ߺ����� ����.
SELECT goods
FROM exp_goods_asia
WHERE country = '�Ϻ�' ;

----------------------------------------------------------
----------------------------------------------------------

SELECT goods
FROM exp_goods_asia
WHERE country = '�ѱ�'
INTERSECT -- �������� ����ִ� ���� ����(������)
SELECT goods
FROM exp_goods_asia
WHERE country = '�Ϻ�' ;


----------------------------------------------------------
----------------------------------------------------------

SELECT goods
FROM exp_goods_asia
WHERE country = '�ѱ�'
MINUS -- ������
SELECT goods
FROM exp_goods_asia
WHERE country = '�Ϻ�' ;
DESC exp_goods_asia;
----------------------------------------------------------
----------------------------------------------------------
SELECT TO_CHAR(department_id) as �μ�
     , COUNT(*) �μ���������
FROM employees     
GROUP BY department_id
UNION
SELECT '��ü'
     , COUNT(*) as ��ü����
FROM employees;   

-- EXISTS �����ϴ��� ���ϴ���
-- ���� �����̶�� ��.


-- job_history ���̺� �����ϴ� �μ� ���
SELECT a.department_id
    ,  a.department_name
FROM departments a    
WHERE EXISTS (SELECT *  --select �� �ǹ̾��� where �� ���뿡 �ش�Ǵ�
                        --�����Ͱ� �����ϴ����� üũ
              FROM job_history b
              WHERE a.department_id = b.department_id);
              
-- job_history ���̺� �������� �ʴ� �μ� ���
SELECT a.department_id
    ,  a.department_name
FROM departments a    
WHERE NOT EXISTS (SELECT *  -- NOT�� �տ� ���̸��.                        
              FROM job_history b
              WHERE a.department_id = b.department_id);              


--���������� ���� �л� ��ȸ
SELECT * FROM �л� a
WHERE NOT EXISTS(SELECT *
                 FROM �������� b
                 WHERE b.�й� = a.�й�);
                 

/*
    ���� ǥ���� '�˻�', 'ġȯ' �ϴ� ������ �����ϰ� ó���� �� �ֵ��� �ϴ� ����.
    oracle �� 10g���� ���
    (JAVA, Python, JS �� ���� ǥ���� ��밡��) ���ݾ� �ٸ�
    .(dot) or [] �� ��� ���� 1���ڸ� �ǹ���
    '^' <- ������ �ǹ��� '^[0-9]' <- ���ڷ� �����ϴ�
    '[^0-9]' <- ���ȣ ���� '^' <- NOT�� �ǹ���.
    
    REGEXP_LIKE : ���Խ� ������ �˻�
*/                 

/*
    �ݺ� ����
    * : 0�� �̻�
    + : 1�� �̻�
    ? : 0, 1��
    {n} : n��
    {n,} : n�� �̻�
    {n,m} : n�� �̻� m�� ����
*/
SELECT *
FROM member
WHERE REGEXP_LIKE(mem_comtel, '^..-');

-- ������ 3�� ���� @ ���� ��ȸ (abc@gmail.com)
SELECT *
FROM member
WHERE REGEXP_LIKE(mem_mail, '^[a-zA-Z]{3,6}@');   

-- mem_add2 ���� ���� ���� ������ �����͸� ����Ͻÿ�
SELECT mem_name
    ,  mem_add2
FROM member
--WHERE REGEXP_LIKE(mem_add2,'. '); -- ������ڵ� ������
--WHERE REGEXP_LIKE(mem_add2,'[��-�R] [0-9]'); -- �ѱ�
--WHERE REGEXP_LIKE(mem_add2,'[��-�R]$'); -- �ѱ۷γ�����  
                                       --$ -> ������
--WHERE REGEXP_LIKE(mem_add2,'^[^��-�R]*$'); --�ѱ��̾���
WHERE not REGEXP_LIKE(mem_add2,'[��-�R]'); --�ѱ��̾���
/*
    | <- �Ǵ�
    () <- ���ϱ׷�
    J�� �����ϸ�, ����° ���ڰ� M�Ǵ� N�� �����̸� ��ȸ
*/
SELECT emp_name
FROM employees
WHERE REGEXP_LIKE(emp_name, '^J.(n|m)');

-- REGEXP_SUBSTR ����ǥ���� ������ ��ġ�ϴ� ���ڿ� ��ȯ
-- �̸��� @�� �������� �հ� �ڸ� ����Ͻÿ�
                          --����, ������ġ, ��Ī����
SELECT REGEXP_SUBSTR(mem_mail, '[^@]+',1,1) as mem_id
      ,REGEXP_SUBSTR(mem_mail, '[^@]+', 1, 2) as mem_domain
FROM member;      

SELECT REGEXP_SUBSTR('A-B-C', '[^-]+', 1,1) as a
    ,  REGEXP_SUBSTR('A-B-C', '[^-]+', 1,2) as b
    ,  REGEXP_SUBSTR('A-B-C', '[^-]+', 1,3) as c
FROM dual;    

SELECT REGEXP_SUBSTR('pang su hi 1234', '[0-9]')    --default 1,1
    ,  REGEXP_SUBSTR('pang su hi 1234', '[^0-9]')
    ,  REGEXP_SUBSTR('pang su hi 1234', '[^0-9]+')
FROM dual;    

-- ���⸦ �������� 2��° �����ϴ� �ּҸ� ����Ͻÿ�.
SELECT mem_add1
FROM member;
SELECT REGEXP_SUBSTR(mem_add1,'[^ ]+', 1,2)
FROM member;
-- ���Ⱑ �ѱ��� �ƴϴϱ� �ѱ��� 2��°�� ��°���
SELECT REGEXP_SUBSTR(mem_add1,'[��-�R]+', 1,2)
FROM member;

SELECT * 
FROM(
SELECT 'abcd1234' as id FROM dual
UNION
SELECT 'Abcd123456' as id FROM dual
UNION
SELECT 'A1234' as id FROM dual
UNION
SELECT 'A12345678964646545' as id FROM dual
)
WHERE REGEXP_LIKE(id, '^[a-zA-Z1-9]{8,14}$') -- 8 ~ 14 ���� �ؽ�Ʈ �����ϴ� ���������.
;