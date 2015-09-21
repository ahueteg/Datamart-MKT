/*REVISION FECHASDE HISTORICO STOCK*/

SELECT A.*,B.A�oSemana_GL INTO MKT.DEMO FROM MKT.STOCK_DIGA_HISTW A
LEFT JOIN 
(
SELECT * FROM 
[mkt].[maestro_tiempo] 
) B
ON A.FECHA=B.Fecha


SELECT A.*,B.Fecha FDS FROM MKT.DEMO A
LEFT JOIN 
(SELECT * FROM MKT.maestro_tiempo
WHERE
Dia_Semana=7
) B
ON A.A�oSemana_GL=B.A�oSemana_GL




SELECT * INTO MKT.STOCK_DIGA_HISTW_COPY FROM MKT.STOCK_DIGA_HISTW

/*ACTUALIZANDO FECHAS DE CIERRE DE STOCK*/

/*2014*/
SELECT 
	C.FECHA,
	B.COD_SUCURSAL,
	B.NOM_SUCURSAL,
	B.LOTE,
	B.CodProducto,
	B.Producto,
	B.StockFisico
into 
mkt.STOCK_DIGA_HISTW_2
FROM 
(
SELECT a.*,convert(int,substring(FECHA,1,4)) A�O,44+ DENSE_RANK()over(ORDER BY FECHA) SEMANA FROM MKT.STOCK_DIGA_HISTW a
WHERE FECHA<='20141229'
) B
INNER JOIN 
(
SELECT * FROM 
[mkt].[maestro_tiempo] 
WHERE 
Dia_Semana=7
)
C
ON B.A�O=C.A�o AND B.SEMANA=C.Semana_GL;--240

/*COMPROBACIONES*/
SELECT COUNT(1)  FROM  MKT.STOCK_DIGA_HISTW WHERE FECHA<='20141229';--240

SELECT * FROM mkt.STOCK_DIGA_HISTW_2
ORDER BY FECHA ASC

/*2015*/


SELECT DISTINCT SEMANA FROM 
(
SELECT a.*,convert(int,substring(FECHA,1,4)) A�O,DENSE_RANK()over(ORDER BY FECHA) SEMANA FROM MKT.STOCK_DIGA_HISTW a
WHERE FECHA>'20141229'
) A
ORDER BY 1 DESC

SELECT 
	C.FECHA,
	B.COD_SUCURSAL,
	B.NOM_SUCURSAL,
	B.LOTE,
	B.CodProducto,
	B.Producto,
	B.StockFisico
into 
mkt.STOCK_DIGA_HISTW_3
FROM 
(
SELECT a.*,convert(int,substring(FECHA,1,4)) A�O, DENSE_RANK()over(ORDER BY FECHA) SEMANA FROM MKT.STOCK_DIGA_HISTW a
WHERE FECHA>'20141229'
) B
INNER JOIN 
(
SELECT * FROM 
[mkt].[maestro_tiempo] 
WHERE 
Dia_Semana=7
)
C
ON B.A�O=C.A�o AND B.SEMANA=C.Semana_GL;--711

/*COMPROBACIONES*/

SELECT COUNT(1)  FROM  MKT.STOCK_DIGA_HISTW WHERE FECHA>'20141229';--240

SELECT * FROM mkt.STOCK_DIGA_HISTW_3
ORDER BY FECHA ASC

/*UNION HISTORICOS 2014-2015*/




SELECT A.* INTO mkt.STOCK_DIGA_HISTW_U FROM 
(
SELECT * FROM mkt.STOCK_DIGA_HISTW_3
UNION ALL 
SELECT * FROM mkt.STOCK_DIGA_HISTW_2
) A

DROP TABLE mkt.STOCK_DIGA_HISTW
EXEC sp_rename 'MKT.STOCK_DIGA_HISTW_U', 'STOCK_DIGA_HISTW';


SELECT * FROM MKT.STOCK_DIGA_HISTW