-- META DATA
RENAME TABLE SBI_GL_TABLE TO SBI_META_TABLE;
ALTER TABLE SBI_META_TABLE CHANGE LABEL NAME VARCHAR(100);
ALTER TABLE SBI_META_TABLE ADD SOURCE_ID INT(11) NOT NULL AFTER NAME;
ALTER TABLE SBI_META_TABLE ADD DELETED BOOLEAN NOT NULL DEFAULT FALSE AFTER NAME;

RENAME TABLE SBI_GL_BNESS_CLS TO SBI_META_BC;
ALTER TABLE SBI_META_BC CHANGE UNIQUE_IDENTIFIER  NAME VARCHAR(100);
-- next stmt add a relation to SBI_META_MODELS (delete the explicit name model field)
ALTER TABLE SBI_META_BC ADD MODEL_ID INT(11) NOT NULL AFTER BC_ID;

-- set original values for the model referenced
UPDATE SBI_META_BC DEST, (SELECT ID, NAME FROM SBI_META_MODELS) SRC 
SET DEST.MODEL_ID = SRC.ID 
WHERE SRC.NAME = DEST.DATAMART_NAME;
ALTER TABLE SBI_META_BC DROP COLUMN DATAMART_NAME;

CREATE TABLE SBI_META_SOURCE (
	SOURCE_ID 				INT(11) NOT NULL AUTO_INCREMENT,
	NAME 					VARCHAR(100) NOT NULL,
	TYPE 					VARCHAR(100) NOT NULL,
	URL 					VARCHAR(100) NULL,
	LOCATION 				VARCHAR(100) NULL,
	SOURCE_SCHEMA 			VARCHAR(100) NULL,
	SOURCE_CATALOGUE		VARCHAR(100) NULL,
	USER_IN 				VARCHAR(100) NOT NULL,
	USER_UP 				VARCHAR(100) NULL DEFAULT NULL,
	USER_DE 				VARCHAR(100) NULL DEFAULT NULL,
	TIME_IN 				TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	TIME_UP 				TIMESTAMP NULL DEFAULT NULL,
	TIME_DE 				TIMESTAMP NULL DEFAULT NULL,
	SBI_VERSION_IN 			VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_UP 			VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_DE 			VARCHAR(10) NULL DEFAULT NULL,
	META_VERSION 			VARCHAR(100) NULL DEFAULT NULL,
	ORGANIZATION 			VARCHAR(20) NULL DEFAULT NULL,
	
	PRIMARY KEY (SOURCE_ID)
) ENGINE=InnoDB ;

/*
CREATE TABLE SBI_META_TABLE  (
	TABLE_ID 				INT(11) NOT NULL AUTO_INCREMENT,
	SOURCE_ID 				INT(11) NOT NULL,
	NAME 					VARCHAR(100) NOT NULL,
	DELETED					BOOLEAN NOT NULL DEFAULT FALSE,
	USER_IN 				VARCHAR(100) NOT NULL,
	USER_UP 				VARCHAR(100) NULL DEFAULT NULL,
	USER_DE 				VARCHAR(100) NULL DEFAULT NULL,
	TIME_IN 				TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	TIME_UP 				TIMESTAMP NULL DEFAULT NULL,
	TIME_DE 				TIMESTAMP NULL DEFAULT NULL,
	SBI_VERSION_IN 			VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_UP 			VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_DE 			VARCHAR(10) NULL DEFAULT NULL,
	META_VERSION 			VARCHAR(100) NULL DEFAULT NULL,
	ORGANIZATION 			VARCHAR(20) NULL DEFAULT NULL,
	
	PRIMARY KEY (TABLE_ID)
) ENGINE=InnoDB ;
*/

