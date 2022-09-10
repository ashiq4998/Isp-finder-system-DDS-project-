select * from price @site1;
select * from peakhour @site1;

SET SERVEROUTPUT ON;
SET VERIFY OFF;

Accept X CHAR prompt "ISP NAME="
Accept Y CHAR prompt "LOCATION="
Accept Z CHAR prompt "PACKAGE="

BEgin
	NULL;
END;
/
CREATE OR REPLACE PACKAGE mypack AS

	function totpack(name In ISpname.ispname%type)
	return int;

    PROCEDURE P1(B1 IN IspName.ISPNAME%TYPE,B2 IN Branches.Address%type,B3 IN Packagee.Packagee%type);
END mypack;
/



CREATE OR REPLACE PACKAGE BODY mypack AS


	function totpack(name In ISpname.ispname%type)
	return int
	is
	
	A int;
	begin 
	select count(*) into A from packagee inner join ispname on packagee.ispID=ispname.ispid where ispname=name;
	--DBMS_OUTPUT.PUT_LINE(A);
	
	return A;
	
	end totpack;
	
	



	PROCEDURE P1(B1 IN IspName.ISPNAME%TYPE,B2 IN Branches.Address%type,B3 IN Packagee.Packagee%type)
	IS
	checks int:=0;
	
Begin
	for R in (select peakhour, ping,price from IspName inner join Branches on Branches.IspID=IspName.IspID
				inner join Packagee on Packagee.IspID=IspName.IspID inner join Peakhour @site1 on packagee.ispid=peakhour.ispid
				inner join price @site1 on price.ispid=packagee.ispid where ispname.ispname=B1 and Branches.Address=B2 and
				Packagee.packagee=B3)loop
				DBMS_OUTPUT.PUT_lINE('Peakhour :'||R.Peakhour||' Ping: '||R.ping || ' Price :'||R.price||' For package '||B3 
				||' Provided by '||B1);
				checks:=checks+1;
	end loop;
	if checks=0 then
		DBMS_OUTPUT.PUT_LINE('NO Data found');
	end if;
	
	
	
	end p1;
	
	

	
END mypack;
/

DECLARE
	
	C VARCHAR2(20);
	D VARCHAR2(20);
	E VARCHAR2(20);
	F VARCHAR2(20);
	A int;
	
BEGIN
	
	C:='&X';
	D:='&y';
	E:= '&z';
	select distinct ispname into F  from ispname where ispname=c;
	
	mypack.P1(C,D,E);
	A:=mypack.totpack(C);
	DBMS_OUTPUT.PUT_LINE('No. of packages provided by '||C||' is '||A);
	

Exception
	When NO_DATA_Found then
	DBMS_OUTPUT.PUT_LINE('NO Such PRovider.');
	 	
	
	
END;
/

