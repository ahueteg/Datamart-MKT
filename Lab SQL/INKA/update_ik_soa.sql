
DELETE FROM [mkt].[SELLOUT_IK_HISTW]
WHERE [Fecha] in
(SELECT DISTINCT CONCAT(SUBSTRING([PERIODO],1,4),SUBSTRING(PERIODO,6,2),SUBSTRING(PERIODO,9,2)) FROM [mkt].[sellout_ik_day])
;

DELETE FROM mkt.so_ik_1;
insert into mkt.so_ik_1
SELECT CONCAT(SUBSTRING([PERIODO],1,4),SUBSTRING(PERIODO,6,2),SUBSTRING(PERIODO,9,2)) Fecha
      ,[COD_PRODUCTO]
      ,[COD_PRODUCTO_PROVEEDOR]
      ,[DESCRIPCION]
      ,[MARCA]
      ,[ESTADO_PROD]
      ,[UMB]
      ,[COD_LOCAL]
      ,[COD_LOCAL_PROVEEDOR]
      ,[DESCRIPCION_LOCAL]
      ,[ESTADO_LOCAL]
      ,[FORMATO]
      ,[TIPO]
      ,[VTA_PERIODO_UNID]
      ,[COSTO_DE_VENTA_PERIODO_S]
  FROM [genomma].[mkt].[sellout_ik_day]


insert into [mkt].[SELLOUT_IK_HISTW]
SELECT * FROM [mkt].so_ik_1;

DELETE FROM MKT.so_ik_2;
insert INTO MKT.so_ik_2
SELECT 
A.Fecha,
A.COD_PRODUCTO,
A.COD_LOCAL,
SUM(A.VTA_PERIODO_UNID) VTA_PERIODO_UNID,
SUM(A.COSTO_DE_VENTA_PERIODO_S) COSTO_DE_VENTA_PERIODO_S
FROM 
(
SELECT * FROM MKT.so_ik_1
WHERE COD_PRODUCTO NOT IN('108244')
)
A
GROUP BY Fecha,COD_PRODUCTO,COD_LOCAL;

/* check producto*/
insert into per.MAESTRO_PRODUCTO_FUENTE
SELECT 
COD_PRODUCTO,
'309' GRPID,
'0000' PROPSTID
FROM
(
SELECT DISTINCT COD_PRODUCTO FROM MKT.so_ik_2 a
LEFT JOIN [per].MAESTRO_PRODUCTO_FUENTE B
ON A.COD_PRODUCTO=B.PROIDCLIE AND B.GrpID='309'
WHERE B.PROPSTID IS NULL 
) A;

/* check TIEMPO*/

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
SELECT DISTINCT [COD_LOCAL]  FROM MKT.so_ik_2 A
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
mkt.so_ik_2 A
LEFT JOIN per.MAESTRO_PRODUCTO_FUENTE B
ON A.COD_PRODUCTO=B.PROIDCLIE AND B.GrpID='309'
LEFT JOIN per.MAESTRO_TIEMPO T
ON A.FECHA=T.Fecha
) Q LEFT JOIN per.MAESTRO_PRODUCTO_PRECIO H
ON H.A�OSEMANA_GL=Q.A�oSemana_GL AND H.ProPstID=Q.PROPSTID AND H.GrpID='309'
WHERE H.PrecioLista IS NULL 
) P
) A;


DELETE FROM MKT.so_ik_3;
INSERT INTO MKT.so_ik_3
SELECT 
A.Fecha,
'309' GrpID,
CAD.CadenaID,
NULL [OficinaID],
NULL [GrupoTratID],
NULL [VendedorID],
NULL [SupervisorID],
G.ProPstID,
PD.PdvID,
H.PrecioID,
A.VTA_PERIODO_UNID UnidDesp,
A.COSTO_DE_VENTA_PERIODO_S MontoDespCliente,
A.VTA_PERIODO_UNID*H.PRECIOLISTA MontoDesp,
T.A�oSemana_GL
FROM [mkt].so_ik_2 A
LEFT JOIN per.maestro_producto_fuente G
ON A.COD_PRODUCTO=G.PROIDCLIE AND G.[GrpID]='309'
LEFT JOIN per.MAESTRO_CADENA CAD
ON CAD.CadenaIDClie='1001' AND CAD.GrpID='309'
LEFT JOIN per.maestro_pdv PD
ON A.COD_LOCAL=PD.PdvIDClie AND PD.GrpID='309'
LEFT JOIN per.[maestro_tiempo] T
ON A.Fecha=T.Fecha
LEFT JOIN per.[maestro_producto_precio] H
ON H.A�OSEMANA_GL=T.A�oSemana_GL AND H.ProPstID=G.PROPSTID AND H.GrpID='309'


DELETE FROM [per].[SELLOUT_IK]
WHERE [Fecha] in
(SELECT DISTINCT CONCAT(SUBSTRING([PERIODO],1,4),SUBSTRING(PERIODO,6,2),SUBSTRING(PERIODO,9,2)) FROM [mkt].[sellout_ik_day])

insert into [per].[SELLOUT_IK]
SELECT * FROM mkt.so_ik_3;