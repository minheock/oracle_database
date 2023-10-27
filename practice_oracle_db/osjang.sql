DROP TABLE os_user;
DROP TABLE os_item;

CREATE TABLE OS_USER(
 user_id	VARCHAR2(100) PRIMARY KEY
,user_pw	VARCHAR2(100)
,user_nm	VARCHAR2(100)
,user_mail	VARCHAR2(100)
,user_adress	VARCHAR2(100)
,profile_img VARCHAR2(1000)
,create_dt DATE
,use_yn VARCHAR2(1 BYTE) DEFAULT 'N'
);

CREATE TABLE OS_ITEM(
 item_no number(10) PRIMARY KEY
,item_name VARCHAR2(4000)
,item_color VARCHAR2(1000)
,item_brand VARCHAR2(1000)
,item_size VARCHAR2(1000)
,user_id VARCHAR2(100)
,img_url VARCHAR2(1000)
,item_category VARCHAR2(1000)
,create_dt DATE
,update_dt DATE DEFAULT SYSDATE
,item_yn VARCHAR2(1) DEFAULT 'N'
);
 ALTER TABLE os_item ADD CONSTRAINT fk_item FOREIGN KEY(user_id) REFERENCES os_user(user_id);
 ALTER TABLE os_item ADD item_price VARCHAR2(1000);
 desc os_user;
select * from os_item;
select * from os_user;
insert into os_item(
      item_no
     ,item_name
     ,item_color
     ,item_brand
     ,item_size
     ,item_category
     ,create_dt    
)VALUES(1, '나이키 에어맥스97', 'silver', '나이키', '270', 'shoes', SYSDATE);




 commit;
 select * from os_user;
 select * from os_item;
  SELECT  user_id
		 ,  user_mail
		 ,  user_adress
		 ,  user_pw
		 ,  user_nm					
		 ,  to_char(create_dt, 'yyyy-MM-dd HH:mm:ss') as create_dt
    FROM os_user;