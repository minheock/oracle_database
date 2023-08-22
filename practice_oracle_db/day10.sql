/*
    뷰 VIEW 338p
    하나 이상의 테이블을 연결해 마치 테이블인 것 처럼 사용하는 객체
    실제 데이터는 뷰를 구성하는 테이블에 담겨 있지만 테이블처럼 사용가능
    사용 목적 : 1. 자주 사용하는 복잡한 SQL문을 매번 작성할 필요 없이 뷰로 만들어 사용
              2. 데이터 보안 측면(몇몇 컬럼과 데이터만 공개가능 원천 테이블 감출 수 있음.)
*/

CREATE OR REPLACE VIEW emp_dept AS -- 뷰 생성 구문
SELECT a.employee_id
      ,a.emp_name
      ,a.department_id
FROM employees a, departments b
WHERE a.department_id = b.department_id;
-- system 계정에서 java계정에 뷰를 만들 수 있는 권한 부여
GRANT CREATE VIEW to java;  -- system 계정에서 실행
SELECT *
FROM emp_dept;


-- 다른 계정에 emp_dept 뷰를 조회할 수 있는 권한 부여
GRANT SELECT ON emp_dept TO study; --java 계정에서 실행

SELECT *
FROM java.emp_dept; -- study 계정에서 조회 다른 계정에서 조횔할때는 스키마(계정). 뷰 or 테이블


/*  뷰 특징
     * 단순 뷰 (테이블 1개로 생성)
     - 그룹 함수 사용 불가
     - dinstinct 사용 불가
     - insert/update/delete 사용 가능
     
     * 복합 뷰 (테이블 여러개로 생성)
     - 그룹 함수 사용 가능
     - dinstinct 사용 가능
     - insert/update/delete 불가능
*/

 -- 뷰 삭제
DROP VIEW emp_dept; -- 생성한 계정에서 실행

/* 시노님 synonim : 동의어란 뜻으로 객체 각자의 고유한 이름에 대한 동의어를 만드는것
   public synonim : 모든 사용자 접근
   private synonim : 특정 사용자만 접근
   시노님 생성시 public 을 생략하면 private 시노님으로 생성됨
   public 시노님의 생성 삭제는 DBA 권한있는 사용자만 가능
   사용 목적 : 1. 보안 측면 계정명과 같은 중요한 정보를 숨기기 위해 별칭을 만듬
             2. 개발 편의성 실제 테이블의 정보가 변경되어도 별칭으로 사용을 했다면
                코드 수정을 안해도 됨. 
*/
-- 시노님 생성 권한 부여
GRANT CREATE SYNONYM to java;
CREATE OR REPLACE SYNONYM empl FOR employees;
SELECT *
FROM empl;
GRANT SELECT ON empl TO study; -- 동의어로 테이블을 조회할 수 있는 권한 부여
SELECT *
FROM java.empl;

-- public synonim dba 권한이 있어야함.
CREATE OR REPLACE PUBLIC SYNONYM empl2 FOR java.employees; -- system 계정에서 생성
SELECT *
FROM empl2; -- 어떤 계정에서도 조회가능(public 이기 때문)
            -- 각 계정에서는 해당 테이블이 어느 계정에 있는지 알 수 없음. (보안)
            
--dba 권한 public synonym 삭제 가능
DROP PUBLIC SYNONYM empl2;

/* 시퀀스 SEQUENCE 348p : 규칙에 따라 자동 순번을 반환하는 객체
   사용목적 : pk 로 사용할 데이터가 없을경우 시퀀스를 만들어서 사용
        ex ) 게시판의 게시글 번호 ( 1로 시작하여 ~~ 999 증가)
    시퀀스명.CURRVAL -- 현재 시퀀스 값
    시퀀스명.NEXTVAL -- 다음 시퀀스 값
*/
DROP SEQUENCE my_seq1;
CREATE SEQUENCE my_seq1
INCREMENT BY 1 -- 증강숫자
START WITH 1   -- 시작숫자
MINVALUE 1     -- 최소값
MAXVALUE 999999    -- 최댓값  
NOCYCLE        --최대나 최소값에 도달하면 생성 중지 디폴트(nocycle)
NOCACHE ;      -- 메모리에 시퀀스 값을 미리 할당하지 않음 디폴트 (nocache)
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

SELECT TO_CHAR(SYSDATE, 'YYYYMMDD')||LPAD(nvl(MAX(seq),0)+1, 4, '0') -- 중복되지 않는 값을 넣기위해 이런식으로 값을 넣어줌.
FROM temp_tb;


/* MERGE문 oracle 10g 부터 사용가능
   특정 조건에 따라 INSERT or UPDATE DELETE 사용시 
*/
-- 현대인의건강 과목이 있다면 학점을 3으로
--                   없다면 생성
SELECT *
FROM 과목;
INSERT INTO 과목 (과목번호, 과목이름, 학점) VALUES(509,'현대인의건강',2); -- 중복이라 오류.
MERGE INTO 과목 a
USING dual              -- 비교대상 테이블 (dual은 into 테이블과 같을때)
ON(a.과목이름 = '현대인의건강')
WHEN MATCHED THEN       -- on의 조건이 만족할때
    UPDATE SET a.학점 = 3  
WHEN NOT MATCHED THEN  -- on의 조건이 만족하지 않을때
    INSERT (a.과목번호, a.과목이름, a.학점) -- matched나 notmatched중 하나만 들어가도 됨.
    VALUES (509, '현대인의건강', 2);
    
        
/* SELECT 문 정확 and 속도*/        
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

-- 2000년도 판매왕을 출력하시오
-- employees, sales 테이블 사용 판매금액 (amount_sold) 판매수량 (quantity_sold)
SELECT *
FROM employees;
SELECT *
FROM sales;

SELECT 이름
    ,  사번
    ,  판매금액
    ,  판매수량
FROM(    
SELECT ROWNUM rnum 
    ,  a.*
FROM(    
SELECT e.emp_name as 이름
    ,  e.employee_id as 사번
    ,  SUM(s.amount_sold) as 판매금액
    ,  count(s.quantity_sold) as 판매수량
FROM employees e, sales s
WHERE e.employee_id = s.employee_id
AND TO_CHAR(s.sales_date, 'YYYY') = 2000
GROUP BY e.emp_name, e.employee_id
ORDER BY 3 desc) a
)
where rnum = 1;

SELECT e.emp_name 
    ,sum(s.amount_sold) as 판매금액
    ,count(s.quantity_sold) as 판매수량
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
    ,  SUM(s.amount_sold) as 판매금액
    ,  SUM(s.quantity_sold) as 판매수량
FROM employees e, sales s
WHERE e.employee_id = s.employee_id
AND TO_CHAR(s.sales_date, 'YYYY') = 2000;