CREATE TABLE SBI_META_TABLE_COLUMN  (
	COLUMN_ID 				INT(11) NOT NULL AUTO_INCREMENT,
	TABLE_ID 				INT(11) NOT NULL,
	NAME 					VARCHAR(100) NOT NULL,
	TYPE					VARCHAR(100) NOT NULL,
	DELETED					BOOLEAN NOT NULL DEFAULT FALSE,
	USER_IN 				VARCHAR(100) NOT NULL,
	USER_UP 				VARCHAR(100) NULL DEFAULT NULL,
	USER_DE 				VARCHAR(100) NULL DEFAULT NULL,
	TIME_IN 				TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	TIME_UP 				TIMESTAMP NULL DEFAULT NULL,
	TIME_DE 				TIMESTAMP NULL DEFAULT NULL,
	SBI_VERSION_IN 			VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_UP 			VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_DE 			VARCHAR(10) NULL DEFAULT NULL,
	META_VERSION 			VARCHAR(100) NULL DEFAULT NULL,
	ORGANIZATION 			VARCHAR(20) NULL DEFAULT NULL,
	
	PRIMARY KEY (COLUMN_ID)
) ENGINE=InnoDB ;

/*
CREATE TABLE SBI_META_BC  (
	BC_ID 					INT(11) NOT NULL AUTO_INCREMENT,
	MODEL_ID				INT(11) NOT NULL,
	NAME					VARCHAR(100) NOT NULL,
	DELETED					BOOLEAN NOT NULL DEFAULT FALSE,
	USER_IN 				VARCHAR(100) NOT NULL,
	USER_UP 				VARCHAR(100) NULL DEFAULT NULL,
	USER_DE 				VARCHAR(100) NULL DEFAULT NULL,
	TIME_IN 				TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	TIME_UP 				TIMESTAMP NULL DEFAULT NULL,
	TIME_DE 				TIMESTAMP NULL DEFAULT NULL,
	SBI_VERSION_IN 			VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_UP 			VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_DE 			VARCHAR(10) NULL DEFAULT NULL,
	META_VERSION 			VARCHAR(100) NULL DEFAULT NULL,
	ORGANIZATION 			VARCHAR(20) NULL DEFAULT NULL,
	
	PRIMARY KEY (BC_ID)
) ENGINE=InnoDB ;
*/
CREATE TABLE SBI_META_BC_ATTRIBUTE  (
	ATTRIBUTE_ID 			INT(11) NOT NULL AUTO_INCREMENT,
	BC_ID					INT(11) NULL,
	COLUMN_ID				INT(11) NULL,
	NAME					VARCHAR(100) NOT NULL,
	TYPE					VARCHAR(100) NULL,
	DELETED					BOOLEAN NOT NULL DEFAULT FALSE,
	USER_IN 				VARCHAR(100) NOT NULL,
	USER_UP 				VARCHAR(100) NULL DEFAULT NULL,
	USER_DE 				VARCHAR(100) NULL DEFAULT NULL,
	TIME_IN 				TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	TIME_UP 				TIMESTAMP NULL DEFAULT NULL,
	TIME_DE 				TIMESTAMP NULL DEFAULT NULL,
	SBI_VERSION_IN 			VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_UP 			VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_DE 			VARCHAR(10) NULL DEFAULT NULL,
	META_VERSION 			VARCHAR(100) NULL DEFAULT NULL,
	ORGANIZATION 			VARCHAR(20) NULL DEFAULT NULL,
	
	PRIMARY KEY (ATTRIBUTE_ID)
) ENGINE=InnoDB ;

CREATE TABLE SBI_META_TABLE_BC  (
	TABLE_ID 					INT(11) NOT NULL,
	BC_ID 					INT(11) NOT NULL,
	USER_IN 				VARCHAR(100) NOT NULL,
	USER_UP 				VARCHAR(100) NULL DEFAULT NULL,
	USER_DE 				VARCHAR(100) NULL DEFAULT NULL,
	TIME_IN 				TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	TIME_UP 				TIMESTAMP NULL DEFAULT NULL,
	TIME_DE 				TIMESTAMP NULL DEFAULT NULL,
	SBI_VERSION_IN 			VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_UP 			VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_DE 			VARCHAR(10) NULL DEFAULT NULL,
	META_VERSION 			VARCHAR(100) NULL DEFAULT NULL,
	ORGANIZATION 			VARCHAR(20) NULL DEFAULT NULL,
	
	PRIMARY KEY (TABLE_ID, BC_ID)
) ENGINE=InnoDB ;

