--ANSI OUTER JOIN
SELECT a.mem_id
      ,a.mem_name
      ,COUNT(DISTINCT b.cart_no) as Ä«Æ®»ç¿ëÈ½¼ö
      ,COUNT(c.prod_id) as Ç°¸ñ¼ö
FROM member a
LEFT OUTER JOIN cart b
ON(a.mem_id = b.cart_member)
LEFT OUTER JOIN prod c
ON(b.cart_prod = c.prod_id)
GROUP BY a.mem_id, a.mem_name;

-- ÁýÇÕ ¿¬»êÀÚ UNION ------------------------------------------------------------------------

CREATE TABLE exp_goods_asia (
       country VARCHAR2(10),
       seq     NUMBER,
       goods   VARCHAR2(80));

INSERT INTO exp_goods_asia VALUES ('ÇÑ±¹', 1, '¿øÀ¯Á¦¿Ü ¼®À¯·ù');
INSERT INTO exp_goods_asia VALUES ('ÇÑ±¹', 2, 'ÀÚµ¿Â÷');
INSERT INTO exp_goods_asia VALUES ('ÇÑ±¹', 3, 'ÀüÀÚÁýÀûÈ¸·Î');
INSERT INTO exp_goods_asia VALUES ('ÇÑ±¹', 4, '¼±¹Ú');
INSERT INTO exp_goods_asia VALUES ('ÇÑ±¹', 5,  'LCD');
INSERT INTO exp_goods_asia VALUES ('ÇÑ±¹', 6,  'ÀÚµ¿Â÷ºÎÇ°');
INSERT INTO exp_goods_asia VALUES ('ÇÑ±¹', 7,  'ÈÞ´ëÀüÈ­');
INSERT INTO exp_goods_asia VALUES ('ÇÑ±¹', 8,  'È¯½ÄÅºÈ­¼ö¼Ò');
INSERT INTO exp_goods_asia VALUES ('ÇÑ±¹', 9,  '¹«¼±¼Û½Å±â µð½ºÇÃ·¹ÀÌ ºÎ¼ÓÇ°');
INSERT INTO exp_goods_asia VALUES ('ÇÑ±¹', 10,  'Ã¶ ¶Ç´Â ºñÇÕ±Ý°­');

INSERT INTO exp_goods_asia VALUES ('ÀÏº»', 1, 'ÀÚµ¿Â÷');
INSERT INTO exp_goods_asia VALUES ('ÀÏº»', 2, 'ÀÚµ¿Â÷ºÎÇ°');
INSERT INTO exp_goods_asia VALUES ('ÀÏº»', 3, 'ÀüÀÚÁýÀûÈ¸·Î');
INSERT INTO exp_goods_asia VALUES ('ÀÏº»', 4, '¼±¹Ú');
INSERT INTO exp_goods_asia VALUES ('ÀÏº»', 5, '¹ÝµµÃ¼¿þÀÌÆÛ');
INSERT INTO exp_goods_asia VALUES ('ÀÏº»', 6, 'È­¹°Â÷');
INSERT INTO exp_goods_asia VALUES ('ÀÏº»', 7, '¿øÀ¯Á¦¿Ü ¼®À¯·ù');
INSERT INTO exp_goods_asia VALUES ('ÀÏº»', 8, '°Ç¼³±â°è');
INSERT INTO exp_goods_asia VALUES ('ÀÏº»', 9, '´ÙÀÌ¿Àµå, Æ®·£Áö½ºÅÍ');
INSERT INTO exp_goods_asia VALUES ('ÀÏº»', 10, '±â°è·ù');

COMMIT;

----------------------------------------------------------
----------------------------------------------------------
select * from exp_goods_asia;


SELECT seq, goods
FROM exp_goods_asia
WHERE country = 'ÇÑ±¹'
UNION -- ´Ü¼ø À¯´Ï¿ÂÀº Áßº¹À» Á¦°ÅÇÔ. Áßº¹°ª 5°³¸¦ Á¦ÇÏ°í 15°³ Ãâ·Â.
SELECT seq, goods
FROM exp_goods_asia
WHERE country = 'ÀÏº»'
UNION
SELECT 10, 'ÄÄÇ»ÅÍ'
FROM dual;
----------------------------------------------------------
----------------------------------------------------------

SELECT goods
FROM exp_goods_asia
WHERE country = 'ÇÑ±¹'
UNION ALL -- Ãâ·Â°á°ú¿¡ ´ëÇÑ °áÇÕ. Áßº¹Á¦°Å ¾øÀ½.
SELECT goods
FROM exp_goods_asia
WHERE country = 'ÀÏº»' ;

