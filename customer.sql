
  CREATE TABLE "CUSTOMER" 
   (	"NUME" VARCHAR2(30 CHAR), 
	"PRENUME" VARCHAR2(30 CHAR), 
	"EMAIL" VARCHAR2(100 CHAR), 
	"ID" NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  NOT NULL ENABLE, 
	"ROL" VARCHAR2(30 CHAR), 
	 CONSTRAINT "CUSTOMER_PK" PRIMARY KEY ("ID")
  USING INDEX  ENABLE
   ) ;