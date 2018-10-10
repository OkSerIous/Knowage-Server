ALTER TABLE SBI_OBJECTS ADD CONSTRAINT FK_SBI_OBJECTS_5 FOREIGN KEY (ENGINE_ID) REFERENCES SBI_ENGINES (ENGINE_ID) ON UPDATE NO ACTION ON DELETE RESTRICT;

ALTER TABLE SBI_META_MODELS_VERSIONS ALTER COLUMN CONTENT TYPE BYTEA;
ALTER TABLE SBI_META_MODELS_VERSIONS ALTER COLUMN CONTENT DROP NOT NULL;
ALTER TABLE SBI_META_MODELS_VERSIONS ADD COLUMN FILE_MODEL BYTEA NULL;

ALTER TABLE SBI_OBJ_METACONTENTS ADD COLUMN ADDITIONAL_INFO VARCHAR(255) NULL;

ALTER TABLE SBI_CATALOG_FUNCTION 
ADD COLUMN OWNER 	VARCHAR(50) NOT NULL,
ADD COLUMN KEYWORDS VARCHAR(255) NULL DEFAULT NULL;

ALTER TABLE SBI_CATALOG_FUNCTION 
ADD COLUMN LABEL VARCHAR(50) NOT NULL;

ALTER TABLE SBI_CATALOG_FUNCTION
ADD CONSTRAINT UNIQUE_LABEL_ORG UNIQUE (LABEL,ORGANIZATION);

ALTER TABLE SBI_CATALOG_FUNCTION 
ADD COLUMN TYPE VARCHAR(50) NULL DEFAULT NULL;



ALTER TABLE SBI_DATA_SET DROP COLUMN IS_PUBLIC;

CREATE TABLE SBI_WHATIF_WORKFLOW(
	ID INTEGER,
    MODEL_ID INTEGER,
    USER_ID INTEGER,
    SEQUENCE INTEGER,
    STATE VARCHAR(20),
    NOTES VARCHAR(100),
    INFO VARCHAR(100),
 	USER_IN 				VARCHAR(100) NOT NULL,
 	USER_UP 				VARCHAR(100) NULL DEFAULT NULL,
 	USER_DE 				VARCHAR(100) NULL DEFAULT NULL,
 	TIME_IN 				TIMESTAMP NOT NULL,
	TIME_UP 				TIMESTAMP NULL DEFAULT NULL,
 	TIME_DE 				TIMESTAMP NULL DEFAULT NULL,
	SBI_VERSION_IN 		VARCHAR(10) NULL DEFAULT NULL,
 	SBI_VERSION_UP 		VARCHAR(10) NULL DEFAULT NULL,
 	SBI_VERSION_DE 		VARCHAR(10) NULL DEFAULT NULL,
 	ORGANIZATION 			VARCHAR(20) NULL DEFAULT NULL,
    PRIMARY KEY (ID)
);

ALTER TABLE SBI_WHATIF_WORKFLOW 				ADD CONSTRAINT FK_SBI_MODEL_WORKFLOW			FOREIGN KEY (MODEL_ID) 			REFERENCES SBI_ARTIFACTS(ID)	ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE SBI_WHATIF_WORKFLOW 				ADD CONSTRAINT FK_SBI_USER_WORKFLOW			FOREIGN KEY (USER_ID) 				REFERENCES SBI_USER(ID) ON DELETE CASCADE ON UPDATE NO ACTION;