----------------------------------------------------------
----------------------------------------------------------

SELECT goods
FROM exp_goods_asia
WHERE country = 'ÇÑ±¹'
INTERSECT -- °øÅëÀ¸·Î µé°íÀÖ´Â ÇàÀ» »èÁ¦(±³ÁýÇÕ)
SELECT goods
FROM exp_goods_asia
WHERE country = 'ÀÏº»' ;


----------------------------------------------------------
----------------------------------------------------------

SELECT goods
FROM exp_goods_asia
WHERE country = 'ÇÑ±¹'
MINUS -- Â÷ÁýÇÕ
SELECT goods
FROM exp_goods_asia
WHERE country = 'ÀÏº»' ;
DESC exp_goods_asia;
----------------------------------------------------------
----------------------------------------------------------
SELECT TO_CHAR(department_id) as ºÎ¼­
     , COUNT(*) ºÎ¼­º°Á÷¿ø¼ö
FROM employees     
GROUP BY department_id
UNION
SELECT 'ÀüÃ¼'
     , COUNT(*) as ÀüÃ¼Á÷¿ø
FROM employees;   

-- EXISTS Á¸ÀçÇÏ´ÂÁö ¾ÈÇÏ´ÂÁö
-- ¼¼¹Ì Á¶ÀÎÀÌ¶ó°í ÇÔ.


-- job_history Å×ÀÌºí¿¡ Á¸ÀçÇÏ´Â ºÎ¼­ Ãâ·Â
SELECT a.department_id
    ,  a.department_name
FROM departments a    
WHERE EXISTS (SELECT *  --select ´Â ÀÇ¹Ì¾øÀ½ where ÀÇ ³»¿ë¿¡ ÇØ´çµÇ´Â
                        --µ¥ÀÌÅÍ°¡ Á¸ÀçÇÏ´ÂÁö¸¸ Ã¼Å©
              FROM job_history b
              WHERE a.department_id = b.department_id);
              
-- job_history Å×ÀÌºí¿¡ Á¸ÀçÇÏÁö ¾Ê´Â ºÎ¼­ Ãâ·Â
SELECT a.department_id
    ,  a.department_name
FROM departments a    
WHERE NOT EXISTS (SELECT *  -- NOTÀ» ¾Õ¿¡ ºÙÀÌ¸éµÊ.                        
              FROM job_history b
              WHERE a.department_id = b.department_id);              


--¼ö°­³»¿ªÀÌ ¾ø´Â ÇÐ»ý Á¶È¸
SELECT * FROM ÇÐ»ý a
WHERE NOT EXISTS(SELECT *
                 FROM ¼ö°­³»¿ª b
                 WHERE b.ÇÐ¹ø = a.ÇÐ¹ø);
                 

/*
    Á¤±Ô Ç¥Çö½Ä '°Ë»ö', 'Ä¡È¯' ÇÏ´Â °úÁ¤À» °£ÆíÇÏ°Ô Ã³¸®ÇÒ ¼ö ÀÖµµ·Ï ÇÏ´Â ¼ö´Ü.
    oracle Àº 10gºÎÅÍ »ç¿ë
    (JAVA, Python, JS ´Ù Á¤±Ô Ç¥Çö½Ä »ç¿ë°¡´É) Á¶±Ý¾¿ ´Ù¸§
    .(dot) or [] Àº ¸ðµç ¹®ÀÚ 1±ÛÀÚ¸¦ ÀÇ¹ÌÇÔ
    '^' <- ½ÃÀÛÀ» ÀÇ¹ÌÇÔ '^[0-9]' <- ¼ýÀÚ·Î ½ÃÀÛÇÏ´Â
    '[^0-9]' <- ´ë°ýÈ£ ¾ÈÀÇ '^' <- NOTÀ» ÀÇ¹ÌÇÔ.
    
    REGEXP_LIKE : Á¤±Ô½Ä ÆÐÅÏÀ» °Ë»ö
*/                 

/*
    ¹Ýº¹ ½ÃÄý
    * : 0°³ ÀÌ»ó
    + : 1°³ ÀÌ»ó
    ? : 0, 1°³
    {n} : n¹ø
    {n,} : n¹ø ÀÌ»ó
    {n,m} : n¹ø ÀÌ»ó m¹ø ÀÌÇÏ
*/
SELECT *
FROM member
WHERE REGEXP_LIKE(mem_comtel, '^..-');

