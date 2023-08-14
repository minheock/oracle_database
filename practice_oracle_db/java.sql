/*
 주석 영역
 table 테이블
 1. 테이블명 컬럼명의 최대 크기는 30 바이트
 2. 테이블명 컬럼명으로 예약어는 사용할 수 없다.
 3. 테이블명 컬럼명으로 문자, 숫자, _, $, # 을 
    사용 할 수 있지만 첫 글자는 문자만 올 수 있음.
 4. 한 테이블에 사용가능한 컬럼은 최대 255개 까지
*/

CREATE TABLE ex2_1(
    col1 CHAR(10)
    ,col2 VARCHAR2(10) --컬럼은, <--로 구분
--    하나의 컬럼에는 하나의 타입과 사이즈를 가짐
    );
    
-- INSERT 데이터 타입

INSERT INTO ex2_1(col1, col2)
VALUES('abc', 'abc');-- 문자열은 '' <-- 작은 따옴표로 표시

--SELECT 데이터 조회
SELECT col1
, LENGTH(col1)
, col2
, LENGTH(col2)
FROM ex2_1;

SELECT * --전체 컬럼을 의미함
FROM employees;
--특정 컬럼만 조회
SELECT emp_name
    ,email
FROM employees;

-- alias(별칭, 가명) as
SELECT emp_name as nm
    , hire_date hd               -- 별칭은 as를 붙이고 쓰지만 디폴트로 인식됨
    , salary 봉급                 -- 한글도 사용 가능하지만 영문 지향
    , department_id "부서 아이디"  -- 띄어쓰기를 포함하려면 "" <- 사용
FROM employees;                  --띄어쓰기는 안쓰는게 좋음 _ 언더바 사용
-- 검색 조건이 있다면 where절 사용
SELECT emp_name
    ,salary
    ,department_id
FROM employees
WHERE salary >= 12000 --salary 가 12000이상
AND department_id = 90;
-- 정렬 조건 ORDER BY default [ASC 오름차순], 내림차순으로 정렬은 DESC
SELECT *
FROM departments
ORDER BY department_id; -- 디폴트 ASC

SELECT *
FROM departments
ORDER BY department_id DESC; --내림차순

SELECT emp_name, salary
FROM employees
ORDER BY salary DESC, emp_name DESC;

SELECT emp_name, salary
FROM employees
ORDER BY hire_date;
-- 수식 연산자 : + = * /
SELECT employee_id as 직원아이디
    ,emp_name as 직원이름
    ,salary/30 as 일당
    ,salary as 월급
    ,salary - salary * 0.1 as 실수령액
    ,salary * 12 as 연봉
FROM employees;    
-- 논리 연산자
SELECT * FROM employees WHERE salary = 2600; --같다
SELECT * FROM employees WHERE salary <> 2600; --같지않다
SELECT * FROM employees WHERE salary != 2600; --같지않다
SELECT * FROM employees WHERE salary < 2600; --미만
SELECT * FROM employees WHERE salary > 2600; --초과
SELECT * FROM employees WHERE salary <= 2600; --이하
SELECT * FROM employees WHERE salary >= 2600; --이상
-- departments 테이블에서 30부서를 조회하시오
SELECT * FROM departments 
WHERE department_id = 30 
OR department_id = 60;
-- PRODUCTS 테이블 '상품 최저금액(PROD_MIN_PRICE)'가
-- 30원 "이상" 50원 "미만" 의 상품명과, 카테고리, 최저금액을 출력하시오
SELECT PROD_NAME,PROD_CATEGORY,PROD_MIN_PRICE
FROM PRODUCTS 
WHERE PROD_MIN_PRICE >= 30
AND PROD_MIN_PRICE < 50
ORDER BY PROD_CATEGORY,PROD_MIN_PRICE DESC;
-- 표현식: 원하는 표현으로 변경 CASW WHEN 조건1 THEN 해당조건변경표현
--                               WHEN 조건2 THEN 해당조건변경표현
--                          END AS 별칭
select cust_name from customers;
SELECT cust_name, cust_gender
    ,CASE WHEN cust_gender = 'M' THEN '남자'
    WHEN cust_gender = 'F' THEN '여자'
    ELSE '??'
    END AS gender
