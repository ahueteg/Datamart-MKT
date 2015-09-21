/*MAESTRO CADENA*/
DROP SEQUENCE  per.seq_cadenaid;

CREATE SEQUENCE per.seq_cadenaid as int
MINVALUE 1000
NO CYCLE

DROP TABLE [per].[MAESTRO_CADENA];
CREATE TABLE [per].[MAESTRO_CADENA](
	CadenaID [VARCHAR](4) PRIMARY KEY,
	CadenaIDClie [varchar](4) NULL,
	DescCadena [varchar](20) NULL
) ON [PRIMARY]

insert into [per].[MAESTRO_CADENA]
SELECT 
NEXT VALUE FOR per.seq_cadenaid OVER(ORDER BY [COD_CENTRO]),
a.* 
FROM mkt.[maestro_cadenax] a

SELECT * FROM [per].[MAESTRO_CADENA]

/*agregacion de grpid*/

ALTER TABLE [per].[MAESTRO_CADENA]
ADD GrpID VARCHAR(3) NOT NULL DEFAULT('000')

SELECT * FROM [per].[MAESTRO_CADENA]

update [per].[MAESTRO_CADENA]
set grpid='307'


ALTER TABLE [per].[MAESTRO_CADENA]
ADD CONSTRAINT FK_CAD_CLI FOREIGN KEY ([GrpID])
REFERENCES per.MAESTRO_CLIENTE([GrpID]);

insert into [per].[maestro_cadena]
(CadenaID,CadenaIDClie,DescCadena,GrpID)
values
(next value for per.seq_cadenaid,'1001','Inkafarma','309')
