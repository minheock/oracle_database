-- �� ���踸
-- ���谪�� ���Ҷ� ���� �׷����� ���, �̶� �׷�������� �ο�ս� �߻�.
SELECT count(*)
FROM �л� a;

-- �м��Լ�
-- �ο� �սǾ��� ���� ����Ҽ� �ִ� ����.
SELECT a.*
    ,  count(*) over() as ��ü�Ǽ� -- over�� ���� ���谡 �м��Լ��� �Ѿ
FROM �л� a;

--��Į�� ��������
SELECT a.*
    , (SELECT COUNT(*) FROM �л�) AS ��ü�Ǽ�
FROM �л� a;    

SELECT emp_name
    ,  department_id 
    ,  rownum  -- ��ü�� ���ؼ�.
--                       ������ ����       
    ,  ROW_NUMBER() OVER(PARTITION BY department_id ORDER BY emp_name) as dep_row -- �м��Լ��� ���� Ư�� �׷캰���� �ο���� �ű���ִ�.
    ,  ROW_NUMBER() OVER(PARTITION BY department_id, job_id ORDER BY emp_name) as depjob
    ,  job_id
    ,  ROW_NUMBER() OVER(PARTITION BY job_id ORDER BY emp_name) as job_row
FROM employees;


-- RANK(), DENSE_RANK()  
-- ���ϸ����� �����ֵ��� ��ŷ�� �ű�� ������ �������̸� �Ⱦ��� �����ű���ִ�.
SELECT mem_id
    ,  mem_name
    ,  mem_job
    ,  mem_mileage
    ,  RANK() OVER(PARTITION BY mem_job ORDER BY mem_mileage desc) as mem_rank
    ,  DENSE_RANK() OVER(PARTITION BY mem_job ORDER BY mem_mileage desc) as mem_dense_rank
FROM member;

SELECT emp_name
    ,  salary
    ,  department_id
    ,  RANK() OVER(PARTITION BY department_id ORDER BY salary desc) as rnak
    ,  DENSE_RANK() OVER(PARTITION BY department_id ORDER BY salary desc) as dense_rnak
FROM employees;    

-- �μ��� salary�� ���� ū ������ ����Ͻÿ�
SELECT * FROM(
SELECT emp_name
    ,  salary
    ,  nvl(a.department_id, 0)
    ,  RANK() OVER(PARTITION BY a.department_id ORDER BY salary desc) as rnak 
    -- rank() -> ������ �ɱ����ؼ� �ѹ��� ���������.
FROM employees a
)
WHERE rnak = 1; 
