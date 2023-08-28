/*
    PL/SQL 집합적 언어와 절차적 언어의 특징을 모두 사용하기 위함.
    DB 내부에서 수행되기 때문에 속도와 안정성이 높음.
    
    기본 단위를 블록(Block)이라고 하며 이름부, 선언부, 실행부로 구성됨.
    이름부는 블룩의 명칭이 오는데 생량할 때는 익명 블록이 된다.
*/

DECLARE --이름없음
    vi_num NUMBER;
BEGIN --열기
    vi_num :=100; --:= 할당의 의미
    DBMS_OUTPUT.PUT_LINE(vi_num); -- 콘솔 프린트
END; --닫기
    -- 실행은 영역을 선택 후 실행
    
DECLARE
    vs_emp_name VARCHAR2(80);
    vs_dep_name departments.department_name%TYPE; -- 테이블에 있는 타입과 사이즈
BEGIN
    SELECT a.emp_name, b.department_name
    INTO vs_emp_name, vs_dep_name -- 출력 결과를 변수에 담는법.
    FROM employees a, departments b
    WHERE a.department_id = b.department_id
    AND a.employee_id = 100;
    DBMS_OUTPUT.PUT_LINE(vs_emp_name || ':' || vs_dep_name); 
END;

-- IF 문
DECLARE 
    vn_user_num NUMBER := TO_NUMBER(:userNm);
    vn_com_num NUMBER := 10;
BEGIN
    IF vn_user_num > vn_com_num THEN
        DBMS_OUTPUT.PUT_LINE('user 숫자가 더 큼');
    ELSIF vn_user_num = vn_com_num THEN
        DBMS_OUTPUT.PUT_LINE('같음');
    ELSE
        DBMS_OUTPUT.PUT_LINE('user 숫자가 더 작음');
    END IF; -- IF 로 열고 END IF로 닫음.
END;


-- 선언이 필요 없으면 BEGIN
BEGIN
    DBMS_OUTPUT.PUT_LINE('3 * 3 = ' || 3*3);
END;    

/*
    신입생이 들어왔습니다. ^^
    기존 학번의 가장 높은 학번을 찾아 + 1을 하여 학번을 생성 후 
    학생 테이블에 저장해주세요.
    만약 올해 첫 학생이라면 해당 년도에  000001 을 붙여서 학번을 생성.
    
    1. 올해 년도
    2. 학번의 max 값
    3. 2. 학번의 앞자리 4자리 와 올해년도 비교
    4. 조건문
    5. INSERT
*/
SELECT TO_CHAR(SYSDATE, 'YYYY')
FROM DUAL;
SELECT MAX(학번)
FROM 학생;

DECLARE
    vs_nm 학생.이름%TYPE       := :nm;
    vs_subject 학생.전공%TYPE  := :sub;
    vn_year VARCHAR2(4)       := TO_CHAR(SYSDATE, 'YYYY');
    vn_max_num NUMBER;
    vn_make_num NUMBER;
BEGIN
    SELECT MAX(학번)
    INTO vn_max_num
    FROM 학생;
    IF vn_year = SUBSTR(vn_max_num, 1, 4) THEN
        vn_make_num := vn_max_num + 1;
    ELSE
        vn_make_num := TO_NUMBER(vn_year || '000001');
    END IF;
    INSERT INTO 학생(학번, 이름, 전공)
    VALUES (vn_make_num, vs_nm, vs_subject);
    COMMIT;
END;    

SELECT * FROM 학생;    

/*
    Loop 문
    단순 Loop문은 EXIT(탈출조건) 필수
    WHILE 은 시작에 조건이 TRUE 이면 LOOP 진입
    FOR 은 IN 초깃값.. 최대값 1씩 초깃값에서 최댓값까지 증가
*/
DECLARE
    vn_gugudan NUMBER := 3;
    vn_i NUMBER       := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(vn_gugudan
                || '*' || vn_i || '=' || vn_gugudan * vn_i);
        vn_i := vn_i + 1;
        EXIT WHEN vn_i > 9; -- 탈출조건
    END LOOP;
END;
-- 2~9 단까지 출력
DECLARE
    vn_gugudan NUMBER := 2;
    vn_i NUMBER       := 1;
BEGIN
    LOOP
    DBMS_OUTPUT.PUT_LINE(vn_gugudan||'단');
--    CONTINUE WHEN vn_gugudan = 5; -- 해당조건일때 아래 건너뜀
        LOOP  
            DBMS_OUTPUT.PUT_LINE(vn_gugudan
                || 'x' || vn_i || '=' || vn_gugudan * vn_i); 
                vn_i := vn_i + 1;
            EXIT WHEN vn_i > 9;
            END LOOP;
    IF vn_i > 9
        THEN vn_i := 1;
    END IF;
    vn_gugudan := vn_gugudan + 1;            
    EXIT WHEN vn_gugudan > 9;        
    END LOOP;
