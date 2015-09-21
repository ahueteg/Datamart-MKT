DELETE FROM mkt.stock_stage;
INSERT INTO mkt.stock_stage
SELECT
cast(A.FECHA as varchar(8)) [Fecha],
'307' [GrpID],
cast(COALESCE(CONVERT(VARCHAR,TRY_CONVERT(BIGINT,A.CD_CENTRO)),A.CD_CENTRO) as varchar(4))[CadenaIDClie],
cast(COALESCE(CONVERT(VARCHAR,TRY_CONVERT(BIGINT,A.Codigo_SAP)),A.Codigo_SAP)  as varchar(12)) [ProIDClie],
cast(NULL  as varchar(11)) [PdvIDClie],
cast(NULL as decimal(18,6)) [UnidExist],
cast(A.CANT_01 as decimal(18,6)) [UnidCedis],
cast(A.CANT_02 as decimal(18,6)) [UnidTrans]
--into mkt.stock_stage
FROM mkt.STOCK_QS_HISTW A;

DELETE FROM mkt.stock_stage
WHERE
ProIDClie in ('186271','116854')


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

20130106
20130113
20130120
20130127
20130203
20130210
20130217
20130224
20130303
20130310
20130317
20130324
20130331
20130407
20130414
20130421
20130428
20130505
20130512
20130519
20130526
20130602
20130609
20130616
20130623
20130630
20130707
20130714
20130721
20130728
20130804
20130811
20130818
20130825
20130901
20130908
20130915
20130922
20130929
20131006
20131013
20131020
20131027
20131103
20131110
20131117
20131124
20131201
20131208
20131215
20131222

UPDATE per.GLP_STOCK
    SET FECHA='20131229'
WHERE GrpID='307' AND Fecha='20131222'
UPDATE per.GLP_STOCK
    SET FECHA='20131222'
WHERE GrpID='307' AND Fecha='20131215'
UPDATE per.GLP_STOCK
    SET FECHA='20131215'
WHERE GrpID='307' AND Fecha='20131208'
UPDATE per.GLP_STOCK
    SET FECHA='20131208'
WHERE GrpID='307' AND Fecha='20131201'
UPDATE per.GLP_STOCK
    SET FECHA='20131201'
WHERE GrpID='307' AND Fecha='20131124'
UPDATE per.GLP_STOCK
    SET FECHA='20131124'
WHERE GrpID='307' AND Fecha='20131117'
UPDATE per.GLP_STOCK
    SET FECHA='20131117'
WHERE GrpID='307' AND Fecha='20131110'
UPDATE per.GLP_STOCK
    SET FECHA='20131110'
WHERE GrpID='307' AND Fecha='20131103'
UPDATE per.GLP_STOCK
    SET FECHA='20131103'
WHERE GrpID='307' AND Fecha='20131027'
UPDATE per.GLP_STOCK
    SET FECHA='20131027'
WHERE GrpID='307' AND Fecha='20131020'
UPDATE per.GLP_STOCK
    SET FECHA='20131020'
WHERE GrpID='307' AND Fecha='20131013'
UPDATE per.GLP_STOCK
    SET FECHA='20131013'
WHERE GrpID='307' AND Fecha='20131006'
UPDATE per.GLP_STOCK
    SET FECHA='20131006'
WHERE GrpID='307' AND Fecha='20130929'
UPDATE per.GLP_STOCK
    SET FECHA='20130929'
WHERE GrpID='307' AND Fecha='20130922'
UPDATE per.GLP_STOCK
    SET FECHA='20130922'
WHERE GrpID='307' AND Fecha='20130915'
UPDATE per.GLP_STOCK
    SET FECHA='20130915'
WHERE GrpID='307' AND Fecha='20130908'
UPDATE per.GLP_STOCK
    SET FECHA='20130908'
WHERE GrpID='307' AND Fecha='20130901'
UPDATE per.GLP_STOCK
    SET FECHA='20130901'
WHERE GrpID='307' AND Fecha='20130825'
UPDATE per.GLP_STOCK
    SET FECHA='20130825'
WHERE GrpID='307' AND Fecha='20130818'
UPDATE per.GLP_STOCK
    SET FECHA='20130818'
