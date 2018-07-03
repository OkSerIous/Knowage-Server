--- START ---
SP_RENAME 'SBI_I18N_MESSAGES', 'SBI_I18N_MESSAGES_OLD';

CREATE TABLE SBI_I18N_MESSAGES AS 
SELECT ROW_NUMBER() OVER() AS ID, T.*
FROM SBI_I18N_MESSAGES_OLD T;

DROP TABLE SBI_I18N_MESSAGES_OLD;

ALTER TABLE SBI_I18N_MESSAGES ADD CONSTRAINT PK_SBI_I18N_MESSAGES PRIMARY KEY (ID);
ALTER TABLE SBI_I18N_MESSAGES ADD CONSTRAINT FK_SBI_I18N_MESSAGES FOREIGN KEY (LANGUAGE_CD) REFERENCES SBI_DOMAINS (VALUE_ID);
ALTER TABLE SBI_I18N_MESSAGES ADD CONSTRAINT SBI_I18N_MESSAGES_UNIQUE UNIQUE (LANGUAGE_CD, LABEL, ORGANIZATION);

INSERT INTO hibernate_sequences VALUES ('SBI_I18N_MESSAGES',
                                                            (SELECT ISNULL(MAX(m.ID) + 1, 1) FROM SBI_I18N_MESSAGES m));
COMMIT;                                                            
--- END ---

ALTER TABLE SBI_DATA_SET ADD CONSTRAINT XAK2SBI_DATA_SET UNIQUE (NAME, VERSION_NUM, ORGANIZATION);

ALTER TABLE SBI_ATTRIBUTE ALTER COLUMN DESCRIPTION VARCHAR(500) NULL;

ALTER TABLE SBI_ATTRIBUTE ADD LOV_ID INTEGER NULL,ALLOW_USER SMALLINT  DEFAULT '1',MULTIVALUE SMALLINT  DEFAULT '0',SYNTAX SMALLINT NULL, 
									  VALUE_TYPE_ID INTEGER NULL, VALUE_TYPE_CD VARCHAR(20), VALUE_TYPE VARCHAR(50);
									  
ALTER TABLE SBI_ATTRIBUTE ADD CONSTRAINT FK_LOV FOREIGN KEY (LOV_ID) REFERENCES SBI_LOV(LOV_ID);
ALTER TABLE SBI_ATTRIBUTE ADD CONSTRAINT ENUM_TYPE CHECK (VALUE_TYPE IN('STRING','DATE','NUM'));

ALTER TABLE SBI_EVENTS_LOG ADD COLUMN EVENT_TYPE VARCHAR(50) DEFAULT 'SCHEDULER' NOT NULL;

UPDATE SBI_EVENTS_LOG SET EVENT_TYPE = (
CASE HANDLER 
	WHEN 'it.eng.spagobi.events.handlers.DefaultEventPresentationHandler' THEN 'SCHEDULER'
	WHEN 'it.eng.spagobi.events.handlers.CommonjEventPresentationHandler' THEN 'COMMONJ'
	WHEN 'it.eng.spagobi.events.handlers.TalendEventPresentationHandler' THEN 'ETL'
	WHEN 'it.eng.spagobi.events.handlers.WekaEventPresentationHandler' THEN 'DATA_MINING'
END
);
commit;

ALTER TABLE SBI_EVENTS_LOG DROP COLUMN HANDLER;

ALTER TABLE SBI_OUTPUT_PARAMETER ALTER COLUMN FORMAT_VALUE VARCHAR(30);

---BEGIN---
CREATE TABLE SBI_METAMODEL_PAR (
	OBJ_METAMODEL_ID INT NOT NULL,
	PAR_ID INT NOT NULL,
	METAMODEL_ID INT NOT NULL,
	LABEL VARCHAR(40) NOT NULL,
	REQ_FL SMALLINT NULL,
	MOD_FL SMALLINT NULL,
	VIEW_FL SMALLINT NULL,
	MULT_FL SMALLINT NULL,
	PROG INT NOT NULL,
	PARURL_NM VARCHAR(20) NULL,
	PRIORITY INT NULL,
	COL_SPAN INT DEFAULT 1 NULL,
	THICK_PERC INT DEFAULT 0 NULL,
	USER_IN VARCHAR(100) NOT NULL,
	USER_UP VARCHAR(100) NULL,
	USER_DE VARCHAR(100) NULL,
	TIME_IN DATETIME NOT NULL,
	TIME_UP DATETIME NULL,
	TIME_DE DATETIME NULL,
	SBI_VERSION_IN VARCHAR(10) NULL,
	SBI_VERSION_UP VARCHAR(10) NULL,
	SBI_VERSION_DE VARCHAR(10) NULL,
	META_VERSION VARCHAR(100) NULL,
	ORGANIZATION VARCHAR(20) NULL,
	PRIMARY KEY (OBJ_METAMODEL_ID)
);

ALTER TABLE SBI_METAMODEL_PAR ADD CONSTRAINT FK_SBI_METAMODEL_PAR_1 FOREIGN KEY (METAMODEL_ID) REFERENCES SBI_META_MODELS (ID) ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE SBI_METAMODEL_PAR ADD CONSTRAINT FK_SBI_METAMODEL_PAR_2 FOREIGN KEY (PAR_ID) REFERENCES SBI_PARAMETERS (PAR_ID) ON UPDATE NO ACTION ON DELETE NO ACTION;

---END---
