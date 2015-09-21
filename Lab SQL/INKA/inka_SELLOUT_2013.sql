SELECT max(fecha) FROM [per].[SELLOUT_IK]

SELECT * into mkt.sellout_inka_2013_2 FROM 
(
SELECT 
substring([Dia],7,4)+SUBSTRING(dia,4,2)+substring(dia,1,2) fecha
      ,[CodLocal]
      ,[DescLocal]
      ,[Cod]
      ,[Producto]
      ,[UnidVend]
FROM mkt.sellout_inka_2013
WHERE substring(dia,3,1)='/'
union all
SELECT
substring([Dia],1,4)+SUBSTRING(dia,6,2)+substring(dia,9,2) fecha
      ,[CodLocal]
      ,[DescLocal]
      ,[Cod]
      ,[Producto]
      ,[UnidVend]
FROM mkt.sellout_inka_2013
WHERE substring(dia,3,1)<>'/'
) a


SELECT fecha,COUNT(1)  FROM mkt.sellout_inka_2013_2
GROUP BY fecha
ORDER BY 1

SELECT * FROM mkt.sellout_inka_2013_2


SELECT * FROM mkt.sellout_inka_2013_x

insert into mkt.sellout_inka_2013_2
SELECT 
substring([Dia],7,4)+SUBSTRING(dia,4,2)+substring(dia,1,2) fecha
      ,[CodLocal]
      ,[DescLocal]
      ,[Cod]
      ,[Producto]
      ,[UnidVend]
FROM mkt.sellout_inka_2013_x
WHERE substring(dia,3,1)='/'
union all
SELECT
substring([Dia],1,4)+SUBSTRING(dia,6,2)+substring(dia,9,2) fecha
      ,[CodLocal]
      ,[DescLocal]
      ,[Cod]
      ,[Producto]
      ,[UnidVend]
FROM mkt.sellout_inka_2013_x
WHERE substring(dia,3,1)<>'/'



INSERT INTO mkt.sellout_inka_2013_2
SELECT 
substring(fecha,7,4)+SUBSTRING(fecha,4,2)+substring(fecha,1,2) fecha
      ,[CodLocal]
      ,[DescLocal]
      ,[Codigo]
      ,Descripcion
      ,[UnidVend]
FROM mkt.sellout_2013_43
WHERE substring(fecha,3,1)='/'
union all
SELECT
substring(fecha,1,4)+SUBSTRING(fecha,6,2)+substring(fecha,9,2) fecha
      ,[CodLocal]
      ,[DescLocal]
      ,[Codigo]
      ,Descripcion
      ,[UnidVend]
FROM mkt.sellout_2013_43
WHERE substring(fecha,3,1)<>'/'

SELECT DISTINCT a.cod  FROM mkt.sellout_inka_2013_2 a
LEFT JOIN 
(
SELECT * FROM 
per.MAESTRO_PRODUCTO_FUENTE 
WHERE grpid='309'
)
b
on convert(varchar,convert(integer,a.cod))=b.ProIDClie
WHERE b.proidclie IS NULL 


SELECT * into mkt.SELLOUT_IK_HISTA FROM  mkt.sellout_inka_2013_2


DROP TABLE MKT.so_ik_1_a ;
SELECT * INTO MKT.so_ik_1_a FROM mkt.SELLOUT_IK_HISTA
WHERE cod<>'429116'


DROP TABLE MKT.so_ik_2_a;
SELECT 
A.Fecha,
convert(varchar,convert(integer,A.cod)) COD_PRODUCTO,
convert(varchar,1000+convert(integer,A.CodLocal))  COD_LOCAL,
SUM(A.UnidVend) VTA_PERIODO_UNID,
SUM(0) COSTO_DE_VENTA_PERIODO_S
INTO MKT.so_ik_2_a
FROM MKT.so_ik_1_a A
GROUP BY Fecha,cod,CodLocal


/* check producto*/

insert into per.MAESTRO_PRODUCTO_FUENTE
SELECT 
COD_PRODUCTO,
'309' GRPID,
'0000' PROPSTID
FROM
(
SELECT DISTINCT COD_PRODUCTO FROM MKT.so_ik_2_a a
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
SELECT DISTINCT [COD_LOCAL]  FROM MKT.so_ik_2_A A
LEFT JOIN [per].maestro_pdv PD
ON [COD_LOCAL]=PD.PdvIDClie  AND PD.GrpID='309'
WHERE PDVID IS NULL 
) A;

SELECT * FROM per.MAESTRO_PDV WHERE GrpID='309'
/*CHECK PRECIO*/

insert into [per].MAESTRO_PRODUCTO_PRECIO
SELECT 
NEXT VALUE FOR [per].[seq_precioid] OVER(ORDER BY [GrpID],[ProPstID],AÒoSemana_GL),
A.*
FROM 
(
SELECT 
'309' GRPID,PROPSTID,AÒoSemana_GL,0 PRECIO FROM
(
SELECT Q.PROPSTID,Q.AÒoSemana_GL FROM
(
SELECT DISTINCT B.PROPSTID,T.AÒoSemana_GL FROM
mkt.so_ik_2_A A
LEFT JOIN per.MAESTRO_PRODUCTO_FUENTE B
ON A.COD_PRODUCTO=B.PROIDCLIE
LEFT JOIN per.MAESTRO_TIEMPO T
ON A.FECHA=T.Fecha
) Q LEFT JOIN per.MAESTRO_PRODUCTO_PRECIO H
ON H.GrpID='309' AND H.AÒOSEMANA_GL=Q.AÒoSemana_GL AND H.ProPstID=Q.PROPSTID
WHERE H.PrecioLista IS NULL 
) P
) A;

INSERT into per.SELLOUT_IK
SELECT 
A.Fecha,
NULL [CadenaID],
NULL [OficinaID],
NULL [GrupoTratID],
NULL [VendedorID],
G.ProPstID,
PD.PdvID,
H.PrecioID,
A.VTA_PERIODO_UNID UnidDesp,
A.COSTO_DE_VENTA_PERIODO_S MontoDespCliente,
A.VTA_PERIODO_UNID*H.PRECIOLISTA MontoDesp,
T.AÒoSemana_GL
FROM [mkt].so_ik_2_A A
LEFT JOIN per.maestro_producto_fuente G
ON G.[GrpID]='309' AND A.COD_PRODUCTO=G.PROIDCLIE
LEFT JOIN per.maestro_pdv PD
ON A.COD_LOCAL=PD.PdvIDClie AND PD.GrpID='309'
LEFT JOIN per.[maestro_tiempo] T
ON A.Fecha=T.Fecha
LEFT JOIN per.[maestro_producto_precio] H
ON H.GrpID='309' AND H.AÒOSEMANA_GL=T.AÒoSemana_GL AND H.ProPstID=G.PROPSTID


SELECT MIN(FECHA),MAX(FECHA) FROM [mkt].so_ik_2_A;--20121231	20131229

SELECT MIN(FECHA),MAX(FECHA) FROM MKT.SO_IK_BACKUP_2014;--20131230	20150528
/*COPIA 2014*/

SELECT * INTO MKT.SO_IK_BACKUP_2014 FROM per.SELLOUT_IK
SELECT * INTO MKT.SO_IK_BACKUP_final FROM per.SELLOUT_IK

SELECT * FROM per.SELLOUT_IK