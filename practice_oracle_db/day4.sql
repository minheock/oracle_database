

CREATE TABLE ex4_1 (
    irum VARCHAR2(100) NOT NULL,
    point NUMBER(5),
    gender CHAR(1),
    reg_date DATE
);
--컬럼명 수정
ALTER TABLE ex4_1 RENAME COlUMN irum TO nm;
--타입 수정 (타입 수정시 테이블에 데이터가 있다면 주의해야함)
ALTER TABLE ex4_1 MODIFY point NUMBER(10);
-- 제약 조건 추가
ALTER TABLE ex4_1 ADD CONSTRAINTS pk_ex4 PRIMARY KEY(nm);
--컬럼 추가
ALTER TABLE ex4_1 ADD hp VARCHAR2(20);
-- 컬럼 삭제
ALTER TABLE ex4_1 DROP COLUMN hp;

-- 테이블 comment
COMMENT ON TABLE tb_info IS '우리반';
COMMENT ON COLUMN tb_info.info_no IS '출석번호';
COMMENT ON COLUMN tb_info.pc_no IS '컴퓨터번호';
COMMENT ON COLUMN tb_info.nm IS '이름';
COMMENT ON COLUMN tb_info.email IS '이메일';
COMMENT ON COLUMN tb_info.hobby IS '취미';
COMMENT ON COLUMN tb_info.mbti IS '브릭스유형지표';

-- 테이블 comment
SELECT *
FROM all_tab_comments
WHERE OWNER = 'JAVA';

SELECT *
FROM all_col_comments
WHERE comments LIKE '%이름%';
--WHERE comments LIKE '%%'
/*
INSERT 데이터 삽입 (DML문)
    1. 기본 형태 컬럼명 기술
*/
CREATE TABLE ex4_2(
val1 VARCHAR2(10),
val2 NUMBER,
val3 DATE
);
INSERT INTO ex4_2(val1, val2 ,val3)
VALUES ('hi', 10, SYSDATE); --문자열 '' number 타입은 숫자
INSERT INTO ex4_2( val2 ,val3)
VALUES (10, SYSDATE);       --위에 작성한 컬럼 순서대로
                            --value 도 INSERT
SELECT *
FROM ex4_2;
-- 테이블 전체에 대해 데이터를 삽입할때는 컬럼명 안써도 됨.
INSERT INTO ex4_2
VALUES ('hello', 20, SYSDATE); 
INSERT INTO ex4_2
VALUES (20, SYSDATE); --오류
CREATE TABLE ex4_3(
emp_id NUMBER,
emp_name VARCHAR2(1000)
);
-- SELECT ~ INSERT
INSERT INTO ex4_3 (emp_id, emp_name)
SELECT employee_id,
emp_name
FROM employees
WHERE salary > 5000;
/*
해석 : ex43 테이블에 두컬럼에 employee 테이블의 두컬럼의 값을 salary가 5000이상인것만 넣어줌.
*/
select * from ex4_3;

--테이블복사
CREATE TABLE ex4_4 AS
SELECT nm, email
FROM tb_info;

select * from ex4_4;
/*UPDATE 데이터 수정*/
SELECT *
FROM tb_info;
UPDATE tb_info
SET hobby = '공부',
email = 'abc@gmail.com'
WHERE info_no = 1;

SELECT *
FROM tb_info;
UPDATE tb_info
SET hobby = '자바',
email = 'minhyeock0713@gmail.com'
WHERE nm = '최민혁';

select * from tb_info;

SELECT *
FROM ex4_4;
DELETE ex4_4; -- 전체삭제

DELETE ex4_4
WHERE nm = '예준서';
SELECT *
FROM products;


-- 중복제거 데이터 보기
SELECT DISTINCT prod_category
FROM products;
-- 의사 컬럼 (테이블에는 없지만 있는것 처럼 사용)
SELECT ROWNUM, --쉼표 넣어줘야함
emp_name,
email
FROM employees
WHERE ROWNUM <= 10;

