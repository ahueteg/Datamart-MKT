DROP TABLE mkt.STOCK_IK_HISTW
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
	  into mkt.STOCK_IK_HISTW
  FROM [genomma].[mkt].[stock_inka]


/*CHEK FECHA*/

SELECT * FROM mkt.STOCK_IK_HISTW A
LEFT JOIN PER.MAESTRO_TIEMPO B
ON A.FECHA=B.FECHA
WHERE B.FECHA IS NULL 

SELECT COD_SAP,DESCRIPCION_PRODUCTO,COUNT(1) CONTEO,SUM([INSTOCK]) SUMA FROM mkt.STOCK_IK_HISTW a
LEFT JOIN [per].MAESTRO_PRODUCTO_FUENTE B
ON A.COD_SAP=B.PROIDCLIE AND B.GrpID='309'
WHERE B.PROPSTID IS NULL 
GROUP BY COD_SAP,DESCRIPCION_PRODUCTO
/*
COD_SAP	DESCRIPCION_PRODUCTO	CONTEO	SUMA
114752	ASEPXIA NECESER PROMO	39050	168
107667	SILUET 40 FAJA REDUCTORA UNISEX PROMO	40307	154
108244	TOUCH ME PA??OLETA COL.SURTIDOS PROMO	836	32
108244	TOUCH ME PA�OLETA COL.SURTIDOS PROMO	40219	2066
*/

DROP TABLE MKT.st_ik_1 ;
SELECT * INTO MKT.st_ik_1 FROM mkt.STOCK_IK_HISTW
WHERE COD_SAP not in ('108244','107667','114752')


DROP TABLE MKT.st_ik_2;
SELECT 
A.Fecha,
A.COD_SAP,
A.COD_LOCAL,
A.TIPO,
SUM(A.STOCK_ACTUAL_UNID) STOCK_ACTUAL_UNID
INTO MKT.st_ik_2
FROM MKT.st_ik_1 A
GROUP BY A.Fecha,
A.COD_SAP,
A.COD_LOCAL,
A.TIPO


EXEC sp_help 'MKT.st_ik_1'

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
ON A.COD_SAP=B.PROIDCLIE
LEFT JOIN per.MAESTRO_TIEMPO T
ON A.FECHA=T.Fecha
) Q LEFT JOIN per.MAESTRO_PRODUCTO_PRECIO H
ON H.GrpID='309' AND H.A�OSEMANA_GL=Q.A�oSemana_GL AND H.ProPstID=Q.PROPSTID
WHERE H.PrecioLista IS NULL 
) P
) A;


/*STOCK IK*/
DROP TABLE mkt.st_ik_3;
SELECT 
a.Fecha,
COD_SAP,
COD_LOCAL,
tipo,
sum(CASE WHEN TIPO='LOCAL' THEN STOCK_ACTUAL_UNID ELSE 0 END) UnidExist,
sum(CASE WHEN TIPO='BODEGA' THEN STOCK_ACTUAL_UNID ELSE 0 END) UnidCedis
into mkt.st_ik_3
FROM mkt.st_ik_2 a
GROUP BY 
a.Fecha,
COD_SAP,
COD_LOCAL,
tipo


DROP TABLE PER.STOCK_IK
SELECT 
D.Fecha,
B.ProPstID,
C.PdvID,
H.PrecioID,
A.UnidExist,
A.UnidCedis,
D.A�oSemana_GL
into PER.STOCK_IK
FROM mkt.st_ik_3 a
LEFT JOIN per.MAESTRO_PRODUCTO_FUENTE B
ON A.COD_SAP=B.ProIDClie AND B.GrpID='309'
LEFT JOIN per.MAESTRO_PDV C
ON A.COD_LOCAL=C.PdvIDClie  AND B.GrpID='309'
LEFT JOIN per.MAESTRO_TIEMPO D
ON D.Fecha=A.FECHA
LEFT JOIN per.[maestro_producto_precio] H
ON H.GrpID='309' AND H.A�OSEMANA_GL=D.A�oSemana_GL AND H.ProPstID=B.PROPSTID


ALTER TABLE [per].[STOCK_IK] with check
ADD CONSTRAINT FK_STIK_TIM FOREIGN KEY (FECHA)
REFERENCES per.[MAESTRO_TIEMPO](FECHA)

ALTER TABLE [per].[STOCK_IK] with check
ADD CONSTRAINT FK_STIK_PRO FOREIGN KEY ([ProPstID])
REFERENCES per.[MAESTRO_PRODUCTO_PRESENTACION]([ProPstID])

ALTER TABLE [per].[STOCK_IK] with check
ADD CONSTRAINT FK_STIK_PDV FOREIGN KEY ([PdvID])
REFERENCES per.MAESTRO_PDV([PdvID])

ALTER TABLE [per].[STOCK_IK] with check
ADD CONSTRAINT FK_STIK_PRE FOREIGN KEY ([PrecioID])
REFERENCES per.[MAESTRO_PRODUCTO_PRECIO]([PrecioID])

ALTER TABLE [per].[STOCK_IK] with check
ADD CONSTRAINT FK_STIK_GRP FOREIGN KEY ([GrpID])
REFERENCES per.[MAESTRO_CLIENTE]([GrpID])

ALTER TABLE [per].[STOCK_IK] with check
ADD CONSTRAINT FK_STIK_CAD FOREIGN KEY ([CadenaID])
REFERENCES per.[MAESTRO_CADENA]([CadenaID])


