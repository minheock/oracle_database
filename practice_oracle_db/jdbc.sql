 CREATE TABLE board(
    board_no NUMBER(10) PRIMARY KEY
    ,board_title VARCHAR2(1000)
    ,board_content VARCHAR2(4000)
    ,mem_id VARCHAR2(100)
    ,create_date DATE DEFAULT SYSDATE
    ,update_date DATE DEFAULT SYSDATE
 );
 
 ALTER TABLE board ADD CONSTRAINT fk_board FOREIGN KEY(mem_id) REFERENCES member(mem_id);
 INSERT INTO board(board_no, board_title, board_content, mem_id)
 VALUES((SELECT NVL(MAX(board_no), 0) + 1
        FROM board)
        , '°øÁö»çÇ×'
        , 'Ã¹¹øÂ° ±Û'
        , 'admin');
SELECT a.board_no
    ,  a.board_title
    ,  a.board_content
    ,  b.mem_id
    ,  b.mem_nm
    ,  a.create_date
    ,  a.update_date
FROM board a, member b
WHERE a.mem_id = b.mem_id
ORDER BY a.update_date desc;
commit; 
SELECT * FROM BOARD;
-- ½ºÇÁ¸µ ´ñ±Û Å×ÀÌºí

CREATE TABLE replys(
    reply_no NUMBER
   ,board_no NUMBER(10)
   ,mem_id VARCHAR2 (100)
   ,reply_content VARCHAR2 (1000)
   ,reply_date DATE DEFAULT SYSDATE
   ,del_yn VARCHAR2(1) DEFAULT 'N'
);

INSERT INTO replys (reply_no, board_no, mem_id, reply_content)
VALUES(1, 4, 'admin', '1566423');
select*from replys;
SELECT a.reply_no
    ,  a.mem_id
    ,  b.mem_nm
    ,  a.reply_content
    ,  TO_CHAR(a.reply_date, 'MM/DD HH24:MI') as reply_date
FROM replys a, member b
WHERE a.mem_id = b.mem_id
AND a.reply_no = 1;
ALTER TABLE replys ADD CONSTRAINT pk_reply PRIMARY KEY(reply_no);
ALTER TABLE replys ADD CONSTRAINT fk_board2 FOREIGN KEY(board_no) REFERENCES board(board_no);

SELECT a.reply_no
    ,  a.mem_id
    ,  b.mem_nm
    ,  a.reply_content
    ,  TO_CHAR(a.reply_date, 'MM/dd HH24:MI') as reply_date
FROM replys a, member b
WHERE a.mem_id = b.mem_id
AND a.board_no = 1
AND a.del_yn = 'N'
ORDER BY reply_date DESC;

commit;
select * from member;

DELETE FROM member 
WHERE mem_id = 'admin';

UPDATE member
SET mem_pw = '$2a$10$eW.s7iA8SJjULnpwTpofMu4xFbwWGlKiZWYe32fMQWSq2qozJDUDu'
WHERE mem_id = 'admin';
commit;

CREATE SEQUENCE seq_free_board
START WITH 1020;

INSERT INTO free_board(bo_no, bo_title,bo_category,bo_writer,bo_pass
,bo_content,bo_reg_date)
VALUES(seq_free_board.nextval,'¾ä¾ä¾ä','BC01','ÆØÀÚ¹®', '1234','abc',sysdate);


SELECT bo_no
, bo_title
,bo_category
,bo_writer
,bo_content
,b.comm_nm as bo_category_nm
FROM free_board a, comm_code b
WHERE a.bo_category = b.comm_cd
AND a.bo_no = 1041;

UPDATE free_board
SET bo_hit = bo_hit + 1
WHERE bo_no = 1041;


commit;
select * from free_board;


