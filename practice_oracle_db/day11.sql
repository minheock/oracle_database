SELECT department_id
      -- level 가상열로서 트리내에서 어떤 단계인지 나타내는 정수값
      ,LPAD(' ', 3 * (level-1)) || department_name as 부서명
      ,parent_id
      ,level
FROM departments
START WITH parent_id IS NULL                    -- 시작
CONNECT BY PRIOR department_id = parent_id;     -- 계층을 어떻게 연결할지(조건) 내부적으로 계층을 만듬. 
                                                -- department id 가 30이면 parent id가 30인 애들이 하위로 붙음
                                                

-- department 테이블에 230 IT 헬프데스크 하위 부서로
--                       IT 원격팀을 INSERT INTO로 넣어보자 
--                   280 IT 원격팀을 삽입해주세요
select * from departments;
SELECT MAX(department_id) + 10
FROM departments;
INSERT INTO departments(department_id, department_name, parent_id) VALUES(280, 'IT 원격팀', 230);


/* 계층형 쿼리에서 정렬을 하려면 SIBLINGS BY 를 추가해야함.*/
SELECT department_id
      ,LPAD(' ', 3 * (level-1)) || department_name as 부서명
      ,parent_id
      ,level
FROM departments
START WITH parent_id IS NULL
CONNECT BY PRIOR department_id = parent_id
--ORDER BY 부서명;   -- 이렇게 하면 순서가 깨짐
-- SIBLINGS 사용시에는 실제 컬럼으로만 정렬가능
ORDER SIBLINGS BY department_name;             



SELECT department_id
      -- level 가상열로서 트리내에서 어떤 단계인지 나타내는 정수값
      ,LPAD(' ', 3 * (level-1)) || department_name as 부서명
      ,parent_id
      ,level
      ,CONNECT_BY_ISLEAF -- 마지막 노드면 1, 자식이 있으면 0
      ,SYS_CONNECT_BY_PATH(department_name, '>') -- 루트 노드에서 자신행까지 연결정보
      ,CONNECT_BY_ISCYCLE -- 무한루프의 원인을 찾을때 
      --(자식이 있는데 그 자식 로우가 부모이면 1, 아니면 0)
      -- 밑에 절에 NOCYCLE 안쓰면 에러뜸.
FROM departments
START WITH parent_id IS NULL                    
CONNECT BY NOCYCLE PRIOR department_id = parent_id;


-- 무한 루프 걸리도록 수정
UPDATE departments
SET parent_id = 10
WHERE department_id = 30;


-- 직원간의 계층관계를 출력하시오(정렬, 직원명, 이름, 오름차순)
SELECT employee_id
    ,  LPAD(' ', 3 * (level-1)) || emp_name as 부서명
    ,  SYS_CONNECT_BY_PATH(emp_name, '>') as 관리관계
FROM employees
START WITH manager_id IS NULL
CONNECT BY PRIOR employee_id = manager_id
ORDER SIBLINGS BY emp_name;

CREATE TABLE 회사 (
       아이디 NUMBER(10),
       이름   VARCHAR2(10),
       직책   VARCHAR2(80),
       상위아이디 NUMBER(10));
DROP TABLE 회사;       
INSERT INTO 회사(아이디, 이름, 직책, 상위아이디) VALUES(1,'이사장', '사장', null);
INSERT INTO 회사(아이디, 이름, 직책, 상위아이디) VALUES(2,'김부장', '부장', 1);
INSERT INTO 회사(아이디, 이름, 직책, 상위아이디) VALUES(3,'서차장', '차장', 2);
INSERT INTO 회사(아이디, 이름, 직책, 상위아이디) VALUES(4,'장과장', '과장', 3);
INSERT INTO 회사(아이디, 이름, 직책, 상위아이디) VALUES(5,'이대리', '대리', 4);
INSERT INTO 회사(아이디, 이름, 직책, 상위아이디) VALUES(6,'최사원', '사원', 5);
INSERT INTO 회사(아이디, 이름, 직책, 상위아이디) VALUES(7,'강사원', '사원', 5);
INSERT INTO 회사(아이디, 이름, 직책, 상위아이디) VALUES(8,'박과장', '과장', 3);
INSERT INTO 회사(아이디, 이름, 직책, 상위아이디) VALUES(9,'김대리', '대리', 8);
INSERT INTO 회사(아이디, 이름, 직책, 상위아이디) VALUES(10,'주사원', '사원', 9);

