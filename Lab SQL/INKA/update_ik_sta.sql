
DELETE FROM [mkt].[STOCK_IK_HISTW]
WHERE Fecha IN
(
SELECT DATEADD(day,-1,CONVERT(DATE,FECHA,112)) FROM 
(SELECT DISTINCT CONCAT(SUBSTRING(Fecha,7,4),SUBSTRING(Fecha,4,2),SUBSTRING(Fecha,1,2)) FECHA FROM [mkt].[stock_ik_day]) A
)

DELETE FROM mkt.st_ik_1;
insert into mkt.st_ik_1
SELECT CONCAT(SUBSTRING(Fecha,7,4),SUBSTRING(Fecha,4,2),SUBSTRING(Fecha,1,2)) Fecha
      ,[COD_SAP]
      ,[COD_PROVEEDOR]
      ,[DESCRIPCION_PRODUCTO]
      ,[UM]
      ,[MARCA]
      ,[ESTADO_PRODUCTO]
      ,[COD_LOCAL]
      ,[DESCRIPCION_LOCAL]
      ,[FORMATO]
      ,[TIPO]
      ,[ESTADO_LOCAL]
      ,[STOCK_ACTUAL_UNID]
      ,[MIX]
      ,[Q]
      ,[INSTOCK]
      ,[VENTA_SEM_Mayo]
      ,[VENTA_SEM_Abril]
      ,[VENTA_SEM_Marzo]
  FROM [genomma].[mkt].[stock_ik_day]

insert into [mkt].[STOCK_IK_HISTW]
SELECT * FROM [mkt].st_ik_1;

DELETE FROM mkt.st_ik_2;
insert into mkt.st_ik_2
SELECT 
A.Fecha,
A.COD_SAP,
A.COD_LOCAL,
A.TIPO,
SUM(A.STOCK_ACTUAL_UNID) STOCK_ACTUAL_UNID
FROM
(
SELECT * FROM MKT.st_ik_1
WHERE COD_SAP not in ('108244','107667','114752')
) A
GROUP BY A.Fecha,
A.COD_SAP,
A.COD_LOCAL,
A.TIPO

/* check producto*/

insert into per.MAESTRO_PRODUCTO_FUENTE
SELECT 
COD_SAP,
'309' GRPID,
'0000' PROPSTID
FROM
(
SELECT DISTINCT COD_SAP FROM mkt.st_ik_2 a
LEFT JOIN [per].MAESTRO_PRODUCTO_FUENTE B
ON A.COD_SAP=B.PROIDCLIE AND B.GrpID='309'
WHERE B.PROPSTID IS NULL 
) A;

/* check pdv*/
insert into [per].maestro_pdv
SELECT 
NEXT VALUE FOR per.seq_PDVid OVER(ORDER BY [COD_LOCAL]),
	[COD_LOCAL],
	[COD_LOCAL],
	[COD_LOCAL],
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	'309'
FROM 
(
SELECT DISTINCT [COD_LOCAL]  FROM MKT.st_ik_2 A
LEFT JOIN [per].maestro_pdv PD
ON [COD_LOCAL]=PD.PdvIDClie AND PD.GrpID='309'
WHERE PDVID IS NULL 
) A;

/*CHECK PRECIO*/
insert into [per].MAESTRO_PRODUCTO_PRECIO
SELECT 
NEXT VALUE FOR [per].[seq_precioid] OVER(ORDER BY [GrpID],[ProPstID],A�oSemana_GL),
A.*
FROM 
(
SELECT 
'309' GRPID,PROPSTID,A�oSemana_GL,0 PRECIO FROM
(
SELECT Q.PROPSTID,Q.A�oSemana_GL FROM
(
SELECT DISTINCT B.PROPSTID,T.A�oSemana_GL FROM
mkt.st_ik_2 A
LEFT JOIN per.MAESTRO_PRODUCTO_FUENTE B
ON A.COD_SAP=B.PROIDCLIE AND B.GrpID='309'
LEFT JOIN per.MAESTRO_TIEMPO T
ON A.FECHA=T.Fecha
) Q LEFT JOIN per.MAESTRO_PRODUCTO_PRECIO H
ON H.A�OSEMANA_GL=Q.A�oSemana_GL AND H.ProPstID=Q.PROPSTID AND H.GrpID='309'
WHERE H.PrecioLista IS NULL 
) P
) A;


DELETE FROM MKT.st_ik_3;
INSERT INTO MKT.st_ik_3
SELECT 
a.Fecha,
COD_SAP,
COD_LOCAL,
tipo,
sum(CASE WHEN TIPO='LOCAL' THEN STOCK_ACTUAL_UNID ELSE 0 END) UnidExist,
sum(CASE WHEN TIPO='BODEGA' THEN STOCK_ACTUAL_UNID ELSE 0 END) UnidCedis
FROM mkt.st_ik_2 a
GROUP BY 
a.Fecha,
COD_SAP,
COD_LOCAL,
tipo

DELETE FROM MKT.st_ik_4;
INSERT INTO MKT.st_ik_4
SELECT 
D.Fecha,
'309' [GrpID],
CAD.CadenaID,
B.ProPstID,
C.PdvID,
H.PrecioID,
A.UnidExist,
A.UnidCedis,
NULL [UnidTrans],
NULL [MontoExist],
NULL [MontoCedis],
NULL [MontoTrans],
D.A�oSemana_GL
FROM mkt.st_ik_3 a
LEFT JOIN per.MAESTRO_PRODUCTO_FUENTE B
ON A.COD_SAP=B.ProIDClie AND B.GrpID='309'
LEFT JOIN per.MAESTRO_CADENA CAD
ON CAD.CadenaIDClie='1001' AND CAD.GrpID='309'
LEFT JOIN per.MAESTRO_PDV C
ON A.COD_LOCAL=C.PdvIDClie  AND B.GrpID='309'
LEFT JOIN per.MAESTRO_TIEMPO D
ON D.Fecha=A.FECHA
LEFT JOIN per.[maestro_producto_precio] H
ON H.A�OSEMANA_GL=D.A�oSemana_GL AND H.ProPstID=B.PROPSTID AND H.GrpID='309'


DELETE FROM [per].[STOCK_IK]
WHERE Fecha IN
(
SELECT DATEADD(day,-1,CONVERT(DATE,FECHA,112)) FROM 
(SELECT DISTINCT CONCAT(SUBSTRING(Fecha,7,4),SUBSTRING(Fecha,4,2),SUBSTRING(Fecha,1,2)) FECHA FROM [mkt].[stock_ik_day]) A
)

insert into [per].[STOCK_IK]
SELECT * FROM mkt.st_ik_4;