END;

-- for문
BEGIN 
--    FOR i IN 1..9 -- 1~9까지 1씩 증가 I는 참조 O 할당 X
    FOR i IN REVERSE 1..9 -- 9 ~ 1까지 1씩 감소
    LOOP
        DBMS_OUTPUT.PUT_LINE(2||'*'||i||'='||2*i);
    END LOOP;
END;    

/*
    ORACLE 사용자 정의함수 pl/sql 로 작성
    오라클 함수는 무조건 리턴 값이 1개 있어야함.    
*/

-- 이름을 입력받아 학번을 리턴하는 함수 작성
-- input: varchar2, output:number
CREATE OR REPLACE FUNCTION fn_get_hakno (nm VARCHAR2)
    RETURN NUMBER
IS  -- 이름있는 블록 작성시 선언부는 IS로 시작
    vn_hakno NUMBER;    
BEGIN
    SELECT 학번
    INTO vn_hakno
    FROM 학생
    WHERE 이름 = nm;
    RETURN vn_hakno;
END;

SELECT fn_get_hakno('최숙경')
FROM dual;
select * from 학생;
select * from 과목;
select * from 수강내역;
SELECT 이름
    ,  SUM(학점) as 총수강학점
FROM 학생 a, 과목 b, 수강내역 c
WHERE a.학번 = c.학번
AND b.과목번호 = c.과목번호
GROUP BY 이름;

-- 학생이름을 입력받아 총수강 학점을 리턴하는 함수를 만드시오
CREATE OR REPLACE FUNCTION vn_get_grades (nm varchar2)
    RETURN NUMBER
IS vn_grade NUMBER;    
BEGIN 
    SELECT SUM(학점) as 총수강학점
    INTO vn_grade
    FROM 학생 , 과목 , 수강내역 
    WHERE 학생.학번 = 수강내역.학번
    AND 과목.과목번호 = 수강내역.과목번호
    AND 이름 = nm;
    RETURN vn_grade;
END;    

SELECT nvl(vn_get_grades(a.이름), 0) 총수강학점
    ,  a.*
FROM 학생 a
ORDER BY 1 DESC;   

/*
 fn_dday('20230829')
 d-day 를 입력받아 (YYYYMMDD)
 남은 날은              input:20230829 return: 1일 남음
 지난 날은 음수로 표현    input:20230827 return: 1일 지남
 을 수행하는 함수를 작성하시오
 input : varchar2, output : varchar2
*/
SELECT CASE WHEN TO_DATE('20230713', 'YYYYMMDD') > TO_DATE(TO_CHAR(SYSDATE, 'YYYYMMDD'))
            THEN ABS(TO_DATE('20230713', 'YYYYMMDD') - TO_DATE(TO_CHAR(SYSDATE, 'YYYYMMDD')))||'일 남음'
            WHEN TO_DATE('20230713', 'YYYYMMDD') < TO_DATE(TO_CHAR(SYSDATE, 'YYYYMMDD'))
            THEN ABS(TO_DATE(TO_CHAR(SYSDATE, 'YYYYMMDD')) - TO_DATE('20230713', 'YYYYMMDD')) ||'일 지남'
            END 
FROM dual;

SELECT abs(TO_DATE('20231213','YYMMDD') - to_date(to_char(sysdate, 'YYMMDD')))
    ,  abs(to_date(to_char(sysdate, 'YYMMDD')) - TO_DATE('20230713','YYMMDD'))
FROM dual;



CREATE OR REPLACE FUNCTION fn_dday(dt varchar2)
    RETURN NUMBER
IS dday NUMBER;
BEGIN 
    SELECT CASE WHEN TO_DATE(dt, 'YYYYMMDD') > TO_DATE(TO_CHAR(SYSDATE, 'YYYYMMDD'))
            THEN ABS(TO_DATE(dt, 'YYYYMMDD') - TO_DATE(TO_CHAR(SYSDATE, 'YYYYMMDD')))||'일 남음'
            WHEN TO_DATE(dt, 'YYYYMMDD') < TO_DATE(TO_CHAR(SYSDATE, 'YYYYMMDD'))
            THEN ABS(TO_DATE(TO_CHAR(SYSDATE, 'YYYYMMDD')) - TO_DATE(dt, 'YYYYMMDD')) ||'일 지남'
            ELSE '오늘입니다.'
            END 
    INTO dday        
    FROM dual;
--    WHERE dday = SYSDATE;
    RETURN dday;
END;    
SELECT fn_dday('20230829')
    ,  fn_dday('20230827')
    ,  fn_dday('20231226')
FROM dual;