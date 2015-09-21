SELECT * FROM MKT.SO_QS_SUM
WHERE COD_VEND NOT IN
(SELECT COD_VENDEDOR FROM MKT.[maestro_vendedor])

SELECT [VBRK_FKDAT]
      ,[COD_CENTRO]
      ,[COD_OFI]
      ,[TRAT_COMERCIAL]
      ,CONVERT(VARCHAR,CONVERT(INTEGER,VBRK_KUNAG)) VBRK_KUNAG
      ,[COD_VEND]
      ,[VBRP_MATNR]
      ,[CANTIDAD]
      ,[MONTO]
	  into [mkt].[SO_QS_SUM2]
  FROM [genomma].[mkt].[SO_QS_SUM]


DROP TABLE mkt.salida

DROP TABLE mkt.demo_vendedor;
DROP TABLE mkt.demo_insert;
DROP TABLE mkt.demo_pdv;
drop table MKT.demo_fuente;
DROP TABLE MKT.DEMO_PRECIO;


SELECT * into mkt.demo_vendedor FROM  MKT.[maestro_vendedor];

SELECT * into mkt.demo_insert FROM MKT.[SO_QS_SUM2];
SELECT * into mkt.demo_pdv FROM  MKT.maestro_pdv;
SELECT * into mkt.demo_fuente FROM MKT.maestro_FUENTE_producto;
SELECT * INTO MKT.DEMO_PRECIO FROM [mkt].[maestro_precio]

SELECT COUNT(1)  FROM mkt.demo_maestro;--263
SELECT * FROM  mkt.demo_maestro


SELECT * FROM mkt.demo_insert


SELECT COUNT(1)  FROM  MKT.[maestro_vendedor] ;--259


SELECT *  FROM mkt.salida 
WHERE cod_vend
IS not NULL 

SELECT * FROM mkt.demo_insert


SELECT * FROM mkt.demo_maestro

SELECT * FROM mkt.demo_pdv ORDER BY 1
SELECT COUNT(1)  FROM mkt.demo_pdv WHERE PDVNOMBRE
IS NULL

SELECT * FROM mkt.salida

SELECT 
max(len(fecha))


FROM mkt.maestro_tiempo

ALTER TABLE mkt.maestro_tiempo ALTER COLUMN fecha varchar (8) ;


SELECT DISTINCT propstid FROM mkt.demo_precio
WHERE precio_lista IS NULL and grpid='307'
ORDER BY 1

SELECT * FROM  mkt.demo_precio




SELECT * FROM mkt.maestro_presentacion_producto
WHERE propstid='3485'


