
/* MAESTRO PDV*/

SELECT * FROM   mkt.maestro_pdvx


DROP TABLE [per].MAESTRO_PDV

CREATE TABLE [per].MAESTRO_PDV(
	PdvID VARCHAR(7) PRIMARY KEY,
	PdvIDClie [varchar](6) NULL,
	RUC [varchar](11) NULL,
	PdvNombre [varchar](40) NULL,
	Status [varchar](30) NULL,
	Ubigeo [varchar](11) NULL,
	Direccion [varchar](60) NULL,
	N [varchar](40) NULL,
	Interior [varchar](20) NULL,
	Distrito [varchar](50) NULL,
	Provincia [varchar](30) NULL,
	Departamento [varchar](24) NULL
) ON [PRIMARY]

DROP SEQUENCE  per.seq_Pdvid;

CREATE SEQUENCE per.seq_Pdvid as int
MINVALUE 1000000
NO CYCLE


insert into [per].maestro_pdv
SELECT
NEXT VALUE FOR per.seq_Pdvid OVER(ORDER BY SOLICITANTE),
	SOLICITANTE,
	RUC,
	[RAZON_SOCIAL],
	NULL,
	[Ubigeo],
	[Calle],
	[N],
	[Interior],
	[Distrito],
	[provincia],
	[Departamento]
FROM [mkt].maestro_pdvx a


insert into per.maestro_pdv
SELECT
NEXT VALUE FOR per.seq_Pdvid OVER(ORDER BY VBRK_KUNAG),
	VBRK_KUNAG,
	VBRK_KUNAG,
	VBRK_KUNAG,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	'307'
FROM
(
SELECT DISTINCT CONVERT(VARCHAR,CONVERT(INTEGER,VBRK_KUNAG)) VBRK_KUNAG  FROM MKT.SO_QS_SUM A
LEFT JOIN per.maestro_pdv PD
ON CONVERT(VARCHAR,CONVERT(INTEGER,VBRK_KUNAG))=PD.pdvidclie
WHERE PDVID IS NULL
) A

SELECT * FROM [per].maestro_pdv

/*agregacion de grpid*/

ALTER TABLE [per].maestro_pdv
ADD GrpID VARCHAR(3) NOT NULL DEFAULT('000')

SELECT * FROM [per].maestro_pdv

update [per].maestro_pdv
set grpid='307'


ALTER TABLE [per].MAESTRO_PDV
ADD CONSTRAINT FK_PDV_CLI FOREIGN KEY ([GrpID])
REFERENCES per.MAESTRO_CLIENTE([GrpID]);

ALTER TABLE per.MAESTRO_PDV ALTER COLUMN RUC VARCHAR(11)
ALTER TABLE per.MAESTRO_PDV ALTER COLUMN PDVNOMBRE VARCHAR(80)
ALTER TABLE per.MAESTRO_PDV ALTER COLUMN Direccion VARCHAR(100)

ALTER TABLE per.MAESTRO_PDV ALTER COLUMN PdvIDClie VARCHAR(8)

ALTER TABLE per.MAESTRO_PDV ALTER COLUMN PdvIDClie VARCHAR(11)

ALTER TABLE genomma.per.MAESTRO_PDV ADD Tipo VARCHAR(10) NOT NULL;