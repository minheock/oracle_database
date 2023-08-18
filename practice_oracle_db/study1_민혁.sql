/*
 STUDY 계정에 create_table 스크립트를 실해하여 
 테이블 생성후 1~ 5 데이터를 임포트한 뒤 
 아래 문제를 출력하시오 
 (문제에 대한 출력물은 이미지 참고)
*/
-----------1번 문제 ---------------------------------------------------
--1988년 이후 출생자의 직업이 의사,자영업 고객을 출력하시오 (어린 고객부터 출력)
SELECT *
FROM customer
WHERE job IN('의사', '자영업')
AND birth > 19880101
ORDER BY 7 desc;
-----------------------------------------------------------------
-----------2번 문제 ---------------------------------------------------
--강남구에 사는 고객의 이름, 전화번호를 출력하시오 
SELECT a.customer_name
    ,  a.phone_number
FROM customer a,address b
WHERE a.zip_code = b.zip_code
AND b.address_detail = '강남구';
---------------------------------------------------------------------
----------3번 문제 ---------------------------------------------------
--CUSTOMER에 있는 회원의 직업별 회원의 수를 출력하시오 (직업 NULL은 제외)
SELECT DISTINCT job
    ,  COUNT(job)
FROM customer
GROUP BY job
HAVING COUNT(job) >= 1
ORDER BY 2 desc;

---------------------------------------------------------------------
----------4-1번 문제 ---------------------------------------------------
-- 가장 많이 가입(처음등록)한 요일과 건수를 출력하시오 
SELECT * FROM(
SELECT ROWNUM rnum
      ,a.*
FROM(
SELECT TO_CHAR(first_reg_date,'day') as 요일
      ,COUNT(TO_CHAR(first_reg_date,'day')) as 건수
FROM customer
GROUP BY TO_CHAR(first_reg_date,'day')
ORDER BY 2 desc) a
)
WHERE rnum = 1;
---------------------------------------------------------------------
----------4-2번 문제 ---------------------------------------------------
-- 남녀 인원수를 출력하시오 
SELECT case sex_code when 'M' then '남자'
                     when 'F' then '여자'
                     else '미등록'
        end as gender
    , case sex_code when 'M' then count('M')
                     when 'F' then count('F')
                     else count(*)- count('M') + count('F')
                     end as cnt
FROM customer
GROUP BY ROLLUP(sex_code);

---------------------------------------------------------------------
----------5번 문제 ---------------------------------------------------
--월별 예약 취소 건수를 출력하시오 (많은 달 부터 출력)
SELECT * FROM address;
SELECT * FROM customer;
SELECT * FROM item;
SELECT * FROM order_info;
SELECT * FROM reservation;
desc reservation;

SELECT SUBSTR(SUBSTR(reserv_date,5,6),1,2)as 월
      ,COUNT(SUBSTR(SUBSTR(reserv_date,5,6),1,2)) as 취소건수
FROM reservation
WHERE cancel = 'Y'
GROUP BY SUBSTR(SUBSTR(reserv_date,5,6),1,2)
ORDER BY 2 desc;




---------------------------------------------------------------------
