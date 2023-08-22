----------6�� ���� ---------------------------------------------------
 -- ��ü ��ǰ�� '��ǰ�̸�', '��ǰ����' �� ������������ ���Ͻÿ� 
SELECT product_name as ��ǰ�̸�
    , sum(i.price * o.quantity) as ��ǰ���� 
FROM item i, order_info o
WHERE i.item_id = o.item_id
GROUP BY i.product_name
ORDER BY 2 desc;
-----------------------------------------------------------------------------
---------- 7�� ���� ---------------------------------------------------
-- ����ǰ�� ���� ������� ���Ͻÿ� 
-- �����, SPECIAL_SET, PASTA, PIZZA, SEA_FOOD, STEAK, SALAD_BAR, SALAD, SANDWICH, WINE, JUICE
SELECT SUBSTR(o.reserv_no, 1, 6) as �����
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
---------- 8�� ���� ---------------------------------------------------
-- ���� �¶���_���� ��ǰ ������� �Ͽ��Ϻ��� �����ϱ��� ������ ����Ͻÿ� 
-- ��¥, ��ǰ��, �Ͽ���, ������, ȭ����, ������, �����, �ݿ���, ������� ������ ���Ͻÿ�
desc order_info;
SELECT SUBSTR(o.reserv_no, 1, 6) as ��¥
    ,  i.product_name as ��ǰ��
    ,  NVL(SUM(DECODE(TO_CHAR(TO_DATE(SUBSTR(o.reserv_no, 1,8),'YYYYMMDD'), 'day'), '�Ͽ���', i.price * o.quantity)), '0')as �Ͽ���
    ,  NVL(SUM(DECODE(TO_CHAR(TO_DATE(SUBSTR(o.reserv_no, 1,8),'YYYYMMDD'), 'day'), '������', i.price * o.quantity)), '0')as ������
    ,  NVL(SUM(DECODE(TO_CHAR(TO_DATE(SUBSTR(o.reserv_no, 1,8),'YYYYMMDD'), 'day'), 'ȭ����', i.price * o.quantity)), '0')as ȭ����
    ,  NVL(SUM(DECODE(TO_CHAR(TO_DATE(SUBSTR(o.reserv_no, 1,8),'YYYYMMDD'), 'day'), '������', i.price * o.quantity)), '0')as ������
    ,  NVL(SUM(DECODE(TO_CHAR(TO_DATE(SUBSTR(o.reserv_no, 1,8),'YYYYMMDD'), 'day'), '�����', i.price * o.quantity)), '0')as �����
    ,  NVL(SUM(DECODE(TO_CHAR(TO_DATE(SUBSTR(o.reserv_no, 1,8),'YYYYMMDD'), 'day'), '�ݿ���', i.price * o.quantity)), '0')as �ݿ���
    ,  NVL(SUM(DECODE(TO_CHAR(TO_DATE(SUBSTR(o.reserv_no, 1,8),'YYYYMMDD'), 'day'), '�����', i.price * o.quantity)), '0')as �����
FROM item i, order_info o
WHERE i.item_id = o.item_id
AND i.item_id = 'M0001'
GROUP BY SUBSTR(o.reserv_no, 1, 6), i.product_name
ORDER BY 1;

----------------------------------------------------------------------------
---------- 9�� ���� ----------------------------------------------------
--�����̷��� �ִ� ���� �ּ�, �����ȣ, �ش����� ������ ����Ͻÿ�
SELECT address_detail as �ּ�
    ,  count(DISTINCT c.customer_id) as ī����
FROM customer c, address a, reservation r
WHERE c.zip_code = a.zip_code(+)
AND c.customer_id = r.customer_id(+)
AND r.cancel = 'N'
GROUP BY a.address_detail
ORDER BY 2 DESC;
----------------------------------------------------------------------------