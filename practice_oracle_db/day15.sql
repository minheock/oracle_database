/*
    부서별 직원의 salary 가 가장 높은 직원을 출력하시오
*/

SELECT * FROM(
SELECT emp_name
    ,  salary
    ,  department_id
    ,  RANK() OVER(PARTITION BY department_id ORDER BY salary DESC) as rnk
FROM employees   
)
WHERE rnk = 1;

-- 학생중 전공별 평점이 가장 높은 학생의 정보를 출력하시오
select * from 학생;
SELECT * FROM(
SELECT a.*
    ,  RANK() OVER(PARTITION BY a.전공 ORDER BY 평점 DESC) as rnk   
    ,  RANK() OVER(ORDER BY a.평점 DESC) as all_rnk    
    ,  COUNT(*) OVER() as 전체학생수
    ,  ROUND(AVG(a.평점) OVER (), 2) as 전체평균
FROM 학생 a
)
WHERE rnk =1
ORDER BY 평점 DESC;

/*
    로우손실 없이 집계값 산출
    partition by 에서 window 절을 활용하여 세부 집계를 할 수 있음.
    AVG, SUM, MAX, MIN, COUNT, RANK, DENSE_RANK, LAG, ROW_NUMBER...
    PARTITON BY 절 : 계산 대상 그룹
    ORDER BY 절 : 대상 그룹에 대한 정렬
    WINDOW 절 : 파티션으로 분할된 그룹에 대해 더 상세한 그룹으로 분할
*/


-- CART, PROD 물품별 prod_sale 합계의 상위 10등 상품을 출력하시오.
SELECT * FROM cart;
SELECT * FROM prod;

-- 일반 방법
SELECT * FROM(
SELECT c.*
    ,  RANK() OVER(ORDER BY sale_sum) as rnk   
FROM(    
SELECT a.cart_prod -- 상품아이디
    ,  b.prod_name -- 상품이름
    ,  SUM(b.prod_sale * a.cart_qty) as sale_sum
FROM cart a
    ,prod b
WHERE a.cart_prod = b.prod_id
GROUP BY a.cart_prod, b.prod_name
 ) c 
)
WHERE rnk <= 10;    


SELECT *
FROM(
SELECT a.cart_prod -- 상품아이디
    ,  b.prod_name -- 상품이름
    ,  RANK() OVER(ORDER BY sum(b.prod_sale * a.cart_qty) DESC)as rnk
FROM cart a
    ,prod b
WHERE a.cart_prod = b.prod_id
GROUP BY a.cart_prod, b.prod_name
)
WHERE rnk <= 10;


/*
    NTILE(expr) 파티션별로 expr 명시된 값 만큼 분할한 결과를 반환
    NTILE(3) 1 ~ 3 의 수를 반환(분할하는 수를 버킷 수 라고함)
    NTILE(4) -> 100/4 -> 25% 로 행을 분할

*/

SELECT emp_name, salary, department_id
    ,  NTILE(2) OVER(PARTITION BY department_id ORDER BY salary DESC) as group_num
    ,  COUNT(*) OVER(PARTITION BY department_id ) as 부서직원수
FROM employees
WHERE department_id IN (30,60);

-- 전체 직원의 급여를 10 분위로 나누었을때 1분위에 속하는 직원을 조회하시오
SELECT emp_name, salary
    ,  NTILE(10) OVER(ORDER BY salary DESC) as 분위
FROM employees;

SELECT *
FROM tb_info;

SELECT nm
    ,  NTILE(6) OVER(ORDER BY DBMS_RANDOM.VALUE) as team
FROM tb_info;    

CREATE TABLE tb_sample AS
SELECT ROWNUM as seq
    ,  '2023' || LPAD(CEIL(ROWNUM / 1000), 2, '0') as month
    ,  ROUND(DBMS_RANDOM.VALUE(100, 1000)) as amt
FROM dual
CONNECT BY LEVEL <= 12000;
SELECT * FROM
tb_sample;


-- 알파벳 대문자 5자리 랜덤 생성
SELECT DBMS_RANDOM.STRING('U', 5) -- 알파벳 대문자 5자리 랜덤생성
    ,  DBMS_RANDOM.STRING('L', 5) -- 소문자
    ,  DBMS_RANDOM.STRING('A', 5) -- 대소문자
    ,  DBMS_RANDOM.STRING('X', 5) -- 알파벳 대문자 & 숫자
    ,  DBMS_RANDOM.STRING('P', 5) -- 대소문자, 숫자, 특수문자
