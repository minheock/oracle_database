/* INNER JOIN 내부조인(동등조인)*/

SELECT * FROM 학생;
SELECT * FROM 수강내역;

SELECT 학생.학번
      ,학생.이름
      ,학생.전공
      ,수강내역.수강내역번호
      ,수강내역.과목번호
      ,과목.과목이름
FROM 학생,수강내역, 과목
WHERE 학생.학번 = 수강내역.학번
AND 학생.이름 = '최숙경'
AND 수강내역.과목번호 = 과목.과목번호;


-- 최숙경의 수강 총 학점을 출력하시오
SELECT * FROM 학생;
SELECT * FROM 과목;
SELECT * FROM 수강내역;
SELECT 학생.학번
    ,  학생.이름
    ,  학생.전공
    ,  SUM(과목.학점) as 총학점
FROM 학생, 과목, 수강내역
WHERE 학생.이름 = '최숙경'
AND 학생.학번 = 수강내역.학번
AND 과목.과목번호 = 수강내역.과목번호
GROUP BY 학생.학번, 학생.이름, 학생.전공;

/*
    OUTER JOIN 외부조인
    어느 한쪽에 NULL 값을 포함시켜야 할때
    (보통은 마스터 테이블은 무조건 포함시켜야하면 아우터 조인을 함.)
*/

SELECT 학생.학번
    ,  학생.이름    
FROM 학생, 수강내역
WHERE 학생.학번 = 수강내역.학번
AND 학생.이름 = '양지운';

SELECT 학생.학번
    ,  학생.이름    
FROM 학생, 수강내역               -- NULL 을 포함시킬 테이블 쪽.
WHERE 학생.학번 = 수강내역.학번(+)-- (+) <-- 한쪽에만 쓸 수 있음.
AND 학생.이름 = '양지운';

-- 학생의 수강이력 건수를 출력하시오
-- 모든 학생 출력 NULL 이면 0으로
SELECT * FROM 학생;
SELECT * FROM 과목;
SELECT * FROM 수강내역;
--DISTINCT
SELECT DISTINCT 학생.이름
    ,  COUNT(수강내역.수강내역번호) as 수강건수
    , NVL(SUM(과목.학점),0) as 총학점
FROM 학생, 수강내역, 과목             
WHERE 학생.학번 = 수강내역.학번(+)
AND 수강내역.과목번호 = 과목.과목번호(+)
GROUP BY ROLLUP(학생.학번, 학생.이름);


SELECT * FROM 학생;
SELECT * FROM 과목;
SELECT * FROM 수강내역;
SELECT 학생.학번
    ,  학생.이름
    ,  학생.전공
    ,  수강내역.수강내역번호
    ,  (SELECT 과목이름         -- 스칼라 서브쿼리
        FROM 과목
        WHERE 과목번호 = 수강내역.과목번호) as 과목이름
FROM 학생, 수강내역
WHERE 학생.이름 = '최숙경'
AND 학생.학번 = 수강내역.학번;

/*학생의 전공별 인원수를 출력하시오.*/
SELECT * FROM 학생;
SELECT * FROM 과목;
SELECT * FROM 수강내역;
SELECT * FROM 강의내역;
SELECT 학생.전공
     , COUNT(*) AS 학생수
FROM 학생
GROUP BY 전공;

/* 학생의 평균평점 보다 높은 학생을 출력하시오. */
SELECT 학번
      ,이름
      ,평점
FROM 학생
WHERE 학생.평점 > (SELECT AVG(평점)
                  FROM 학생)          -- 중첩 서브 쿼리
ORDER BY 3 desc;

-- 수강내역이 없는 학생은?
SELECT DISTINCT 학생.이름
FROM 학생, 수강내역
WHERE 학생.학번 NOT IN(SELECT 수강내역.학번
                        FROM 수강내역);

/*  인라인 뷰 (FROM 절)
    SELECT  문의 질의 결과를 테이블처럼 사용
*/                        

SELECT ROWNUM as rnum
      ,학번, 이름, 전공
FROM 학생                 -- 임시컬럼이어서 특정지을수 없다.
WHERE ROWNUM <= 5;         -- 예) =1 은되지만 =2는 안됨.


SELECT * 
FROM (SELECT ROWNUM as rnum
      ,학번, 이름, 전공
    FROM 학생) a  -- select 문을 테이블처럼 사용
WHERE a.rnum BETWEEN 2 AND 5; 