FROM customers;

SELECT cust_name, cust_gender
    ,CASE WHEN cust_gender = 'M' THEN '남자'
    ELSE '여자'
    END AS gender
FROM customers;

SELECT employee_id
,emp_name
,CASE WHEN salary <= 5000 THEN 'c등급'
WHEN salary > 5000 AND salary <= 15000 THEN 'B등급'
ELSE 'A등급'
END as grade
FROM employees;

FROM employees;
-- BETWEEN AND 조건식
SELECT employee_id, salary
FROM employees --2000 ~2500
WHERE salary BETWEEN 2000 AND 2500;
--IN 조건식 or 의 의미
SELECT employee_id, salary, department_id
FROM employees
WHERE department_id IN(90,80,10); --90 or 80 or 10
-- 문자열 연산자 || <-- +
SELECT emp_name || ' : ' || employee_id as 이름사번
FROM employees;
-- ** 많이 사용 LIKE
SELECT emp_name
FROM employees
WHERE emp_name LIKE 'A%'; --A로 시작하는

SELECT emp_name
FROM employees
WHERE emp_name LIKE 'A%sa%n'; 

SELECT emp_name
FROM employees
WHERE emp_name LIKE '%na%'; 


SELECT emp_name
FROM employees
WHERE department_id = :a 
OR department_id = :b;      -- 콜론 : 이름 <-- 바인드
                            -- 여러 값을 테스트 해볼 때 사용.
                            
SELECT emp_name
FROM employees
WHERE emp_name LIKE '%'||:val||'%';  --%값%

CREATE TABLE ex2_2(
    nm VARCHAR2(20)
);
INSERT INTO ex2_2 VALUES('길동');
INSERT INTO ex2_2 VALUES('홍길동');
INSERT INTO ex2_2 VALUES('길동홍');
INSERT INTO ex2_2 VALUES('홍길동상');

SELECT *
FROM ex2_2
WHERE nm LIKE '__';

CREATE TABLE students (
stu_id VARCHAR2(12) /* 학번 */
, stu_grade NUMBER(1)/* 학년 */
, stu_semester NUMBER(1) /* 학기 */
, stu_name VARCHAR2(10) /* 학생 이름 */
, stu_birth VARCHAR2(10) /* 학생 생년월일 */
, stu_kor NUMBER(3) /* 국어 점수 */
, stu_eng NUMBER(3) /* 영어 점수 */
, stu_math NUMBER(3) /* 수학 점수 */
, CONSTRAINTS stu_pk PRIMARY KEY (stu_id, stu_grade, stu_semester)
);

SELECT stu_name, stu_grade, (stu_kor + stu_eng + stu_math)/3 as subject_avg
FROM students -- 1학년 김씨만 조회하시오
--WHERE stu_name LIKE '김%'
WHERE stu_grade = 1 
AND (stu_kor + stu_eng + stu_math)/3 >= 90;

/*
    CUSTOMERS
    도시 : Los Angeles
    미혼 : single
    성별 : 여자
    1983 이후 출생자
    정렬조건 출생년도 내림차순 이름 오름차순
*/
select * from customers;
SELECT cust_name,
cust_gender,
cust_year_of_birth,
cust_marital_status,
cust_street_address,
cust_food
FROM customers
WHERE cust_gender = 'F'
AND cust_year_of_birth >= 1983
AND cust_marital_status = 'single'
AND cust_city = 'Los Angeles'
ORDER BY cust_year_of_birth DESC, cust_name;

--alter table [테이블명] add [컬럼명] [타입] [옵션]; 
ALTER TABLE customers 
ADD (cust_food VARCHAR2(30));




