SELECT
  SUBSTRING(A.FECHA,7,4)+SUBSTRING(A.FECHA,4,2)+ SUBSTRING(A.FECHA,1,2) FECHA,
  COD_SUCURSAL,
  NOM_SUCURSAL,
  LOTE,
  CodProducto,
  Producto,
  StockFisico
INTO mkt.STOCK_DIGA_HISTW
FROM mkt.STOCK_DIGA_HIST A;

--DROP TABLE mkt.stock_stage;
DELETE FROM mkt.stock_stage;
INSERT INTO mkt.stock_stage
SELECT
cast(A.FECHA as varchar(8)) [Fecha],
'337' [GrpID],
cast(convert(int,A.COD_SUCURSAL) as varchar(4))[CadenaIDClie],
cast(convert(int,A.CodProducto)  as varchar(12)) [ProIDClie],
cast(NULL as varchar(8)) [PdvIDClie],
cast(NULL as decimal(18,6)) [UnidExist],
cast(A.StockFisico as decimal(18,6)) [UnidCedis],
cast(NULL as decimal(18,6)) [UnidTrans]
--into mkt.stock_stage
FROM mkt.STOCK_DIGA_HISTW A;

/*VALIDACIONES*/
print ('VALIDACIONES')
/*CHECK PRODUCTO FUENTE*/

insert into per.MAESTRO_PRODUCTO_FUENTE
SELECT
A.ProIDClie,
A.GrpID GRPID,
'0000' PROPSTID
	FROM (
		SELECT DISTINCT A.ProIDClie,A.GrpID FROM mkt.stock_stage A
			LEFT JOIN per.MAESTRO_PRODUCTO_FUENTE B
				ON A.ProIDClie=B.ProIDClie AND B.GrpID=A.GrpID
		WHERE B.ProPstID IS NULL
	) A;

/*CHECK CADENAID*/

insert into per.MAESTRO_CADENA
(	CadenaID,	CadenaIDClie,	DescCadena,	GrpID)
SELECT
NEXT VALUE FOR per.seq_cadenaid OVER(ORDER BY A.CadenaIDClie),
A.CadenaIDClie,
A.CadenaIDClie,
A.GrpID
	FROM (
		SELECT DISTINCT A.CadenaIDClie,A.GrpID
			FROM mkt.stock_stage A
			LEFT JOIN per.MAESTRO_CADENA B
				ON A.CadenaIDClie=B.CadenaIDClie AND A.GrpID=B.GrpID
		WHERE A.CadenaIDClie IS NOT NULL AND B.CadenaID IS NULL
	) A;


/*CHECK PDV*/

insert into per.MAESTRO_PDV
(PdvID, PdvIDClie, RUC, PdvNombre, GrpID)
SELECT
NEXT VALUE FOR per.seq_PDVid OVER(ORDER BY A.PdvIDClie),
	A.PdvIDClie,
	A.PdvIDClie,
	A.PdvIDClie,
	A.GrpID
	FROM (
		SELECT DISTINCT A.PdvIDClie,A.GrpID  FROM mkt.stock_stage A
			LEFT JOIN per.MAESTRO_PDV B
				ON A.PdvIDClie=B.PdvIDClie AND A.GrpID=B.GrpID
		WHERE A.PdvIDClie IS NOT NULL AND B.PdvID IS NULL
	) A;


/*CHECK PRECIO*/

