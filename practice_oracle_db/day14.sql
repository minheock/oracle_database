-- 걍 집계만
-- 집계값을 구할때 보통 그룹쿼리 사용, 이때 그룹바이절로 로우손실 발생.
SELECT count(*)
FROM 학생 a;

-- 분석함수
-- 로우 손실없이 같이 출력할수 있는 장점.
SELECT a.*
    ,  count(*) over() as 전체건수 -- over를 쓰면 집계가 분석함수로 넘어감
FROM 학생 a;

--스칼라 서브쿼리
SELECT a.*
    , (SELECT COUNT(*) FROM 학생) AS 전체건수
FROM 학생 a;    

SELECT emp_name
    ,  department_id 
    ,  rownum  -- 전체에 대해서.
--                       구간을 구분       
    ,  ROW_NUMBER() OVER(PARTITION BY department_id ORDER BY emp_name) as dep_row -- 분석함수를 쓰면 특정 그룹별로의 로우넘을 매길수있다.
    ,  ROW_NUMBER() OVER(PARTITION BY department_id, job_id ORDER BY emp_name) as depjob
    ,  job_id
    ,  ROW_NUMBER() OVER(PARTITION BY job_id ORDER BY emp_name) as job_row
FROM employees;


-- RANK(), DENSE_RANK()  
-- 마일리지가 높은애들의 랭킹을 매기고 싶은데 오더바이를 안쓰고 순위매길수있다.
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

-- 부서별 salary가 가장 큰 직원만 출력하시오
SELECT * FROM(
SELECT emp_name
    ,  salary
    ,  nvl(a.department_id, 0)
    ,  RANK() OVER(PARTITION BY a.department_id ORDER BY salary desc) as rnak 
    -- rank() -> 조건을 걸기위해선 한번더 감싸줘야함.
FROM employees a
)
WHERE rnak = 1; 