WHERE GrpID='307' AND Fecha='20130811'
UPDATE per.GLP_STOCK
    SET FECHA='20130811'
WHERE GrpID='307' AND Fecha='20130804'
UPDATE per.GLP_STOCK
    SET FECHA='20130804'
WHERE GrpID='307' AND Fecha='20130728'
UPDATE per.GLP_STOCK
    SET FECHA='20130728'
WHERE GrpID='307' AND Fecha='20130721'
UPDATE per.GLP_STOCK
    SET FECHA='20130721'
WHERE GrpID='307' AND Fecha='20130714'
UPDATE per.GLP_STOCK
    SET FECHA='20130714'
WHERE GrpID='307' AND Fecha='20130707'
UPDATE per.GLP_STOCK
    SET FECHA='20130707'
WHERE GrpID='307' AND Fecha='20130630'
UPDATE per.GLP_STOCK
    SET FECHA='20130630'
WHERE GrpID='307' AND Fecha='20130623'
UPDATE per.GLP_STOCK
    SET FECHA='20130623'
WHERE GrpID='307' AND Fecha='20130616'
UPDATE per.GLP_STOCK
    SET FECHA='20130616'
WHERE GrpID='307' AND Fecha='20130609'
UPDATE per.GLP_STOCK
    SET FECHA='20130609'
WHERE GrpID='307' AND Fecha='20130602'
UPDATE per.GLP_STOCK
    SET FECHA='20130602'
WHERE GrpID='307' AND Fecha='20130526'
UPDATE per.GLP_STOCK
    SET FECHA='20130526'
WHERE GrpID='307' AND Fecha='20130519'
UPDATE per.GLP_STOCK
    SET FECHA='20130519'
WHERE GrpID='307' AND Fecha='20130512'
UPDATE per.GLP_STOCK
    SET FECHA='20130512'
WHERE GrpID='307' AND Fecha='20130505'
UPDATE per.GLP_STOCK
    SET FECHA='20130505'
WHERE GrpID='307' AND Fecha='20130428'
UPDATE per.GLP_STOCK
    SET FECHA='20130428'
WHERE GrpID='307' AND Fecha='20130421'
UPDATE per.GLP_STOCK
    SET FECHA='20130421'
WHERE GrpID='307' AND Fecha='20130414'
UPDATE per.GLP_STOCK
    SET FECHA='20130414'
WHERE GrpID='307' AND Fecha='20130407'
UPDATE per.GLP_STOCK
    SET FECHA='20130407'
WHERE GrpID='307' AND Fecha='20130331'
UPDATE per.GLP_STOCK
    SET FECHA='20130331'
WHERE GrpID='307' AND Fecha='20130324'
UPDATE per.GLP_STOCK
    SET FECHA='20130324'
WHERE GrpID='307' AND Fecha='20130317'
UPDATE per.GLP_STOCK
    SET FECHA='20130317'
WHERE GrpID='307' AND Fecha='20130310'
UPDATE per.GLP_STOCK
    SET FECHA='20130310'
WHERE GrpID='307' AND Fecha='20130303'
UPDATE per.GLP_STOCK
    SET FECHA='20130303'
WHERE GrpID='307' AND Fecha='20130224'
UPDATE per.GLP_STOCK
    SET FECHA='20130224'
WHERE GrpID='307' AND Fecha='20130217'
UPDATE per.GLP_STOCK
    SET FECHA='20130217'
WHERE GrpID='307' AND Fecha='20130210'
UPDATE per.GLP_STOCK
    SET FECHA='20130210'
WHERE GrpID='307' AND Fecha='20130203'
UPDATE per.GLP_STOCK
    SET FECHA='20130203'
WHERE GrpID='307' AND Fecha='20130127'
UPDATE per.GLP_STOCK
    SET FECHA='20130127'
WHERE GrpID='307' AND Fecha='20130120'
UPDATE per.GLP_STOCK
    SET FECHA='20130120'
WHERE GrpID='307' AND Fecha='20130113'
UPDATE per.GLP_STOCK
    SET FECHA='20130113'
WHERE GrpID='307' AND Fecha='20130106'





SELECT * FROM per.MAESTRO_PRODUCTO_PRECIO
WHERE GrpID='307' and A�oSemana_GL IS NULL