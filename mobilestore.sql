
---------------------Title : MOBILE STORE ------------------------
create table brand(bid number(3) primary key,bname varchar2(15));

insert into brand values(1,'samsung');
insert into brand values(2,'nokia');
insert into brand values(3,'oppo');
insert into brand values(4,'vivo');
insert into brand values(5,'oneplus');

select * from brand;

create table model
  (bid number(3),
   mid number(5) primary key,
   mname varchar2(10),
   mprice number(10),
   m_dom date,
   mrating number(3),
   mstock number(5),
   mpurchases number(5),
  constraint fk_model foreign key(bid) references brand(bid));
  
insert into model values(1,1001,'galaxyj7',25000,'25-jan-19',NULL,51,NULL);
insert into model values(1,1002,'galaxym12',18000,'27-feb-19',NULL,35,NULL);
insert into model values(1,1003,'galaxys14',22000,'3-mar-19',NULL,44,NULL);
insert into model values(2,2001,'nokiag21',15499,'3-dec-18',NULL,22,NULL);
insert into model values(2,2002,'nokia5plus',5899,'3-mar-19',NULL,12,NULL);
insert into model values(2,2003,'nokia7.2',9999,'18-mar-19',NULL,78,NULL);

insert into model values(3,3001,'oppoF21',21999,'25-dec-19',NULL,71,NULL);
insert into model values(3,3002,'oppoA31',11990,'27-feb-20',NULL,45,NULL);
insert into model values(3,3003,'oppoA74',45995,'3-mar-20',NULL,74,NULL);
insert into model values(3,3004,'opporeno8',28680,'3-dec-20',NULL,66,NULL);
insert into model values(4,4001,'vivoY73',12990,'3-mar-19',NULL,32,NULL);
insert into model values(4,4002,'vivov21',23090,'18-mar-20',NULL,59,NULL);

insert into model values(5,5001,'oneplusCE2',28999,'18-apr-20',NULL,58,NULL);
insert into model values(5,5002,'onepl20pro',61999,'18-mar-20',NULL,23,NULL);

alter table model modify mname varchar2(20);

insert into model values(5,5003,'oneplusnord20',31999,'18-dec-20',NULL,28,NULL);

select * from model;

create sequence cust_seq
    minvalue 1
    start with 501
    increment by 1;
    

 create table customer
    (cid number(5) primary key,
    cname varchar2(15),
    cphno number(10),
    crating number(3),
    cdate date,
    purchased_mid number(4),
   constraint fk_customer foreign key(purchased_mid) references model(mid));
   
set serveroutput on;

---------display details of all mobiles
CREATE OR REPLACE PROCEDURE p1 is
         cursor cc1 is
         select b.bid,b.bname,m.mname,m.mprice from brand b inner join model m on b.bid=m.bid;
         vcc1 cc1%ROWTYPE;
         Begin
         open cc1;
         loop
         fetch cc1 into vcc1;
           exit when cc1%NOTFOUND;
           DBMS_OUTPUT.PUT_LINE(vcc1.bid||'  '||vcc1.bname||'   '||vcc1.mname||'  '||vcc1.mprice);
         end loop;
        close cc1;
         end;
         
EXEC p1;

----------------display details as per price filters and mobile brand
create or replace procedure p2(a IN number,x IN number,y IN varchar2) is
            cursor cc1(a number,x number,y varchar2) is
            select b.bid,b.bname,m.mname,m.mprice from brand b inner join model m on b.bid=m.bid where
             m.mprice>=a and m.mprice<=x and b.bname=y;
            vcc1 cc1%ROWTYPE;
            Begin
            open cc1(a,x,y);
            --open cc1(&min,&max,'&mobile');
            loop
            fetch cc1 into vcc1;
              exit when cc1%NOTFOUND;
              DBMS_OUTPUT.PUT_LINE(vcc1.bid||'  '||vcc1.bname||'   '||vcc1.mname||'  '||vcc1.mprice);
            end loop;
           close cc1;
           EXCEPTION when others then
             dbms_output.put_line('data not found');
            end;

exec p2(&min_amt,&max_amt,'&mobilename');

/*
declare
opt number(1):=&1_2;
begin
if (opt=1) then
p1;
else
p2;
end if;
end;    */
UPDATE MODEL SET MPURCHASES=0 WHERE MPURCHASES IS NULL;
UPDATE MODEL SET MRATING=0 WHERE MRATING IS NULL;

--------------updating customer data and customer ratings
create or replace procedure p3(vcname customer.cname%type,vcphno customer.cphno%type,vcrating customer.crating%type,
vpurchased_mid customer.purchased_mid%type) is
begin
insert into customer(cid,cname,cphno,crating,cdate,purchased_mid) values(cust_seq.nextval,vcname,vcphno,vcrating,sysdate,vpurchased_mid);
update model set mstock=mstock-1,mpurchases=mpurchases+1,mrating=(mrating+vcrating)/2 where mid=vpurchased_mid and mrating!=0;
update model set mstock=mstock-1,mpurchases=mpurchases+1,mrating=vcrating where mid=vpurchased_mid and mrating=0;

commit;
dbms_output.put_line('data inserted');
end;

exec p3('&entername',&phno,&rate_it_12345,'&mobileid_mid');

select * from customer;                ------table updated with data
select * from model;                   --------table updated with stock details and ratings 



 








         