CREATE TABLE SBI_META_DS_BC  (
	DS_ID 					INT(11) NOT NULL,
	BC_ID 					INT(11) NOT NULL,
	USER_IN 				VARCHAR(100) NOT NULL,
	USER_UP 				VARCHAR(100) NULL DEFAULT NULL,
	USER_DE 				VARCHAR(100) NULL DEFAULT NULL,
	TIME_IN 				TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	TIME_UP 				TIMESTAMP NULL DEFAULT NULL,
	TIME_DE 				TIMESTAMP NULL DEFAULT NULL,
	SBI_VERSION_IN 			VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_UP 			VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_DE 			VARCHAR(10) NULL DEFAULT NULL,
	META_VERSION 			VARCHAR(100) NULL DEFAULT NULL,
	ORGANIZATION 			VARCHAR(20) NULL DEFAULT NULL,
	
	PRIMARY KEY (DS_ID, BC_ID)
) ENGINE=InnoDB ;


CREATE TABLE SBI_META_OBJ_DS  (
	DS_ID 					INT(11) NOT NULL,
	OBJ_ID 					INT(11) NOT NULL,
	USER_IN 				VARCHAR(100) NOT NULL,
	USER_UP 				VARCHAR(100) NULL DEFAULT NULL,
	USER_DE 				VARCHAR(100) NULL DEFAULT NULL,
	TIME_IN 				TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	TIME_UP 				TIMESTAMP NULL DEFAULT NULL,
	TIME_DE 				TIMESTAMP NULL DEFAULT NULL,
	SBI_VERSION_IN 			VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_UP 			VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_DE 			VARCHAR(10) NULL DEFAULT NULL,
	META_VERSION 			VARCHAR(100) NULL DEFAULT NULL,
	ORGANIZATION 			VARCHAR(20) NULL DEFAULT NULL,
	
	PRIMARY KEY (DS_ID, OBJ_ID)
) ENGINE=InnoDB ;

CREATE TABLE SBI_META_DS_TABLE  (
	DS_ID 					INT(11) NOT NULL,
	TABLE_ID 					INT(11) NOT NULL,
	USER_IN 				VARCHAR(100) NOT NULL,
	USER_UP 				VARCHAR(100) NULL DEFAULT NULL,
	USER_DE 				VARCHAR(100) NULL DEFAULT NULL,
	TIME_IN 				TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	TIME_UP 				TIMESTAMP NULL DEFAULT NULL,
	TIME_DE 				TIMESTAMP NULL DEFAULT NULL,
	SBI_VERSION_IN 			VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_UP 			VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_DE 			VARCHAR(10) NULL DEFAULT NULL,
	META_VERSION 			VARCHAR(100) NULL DEFAULT NULL,
	ORGANIZATION 			VARCHAR(20) NULL DEFAULT NULL,
	
	PRIMARY KEY (DS_ID, TABLE_ID)
) ENGINE=InnoDB ;

CREATE TABLE SBI_META_OBJ_TABLE  (
	OBJ_ID 					INT(11) NOT NULL,
	TABLE_ID 				INT(11) NOT NULL,
	ROLE					VARCHAR(100) NULL,
	USER_IN 				VARCHAR(100) NOT NULL,
	USER_UP 				VARCHAR(100) NULL DEFAULT NULL,
	USER_DE 				VARCHAR(100) NULL DEFAULT NULL,
	TIME_IN 				TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	TIME_UP 				TIMESTAMP NULL DEFAULT NULL,
	TIME_DE 				TIMESTAMP NULL DEFAULT NULL,
	SBI_VERSION_IN 			VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_UP 			VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_DE 			VARCHAR(10) NULL DEFAULT NULL,
	META_VERSION 			VARCHAR(100) NULL DEFAULT NULL,
	ORGANIZATION 			VARCHAR(20) NULL DEFAULT NULL,
	
	PRIMARY KEY (OBJ_ID, TABLE_ID)
) ENGINE=InnoDB ;

