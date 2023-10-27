CREATE TABLE tb_user(
     user_id VARCHAR2(100) primary key
    ,user_pw VARCHAR2(100)
    ,user_nm VARCHAR2(100)
    ,user_mail VARCHAR2(100)
    ,user_mileage number
    ,create_dt DATE
    ,update_dt DATE DEFAULT SYSDATE
    ,use_yn VARCHAR2(1) DEFAULT 'Y'
);
-- select ~ insert 로 tb_user 테이블에 데이터 삽입
SELECT mem_id, mem_pass, mem_name, mem_mail, mem_mileage, sysdate
FROM member;

INSERT INTO tb_user(user_id, user_pw, user_nm, user_mail, user_mileage, create_dt)
SELECT mem_id, mem_pass, mem_name, mem_mail, mem_mileage, sysdate
FROM member;
commit;

SELECT *FROM tb_user;

INSERT INTO tb_user(user_id, 
                    user_pw,
                    user_nm, 
                    user_mileage)
VALUES ('a', 'a', 'a', 1);


UPDATE tb_user
SET user_nm = '팽하'
WHERE user_id = 'lee001';

INSERT INTO bbs(bbs_no, bbs_title, bbs_content,author_id)
SELECT bbs_seq.NEXTVAL, bbs_title||'_'||level
     , bbs_content||'_'||level, author_id
from bbs
where bbs_title is not null
CONNECT BY LEVEL <= 100;

INSERT INTO bbs(bbs_no, bbs_title, bbs_content,author_id)
SELECT bbs_seq.NEXTVAL,'게시글'||level
     , '내용'||level,'a001'
from dual
CONNECT BY LEVEL <= 100;

commit;
SELECT * FROM bbs;