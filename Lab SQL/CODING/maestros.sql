
SELECT * FROM mkt.maestro_cadena


/*MAESTRO CADENA*/
DROP SEQUENCE  mkt.cadenaid;

CREATE SEQUENCE mkt.cadenaid as int
MINVALUE 1000
NO CYCLE

DROP TABLE [mkt].[maestro_cadena];
CREATE TABLE [mkt].[maestro_cadena](
	CADENAID [VARCHAR](4) PRIMARY KEY,
	[COD_CADENA] [varchar](4) NULL,
	[DESC_CADENA] [varchar](20) NULL
) ON [PRIMARY]

insert into [mkt].[maestro_cadena]
SELECT 
NEXT VALUE FOR mkt.cadenaid OVER(ORDER BY [COD_CENTRO]),
a.* 
FROM [mkt].[maestro_cadenax] a


SELECT * FROM [mkt].[maestro_cadena]

/*MAESTRO OFICINA*/

DROP SEQUENCE  mkt.oficinaid;

CREATE SEQUENCE mkt.oficinaid as int
MINVALUE 1000
NO CYCLE

DROP TABLE [mkt].[maestro_oficina];
CREATE TABLE [mkt].[maestro_oficina](
	OFICINAID [VARCHAR](4) PRIMARY KEY,
	[COD_OFICINA] [varchar](4) NULL,
	[DESC_OFICINA] [varchar](20) NULL
) ON [PRIMARY]

insert into [mkt].[maestro_oficina]
SELECT 
NEXT VALUE FOR mkt.oficinaid OVER(ORDER BY [COD_OFICINA]),
a.* 
FROM [mkt].[maestro_oficinax] a


SELECT * FROM [mkt].[maestro_oficina]

/*MAESTRO GRUPOTARGET*/

DROP SEQUENCE  mkt.grupotargetid;

CREATE SEQUENCE mkt.grupotargetid as int
MINVALUE 1000
NO CYCLE

DROP TABLE [mkt].[maestro_grupotarget];
CREATE TABLE [mkt].[maestro_grupotarget](
	GRUPOTARGETID [VARCHAR](4) PRIMARY KEY,
	[COD_GRUPOTARGET] [varchar](4) NULL,
	[DESC_GRUPOTARGET] [varchar](30) NULL
) ON [PRIMARY]

insert into [mkt].[maestro_grupotarget]
SELECT 
NEXT VALUE FOR mkt.grupotargetid OVER(ORDER BY [COD_GRUPOTARGET]),
a.[COD_GRUPOTARGET],
A.[DESC_GRUPOTARGET]
FROM [mkt].[maestro_grupotargetx] a



/*MAESTRO PRESENTACION*/

SELECT * FROM MKT.maestro_productox

/*MAESTRO AGRUPACION PAUTA*/
SELECT DISTINCT A.AGRPROID,A.AGRPRONOMBRE FROM MKT.maestro_productox A

CREATE TABLE [mkt].[maestro_agrpro](
	AGRPROID [VARCHAR](4) PRIMARY KEY,
	AGRPRONOMBRE [varchar](50) NULL,
) ON [PRIMARY]

insert into [mkt].[maestro_agrpro]
SELECT DISTINCT A.AGRPROID,A.AGRPRONOMBRE FROM MKT.maestro_productox A

SELECT * FROM [mkt].[maestro_agrpro]

/*MAESTRO LINEA PRODUCTO*/

SELECT DISTINCT LINID,LINNOMBRE FROM MKT.maestro_productox

CREATE TABLE [mkt].[maestro_lineaproducto](
	LINID [VARCHAR](3) PRIMARY KEY,
	LINNOMBRE [varchar](30) NULL,
) ON [PRIMARY]


SELECT max(len(LINNOMBRE)) FROM MKT.maestro_productox

insert into [mkt].[maestro_lineaproducto]
SELECT DISTINCT A.LINID,A.LINNOMBRE FROM MKT.maestro_productox A

SELECT * FROM [mkt].[maestro_lineaproducto]

/*MAESTRO MARCA*/

SELECT DISTINCT MrcID,MrcNombre FROM MKT.maestro_productox

CREATE TABLE [mkt].[maestro_marcaproducto](
	MRCID [VARCHAR](3) PRIMARY KEY,
	MRCNOMBRE [varchar](20) NULL,
) ON [PRIMARY]


SELECT max(len(MrcNombre)) FROM MKT.maestro_productox

insert into [mkt].[maestro_marcaproducto]
SELECT DISTINCT A.MRCID,A.MRCNOMBRE FROM MKT.maestro_productox A

SELECT * FROM [mkt].[maestro_marcaproducto]

/*MAESTRO PRODUCTO*/

SELECT DISTINCT ProID,ProNombre INTO abc FROM MKT.maestro_productox

DROP TABLE [mkt].[maestro_producto];
CREATE TABLE [mkt].[maestro_producto](
	PROID [VARCHAR](4) PRIMARY KEY,
	PRONOMBRE [varchar](65) NULL,
) ON [PRIMARY]


