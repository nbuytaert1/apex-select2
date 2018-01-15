CREATE TABLE  "TEST_IG" 
   (	"ID" NUMBER, 
	"FIRST_LETTER" VARCHAR2(1), 
	"NAME_CODE" VARCHAR2(2), 
	"FIRST_LETTERS" VARCHAR2(100), 
	"NAME_CODES" VARCHAR2(200), 
	 CONSTRAINT "TEST_IG_PK" PRIMARY KEY ("ID")
  USING INDEX  ENABLE
   )
/


CREATE OR REPLACE EDITIONABLE TRIGGER  "BI_TEST_IG" 
  before insert on "TEST_IG"              
  for each row 
begin  
  if :NEW."ID" is null then
    select "TEST_IG_SEQ".nextval into :NEW."ID" from sys.dual;
  end if;
end;

/
ALTER TRIGGER  "BI_TEST_IG" ENABLE
/


