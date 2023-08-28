/*
    PL/SQL ������ ���� ������ ����� Ư¡�� ��� ����ϱ� ����.
    DB ���ο��� ����Ǳ� ������ �ӵ��� �������� ����.
    
    �⺻ ������ ���(Block)�̶�� �ϸ� �̸���, �����, ����η� ������.
    �̸��δ� ����� ��Ī�� ���µ� ������ ���� �͸� ����� �ȴ�.
*/

DECLARE --�̸�����
    vi_num NUMBER;
BEGIN --����
    vi_num :=100; --:= �Ҵ��� �ǹ�
    DBMS_OUTPUT.PUT_LINE(vi_num); -- �ܼ� ����Ʈ
END; --�ݱ�
    -- ������ ������ ���� �� ����
    
DECLARE
    vs_emp_name VARCHAR2(80);
    vs_dep_name departments.department_name%TYPE; -- ���̺� �ִ� Ÿ�԰� ������
BEGIN
    SELECT a.emp_name, b.department_name
    INTO vs_emp_name, vs_dep_name -- ��� ����� ������ ��¹�.
    FROM employees a, departments b
    WHERE a.department_id = b.department_id
    AND a.employee_id = 100;
    DBMS_OUTPUT.PUT_LINE(vs_emp_name || ':' || vs_dep_name); 
END;

-- IF ��
DECLARE 
    vn_user_num NUMBER := TO_NUMBER(:userNm);
    vn_com_num NUMBER := 10;
BEGIN
    IF vn_user_num > vn_com_num THEN
        DBMS_OUTPUT.PUT_LINE('user ���ڰ� �� ŭ');
    ELSIF vn_user_num = vn_com_num THEN
        DBMS_OUTPUT.PUT_LINE('����');
    ELSE
        DBMS_OUTPUT.PUT_LINE('user ���ڰ� �� ����');
    END IF; -- IF �� ���� END IF�� ����.
END;


-- ������ �ʿ� ������ BEGIN
BEGIN
    DBMS_OUTPUT.PUT_LINE('3 * 3 = ' || 3*3);
END;    

/*
    ���Ի��� ���Խ��ϴ�. ^^
    ���� �й��� ���� ���� �й��� ã�� + 1�� �Ͽ� �й��� ���� �� 
    �л� ���̺� �������ּ���.
    ���� ���� ù �л��̶�� �ش� �⵵��  000001 �� �ٿ��� �й��� ����.
    
    1. ���� �⵵
    2. �й��� max ��
    3. 2. �й��� ���ڸ� 4�ڸ� �� ���س⵵ ��
    4. ���ǹ�
    5. INSERT
*/
SELECT TO_CHAR(SYSDATE, 'YYYY')
FROM DUAL;
SELECT MAX(�й�)
FROM �л�;

DECLARE
    vs_nm �л�.�̸�%TYPE       := :nm;
    vs_subject �л�.����%TYPE  := :sub;
    vn_year VARCHAR2(4)       := TO_CHAR(SYSDATE, 'YYYY');
    vn_max_num NUMBER;
    vn_make_num NUMBER;
BEGIN
    SELECT MAX(�й�)
    INTO vn_max_num
    FROM �л�;
    IF vn_year = SUBSTR(vn_max_num, 1, 4) THEN
        vn_make_num := vn_max_num + 1;
    ELSE
        vn_make_num := TO_NUMBER(vn_year || '000001');
    END IF;
    INSERT INTO �л�(�й�, �̸�, ����)
    VALUES (vn_make_num, vs_nm, vs_subject);
    COMMIT;
END;    

SELECT * FROM �л�;    

/*
    Loop ��
    �ܼ� Loop���� EXIT(Ż������) �ʼ�
    WHILE �� ���ۿ� ������ TRUE �̸� LOOP ����
    FOR �� IN �ʱ갪.. �ִ밪 1�� �ʱ갪���� �ִ񰪱��� ����
*/
DECLARE
    vn_gugudan NUMBER := 3;
    vn_i NUMBER       := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(vn_gugudan
                || '*' || vn_i || '=' || vn_gugudan * vn_i);
        vn_i := vn_i + 1;
        EXIT WHEN vn_i > 9; -- Ż������
    END LOOP;
