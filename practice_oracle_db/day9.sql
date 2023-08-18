--ANSI OUTER JOIN
SELECT a.mem_id
      ,a.mem_name
      ,COUNT(DISTINCT b.cart_no) as 카트사용횟수
      ,COUNT(c.prod_id) as 품목수
FROM member a
LEFT OUTER JOIN cart b
ON(a.mem_id = b.cart_member)
LEFT OUTER JOIN prod c
ON(b.cart_prod = c.prod_id)
GROUP BY a.mem_id, a.mem_name;

-- 집합 연산자 UNION ------------------------------------------------------------------------

CREATE TABLE exp_goods_asia (
       country VARCHAR2(10),
       seq     NUMBER,
       goods   VARCHAR2(80));

INSERT INTO exp_goods_asia VALUES ('한국', 1, '원유제외 석유류');
INSERT INTO exp_goods_asia VALUES ('한국', 2, '자동차');
INSERT INTO exp_goods_asia VALUES ('한국', 3, '전자집적회로');
INSERT INTO exp_goods_asia VALUES ('한국', 4, '선박');
INSERT INTO exp_goods_asia VALUES ('한국', 5,  'LCD');
INSERT INTO exp_goods_asia VALUES ('한국', 6,  '자동차부품');
INSERT INTO exp_goods_asia VALUES ('한국', 7,  '휴대전화');
INSERT INTO exp_goods_asia VALUES ('한국', 8,  '환식탄화수소');
INSERT INTO exp_goods_asia VALUES ('한국', 9,  '무선송신기 디스플레이 부속품');
INSERT INTO exp_goods_asia VALUES ('한국', 10,  '철 또는 비합금강');

INSERT INTO exp_goods_asia VALUES ('일본', 1, '자동차');
INSERT INTO exp_goods_asia VALUES ('일본', 2, '자동차부품');
INSERT INTO exp_goods_asia VALUES ('일본', 3, '전자집적회로');
INSERT INTO exp_goods_asia VALUES ('일본', 4, '선박');
INSERT INTO exp_goods_asia VALUES ('일본', 5, '반도체웨이퍼');
INSERT INTO exp_goods_asia VALUES ('일본', 6, '화물차');
INSERT INTO exp_goods_asia VALUES ('일본', 7, '원유제외 석유류');
INSERT INTO exp_goods_asia VALUES ('일본', 8, '건설기계');
INSERT INTO exp_goods_asia VALUES ('일본', 9, '다이오드, 트랜지스터');
INSERT INTO exp_goods_asia VALUES ('일본', 10, '기계류');

COMMIT;

----------------------------------------------------------
----------------------------------------------------------
SELECT seq, goods
FROM exp_goods_asia
WHERE country = '한국'
UNION -- 단순 유니온은 중복을 제거함. 중복값 5개를 제하고 15개 출력.
SELECT seq, goods
FROM exp_goods_asia
WHERE country = '일본'
UNION
SELECT 10, '컴퓨터'
FROM dual;
----------------------------------------------------------
----------------------------------------------------------

SELECT goods
FROM exp_goods_asia
WHERE country = '한국'
UNION ALL -- 출력결과에 대한 결합. 중복제거 없음.
SELECT goods
FROM exp_goods_asia
WHERE country = '일본' ;

----------------------------------------------------------
----------------------------------------------------------

SELECT goods
FROM exp_goods_asia
WHERE country = '한국'
INTERSECT -- 공통으로 들고있는 행을 삭제(교집합)
SELECT goods
FROM exp_goods_asia
WHERE country = '일본' ;


----------------------------------------------------------
----------------------------------------------------------

SELECT goods
FROM exp_goods_asia
WHERE country = '한국'
MINUS -- 차집합
SELECT goods
FROM exp_goods_asia
WHERE country = '일본' ;
DESC exp_goods_asia;
----------------------------------------------------------
----------------------------------------------------------
SELECT TO_CHAR(department_id) as 부서
     , COUNT(*) 부서별직원수
FROM employees     
GROUP BY department_id
UNION
SELECT '전체'
     , COUNT(*) as 전체직원
FROM employees;   

-- EXISTS 존재하는지 안하는지
-- 세미 조인이라고 함.


-- job_history 테이블에 존재하는 부서 출력
SELECT a.department_id
    ,  a.department_name
FROM departments a    
WHERE EXISTS (SELECT *  --select 는 의미없음 where 의 내용에 해당되는
                        --데이터가 존재하는지만 체크
              FROM job_history b
              WHERE a.department_id = b.department_id);
              
-- job_history 테이블에 존재하지 않는 부서 출력
SELECT a.department_id
    ,  a.department_name
FROM departments a    
WHERE NOT EXISTS (SELECT *  -- NOT을 앞에 붙이면됨.                        
              FROM job_history b
              WHERE a.department_id = b.department_id);              


--수강내역이 없는 학생 조회
SELECT * FROM 학생 a
WHERE NOT EXISTS(SELECT *
                 FROM 수강내역 b
                 WHERE b.학번 = a.학번);
                 

/*
    정규 표현식 '검색', '치환' 하는 과정을 간편하게 처리할 수 있도록 하는 수단.
    oracle 은 10g부터 사용
    (JAVA, Python, JS 다 정규 표현식 사용가능) 조금씩 다름
    .(dot) or [] 은 모든 문자 1글자를 의미함
    '^' <- 시작을 의미함 '^[0-9]' <- 숫자로 시작하는
    '[^0-9]' <- 대괄호 안의 '^' <- NOT을 의미함.
    
    REGEXP_LIKE : 정규식 패턴을 검색
*/                 
SELECT *
FROM member
WHERE REGEXP_LIKE(mem_comtel, '^..-');
                 