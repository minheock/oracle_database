SELECT * 
FROM employees;


SELECT * 
FROM departments;

-- inner join �������� (���� �����̶�� ��)
-- �� �÷��� ������ ���� ������ ����
SELECT employees.emp_name
    , departments.department_name
FROM employees, departments
WHERE employees.department_id = departments.department_id;


-- ���̺� ��Ī

SELECT a.emp_name                -- ��� ���ʿ��� �ִ� �÷��� ��Ī �Ƚᵵ��
    , b.department_name
    , a.department_id            -- ������ �÷����� �������� ��� ������ ǥ���ؾ���
FROM employees a, departments b
WHERE a.department_id = b.department_id;

SELECT *
FROM member;
SELECT *
FROM cart;
-- member �����뾾�� īƮ(�����̷�) �̷��� ����Ͻÿ�
SELECT mem_name
    ,  cart_no
    ,  cart_prod
    ,  cart_qty
FROM member a, cart b
WHERE a.mem_id = b.cart_member
AND a.mem_name = '������';

-- ANSI JOIN : American National Standards Institute 
-- �̱� ǥ�� SQL ��������(������ �� �ǹ����� �� �Ⱦ�)
SELECT mem_name
    ,  cart_no
    ,  cart_prod
    ,  cart_qty
FROM member a
INNER JOIN cart b
ON(a.mem_id = b.cart_member)
WHERE a.mem_name = '������';

--��ǰ ���� ���
SELECT * FROM prod;
SELECT mem_name
    ,  cart_no
    ,  cart_prod
    ,  cart_qty
    ,  c.prod_name
    ,  c.prod_sale
FROM member a, cart b, prod c
WHERE a.mem_id = b.cart_member
AND b.cart_prod = c.prod_id
AND a.mem_name = '������';
-- ������ ���� ������ ��ü ��ǰ�� �հ� �ݾ���?
SELECT mem_name
    ,  cart_no
    ,  cart_prod
    ,  cart_qty
    ,  c.prod_name
    ,  c.prod_sale
    ,  (cart_qty * prod_sale) as �հ�
FROM member a, cart b, prod c
WHERE a.mem_id = b.cart_member
AND b.cart_prod = c.prod_id
AND a.mem_name = '������';

SELECT mem_name
      ,mem_id
      ,SUM(cart_qty * prod_sale) as �հ�ݾ�
FROM member a,cart b,prod c
WHERE  a.mem_id = b.cart_member
AND b.cart_prod = c.prod_id
AND a.mem_name = '������'
GROUP BY mem_name, mem_id;

--ANSI
SELECT mem_name
      ,mem_id
      ,SUM(cart_qty * prod_sale) as �հ�ݾ�
FROM member 
INNER JOIN cart
ON(member.mem_id = cart.cart_member)
INNER JOIN prod
ON(cart.cart_prod = prod.prod_id)
WHERE member.mem_name = '������'
GROUP BY member.mem_name, member.mem_id;

-- employees, jobs ���̺��� Ȱ���Ͽ�
-- salary �� 15000 �̻��� ������ ���, �̸�, salary, ���� ���̵�, �������� ����Ͻÿ�
SELECT *
FROM employees;
SELECT *
FROM jobs;
SELECT employees.employee_id
    , employees.emp_name  
    , employees.salary    
    , employees.job_id    
    , jobs.job_title
FROM employees , jobs
WHERE employees.job_id = jobs.job_id
AND employees.salary >= 15000;


/* �������� (�����ȿ� ����)
    1. ��Į�� �������� (SELECT ��)
    2. �ζ��κ� (FROM ��)
    3. ��ø���� (WHERE ��)
*/
-- ��Į�� ���������� ������ ��ȯ 
-- 1:1 ����, as�� ������ �������.
-- ���� �ڵ尪�� �̸��� �����ö� ���� ���
-- ������ ���� ���� ���� ���̺��� �� �Ǽ� ��ŭ ���������� ��ȸ�ϱ� ������
-- ���������� ���̺��� �Ǽ��� ������ �ڿ��� ���� ����ϰ� ��. 
-- (���� ������� ������ �̿��ϴ°� �� ����)
SELECT a.emp_name
     , a.department_id
     , (SELECT department_name
        FROM departments
        WHERE department_id = a.department_id) as dep_name
     , a.job_id
     , (SELECT job_title
        FROM jobs
        WHERE job_id = a.job_id) as job_name
FROM employees a;     

SELECT a.emp_name
     , a.department_id
     , department_name as dep_name
FROM employees a, departments b
WHERE a.department_id = b.department_id ; 

-- ��ø ��������
-- ��ü ������ ���� ��պ��� ������ ū ������ ����Ͻÿ�
SELECT emp_name
     , salary
FROM employees
WHERE salary >= (SELECT AVG(salary)
                 FROM employees);     

SELECT emp_name
     , salary
FROM employees
WHERE salary >= 6461.831775700934579439252336448598130841;  


-- ���ÿ� 2�� �̻��� �÷� ���� ���� �� ��ȸ
SELECT employee_id
    ,  emp_name
    ,  job_id
FROM employees
WHERE (employee_id, job_id) IN (SELECT employee_id, job_id
                                FROM job_history);

SELECT *
FROM member;
-- cart ��� �̷��� ���� ȸ���� ��ȸ�Ͻÿ�
SELECT cart_member
FROM cart;

SELECT *
FROM member
WHERE mem_id NOT IN(SELECT cart_member
                    FROM cart);
SELECT *
FROM member
WHERE mem_id NOT IN('a001', 'b001');

--member �߿��� ��ü ȸ���� ���ϸ��� ��հ� �̻��� ȸ���� ��ȸ�Ͻÿ�
SELECT mem_name
      ,mem_job
      ,mem_mileage
FROM member
WHERE mem_mileage >= (SELECT AVG(mem_mileage)
                            FROM member)
ORDER BY mem_mileage DESC;     

-- �ּ��� �л��� �����̷��� �Ǽ���?
SELECT �̸�
     , �й�     
     , (SELECT COUNT(����������ȣ)
        FROM ��������)as ����Ƚ��
FROM �л�
WHERE �̸� = '�ּ���';
                    