SELECT *                -- 분할해주기위해 rownum을 from 으로 사용함.             
FROM(                   -- 10건씩 자르려고. 예시) 웹페이지 게시판 이동 10개제한.
SELECT ROWNUM as rnum   -- 이렇게 쓰는게 보통 하나의 셋.
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
ORDER BY emp_name; -- 이름을 기준으로 정렬을 다시하기 때문에 로우넘이 깨짐.


/* 학생중에 평점 높은 5명만 출력하시오*/
SELECT * 
FROM(
SELECT ROWNUM as rnum
    ,a.*
FROM (SELECT 학생.이름
            ,학생.전공
            ,ROUND(학생.평점, 1) as 높은학점
             FROM 학생
             WHERE 학생.평점 > (SELECT AVG(평점)
                               FROM 학생) 
             ORDER BY 3 desc) a
)
WHERE rnum <= 5;

--member,cart,prod 를 사용하여
-- 고객별 카트 사용 횟수, 상품목록건수, 상품구매수량, 총구매금액을 출력하시오
-- 구매이력이 없다면 0 <-- 으로 출력되도록
-- 아우터 조인, 수량 * 세일즈
select * from member;
select * from cart;
select * from prod;
select * from lprod;






-- 대전 사는 사람들의 총합산금액의 평균이상의 총합산금액을 출력 아닌것들은 0으로 표기 
-- 그리고 그 합산금액의 누적합산금액을 출력.

SELECT m.mem_name
    , NVL(SUM(c.cart_qty),0) as 상품구매수량
    , NVL(CASE WHEN SUM(p.prod_sale * c.cart_qty) > (SELECT ROUND(SUM(p.prod_sale * c.cart_qty)/
                                                     COUNT(DISTINCT m.mem_name), 0)
                                                     FROM member m, cart c, prod p
                                                     WHERE SUBSTR(m.mem_add1, 1, 2) = '대전'
                                                     AND m.mem_id = c.cart_member(+)
                                                     AND c.cart_prod = p.prod_id(+))
           THEN SUM(p.prod_sale * c.cart_qty)
           END, 0) as 합산금액
    ,  SUM( NVL(CASE WHEN SUM(p.prod_sale * c.cart_qty) > (SELECT ROUND(SUM(p.prod_sale * c.cart_qty)/
                                                     COUNT(DISTINCT m.mem_name), 0)
                                                     FROM member m, cart c, prod p
                                                     WHERE SUBSTR(m.mem_add1, 1, 2) = '대전'
                                                     AND m.mem_id = c.cart_member(+)
                                                     AND c.cart_prod = p.prod_id(+))
           THEN SUM(p.prod_sale * c.cart_qty)
           END, 0)) OVER(ORDER BY m.mem_name) as 누적합산금액
FROM member m, cart c, prod p
WHERE SUBSTR(m.mem_add1, 1, 2) = '대전'
AND m.mem_id = c.cart_member(+)
AND c.cart_prod = p.prod_id(+)
GROUP BY m.mem_name
ORDER BY 1;



SELECT ROUND(SUM(p.prod_sale * c.cart_qty)/COUNT(DISTINCT m.mem_name), 0)
FROM member m, cart c, prod p
WHERE SUBSTR(m.mem_add1, 1, 2) = '대전'
AND m.mem_id = c.cart_member(+)
AND c.cart_prod = p.prod_id(+);


SELECT ROUND(SUM(p.prod_sale * c.cart_qty)/COUNT(DISTINCT m.mem_name), 0) as 평균구매합산금액
FROM member m, cart c, prod p
WHERE SUBSTR(m.mem_add1, 1, 2) = '대전'
AND m.mem_id = c.cart_member(+)
AND c.cart_prod = p.prod_id(+);






SELECT * FROM(
SELECT ROWNUM as rnum
    ,a.*
FROM(
SELECT a.mem_id
    ,  a.mem_name
    ,  NVL(count(DISTINCT b.cart_no), 0) as 카트사용횟수
    ,  NVL(count(c.prod_id),0)as 상품품목건수
    ,  NVL(sum(b.cart_qty),0) as 상품구매수량
    ,  NVL(sum(c.prod_sale * b.cart_qty), 0) as 구매합산금액
FROM member a, cart b, prod c
WHERE a.mem_id = b.cart_member(+)
AND b.cart_prod = c.prod_id(+)
GROUP BY a.mem_id, a.mem_name
ORDER BY 6 desc) a
)
WHERE rnum <= 18;

