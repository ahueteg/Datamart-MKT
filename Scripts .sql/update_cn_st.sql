DELETE FROM MKT.STOCK_CONTI_HISTW
WHERE FECHA in
(SELECT DISTINCT SUBSTRING(A.ARCHIVO,1,4)+SUBSTRING(A.ARCHIVO,6,2)+ SUBSTRING(A.ARCHIVO,9,2)
 FROM mkt.stock_cn_day A);

INSERT INTO mkt.STOCK_CONTI_HISTW
SELECT
  SUBSTRING(A.ARCHIVO,1,4)+SUBSTRING(A.ARCHIVO,6,2)+ SUBSTRING(A.ARCHIVO,9,2) FECHA,
  A.CODIGO,
  A.DESC_PROD,
  CAST(A.COMPRAS_C AS INTEGER),
  CAST(A.COMPRAS_I AS DECIMAL(9,2)),
  CAST(A.VENTAS_C AS INTEGER),
  CAST(A.VENTAS_I AS DECIMAL(9,2)),
  CAST(A.STOCK AS INTEGER),
  CAST(A.NVATOT AS DECIMAL(9,2)),
  NULL,
  CAST(A.PRECIO AS DECIMAL(9,2))
FROM mkt.stock_cn_day A;

DELETE FROM mkt.stock_stage;
INSERT INTO mkt.stock_stage
SELECT
cast(A.FECHA as varchar(8)) [Fecha],
'327' [GrpID],
cast('1001' as varchar(4))[CadenaIDClie],
cast(convert(int,A.CODIGO)  as varchar(12)) [ProIDClie],
cast(NULL as varchar(11)) [PdvIDClie],
cast(NULL as decimal(18,6)) [UnidExist],
cast(A.STOCK as decimal(18,6)) [UnidCedis],
cast(NULL as decimal(18,6)) [UnidTrans]
--into mkt.stock_stage
FROM (
  SELECT
  SUBSTRING(A.ARCHIVO,1,4)+SUBSTRING(A.ARCHIVO,6,2)+ SUBSTRING(A.ARCHIVO,9,2) FECHA,
  A.CODIGO,
  A.DESC_PROD,
  CAST(A.COMPRAS_C AS INTEGER) COMPRAS_C,
  CAST(A.COMPRAS_I AS DECIMAL(9,2)) COMPRAS_I,
  CAST(A.VENTAS_C AS INTEGER) VENTAS_C,
  CAST(A.VENTAS_I AS DECIMAL(9,2)) VENTAS_I,
  CAST(A.STOCK AS INTEGER) STOCK,
  CAST(A.NVATOT AS DECIMAL(9,2)) NVATOT,
  NULL NA,
  CAST(A.PRECIO AS DECIMAL(9,2)) PRECIO
FROM mkt.stock_cn_day A
     ) A;



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
WHERE Fecha in (SELECT DISTINCT Fecha FROM mkt.stock_stage)
  AND GrpID in (SELECT DISTINCT GrpID FROM mkt.stock_stage);

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
	PdvIDClie;

UPDATE TGT
    SET TGT.PrecioLista=SRC.[PL (Sin IGV)],
      TGT.PVP=SRC.[PVP (Sin IGV)]
FROM PER.MAESTRO_PRODUCTO_PRECIO tgt
INNER JOIN (
            SELECT
                A�o,
                Semana,
                GrupoID GrpID,
                GrpNombre,
                ProPstID,
                ProPstNombre,
                [PL (Sin IGV)],
                [PVP (Sin IGV)]
              FROM OPENROWSET('Microsoft.ACE.OLEDB.15.0',
                 'Excel 12.0 Xml;HDR=YES;IMEX=1;Database=\\perfile01\INFORMACION COMERCIAL - PERU\Per�\Maestros\Maestros Base\Maestro Precios.xlsx',
                 'SELECT * FROM [Maestro de Precios$]')
              WHERE grupoid IS NOT NULL
           ) SRC
  ON TGT.ProPstID=SRC.ProPstID AND TGT.GrpID=SRC.GrpID AND TGT.A�oSemana_GL=CONVERT(VARCHAR,SRC.A�o*100+SRC.Semana);