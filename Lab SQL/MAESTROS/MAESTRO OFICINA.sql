
/*MAESTRO OFICINA*/

DROP SEQUENCE  per.seq_oficinaid;

CREATE SEQUENCE per.seq_oficinaid as int
MINVALUE 1000
NO CYCLE

DROP TABLE [per].[MAESTRO_OFICINA];
CREATE TABLE [per].[MAESTRO_OFICINA](
	OficinaID [VARCHAR](4) PRIMARY KEY,
	OficinaIDClie [varchar](4) NULL,
	DescOficina [varchar](20) NULL
) ON [PRIMARY]

insert into [per].[MAESTRO_OFICINA]
SELECT
NEXT VALUE FOR per.seq_oficinaid OVER(ORDER BY [COD_OFICINA]),
a.*
FROM mkt.[maestro_oficinax] a

SELECT * FROM [per].[MAESTRO_OFICINA]

/*agregacion de grpid*/

ALTER TABLE [per].[MAESTRO_OFICINA]
ADD GrpID VARCHAR(3) NOT NULL DEFAULT('000')

SELECT * FROM [per].[MAESTRO_OFICINA]

update [per].[MAESTRO_OFICINA]
set grpid='307'


ALTER TABLE [per].[MAESTRO_OFICINA]
ADD CONSTRAINT FK_OFI_CLI FOREIGN KEY ([GrpID])
REFERENCES per.MAESTRO_CLIENTE([GrpID]);