
CREATE TABLE stocks(
    item_code VARCHAR2(10)
    ,stock_nm VARCHAR2(100)
    ,close_price VARCHAR2(100)
    ,compare_close VARCHAR2(100)
    ,create_at DATE

)
desc md_stocks;
CREATE TABLE TB_stock_bbs (
  item_code    VARCHAR2(10)
, discussionId VARCHAR2(100)
, bbs_title    VARCHAR2(1000)
, bbs_contents VARCHAR2(4000)
, create_date  DATE
, readCount    NUMBER
, gootCount    NUMBER
, badCount     NUMBER
, commentCount NUMBER
, update_date  DATE
, CONSTRAINT stock_bbs_pk PRIMARY KEY(item_code, discussionId)
)
desc tb_stock_bbs;
MERGE INTO tb_stock_bbs a
USING dual
ON (a.item_id = :1
    and a.discussionId = :2)  -- 데이터가 있어서 중복되었을때는
WHEN MATCHED THEN   -- 업데이트를 한다.
    UPDATE SET a.readCount = :3
            ,  a.goodCount = :4
            ,  a.badCount = :5
            ,  a.commentCount = :6
WHEN NOT MATCHED THEN -- 없으면 insert문으로 값을 넣는다.
    INSERT (a.item_code, a.discussionId, a.bbs_title, a.bbs_contents)
    VALUES (:7, :8, :9, :10);
    
SELECT a.item_code, a.stock_nm
    ,  sum(readcount) as read_cnt
    ,  sum(goodcount) as good_cnt
    ,  sum(badcount) as bad_cnt
    ,  sum(commentcount) as comment_cnt
FROM tb_stock_bbs b, md_stocks a
where a.item_code = b.item_code
and regexp_like(a.stock_nm, '^[가-힝]+$')
order by readcount desc;   
select * from  md_stocks;
    