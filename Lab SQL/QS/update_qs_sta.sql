DELETE FROM mkt.st_qs_1;
DELETE FROM mkt.st_qs_2;

insert INTO mkt.st_qs_1
SELECT  
[GRUPO_ARTICULO]
,[Codigo_SAP]
      ,[COD_PROV]
      ,[NOMPROD]
      ,[CD_CENTRO]
      ,[CD_ALMACEN]
      ,[Stock_Especial]
      ,[Num_Stock_Especial]
      ,[LOTE]
      ,CASE WHEN len([CANT_01])=12 THEN CAST(SUBSTRING([CANT_01],2,11) AS DECIMAL(12,3))/-1000 ELSE CAST([CANT_01] AS DECIMAL(12,3))/1000 END [CANT_01]
      ,CASE WHEN len([CANT_02])=12 THEN CAST(SUBSTRING([CANT_02],2,11) AS DECIMAL(12,3))/-1000 ELSE CAST([CANT_02] AS DECIMAL(12,3))/1000 END [CANT_02]
      ,CASE WHEN len([CANT_03])=12 THEN CAST(SUBSTRING([CANT_03],2,11) AS DECIMAL(12,3))/-1000 ELSE CAST([CANT_03] AS DECIMAL(12,3))/1000 END [CANT_03]
      ,CASE WHEN len([CANT_04])=12 THEN CAST(SUBSTRING([CANT_04],2,11) AS DECIMAL(12,3))/-1000 ELSE CAST([CANT_04] AS DECIMAL(12,3))/1000 END [CANT_04]
      ,[UNIDAD_MEDIDA]
      ,[FEC_VCMTO_LOTE]
      ,B.A�o_GL
	  ,B.SEMANA_GL
	  ,B.[FECHA]
FROM mkt.stock_qs_day A
LEFT JOIN per.MAESTRO_TIEMPO B
on B.Fecha=convert(varchar,DATEADD(day,-1,CONVERT(DATE,A.FEC_PROCESO,112)),112)

DELETE FROM MKT.STOCK_QS_HISTW
WHERE FECHA in
(SELECT DISTINCT A.FECHA FROM mkt.st_qs_1 A)

insert into MKT.STOCK_QS_HISTW
SELECT * FROM mkt.st_qs_1;

DELETE FROM mkt.st_qs_1
WHERE CODIGO_SAP='116854';

/*CHECK CD_CENTRO*/
insert into [per].[maestro_cadena]
SELECT 
NEXT VALUE FOR per.seq_cadenaid OVER(ORDER BY CD_CENTRO),
CD_CENTRO,
CD_CENTRO,
'307'
FROM 
(
SELECT DISTINCT CD_CENTRO FROM MKT.st_qs_1 a
LEFT JOIN [per].[maestro_cadena] B
ON A.CD_CENTRO=B.CadenaIDClie AND B.GrpID='307'
WHERE B.CADENAID IS NULL 
) A;

/*CHECK PRODUCTO*/
insert into per.MAESTRO_PRODUCTO_FUENTE
SELECT 
CODIGO_SAP,
'307' GRPID,
'0000' PROPSTID
FROM
(
SELECT DISTINCT CODIGO_SAP FROM mkt.st_qs_1 a
LEFT JOIN [per].MAESTRO_PRODUCTO_FUENTE B
ON A.CODIGO_SAP=B.PROIDCLIE AND B.GrpID='307'
WHERE B.PROPSTID IS NULL 
) A;

/*CHECK PRECIO*/
insert into [per].MAESTRO_PRODUCTO_PRECIO
SELECT 
NEXT VALUE FOR [per].[seq_precioid] OVER(ORDER BY [GrpID],[ProPstID],A�oSemana_GL),
A.*
FROM 
(
SELECT 
'307' GRPID,PROPSTID,A�oSemana_GL,0 PRECIO FROM
(
SELECT Q.PROPSTID,Q.A�oSemana_GL FROM
(
SELECT DISTINCT B.PROPSTID,T.A�oSemana_GL FROM
mkt.st_qs_1 A
LEFT JOIN per.MAESTRO_PRODUCTO_FUENTE B
ON A.Codigo_SAP=B.PROIDCLIE
LEFT JOIN per.MAESTRO_TIEMPO T
ON A.FECHA=T.Fecha
) Q LEFT JOIN per.MAESTRO_PRODUCTO_PRECIO H
ON H.GrpID='307' AND H.A�OSEMANA_GL=Q.A�oSemana_GL AND H.ProPstID=Q.PROPSTID
WHERE H.PrecioLista IS NULL 
) P
) A;



DELETE FROM mkt.st_qs_2;
insert INTO mkt.st_qs_2
SELECT 
D.Fecha,
'307' GrpID,
C.CadenaID,
B.ProPstID,
PD.PdvID,
H.PrecioID,
NULL UnidExist,
SUM(A.CANT_01) UnidCedis,
SUM(A.CANT_02) UnidTrans,
NULL MontoExist,
NULL MontoCedis,
NULL MontoTrans,
D.A�oSemana_GL
FROM 
mkt.st_qs_1 A
LEFT JOIN per.MAESTRO_PRODUCTO_FUENTE B
ON A.CODIGO_SAP=B.ProIDClie AND B.GrpID='307'
LEFT JOIN per.MAESTRO_CADENA C
ON A.CD_CENTRO=C.CadenaIDClie AND C.GrpID='307'
LEFT JOIN per.MAESTRO_TIEMPO D
ON D.Fecha=A.FECHA
LEFT JOIN per.MAESTRO_PDV PD
ON NULL=PD.PdvIDClie AND PD.GrpID='307'
LEFT JOIN per.MAESTRO_PRODUCTO_PRECIO H
ON H.A�OSEMANA_GL=D.A�oSemana_GL AND H.ProPstID=B.ProPstID AND H.GrpID='307'
GROUP BY 
D.Fecha,
C.CadenaID,
B.ProPstID,
PD.PdvID,
H.PrecioID,
D.A�oSemana_GL

DELETE FROM [per].[STOCK_QS]
WHERE FECHA in
(SELECT DISTINCT A.FECHA FROM mkt.st_qs_2 A)

insert into [per].[STOCK_QS]
SELECT * FROM mkt.st_qs_2;
