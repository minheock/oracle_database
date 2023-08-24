----------6번 문제 ---------------------------------------------------
 -- 전체 상품별 '상품이름', '상품매출' 을 내림차순으로 구하시오 
SELECT product_name as 상품이름
    , sum(i.price * o.quantity) as 상품매출 
FROM item i, order_info o
WHERE i.item_id = o.item_id
GROUP BY i.product_name
ORDER BY 2 desc;
-----------------------------------------------------------------------------
---------- 7번 문제 ---------------------------------------------------
-- 모든상품의 월별 매출액을 구하시오 
-- 매출월, SPECIAL_SET, PASTA, PIZZA, SEA_FOOD, STEAK, SALAD_BAR, SALAD, SANDWICH, WINE, JUICE
SELECT SUBSTR(o.reserv_no, 1, 6) as 매출월
    ,  nvl(SUM(DECODE(i.item_id, 'M0001', i.price * o.quantity)),0) as SPECIAL_SET
    ,  nvl(SUM(DECODE(i.item_id, 'M0002', i.price * o.quantity)),0) as PASTA
    ,  nvl(SUM(DECODE(i.item_id, 'M0003', i.price * o.quantity)),0) as PIZZA
    ,  nvl(SUM(DECODE(i.item_id, 'M0004', i.price * o.quantity)),0) as SEA_FOOD
    ,  nvl(SUM(DECODE(i.item_id, 'M0005', i.price * o.quantity)),0) as STEAK
    ,  nvl(SUM(DECODE(i.item_id, 'M0006', i.price * o.quantity)),0) as SALAD_BAR
    ,  nvl(SUM(DECODE(i.item_id, 'M0007', i.price * o.quantity)),0) as SALAD
    ,  nvl(SUM(DECODE(i.item_id, 'M0008', i.price * o.quantity)),0) as SANDWICH
    ,  nvl(SUM(DECODE(i.item_id, 'M0009', i.price * o.quantity)),0) as WINE
    ,  nvl(SUM(DECODE(i.item_id, 'M0010', i.price * o.quantity)),0) as JUICE
FROM order_info o, item i
WHERE i.item_id = o.item_id
GROUP BY SUBSTR(o.reserv_no, 1, 6)
ORDER BY 1;
----------------------------------------------------------------------------
---------- 8번 문제 ---------------------------------------------------
-- 월별 온라인_전용 상품 매출액을 일요일부터 월요일까지 구분해 출력하시오 
-- 날짜, 상품명, 일요일, 월요일, 화요일, 수요일, 목요일, 금요일, 토요일의 매출을 구하시오
desc order_info;
SELECT SUBSTR(o.reserv_no, 1, 6) as 날짜
    ,  i.product_name as 상품명
    ,  NVL(SUM(DECODE(TO_CHAR(TO_DATE(SUBSTR(o.reserv_no, 1,8),'YYYYMMDD'), 'day'), '일요일', i.price * o.quantity)), '0')as 일요일
    ,  NVL(SUM(DECODE(TO_CHAR(TO_DATE(SUBSTR(o.reserv_no, 1,8),'YYYYMMDD'), 'day'), '월요일', i.price * o.quantity)), '0')as 월요일
    ,  NVL(SUM(DECODE(TO_CHAR(TO_DATE(SUBSTR(o.reserv_no, 1,8),'YYYYMMDD'), 'day'), '화요일', i.price * o.quantity)), '0')as 화요일
    ,  NVL(SUM(DECODE(TO_CHAR(TO_DATE(SUBSTR(o.reserv_no, 1,8),'YYYYMMDD'), 'day'), '수요일', i.price * o.quantity)), '0')as 수요일
    ,  NVL(SUM(DECODE(TO_CHAR(TO_DATE(SUBSTR(o.reserv_no, 1,8),'YYYYMMDD'), 'day'), '목요일', i.price * o.quantity)), '0')as 목요일
    ,  NVL(SUM(DECODE(TO_CHAR(TO_DATE(SUBSTR(o.reserv_no, 1,8),'YYYYMMDD'), 'day'), '금요일', i.price * o.quantity)), '0')as 금요일
    ,  NVL(SUM(DECODE(TO_CHAR(TO_DATE(SUBSTR(o.reserv_no, 1,8),'YYYYMMDD'), 'day'), '토요일', i.price * o.quantity)), '0')as 토요일
FROM item i, order_info o
WHERE i.item_id = o.item_id
AND i.item_id = 'M0001'
GROUP BY SUBSTR(o.reserv_no, 1, 6), i.product_name
ORDER BY 1;

----------------------------------------------------------------------------
---------- 9번 문제 ----------------------------------------------------
--매출이력이 있는 고객의 주소, 우편번호, 해당지역 고객수를 출력하시오
SELECT address_detail as 주소
    ,  count(DISTINCT c.customer_id) as 카운팅
FROM customer c, address a, reservation r
WHERE c.zip_code = a.zip_code(+)
AND c.customer_id = r.customer_id(+)
AND r.cancel = 'N'
GROUP BY a.address_detail
ORDER BY 2 DESC;
----------------------------------------------------------------------------
-- 고객별 지점 (branch) 방문 횟수와 방문객의 합을 출력
-- 방문 횟수가 4번 이상 합을 출력하시오 (예약 취소건 제외) 정렬 (방문횟수 내림, 방문객수 내림)
select *from customer;
select *from address;
select *from reservation;
SELECT a.customer_id
    ,  a.customer_name
    ,  b.branch
    ,  COUNT(a.customer_id) as 지점방문횟수
    ,  sum(b.visitor_cnt) as 방문객수
FROM customer a, reservation b
WHERE a.customer_id = b.customer_id
AND b.cancel = 'N'
GROUP BY (a.customer_id, a.customer_name, b.branch)
HAVING  COUNT(a.customer_id) >= 4
ORDER BY 4 desc , 5 desc;

-- 가장 방문을 많이 한 고객의 그동안 구매한 품목별 합산 금액을 출력하시오.
-- W1338910
SELECT reserv_no
FROM reservation
WHERE cancel = 'N'
AND customer_id = 'W1338910';

SELECT (SELECT product_name FROM item  WHERE item_id = a.item_id) as category
    ,  sum(sales) as 구매합계
FROM order_info a
WHERE reserv_no IN (SELECT reserv_no
                    FROM reservation
                    WHERE cancel = 'N'
                    AND customer_id = (SELECT customer_id
                                        FROM(
                                        SELECT a.customer_id
                                            ,  a.customer_name
                                            ,  b.branch
                                            ,  COUNT(a.customer_id) as 지점방문횟수
                                            ,  sum(b.visitor_cnt) as 방문객수
                                        FROM customer a, reservation b
                                        WHERE a.customer_id = b.customer_id
                                        AND b.cancel = 'N'
                                        GROUP BY (a.customer_id, a.customer_name, b.branch)
                                        ORDER BY 4 desc , 5 desc
                                        )
                                        WHERE rownum <= 1)
 )
GROUP BY item_id;