-- ¿µ¹®ÀÚ 3¹ø ÃâÇö @ ÆÐÅÏ Á¶È¸ (abc@gmail.com)
SELECT *
FROM member
WHERE REGEXP_LIKE(mem_mail, '^[a-zA-Z]{3,6}@');   

-- mem_add2 ¹®ÀÚ ¶ç¾î¾²±â ¹®ÀÚ ÆÐÅÏÀÇ µ¥ÀÌÅÍ¸¦ Ãâ·ÂÇÏ½Ã¿À
SELECT mem_name
    ,  mem_add2
FROM member
--WHERE REGEXP_LIKE(mem_add2,'. '); -- ¾î´À¹®ÀÚµç ¶ç¾î¹ö·Á
--WHERE REGEXP_LIKE(mem_add2,'[°¡-ÆR] [0-9]'); -- ÇÑ±Û
--WHERE REGEXP_LIKE(mem_add2,'[°¡-ÆR]$'); -- ÇÑ±Û·Î³¡³ª´Â  
                                       --$ -> ³¡³ª´Â
--WHERE REGEXP_LIKE(mem_add2,'^[^°¡-ÆR]*$'); --ÇÑ±ÛÀÌ¾ø´Â
WHERE not REGEXP_LIKE(mem_add2,'[°¡-ÆR]'); --ÇÑ±ÛÀÌ¾ø´Â
/*
    | <- ¶Ç´Â
    () <- ÆÐÅÏ±×·ì
    J·Î ½ÃÀÛÇÏ¸ç, ¼¼¹øÂ° ¹®ÀÚ°¡ M¶Ç´Â NÀÎ Á÷¿øÀÌ¸§ Á¶È¸
*/
SELECT emp_name
FROM employees
WHERE REGEXP_LIKE(emp_name, '^J.(n|m)');

-- REGEXP_SUBSTR Á¤±ÔÇ¥Çö½Ä ÆÐÅÏÀ» ÀÏÄ¡ÇÏ´Â ¹®ÀÚ¿­ ¹ÝÈ¯
-- ÀÌ¸ÞÀÏ @¸¦ ±âÁØÀ¸·Î ¾Õ°ú µÚ¸¦ Ãâ·ÂÇÏ½Ã¿À
                          --ÆÐÅÏ, ½ÃÀÛÀ§Ä¡, ¸ÅÄª¼ø¹ø
SELECT REGEXP_SUBSTR(mem_mail, '[^@]+',1,1) as mem_id
      ,REGEXP_SUBSTR(mem_mail, '[^@]+', 1, 2) as mem_domain
FROM member;      

SELECT REGEXP_SUBSTR('A-B-C', '[^-]+', 1,1) as a
    ,  REGEXP_SUBSTR('A-B-C', '[^-]+', 1,2) as b
    ,  REGEXP_SUBSTR('A-B-C', '[^-]+', 1,3) as c
FROM dual;    

SELECT REGEXP_SUBSTR('pang su hi 1234', '[0-9]')    --default 1,1
    ,  REGEXP_SUBSTR('pang su hi 1234', '[^0-9]')
    ,  REGEXP_SUBSTR('pang su hi 1234', '[^0-9]+')
FROM dual;    

-- ¶ç¾î¾²±â¸¦ ±âÁØÀ¸·Î 2¹øÂ° ÃâÇöÇÏ´Â ÁÖ¼Ò¸¦ Ãâ·ÂÇÏ½Ã¿À.
SELECT mem_add1
FROM member;
SELECT REGEXP_SUBSTR(mem_add1,'[^ ]+', 1,2)
FROM member;
-- ¶ç¾î¾²±â°¡ ÇÑ±ÛÀÌ ¾Æ´Ï´Ï±ñ ÇÑ±ÛÀÇ 2¹øÂ°¸¦ Ãâ·Â°¡´É
SELECT REGEXP_SUBSTR(mem_add1,'[°¡-ÆR]+', 1,2)
FROM member;

SELECT * 
FROM(
SELECT 'abcd1234' as id FROM dual
UNION
SELECT 'Abcd123456' as id FROM dual
UNION
SELECT 'A1234' as id FROM dual
UNION
SELECT 'A12345678964646545' as id FROM dual
)
WHERE REGEXP_LIKE(id, '^[a-zA-Z1-9]{8,14}$') -- 8 ~ 14 »çÀÌ ÅØ½ºÆ® ¸¸Á·ÇÏ´Â µ¥ÀÌÅÍÃâ·Â.
;