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

/* 집계 함수 대상 데이터를 특정 그룹으로 묶은 다음 그룹에 대한
    총합, 평균, 최댓값, 최솟값 등을 구하는 함수.
    COUNT(expr) 로우 수를 반환하는 집계함수.
*/ 
SELECT COUNT(*)                    --null 포함
    ,COUNT(department_id)          -- default ALL
    ,COUNT(ALL department_id)      --중복 포함 null X
    ,COUNT(DISTINCT department_id) --중복 제거
    ,COUNT(employee_id)
    --, employee_id  <-- 이건 오류남 같은 그룹바이가 아니라서.
    FROM employees;
    
SELECT department_id 
      ,SUM(salary)            --합계
      ,ROUND(AVG(salary),2)   --평균
      ,MAX(salary)            --최대
      ,MIN(salary)            --최소
FROM employees
GROUP BY department_id        --부서별로 나열되게.
ORDER BY 1;        
    
--50번 부서의 최대, 최소 급여를 출력하시오
SELECT MAX(salary)
    ,  MIN(salary)
FROM employees
WHERE department_id = 50;


 --Q. member 테이블을 활용하여
 --회원의 직업별 회원수를 출력하시오
 --정렬(회원수 내림차순)
 
SELECT *
FROM member;
 
SELECT DISTINCT mem_job as 직업
  ,COUNT(mem_id) as 회원수
FROM member
GROUP BY mem_job
ORDER BY 2 desc; 

-- 2013년도 기간별 총 대출잔액
select *
from kor_loan_status;


SELECT period
    ,  SUM(loan_jan_amt) as 총잔액
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY period
ORDER BY 1;
-- 2013년도 지역별 총 대출잔액
DESC kor_loan_status;

SELECT DISTINCT region as 지역
    ,  SUM(loan_jan_amt) as 총잔액
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY region
ORDER BY 1;

-- 2013년도 지역별, 대출 종류별 총 대출잔액    
-- SELECT 절에 오는 컬럼은 집계 함수를 제외하고
-- GROUB by 절에 반드시 포함되어야함. 안그러면 오류남.
-- 하지만 SELECT 절에 존재하지 않더라도 group by로 묶으면 오류는 안남.
SELECT DISTINCT region as 지역
    ,  gubun
    ,  SUM(loan_jan_amt) as 총잔액
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY region, gubun
ORDER BY 1;


--년도별 대출의 총 합계
SELECT SUBSTR(period, 1,4) as 년도
    , region as 지역
    , SUM(loan_jan_amt) as 총잔액
FROM kor_loan_status
GROUP BY SUBSTR(period, 1,4), region
ORDER BY 1;

-- employees 직원들의 고용 년도별 직원수 출력.
select *
from employees;

-- 틀리게 한 내가짠 쿼리.
-- substr 보단 desc로 타입확인하고 to_char 썼어야 했음.
SELECT SUBSTR(hire_date,1,2) as 입사년도
     ,COUNT(employee_id) as 회원수
FROM employees
GROUP BY SUBSTR(hire_date,1,2)
ORDER BY 1;

-- 맞게 한 쿼리.
-- 그룹핑 대상의 데이터에 대해 검색조건을 쓰려면
-- HAVING 사용
-- 입사직원이 10명 이상인 년도와 직원수
-- **** select 문 실행순서
-- from -> where -> group by -> habing -> select -> order by
SELECT TO_CHAR(hire_date, 'YYYY') as 입사년도
     ,COUNT(employee_id) as 회원수
FROM employees
GROUP BY TO_CHAR(hire_date, 'YYYY')
HAVING COUNT(employee_id) >= 10
ORDER BY 1;

-- member 테이블 활용하여
-- 직업별 마일리지 평균금액을 구하시오 
--(소수점 둘째 자리까지 반올림 하여 출력)
-- (1) 정렬 평균 마일리지 내림차순
-- (2) 평균 마일리지가 3000이상인 데이터만 출력
select *
from member;

SELECT mem_job
,ROUND(AVG(mem_mileage),2) as 평균
FROM member
GROUP BY mem_job
HAVING AVG(mem_mileage) >= 3000
ORDER BY 2 DESC;
-------------------------------------------------

-- Q. 직업별 마일리지 합계 마일리지 전체합계를 출력하시오
SELECT NVL(mem_job, '합계') as 직업
     , COUNT(mem_id) as 회원수
     , SUM(mem_mileage) as 합계
FROM member
GROUP BY ROLLUP(mem_job); -- 롤업 말아올린다 라는 뜻으로 
                          -- 집계결과의 합을 출력함.   
                          
-- Q. products 상품 테이블의 / 카테고리를 찾자. 카테고리별 / 상품을 카운트하자. 상품수와 / 롤업쓰자. 전체 상품 수를 출력하시오

select *
from products;

SELECT NVL(prod_category, '합 계')
    ,  prod_subcategory as 서브카테고리
    ,  COUNT(prod_name)
FROM products
GROUP BY ROLLUP(prod_category, prod_subcategory);
--HAVING COUNT(prod_name) >= 10
--ORDER BY 2;


SELECT SUBSTR(period, 1,4) as 년도
    , region as 지역
    , SUM(loan_jan_amt) as 총잔액
FROM kor_loan_status
GROUP BY ROLLUP(SUBSTR(period, 1,4), region)
ORDER BY 1;

SELECT *
FROM customers;

-- 년도별 회원수를 출력하시오 단 (남, 녀 구분하여서)
-- DECODE(cust_gender, 'M', 'M') as 남성
--    ,  DECODE(cust_gender, 'F', 'F') as 여성

-- 내가 짠 코드
SELECT cust_year_of_birth as 생일년도
    , COUNT(DECODE(cust_gender, 'M', 'M')) as 남성
    , COUNT(DECODE(cust_gender, 'F', 'F')) as 여성
    , COUNT(cust_gender) as 전체
FROM customers
GROUP BY ROLLUP(cust_year_of_birth)
ORDER BY 1;

-- 레퍼런스 코드
SELECT cust_year_of_birth as 생일년도
    , SUM(DECODE(cust_gender, 'M',1 ,0)) as 남성
    , SUM(DECODE(cust_gender, 'F',1 ,0)) as 여성
    , COUNT(cust_gender) as 전체
FROM customers
GROUP BY ROLLUP(cust_year_of_birth)
ORDER BY 1;


-- 지역과 각 연도별 대출 총 잔액을 구하는 쿼리를 작성해 보자.(KOR LOAN STATU)
-- 2013년도 지역별 총 대출잔액
DESC kor_loan_status;
SELECT *
FROM kor_loan_status;

SELECT region as 지역
--      ,DECODE(period,'2011%',period) as amt_2011
      ,SUM(CASE WHEN SUBSTR(period, 1,4)='2011' THEN loan_jan_amt 
       END) AS AMT_2011
      ,SUM(DECODE(SUBSTR(period, 1,4),'2012', loan_jan_amt)) as amt_2012
--      ,SUM(DECODE(period,'2013%', loan_jan_amt)) as amt_2013 -- LIKE는 조건절에서만
      ,SUM(DECODE(SUBSTR(period, 1,4),'2013', loan_jan_amt)) as amt_2013
FROM kor_loan_status
GROUP BY ROLLUP(region);

--SELECT DECODE(period LIKE '2013%','2013', loan_jan_amt)
FROM kor_loan_status;
SELECT DISTINCT region as 지역
    ,  SUM(loan_jan_amt) as 총잔액
FROM kor_loan_status
WHERE period LIKE '2011%'
GROUP BY region
ORDER BY 1;