END;
-- 2~9 �ܱ��� ���
DECLARE
    vn_gugudan NUMBER := 2;
    vn_i NUMBER       := 1;
BEGIN
    LOOP
    DBMS_OUTPUT.PUT_LINE(vn_gugudan||'��');
--    CONTINUE WHEN vn_gugudan = 5; -- �ش������϶� �Ʒ� �ǳʶ�
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

-- for��
BEGIN 
--    FOR i IN 1..9 -- 1~9���� 1�� ���� I�� ���� O �Ҵ� X
    FOR i IN REVERSE 1..9 -- 9 ~ 1���� 1�� ����
    LOOP
        DBMS_OUTPUT.PUT_LINE(2||'*'||i||'='||2*i);
    END LOOP;
END;    

/*
    ORACLE ����� �����Լ� pl/sql �� �ۼ�
    ����Ŭ �Լ��� ������ ���� ���� 1�� �־����.    
*/

-- �̸��� �Է¹޾� �й��� �����ϴ� �Լ� �ۼ�
-- input: varchar2, output:number
CREATE OR REPLACE FUNCTION fn_get_hakno (nm VARCHAR2)
    RETURN NUMBER
IS  -- �̸��ִ� ��� �ۼ��� ����δ� IS�� ����
    vn_hakno NUMBER;    
BEGIN
    SELECT �й�
    INTO vn_hakno
    FROM �л�
    WHERE �̸� = nm;
    RETURN vn_hakno;
END;

SELECT fn_get_hakno('�ּ���')
FROM dual;
select * from �л�;
select * from ����;
select * from ��������;
SELECT �̸�
    ,  SUM(����) as �Ѽ�������
FROM �л� a, ���� b, �������� c
WHERE a.�й� = c.�й�
AND b.�����ȣ = c.�����ȣ
GROUP BY �̸�;

-- �л��̸��� �Է¹޾� �Ѽ��� ������ �����ϴ� �Լ��� ����ÿ�
CREATE OR REPLACE FUNCTION vn_get_grades (nm varchar2)
    RETURN NUMBER
IS vn_grade NUMBER;    
BEGIN 
    SELECT SUM(����) as �Ѽ�������
    INTO vn_grade
    FROM �л� , ���� , �������� 
    WHERE �л�.�й� = ��������.�й�
    AND ����.�����ȣ = ��������.�����ȣ
    AND �̸� = nm;
    RETURN vn_grade;
END;    

SELECT nvl(vn_get_grades(a.�̸�), 0) �Ѽ�������
    ,  a.*
FROM �л� a
ORDER BY 1 DESC;   

/*
 fn_dday('20230829')
 d-day �� �Է¹޾� (YYYYMMDD)
 ���� ����              input:20230829 return: 1�� ����
 ���� ���� ������ ǥ��    input:20230827 return: 1�� ����
 �� �����ϴ� �Լ��� �ۼ��Ͻÿ�
 input : varchar2, output : varchar2
*/
SELECT CASE WHEN TO_DATE('20230713', 'YYYYMMDD') > TO_DATE(TO_CHAR(SYSDATE, 'YYYYMMDD'))
            THEN ABS(TO_DATE('20230713', 'YYYYMMDD') - TO_DATE(TO_CHAR(SYSDATE, 'YYYYMMDD')))||'�� ����'
            WHEN TO_DATE('20230713', 'YYYYMMDD') < TO_DATE(TO_CHAR(SYSDATE, 'YYYYMMDD'))
            THEN ABS(TO_DATE(TO_CHAR(SYSDATE, 'YYYYMMDD')) - TO_DATE('20230713', 'YYYYMMDD')) ||'�� ����'
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
            THEN ABS(TO_DATE(dt, 'YYYYMMDD') - TO_DATE(TO_CHAR(SYSDATE, 'YYYYMMDD')))||'�� ����'
            WHEN TO_DATE(dt, 'YYYYMMDD') < TO_DATE(TO_CHAR(SYSDATE, 'YYYYMMDD'))
            THEN ABS(TO_DATE(TO_CHAR(SYSDATE, 'YYYYMMDD')) - TO_DATE(dt, 'YYYYMMDD')) ||'�� ����'
            ELSE '�����Դϴ�.'
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