CREATE TABLE SBI_META_JOB  (
	JOB_ID 					INT(11) NOT NULL AUTO_INCREMENT,
	NAME					VARCHAR(100) NOT NULL,
	DELETED					BOOLEAN NOT NULL DEFAULT FALSE,
	USER_IN 				VARCHAR(100) NOT NULL,
	USER_UP 				VARCHAR(100) NULL DEFAULT NULL,
	USER_DE 				VARCHAR(100) NULL DEFAULT NULL,
	TIME_IN 				TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	TIME_UP 				TIMESTAMP NULL DEFAULT NULL,
	TIME_DE 				TIMESTAMP NULL DEFAULT NULL,
	SBI_VERSION_IN 			VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_UP 			VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_DE 			VARCHAR(10) NULL DEFAULT NULL,
	META_VERSION 			VARCHAR(100) NULL DEFAULT NULL,
	ORGANIZATION 			VARCHAR(20) NULL DEFAULT NULL,
	
	PRIMARY KEY (JOB_ID)
) ENGINE=InnoDB ;


CREATE TABLE SBI_META_JOB_SOURCE  (
	JOB_ID					INT(11) NOT NULL,
	SOURCE_ID				INT(11) NOT NULL,
	USER_IN 				VARCHAR(100) NOT NULL,
	USER_UP 				VARCHAR(100) NULL DEFAULT NULL,
	USER_DE 				VARCHAR(100) NULL DEFAULT NULL,
	TIME_IN 				TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	TIME_UP 				TIMESTAMP NULL DEFAULT NULL,
	TIME_DE 				TIMESTAMP NULL DEFAULT NULL,
	SBI_VERSION_IN 			VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_UP 			VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_DE 			VARCHAR(10) NULL DEFAULT NULL,
	META_VERSION 			VARCHAR(100) NULL DEFAULT NULL,
	ORGANIZATION 			VARCHAR(20) NULL DEFAULT NULL,
	
	PRIMARY KEY (JOB_ID, SOURCE_ID)
) ENGINE=InnoDB ;

CREATE TABLE SBI_META_JOB_TABLE  (
	JOB_ID					INT(11) NOT NULL,
	TABLE_ID				INT(11) NOT NULL,
	USER_IN 				VARCHAR(100) NOT NULL,
	USER_UP 				VARCHAR(100) NULL DEFAULT NULL,
	USER_DE 				VARCHAR(100) NULL DEFAULT NULL,
	TIME_IN 				TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	TIME_UP 				TIMESTAMP NULL DEFAULT NULL,
	TIME_DE 				TIMESTAMP NULL DEFAULT NULL,
	SBI_VERSION_IN 			VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_UP 			VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_DE 			VARCHAR(10) NULL DEFAULT NULL,
	META_VERSION 			VARCHAR(100) NULL DEFAULT NULL,
	ORGANIZATION 			VARCHAR(20) NULL DEFAULT NULL,
	
	PRIMARY KEY (JOB_ID,TABLE_ID)
) ENGINE=InnoDB ;

