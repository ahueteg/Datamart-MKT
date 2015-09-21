/*MAESTRO GRUPOTARGET*/

DROP SEQUENCE  per.seq_Grupo1id;

CREATE SEQUENCE per.seq_Grupo1id as int
MINVALUE 1000
NO CYCLE

DROP TABLE [per].[MAESTRO_GRUPO1];
CREATE TABLE [per].[MAESTRO_GRUPO1](
	Grupo1ID [VARCHAR](4) PRIMARY KEY,
	Grupo1IDClie [varchar](4) NULL,
	DescGrupo1 [varchar](30) NULL
) ON [PRIMARY]

insert into [per].[MAESTRO_GRUPO1]
SELECT
NEXT VALUE FOR per.seq_Grupo1id OVER(ORDER BY [COD_GRUPOTARGET]),
a.[COD_GRUPOTARGET],
A.[DESC_GRUPOTARGET]
FROM mkt.[maestro_grupotargetx] a

SELECT * FROM [per].[MAESTRO_GRUPO1]
SELECT * FROM  mkt.[maestro_grupotargetx]

/*agregacion de grpid*/

ALTER TABLE [per].[MAESTRO_GRUPO1]
ADD GrpID VARCHAR(3) NOT NULL DEFAULT('000')

SELECT * FROM [per].[MAESTRO_GRUPO1]

update [per].[MAESTRO_GRUPO1]
set grpid='307'


ALTER TABLE [per].[MAESTRO_GRUPO1]
ADD CONSTRAINT FK_GRT_CLI FOREIGN KEY ([GrpID])
REFERENCES per.MAESTRO_CLIENTE([GrpID]);