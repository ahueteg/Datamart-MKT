
DELETE FROM mkt.stock_stage;
INSERT INTO mkt.stock_stage
SELECT
cast(A.FECHA as varchar(8)) [Fecha],
'308' [GrpID],
cast('1001' as varchar(4))[CadenaIDClie],
cast(convert(BIGINT,A.COD_SPSA)  as varchar(12)) [ProIDClie],
cast(COD_LOCAL as varchar(11)) [PdvIDClie],
cast(CASE WHEN TIPO='LOCAL' THEN INVENTARIO ELSE 0 END as decimal(18,6)) [UnidExist],
cast(CASE WHEN TIPO='BODEGA' THEN INVENTARIO ELSE 0 END as decimal(18,6)) [UnidCedis],
cast(NULL as decimal(18,6)) [UnidTrans]
FROM mkt.STOCK_SPP_HISTW A;


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
(PrecioID, GrpID, ProPstID, A�oSemana_GL, PrecioLista)
SELECT
NEXT VALUE FOR [per].[seq_precioid] OVER(ORDER BY A.GrpID,A.ProPstID,A.A�oSemana_GL),
A.GrpID,
A.ProPstID,
A.A�oSemana_GL,
0 PrecioLista
	FROM (
		SELECT A.GrpID, A.ProPstID, A.A�oSemana_GL
			FROM (
				SELECT DISTINCT A.GrpID, B.ProPstID, C.A�oSemana_GL
					FROM mkt.stock_stage A
					LEFT JOIN per.MAESTRO_PRODUCTO_FUENTE B
						ON A.ProIDClie=B.ProIDClie AND A.GrpID=B.GrpID
					LEFT JOIN per.MAESTRO_TIEMPO C
						ON A.Fecha=C.Fecha
				WHERE A.ProIDClie IS NOT NULL
			) A
			LEFT JOIN per.MAESTRO_PRODUCTO_PRECIO B
				ON A.GrpID=B.GrpID  AND A.ProPstID=B.ProPstID AND A.A�oSemana_GL=B.A�oSemana_GL
		WHERE B.PrecioLista IS NULL
	) A;


--DROP TABLE per.GLP_STOCK;
DELETE FROM per.GLP_STOCK
WHERE GrpID IN
			(SELECT DISTINCT GrpID FROM mkt.stock_stage);

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



UPDATE per.GLP_STOCK
    SET FECHA='20150111'
WHERE GrpID='308' AND Fecha='20150114'

UPDATE per.GLP_STOCK
    SET FECHA='20150208'
WHERE GrpID='308' AND Fecha='20150209'

UPDATE per.GLP_STOCK
    SET FECHA='20150301'
WHERE GrpID='308' AND Fecha='20150228'

UPDATE per.GLP_STOCK
    SET FECHA='20150308'
WHERE GrpID='308' AND Fecha='20150309'

UPDATE per.GLP_STOCK
    SET FECHA='20150308'
WHERE GrpID='308' AND Fecha='20150309'

UPDATE per.GLP_STOCK
    SET FECHA='20150315'
WHERE GrpID='308' AND Fecha='20150317'

UPDATE per.GLP_STOCK
    SET FECHA='20150322'
WHERE GrpID='308' AND Fecha='20150323'

UPDATE per.GLP_STOCK
    SET FECHA='20150329'
WHERE GrpID='308' AND Fecha='20150330'

UPDATE per.GLP_STOCK
    SET FECHA='20150426'
WHERE GrpID='308' AND Fecha='20150427'

UPDATE per.GLP_STOCK
    SET FECHA='20150503'
WHERE GrpID='308' AND Fecha='20150504'

UPDATE per.GLP_STOCK
    SET FECHA='20150510'
WHERE GrpID='308' AND Fecha='20150511'

UPDATE per.GLP_STOCK
    SET FECHA='20150517'
WHERE GrpID='308' AND Fecha='20150519'

UPDATE per.GLP_STOCK
    SET FECHA='20150524'
WHERE GrpID='308' AND Fecha='20150525'


UPDATE per.GLP_STOCK
    SET FECHA='20150531'
WHERE GrpID='308' AND Fecha='20150602'

UPDATE per.GLP_STOCK
    SET FECHA='20150607'
WHERE GrpID='308' AND Fecha='20150608'

UPDATE per.GLP_STOCK
    SET FECHA='20150614'
WHERE GrpID='308' AND Fecha='20150616'

UPDATE per.GLP_STOCK
    SET FECHA='20150621'
WHERE GrpID='308' AND Fecha='20150622'

UPDATE per.GLP_STOCK
    SET FECHA='20150628'
WHERE GrpID='308' AND Fecha='20150630'

UPDATE per.GLP_STOCK
    SET FECHA='20150712'
WHERE GrpID='308' AND Fecha='20150713'