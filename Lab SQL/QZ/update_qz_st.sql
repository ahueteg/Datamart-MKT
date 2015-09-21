DELETE FROM  mkt.STOCK_QZ_HISTW
WHERE FECHA in
      (SELECT DISTINCT convert(varchar,DATEADD(day,-1,CONVERT(DATE,A.FEC_PROCESO,112)),112) FROM mkt.stock_qz_day A);

INSERT INTO mkt.STOCK_QZ_HISTW
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
      ,convert(varchar,DATEADD(day,-1,CONVERT(DATE,A.FEC_PROCESO,112)),112) FECHA
      ,ARCHIVO
FROM mkt.stock_qz_day A

DELETE FROM mkt.stock_stage;
INSERT INTO mkt.stock_stage
SELECT
cast(A.FECHA as varchar(8)) [Fecha],
'313' [GrpID],
cast(COALESCE(CONVERT(VARCHAR,TRY_CONVERT(BIGINT,A.CD_CENTRO)),A.CD_CENTRO) as varchar(4))[CadenaIDClie],
cast(COALESCE(CONVERT(VARCHAR,TRY_CONVERT(BIGINT,A.Codigo_SAP)),A.Codigo_SAP)  as varchar(12)) [ProIDClie],
cast(NULL  as varchar(11)) [PdvIDClie],
cast(NULL as decimal(18,6)) [UnidExist],
cast(A.CANT_01 as decimal(18,6)) [UnidCedis],
cast(A.CANT_02 as decimal(18,6)) [UnidTrans]
FROM (
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
      ,convert(varchar,DATEADD(day,-1,CONVERT(DATE,A.FEC_PROCESO,112)),112) FECHA
      FROM mkt.stock_qz_day A
     )A;

/*
DELETE FROM mkt.stock_stage
WHERE
ProIDClie in ('116854')
*/
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
FROM mkt.stock_stage
GROUP BY
	Fecha,
	GrpID,
	CadenaIDClie,
	ProIDClie,
	PdvIDClie