-- ALTER --
ALTER TABLE SBI_META_TABLE ADD CONSTRAINT FK_SBI_META_TABLE_1 FOREIGN KEY (SOURCE_ID) REFERENCES SBI_META_SOURCE (SOURCE_ID) ON DELETE  RESTRICT ON UPDATE  RESTRICT;
ALTER TABLE SBI_META_TABLE_COLUMN ADD CONSTRAINT FK_SBI_META_COLUMN_1 FOREIGN KEY (TABLE_ID) REFERENCES SBI_META_TABLE (TABLE_ID) ON DELETE  RESTRICT ON UPDATE  RESTRICT;
ALTER TABLE SBI_META_BC ADD CONSTRAINT FK_SBI_META_BC_1 FOREIGN KEY (MODEL_ID) REFERENCES SBI_META_MODELS(ID) ON DELETE  RESTRICT ON UPDATE  RESTRICT;
ALTER TABLE SBI_META_BC_ATTRIBUTE ADD CONSTRAINT FK_SBI_META_BC_ATTRIBUTE_1 FOREIGN KEY (BC_ID) REFERENCES SBI_META_BC(BC_ID) ON DELETE  RESTRICT ON UPDATE  RESTRICT;
ALTER TABLE SBI_META_BC_ATTRIBUTE ADD CONSTRAINT FK_SBI_META_BC_ATTRIBUTE_2 FOREIGN KEY (COLUMN_ID) REFERENCES SBI_META_TABLE_COLUMN(COLUMN_ID) ON DELETE  RESTRICT ON UPDATE RESTRICT;
ALTER TABLE SBI_META_DS_BC ADD CONSTRAINT FK_SBI_META_DS_BC_1 FOREIGN KEY (DS_ID) REFERENCES SBI_DATA_SET(DS_ID) ON DELETE  RESTRICT ON UPDATE  RESTRICT;
ALTER TABLE SBI_META_DS_BC ADD CONSTRAINT FK_SBI_META_DS_BC_2 FOREIGN KEY (BC_ID) REFERENCES SBI_META_BC(BC_ID) ON DELETE  RESTRICT ON UPDATE  RESTRICT;
ALTER TABLE SBI_META_TABLE_BC ADD CONSTRAINT FK_SBI_META_TABLE_BC_1 FOREIGN KEY (TABLE_ID) REFERENCES SBI_META_TABLE(TABLE_ID) ON DELETE  RESTRICT ON UPDATE  RESTRICT;
ALTER TABLE SBI_META_TABLE_BC ADD CONSTRAINT FK_SBI_META_TABLE_BC_2 FOREIGN KEY (BC_ID) REFERENCES SBI_META_BC(BC_ID) ON DELETE  RESTRICT ON UPDATE  RESTRICT;
ALTER TABLE SBI_META_OBJ_DS ADD CONSTRAINT FK_SBI_META_OBJ_DS_1 FOREIGN KEY (DS_ID) REFERENCES SBI_DATA_SET(DS_ID) ON DELETE  RESTRICT ON UPDATE  RESTRICT;
ALTER TABLE SBI_META_OBJ_DS ADD CONSTRAINT FK_SBI_META_OBJ_DS_2 FOREIGN KEY (OBJ_ID) REFERENCES SBI_OBJECTS(BIOBJ_ID) ON DELETE  RESTRICT ON UPDATE  RESTRICT;
ALTER TABLE SBI_META_DS_TABLE ADD CONSTRAINT FK_SBI_META_DS_TABLE_1 FOREIGN KEY (DS_ID) REFERENCES SBI_DATA_SET(DS_ID) ON DELETE  RESTRICT ON UPDATE  RESTRICT;
ALTER TABLE SBI_META_DS_TABLE ADD CONSTRAINT FK_SBI_META_DS_TABLE_2 FOREIGN KEY (TABLE_ID) REFERENCES SBI_META_TABLE(TABLE_ID) ON DELETE  RESTRICT ON UPDATE  RESTRICT;
ALTER TABLE SBI_META_OBJ_TABLE ADD CONSTRAINT FK_SBI_META_OBJ_TABLE_1 FOREIGN KEY (OBJ_ID) REFERENCES SBI_OBJECTS(BIOBJ_ID) ON DELETE  RESTRICT ON UPDATE  RESTRICT;
ALTER TABLE SBI_META_OBJ_TABLE ADD CONSTRAINT FK_SBI_META_OBJ_TABLE_2 FOREIGN KEY (TABLE_ID) REFERENCES SBI_META_TABLE(TABLE_ID) ON DELETE  RESTRICT ON UPDATE  RESTRICT;
ALTER TABLE SBI_META_JOB_SOURCE ADD CONSTRAINT FK_SBI_META_JOB_SOURCE_1 FOREIGN KEY (JOB_ID) REFERENCES SBI_META_JOB(JOB_ID) ON DELETE  RESTRICT ON UPDATE  RESTRICT;
ALTER TABLE SBI_META_JOB_SOURCE ADD CONSTRAINT FK_SBI_META_JOB_SOURCE_2 FOREIGN KEY (SOURCE_ID) REFERENCES SBI_META_SOURCE(SOURCE_ID) ON DELETE  RESTRICT ON UPDATE  RESTRICT;
ALTER TABLE SBI_META_JOB_TABLE ADD CONSTRAINT FK_SBI_META_JOB_TABLE_1 FOREIGN KEY (JOB_ID) REFERENCES SBI_META_JOB(JOB_ID) ON DELETE  RESTRICT ON UPDATE  RESTRICT;
ALTER TABLE SBI_META_JOB_TABLE ADD CONSTRAINT FK_SBI_META_JOB_TABLE_2 FOREIGN KEY (TABLE_ID) REFERENCES SBI_META_TABLE(TABLE_ID) ON DELETE  RESTRICT ON UPDATE  RESTRICT;