insert into per.MAESTRO_PRODUCTO_PRECIO
(PrecioID, GrpID, ProPstID, AñoSemana_GL, PrecioLista)
SELECT
NEXT VALUE FOR [per].[seq_precioid] OVER(ORDER BY A.GrpID,A.ProPstID,A.AñoSemana_GL),
A.GrpID,
A.ProPstID,
A.AñoSemana_GL,
0 PrecioLista
	FROM (
		SELECT A.GrpID, A.ProPstID, A.AñoSemana_GL
			FROM (
				SELECT DISTINCT A.GrpID, B.ProPstID, C.AñoSemana_GL
					FROM mkt.stock_stage A
					LEFT JOIN per.MAESTRO_PRODUCTO_FUENTE B
						ON A.ProIDClie=B.ProIDClie AND A.GrpID=B.GrpID
					LEFT JOIN per.MAESTRO_TIEMPO C
						ON A.Fecha=C.Fecha
				WHERE A.ProIDClie IS NOT NULL
			) A
			LEFT JOIN per.MAESTRO_PRODUCTO_PRECIO B
				ON A.GrpID=B.GrpID  AND A.ProPstID=B.ProPstID AND A.AñoSemana_GL=B.AñoSemana_GL
		WHERE B.PrecioLista IS NULL
	) A;


--DROP TABLE per.GLP_STOCK;
DELETE FROM per.GLP_STOCK;
INSERT INTO per.GLP_STOCK
SELECT
	Fecha,
	GrpID,
	CadenaIDClie,
	ProIDClie,
	PdvIDClie,
	CAST(SUM(UnidExist) as DECIMAL(18,6)) UnidExist,
	CAST(SUM(UnidCedis) as DECIMAL(18,6)) UnidCedis,
	CAST(SUM(UnidTrans) as DECIMAL(18,6)) UnidTrans
--INTO per.GLP_STOCK
FROM mkt.stock_stage
GROUP BY
	Fecha,
	GrpID,
	CadenaIDClie,
	ProIDClie,
	PdvIDClie

SELECT * FROM per.GLP_STOCK

DELETE FROM per.INFO_STOCK;
insert INTO per.INFO_STOCK
SELECT
A.Fecha,
A.GrpID,
B.CadenaID,
H.ProPstID,
J.PdvID,
I.PrecioID,
A.UnidExist,
A.UnidCedis,
A.UnidTrans,
A.UnidExist*I.PrecioLista MontoExist,
A.UnidCedis*I.PrecioLista MontoCedis,
A.UnidTrans*I.PrecioLista MontoTrans,
G.AñoSemana_GL
	FROM (
		SELECT
			Fecha,
			GrpID,
			CadenaIDClie,
			ProIDClie,
			PdvIDClie,
			SUM(UnidExist) UnidExist,
			SUM(UnidCedis) UnidCedis,
			SUM(UnidTrans) UnidTrans
		FROM mkt.stock_stage
		GROUP BY
			Fecha,
			GrpID,
			CadenaIDClie,
			ProIDClie,
			PdvIDClie
	) A
	LEFT JOIN per.MAESTRO_CADENA B
	ON A.CadenaIDClie=B.CadenaIDClie AND A.GrpID=B.GrpID
	LEFT JOIN per.MAESTRO_TIEMPO G
	ON A.Fecha=G.Fecha
	LEFT JOIN per.MAESTRO_PRODUCTO_FUENTE H
	ON A.ProIDClie=H.ProIDClie AND A.GrpID=H.GrpID
	LEFT JOIN per.MAESTRO_PRODUCTO_PRECIO I
	ON G.AñoSemana_GL=I.AñoSemana_GL AND H.ProPstID=I.ProPstID AND A.GrpID=I.GrpID
	LEFT JOIN per.MAESTRO_PDV J
	ON A.PdvIDClie=J.PdvIDClie AND A.GrpID=J.GrpID

SELECT * FROM mkt.INFO_STOCK

04/06/2015	4

UPDATE per.GLP_STOCK
    SET FECHA='20150607'
WHERE GrpID='337' AND Fecha='20150604'

22/06/2015	1

UPDATE per.GLP_STOCK
    SET FECHA='20150621'
WHERE GrpID='337' AND Fecha='20150622'

29/06/2015	1

UPDATE per.GLP_STOCK
    SET FECHA='20150628'
WHERE GrpID='337' AND Fecha='20150629'

13/07/2015	1

UPDATE per.GLP_STOCK
    SET FECHA='20150712'
WHERE GrpID='337' AND Fecha='20150713'