SELECT max(len(ProNombre)) FROM MKT.maestro_productox

SELECT * FROM dbo.abc
WHERE ProID
in ( SELECT ProID FROM dbo.abc GROUP BY ProID HAVING COUNT(1) >1)

insert into [mkt].[maestro_producto]
SELECT DISTINCT A.PROID,A.PRONOMBRE FROM MKT.maestro_productox A
WHERE PROID<>'1412'

insert into [mkt].[maestro_producto]
SELECT DISTINCT A.PROID,'SILKA ORTHOPEDIC PLANTILLA GEL - PER' FROM MKT.maestro_productox A
WHERE PROID='1412'

c

/* MAESTRO PRESENTACION*/

DROP TABLE [mkt].[maestro_presentacion_producto];
CREATE TABLE [mkt].[maestro_presentacion_producto](
	[ProPstID] [varchar](4) PRIMARY KEY,
	[ProPstCodBarras] [varchar](13) NULL,
	[ProPstCodigoAtlas] [varchar](15) NULL,
	[ProPstNombre] [varchar](100) NULL,
	[ProID] [VARCHAR](4) NOT NULL,
	[AgrProID] [VARCHAR](4) NOT NULL,
	[LinID] [VARCHAR](3) NOT NULL,
	[MrcID] [VARCHAR](3) NOT NULL,
) ON [PRIMARY]


ALTER TABLE [mkt].[maestro_presentacion_producto]
ADD CONSTRAINT FK_PRE_PRO FOREIGN KEY (PROID)
REFERENCES MKT.maestro_producto(PROID)


ALTER TABLE [mkt].[maestro_presentacion_producto]
ADD CONSTRAINT FK_PRE_AGR FOREIGN KEY ([AgrProID])
REFERENCES MKT.[maestro_agrpro]([AgrProID])


ALTER TABLE [mkt].[maestro_presentacion_producto]
ADD CONSTRAINT FK_PRE_MRC FOREIGN KEY (MRCID)
REFERENCES MKT.[maestro_marcaproducto](MRCID)

ALTER TABLE [mkt].[maestro_presentacion_producto]
ADD CONSTRAINT FK_PRE_LIN FOREIGN KEY (LINID)
REFERENCES MKT.[maestro_lineaproducto](LINID)

INSERT INTO [mkt].[maestro_presentacion_producto]
SELECT 
	[ProPstID],
	CONVERT(varchar(12),[ProPstCodBarras]),
	[ProPstCodigoAtlas],
	[ProPstNombre],
	[ProID],
	[AgrProID],
	[LinID],
	[MrcID]
FROM MKT.maestro_productox

SELECT * FROM [mkt].[maestro_presentacion_producto]

/*MAESTRO PRECIO*/
SELECT * FROM [mkt].[maestro_preciox] 

DROP TABLE [mkt].[maestro_precio];
CREATE TABLE [mkt].[maestro_precio](
	[PrecioID] VARCHAR(6) PRIMARY KEY,
	[GrpID] VARCHAR(3) NOT NULL,
	[ProPstID] VARCHAR(4) NOT NULL,
	[AÒOSEMANA_GL] VARCHAR(6) NOT NULL,
	[PRECIO_LISTA] DECIMAL(15,4) NULL
) ON [PRIMARY]
 

ALTER TABLE [mkt].[maestro_precio]
ADD CONSTRAINT FK_PRECIO_CLI FOREIGN KEY ([GrpID])
REFERENCES MKT.maestro_CLIENTE([GrpID]);

ALTER TABLE [mkt].[maestro_precio]
ADD CONSTRAINT FK_PRECIO_PREPRO FOREIGN KEY ([ProPstID])
REFERENCES MKT.maestro_presentacion_producto([ProPstID]);

ALTER TABLE [mkt].[maestro_precio]
ADD CONSTRAINT FK_PRECIO_AS FOREIGN KEY ([AÒOSEMANA_GL])
REFERENCES [mkt].[maestro_aÒosemana_gl]([AÒOSEMANA_GL]);

DROP SEQUENCE  mkt.PRECIOID;

CREATE SEQUENCE mkt.PRECIOID as int
MINVALUE 100000
NO CYCLE


insert into [mkt].[maestro_precio]
SELECT 
NEXT VALUE FOR mkt.PRECIOID OVER(ORDER BY [GrpID],[ProPstID],[AÒOSEMANA]),
a.* 
FROM [mkt].[maestro_preciox] a

SELECT * FROM MKT.[maestro_precio]
WHERE PRECIO_LISTA IS NULL 


DELETE FROM [mkt].[maestro_preciox]
WHERE [ProPstID] NOT IN
(SELECT [ProPstID] FROM MKT.maestro_presentacion_producto)

DELETE FROM MKT.[maestro_precio]
WHERE PRECIO_LISTA IS NULL 

/*MAESTRO CLIENTE*/
SELECT * FROM  [mkt].maestro_clientex