-- NULL (IS NULL or IS NOT NULL)
SELECT *
FROM employees
WHERE manager_id IS NULL; -- null인 애들이 나옴

SELECT *
FROM departments
WHERE department_id IN (30, 60);

SELECT *
FROM departments
WHERE department_id NOT IN (30, 60);


/*
oracle 데이터 베이스 내장함수
문자 관련

*/
SELECT LOWER('I like mac') as lowers
,UPPER('I like mac') as uppers
,INITCAP('I like mac') as initcaps-- 단어 첫글자 대문자
FROM dual; -- 임시테이블

SELECT *
FROM employees
WHERE UPPER(emp_name) LIKE '%'||:S||'%';

SELECT 'HI', emp_name
FROM employees;

-- SUBSTR (char, pos, len) 대상 문자열 char 의 pos번째부터
-- len 길이 만큼 자른 뒤 반환
-- pos 값으로 0이 오면 디폴트 값 1 즉 첫번째 문자열
-- 음수가 오면 문자열의 맨 끝에서 시작한 상대적 위치
-- len 값이 생략되면 pos 번째 문자부터 나머지 모든 문자를 반환
SELECT SUBSTR('ABCD EFG', 1, 4),
        SUBSTR('ABCD EFG', -3, 3),
        SUBSTR('ABCD EFG', -3, 1),
        SUBSTR('ABCD EFG', 5)
FROM dual;
/* INSERT 대상 문자열에서 찾을 문자열의 위치*/
SELECT INSTR('내가 만약 외로울 때면, 내가 만약 괴로울 때면', '만약'), --디폴트 1, 1
        INSTR('내가 만약 외로울 때면, 내가 만약 괴로울 때면', '만약',5), 
        INSTR('내가 만약 외로울 때면, 내가 만약 괴로울 때면', '만약',1,2),
        INSTR('내가 만약 외로울 때면, 내가 만약 괴로울 때면', '나')
FROM dual;

/* 고객의 이메일 주소의 이름과 도메인을 분리하여 출력하시오
ex leeapgil@gmaul.com -> id : leeapgil, domain:gmail.com
*/
SELECT SUBSTR('leeapgil@gmaul.com', 1, 8),
        SUBSTR('leeapgil@gmaul.com', 10)
FROM customers;



SELECT cust_id ,
cust_name,
cust_email,
SUBSTR(cust_email, 1, INSTR(cust_email,'@')-1) as ID, --substr은 2번째 인자부터 3번째 인자까지 자르는 메서드이고
SUBSTR(cust_email, INSTR(cust_email,'@')+1) as DOMAIN -- instr은 1번째 인자에있는 문자열안에 2번째 인자에있는 값과 
FROM customers                                        --같은 값의 인덱스를 찾아주는 메서드이기때문에 둘을 활용하면 원하는 위치를 잘라서 컬럼을 
ORDER BY cust_name;                                   -- 만들수 있다.





ALTER TABLE tb_info ADD 에너지방향 VARCHAR2(20);
ALTER TABLE tb_info ADD 인식방식 VARCHAR2(20);
ALTER TABLE tb_info ADD 판단형 VARCHAR2(20);
ALTER TABLE tb_info ADD 생활양식 VARCHAR2(20);
ALTER TABLE tb_info DROP COLUMN 에너지방향;
ALTER TABLE tb_info DROP COLUMN 인식방식;
ALTER TABLE tb_info DROP COLUMN 판단형;
ALTER TABLE tb_info DROP COLUMN 생활양식;
SELECT 
nm,
mbti,
CASE WHEN mbti LIKE '%I%' THEN '내향형'
          else '외향형' END AS 에너지방향,
     CASE WHEN mbti LIKE '%S%' THEN '직관형'
          else '감각형' END AS 인식방식,
     CASE WHEN mbti LIKE '%T%' THEN '사고형'
          else '감성형' END AS 판단형,
     CASE WHEN mbti LIKE '%J%' THEN '자율형'
          else '계획형' END AS 생활양식                        
FROM tb_info;
