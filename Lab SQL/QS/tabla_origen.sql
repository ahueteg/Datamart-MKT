/* TABLA ORIGEN INVENTARIO-SELLOUT */




SELECT 
A.VBRK_FKDAT FECHA,
B.CADENAID,
C.OFICINAID,
D.Grupo1ID,
F.VENDEDORID,
PP.ProPstID,
PD.PDVID,
H.PRECIOID,
A.VBRP_FKIMG UNIDDESP,
A.ZVALNETO_SF_QS MONTODESPCLIENTE,
A.VBRP_FKIMG*H.PrecioLista MONTODESP,
T.AÒoSemana_GL
INTO MKT.SO_QS_ORI
FROM [mkt].[SELLOUT_QS_HISTW] A
LEFT JOIN per.[maestro_cadena] B
ON A.COD_CENTRO=B.CadenaIDClie
LEFT JOIN per.[maestro_OFICINA] C
ON A.COD_OFI=C.OficinaIDClie
LEFT JOIN per.[MAESTRO_GRUPO1] D
ON A.TRAT_COMERCIAL=D.Grupo1IDClie
LEFT JOIN per.[maestro_vendedor] F
ON A.COD_VEND=F.VendedorIDClie
LEFT JOIN per.[maestro_tiempo] T
ON A.VBRK_FKDAT=T.Fecha
LEFT JOIN per.maestro_producto_fuente G
ON G.[GrpID]='307' AND A.VBRP_MATNR=G.PROIDCLIE
LEFT JOIN per.[maestro_producto_presentacion] PP
ON G.PROPSTID=PP.PROPSTID
LEFT JOIN per.[maestro_producto_precio] H
ON H.GrpID='307' AND H.AÒOSEMANA_GL=T.AÒoSemana_GL AND H.ProPstID=G.PROPSTID
LEFT JOIN per.maestro_pdv PD
ON CONVERT(VARCHAR,CONVERT(INTEGER,VBRK_KUNAG))=PD.PdvIDClie;

SELECT * FROM MKT.SO_QS_ORI
WHERE PRECIOID IS NULL 



SELECT * FROM [per].[STOCK_QS]
WHERE PRECIOID IS NULL 

create view per.Cadena
as
SELECT * FROM [per].[STOCK_QS]


SELECT * FROM per.Cadena


SELECT max(len(a.descripcion_producto)) FROM mkt.stock_inka_201433 a

SELECT * FROM mkt.stock_inka_201433

DROP TABLE mkt.stock_inka_201430_32

DROP TABLE mkt.stock_inka_201432

DROP TABLE mkt.stock_inka_2014



SELECT fecha,sum(stock_actual_unid),COUNT(1)  FROM mkt.stock_inka_2014
GROUP BY fecha
ORDER BY 1

SELECT periodo,sum(vta_periodo_unid),COUNT(1)  FROM mkt.sellout_inka_2014
GROUP BY periodo
ORDER BY 1


SELECT fecha,sum(stock_actual_unid),COUNT(1)  FROM mkt.stock_inka
GROUP BY fecha
ORDER BY 1

SELECT periodo,sum(vta_periodo_unid),COUNT(1)  FROM mkt.sellout_inka
GROUP BY periodo
ORDER BY 1


'03/03/2015'
'01-02-2015'