FROM DUAL;    

/*
    주어진 그룹과 순서에 따라 ROW에 있는 값을 참조할때 사용
    LAG(expr, offset, default_value) 선행로우의 값 참조
    LEAD(expr, offset, default_value) 후행로우의 값 참조
*/

SELECT emp_name, department_id, salary
    ,  LAG(emp_name, 1, '가장높음') OVER(PARTITION BY department_id
                                   ORDER BY salary DESC) as emp_lag
    ,  LEAD(emp_name, 1, '가장낮음') OVER(PARTITION BY department_id
                                    ORDER BY salary desc) as emp_lead
FROM employees;                         

/*
     학생의 평점을 기준으로 한단계 위의 학생의 평점과 차이를 출력하시오
     순위 이름   평점    상위학생이름  상위평점과 차이
     1등  팽수   4.5       없음           0
     2등  길동   4.3       팽수          0.2
     3등  동길   3.0       길동          1.3      
     LAG(emp_name, 1, '가장높은') 매개변수 1, 3의 타입이 같아야함
*/
select * from 학생;

 SELECT 이름, round(평점, 1)
    ,  LAG(이름, 1 ,'없음') OVER(ORDER BY 평점 DESC) as 상위학생이름
    --                   타입을 맞춰줘야함.
    ,  ROUND(LAG(평점, 1, 평점) OVER(ORDER BY 평점 DESC) - 평점, 2) as 상위평점차이 
FROM 학생
order by 2 desc;  

/*
    1. 회원은 게시판에 게시글을 여러개 작성 할 수 있다.
    2. 회원은 작성된 게시글에 댓글을 작성 할 수 있다.
        게시판에는 제목, 글 내용, 작성자, 작성일, 수정일 정보가 있어야함.
        
    회원  m - n  게시판테이블      
    글번호       bbs_no        NUMBER          PK  
    상위 글번호  parent_no      NUMBER          FK
    제목        bbs_title     varchar2(1000)          NOTNULL
    글내용      bbs_content   varchar2(4000)          NOTNULL
    작성자      author_id     varchar2(100)    FK     NOTNULL
    생성일자    create_dt       timestamp              DEFAULT
    수정일자    update_dt       timestamp              DEFAULT
*/
DROP TABLE bbs;
CREATE TABLE bbs (
bbs_no          NUMBER PRIMARY KEY
,parent_no      NUMBER
,bbs_title      VARCHAR2(1000) DEFAULT NULL -- 댓글의 경우 NULL
,bbs_content    VARCHAR2(4000) NOT NULL
,author_id      VARCHAR2(100)
,create_dt      TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- 사용자 세션의 시간
,update_dt      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
,CONSTRAINT fk_prent FOREIGN KEY(parent_no) 
 REFERENCES bbs(bbs_no) ON DELETE CASCADE 
 -- 게시글의 no 를 참조하고 참조 데이터 삭제시 같이 삭제
,CONSTRAINT fk_user  FOREIGN KEY(author_id) 
 REFERENCES tb_user(user_id) ON DELETE CASCADE -- 유저 탈퇴시 같이 삭제
);

-- 게시글 번호 시퀀스
DROP SEQUENCE bbs_seq;
CREATE SEQUENCE bbs_seq START WITH 1 INCREMENT BY 1;

INSERT INTO bbs(bbs_no, bbs_title, bbs_content, author_id)
VALUES(bbs_seq.NEXTVAL, '공지사항', '오늘은 금요일 입니다.!!!!', 'a001');

INSERT INTO bbs(bbs_no, bbs_title, bbs_content, author_id)
VALUES(bbs_seq.NEXTVAL, '게시글1', '게시글 1입니다.', 'b001');

INSERT INTO bbs(bbs_no, parent_no, bbs_content, author_id)
VALUES(bbs_seq.NEXTVAL, 1, '곧 월요일이예요 ...', 'x001');

SELECT * FROM bbs;
select  level, a.*
FROM bbs a
START WITH parent_no is null
connect by prior bbs_no = parent_no ;    


select a.*
FROM bbs a
START WITH bbs_no =1
connect by prior bbs_no = parent_no ; 





SELECT * 
FROM tb_user;
SELECT * 
FROM user_tab_columns
WHERE table_name = 'TB_USER'

SELECT user_id
    ,  user_nm
    ,  user_pw
    ,  user_mileage
FROM tb_user
WHERE user_id = '';