DESC 회사;       
SELECT * FROM 회사;
SELECT 이름
    ,  LPAD(' ', 3 * (level-1)) || 직책 as 직책
    ,  level
    ,  상위아이디
FROM 회사
START WITH 상위아이디 IS NULL
CONNECT BY PRIOR 아이디 = 상위아이디
;

SELECT period
    ,  sum(loan_jan_amt) as 대출합계
FROM kor_loan_status
WHERE substr(period, 1, 4) = 2013
GROUP BY period;

/* level 은 가상 - 열로서 (connect by 절과 함께 사용)
   임의의 데이터가 필요할때 많이 사용.
*/
-- 2013년 1~12 월 데이터
SELECT '2013'|| LPAD(LEVEL, 2, '0') as 년월
FROM dual
CONNECT BY LEVEL <= 12;


-- 현업에서 은근 많이 사용함.
SELECT a.년월
     , nvl(b.대출합계, '0') as 대출합계
FROM   (SELECT '2013'|| LPAD(LEVEL, 2, '0') as 년월
        FROM dual
        CONNECT BY LEVEL <= 12
        ) a
        --
     , (SELECT period as 년월
     ,  sum(loan_jan_amt) as 대출합계
        FROM kor_loan_status
        WHERE substr(period, 1, 4) = 2013
        GROUP BY period
        ) b
WHERE a.년월 = b.년월(+);    

-- 202301 ~ 202312
SELECT '2023'|| LPAD(LEVEL, 2, '0') as 년월
FROM dual
CONNECT BY LEVEL <= 12;
--
select TO_CHAR(SYSDATE, 'YYYY')||LPAD(LEVEL, 2, '0') as 올해
from dual
CONNECT BY LEVEL <= 12;

-- 이번달 1일 부터 마지막날까지 출력
-- (단 해당 select 문을 다음달에 실행시 해당월의 마지막날까지 출력되도록)
-- 20230801
-- 20230802
-- 20230803
-- 20230801
-- ...
-- 20230831
SELECT TO_CHAR(SYSDATE, 'YYYYMM')||LPAD(LEVEL, 2, '0') as 팔월  
FROM dual
CONNECT BY LEVEL <= SUBSTR(LAST_DAY(SYSDATE), 7,8);

-- member 회원의 생일 (mem_bir) 의 월별 회원수를 출력하시오 (모든 월이 나오도록)
-- a.월||'월' , 회원수

select * from member;
-- 그냥풀기
SELECT DISTINCT nvl(a.생일_월||'월','합계') as 생일_월
    ,  COUNT( b.월별) as 회원수
FROM   (SELECT LPAD(LEVEL, 2, '0') as 생일_월
        FROM dual
        CONNECT BY LEVEL <= 12
        ) a
        ,
        (SELECT substr(substr(mem_bir, 4),1, 2) as 월별
        FROM member
        ) b
        WHERE a.생일_월 = b.월별(+)
        GROUP BY ROLLUP(a.생일_월||'월', b.월별)
        ORDER BY 1;
        
-- 유니온으로 풀기
SELECT * FROM(
SELECT a.생일_월||'월' as 생일_월
    ,  nvl(b.회원수, '0') as 회원수
FROM   (SELECT LPAD(LEVEL, 2, '0') as 생일_월
        FROM dual
        CONNECT BY LEVEL <= 12
        ) a
        ,
        (SELECT TO_CHAR(mem_bir, 'MM') as 월별
        ,COUNT(substr(substr(mem_bir, 4),1, 2)) as 회원수
        FROM member
        GROUP BY TO_CHAR(mem_bir, 'MM')
        order by 1
        ) b
WHERE a.생일_월 = b.월별(+)
UNION
SELECT  '합계' as 생일_월
      , COUNT(TO_CHAR(mem_bir, 'MM'))as 회원수
        FROM member
        order by 1
);
        
        
        
        
SELECT  '합계' as 생일_월
     ,  count(substr(substr(mem_bir, 4),1, 2))as 회원수
        FROM member
        order by 1;
        
SELECT  nvl(TO_CHAR(mem_bir, 'MM')||'월','합계') as 생일_월
        ,COUNT(substr(substr(mem_bir, 4),1, 2)) as 회원수
        FROM member
        GROUP BY ROLLUP(TO_CHAR(mem_bir, 'MM')||'월')
        order by 1;        
              