DROP TABLE [mkt].maestro_cliente

SELECT 
[GrpID]
      ,[GrpNombre]
      ,[GrpRFC]
      ,[GrpURL]
      ,[GrpRazonSocial]
      ,[Canal]
	  into [mkt].maestro_cliente
	  FROM [mkt].maestro_clientex

ALTER TABLE mkt.maestro_cliente ALTER COLUMN [GrpID] VARCHAR(3) NOT NULL;
alter table mkt.maestro_cliente add primary key ([GrpID]);

SELECT * FROM [mkt].maestro_cliente

/*MAESTRO AÒOSEMANA*/

SELECT DISTINCT AÒOSEMANA_GL,AÒO_GL,SEMANA_GL INTO mkt.maestro_aÒosemana_gl FROM [mkt].[maestro_tiempo]

ALTER TABLE mkt.maestro_aÒosemana_gl ALTER COLUMN AÒOSEMANA_GL VARCHAR(6) NOT NULL
alter table mkt.maestro_aÒosemana_gl add primary key (AÒOSEMANA_GL)


/*MAESTTRO VENDEDOR*/

SELECT * FROM mkt.maestro_vendedorx;

DROP SEQUENCE  mkt.vendedorid;

CREATE SEQUENCE mkt.vendedorid as int
MINVALUE 100000
NO CYCLE

DROP TABLE [mkt].[maestro_vendedor];
CREATE TABLE [mkt].[maestro_vendedor](
	VENDEDORID [VARCHAR](6) PRIMARY KEY,
	[COD_VENDEDOR] [varchar](5) NULL,
	[DESC_VENDEDOR] [varchar](50) NULL
) ON [PRIMARY]

insert into [mkt].[maestro_vendedor]
SELECT 
NEXT VALUE FOR mkt.vendedorid OVER(ORDER BY [COD_VENDEDOR]),
a.* 
FROM [mkt].[maestro_vendedorx] a

SELECT * FROM [mkt].[maestro_vendedor]


/* MAESTRO PDV*/

SELECT * FROM   mkt.maestro_pdvx

SELECT 
PDVID,
CODIGOCLIENTEPTV,
RUC,
PDVNOMBRE,
STATUS,
DIRECciÛn,
N,
INTERIOR,
GEO_DISTRITO,
GEO_PROVINCIA,
GEO_DEPARTAMENTO

DROP TABLE [mkt].[maestro_pdv]

CREATE TABLE [mkt].[maestro_pdv](
	PDVID VARCHAR(7) PRIMARY KEY,
	COD_PDV [varchar](6) NULL,
	RUC [varchar](11) NULL,
	PDVNOMBRE [varchar](40) NULL,
	STATUS [varchar](30) NULL,
	[Ubigeo] [varchar](11) NULL,
	DIRECCION [varchar](60) NULL,
	[N] [varchar](40) NULL,
	[Interior] [varchar](20) NULL,
	[Distrito] [varchar](50) NULL,
	[provincia] [varchar](30) NULL,
	[Departamento] [varchar](24) NULL
) ON [PRIMARY]

DROP SEQUENCE  mkt.PDVid;

CREATE SEQUENCE mkt.PDVid as int
MINVALUE 1000000
NO CYCLE


insert into [mkt].maestro_pdv
SELECT 
NEXT VALUE FOR mkt.PDVid OVER(ORDER BY SOLICITANTE),
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


SELECT * FROM [mkt].maestro_pdv


/* MAESTRO FUENTE PRODUCTO*/

DROP TABLE  [mkt].[maestro_fuente_producto];
CREATE TABLE [mkt].[maestro_fuente_producto](
	PROIDCLIE [VARCHAR](12) NULL,
	[GrpID] [varchar](3) NULL,
	PROPSTID [varchar](4) NULL
) ON [PRIMARY]

ALTER TABLE [mkt].[maestro_fuente_producto]
ADD CONSTRAINT FK_FUE_PRO FOREIGN KEY (PROPSTID)
REFERENCES MKT.[maestro_presentacion_producto](PROPSTID)

ALTER TABLE [mkt].[maestro_fuente_producto]
ADD CONSTRAINT FK_FUE_GRP FOREIGN KEY ([GrpID])
REFERENCES MKT.[maestro_cliente]([GrpID])


insert into mkt.maestro_fuente_producto
SELECT 
rtrim(ltrim(PROIDCLIE)),
rtrim(ltrim(CADID)),
rtrim(ltrim(PROPSTID))
FROM  mkt.maestro_fuente_productox

SELECT LEN(PROPSTID),PROPSTID FROM mkt.maestro_fuente_productox
ORDER BY 1

/*registros eliminados*/
delete FROM [mkt].maestro_fuente_productox
WHERE rtrim(ltrim([ProPstID])) NOT IN
(SELECT [ProPstID] FROM MKT.maestro_presentacion_producto)


SELECT * FROM mkt.maestro_fuente_producto