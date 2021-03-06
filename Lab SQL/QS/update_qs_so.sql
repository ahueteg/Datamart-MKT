/*INICIO*/
DELETE FROM mkt.SELLOUT_QS_HISTW
WHERE VBRK_FKDAT in
      (SELECT DISTINCT A.VBRK_FKDAT FROM mkt.sellout_qs_day A);

insert into mkt.SELLOUT_QS_HISTW
SELECT [ID]
      ,[FECHAGEN]
      ,[VBRP_MATKL]
      ,[VBRP_MATNR]
      ,[WPROD]
      ,[VBRK_KUNAG]
      ,[KNA1_STCD1]
      ,[UBIGEO]
      ,[COD_VEND]
      ,[COD_PROM]
      ,[FREE1]
      ,[COD_OFI]
      ,[COD_CENTRO]
      ,[COD_ALM]
      ,[VBAK_VBELN]
      ,[VBKD_BSARK_E]
      ,[VBRK_VBELN]
      ,[VBRP_POSNR]
      ,[VBRK_XBLNR]
      ,[VBRK_ERDAT]
      ,[VBRK_FKART]
      ,[VBRK_FKDAT]
      ,[VBRK_ZZRFOFI]
      ,[VBRP_CHARG]
      ,[VBRK_ZTERM]
      ,[VBRP_AUGRU_AUFT]
      ,[VBRK_FKSTO]
	  ,CASE WHEN len([VBRP_FKIMG])=12 THEN CAST(SUBSTRING([VBRP_FKIMG],2,11) AS DECIMAL(12,3))/-1000 ELSE CAST([VBRP_FKIMG] AS DECIMAL(12,3))/1000 END [VBRP_FKIMG]
      ,[VBRP_VRKME]
	  ,CAST([VBRP_ZZ_ZP01] AS DECIMAL(12,2))/100 [VBRP_ZZ_ZP01]
      ,[VBRK_WAERK]
      ,CAST([DESC_RR] AS DECIMAL(7,2))/100 [DESC_RR]
	  ,CAST([DESC_NR] AS DECIMAL(7,2))/100 [DESC_NR]
      ,CASE WHEN len([VBRP_KZWI1])=12 THEN CAST(SUBSTRING([VBRP_KZWI1],2,11) AS DECIMAL(12,2))/-100 ELSE CAST([VBRP_KZWI1] AS DECIMAL(12,2))/100 END [VBRP_KZWI1]
	  ,CASE WHEN len([ZVALVTA_UNI])=12 THEN CAST(SUBSTRING([ZVALVTA_UNI],2,11) AS DECIMAL(12,2))/-100 ELSE CAST([ZVALVTA_UNI] AS DECIMAL(12,2))/100 END [ZVALVTA_UNI]
	  ,CASE WHEN len([ZIMP_BRUTO])=12 THEN CAST(SUBSTRING([ZIMP_BRUTO],2,11) AS DECIMAL(12,2))/-100 ELSE CAST([ZIMP_BRUTO] AS DECIMAL(12,2))/100 END [ZIMP_BRUTO]
      ,CAST([ZMARGEN] AS DECIMAL(6,2))/100 [ZMARGEN]
	  ,CASE WHEN len([ZVAL_VTAIMP])=12 THEN CAST(SUBSTRING([ZVAL_VTAIMP],2,11) AS DECIMAL(12,2))/-100 ELSE CAST([ZVAL_VTAIMP] AS DECIMAL(12,2))/100 END [ZVAL_VTAIMP]
      ,CASE WHEN len([ZIMP_IMPTO])=12 THEN CAST(SUBSTRING([ZIMP_IMPTO],2,11) AS DECIMAL(12,2))/-100 ELSE CAST([ZIMP_IMPTO] AS DECIMAL(12,2))/100 END [ZIMP_IMPTO]
      ,CAST([DESC_QS] AS DECIMAL(6,2))/100 [DESC_QS]
      ,CASE WHEN len([ZVALNETO])=12 THEN CAST(SUBSTRING([ZVALNETO],2,11) AS DECIMAL(12,2))/-100 ELSE CAST([ZVALNETO] AS DECIMAL(12,2))/100 END [ZVALNETO]
      ,[CLS_PED]
      ,[IND_BONIF]
	  ,CASE WHEN len([ZVALNET_CFLETE])=12 THEN CAST(SUBSTRING([ZVALNET_CFLETE],2,11) AS DECIMAL(12,2))/-100 ELSE CAST([ZVALNET_CFLETE] AS DECIMAL(12,2))/100 END [ZVALNET_CFLETE]
	  ,CASE WHEN len([VAL_DESC_RR])=12 THEN CAST(SUBSTRING([VAL_DESC_RR],2,11) AS DECIMAL(12,2))/-100 ELSE CAST([VAL_DESC_RR] AS DECIMAL(12,2))/100 END [VAL_DESC_RR]
      ,CASE WHEN len([VAL_DESC_NR])=12 THEN CAST(SUBSTRING([VAL_DESC_NR],2,11) AS DECIMAL(12,2))/-100 ELSE CAST([VAL_DESC_NR] AS DECIMAL(12,2))/100 END [VAL_DESC_NR]
	  ,CASE WHEN len([VAL_DESC_QS])=12 THEN CAST(SUBSTRING([VAL_DESC_QS],2,11) AS DECIMAL(12,2))/-100 ELSE CAST([VAL_DESC_QS] AS DECIMAL(12,2))/100 END [VAL_DESC_QS]
	  ,CASE WHEN len([VAL_FLETE_APROV])=12 THEN CAST(SUBSTRING([VAL_FLETE_APROV],2,11) AS DECIMAL(12,2))/-100 ELSE CAST([VAL_FLETE_APROV] AS DECIMAL(12,2))/100 END [VAL_FLETE_APROV]
      ,CASE WHEN len([ZVALNETO_SF_QS])=12 THEN CAST(SUBSTRING([ZVALNETO_SF_QS],2,11) AS DECIMAL(12,2))/-100 ELSE CAST([ZVALNETO_SF_QS] AS DECIMAL(12,2))/100 END [ZVALNETO_SF_QS]
      ,CAST([TIPO_CAMBIO] AS DECIMAL(12,5))/100000 [TIPO_CAMBIO]
      ,CAST([PJE_DSCTO_CE] AS DECIMAL(5,2))/100 [PJE_DSCTO_CE]
	  ,CASE WHEN len([VALOR_DSCTO_CE])=12 THEN CAST(SUBSTRING([VALOR_DSCTO_CE],2,11) AS DECIMAL(12,2))/-100 ELSE CAST([VALOR_DSCTO_CE] AS DECIMAL(12,2))/100 END [VALOR_DSCTO_CE]
      ,CASE WHEN len([COSTO_UNIT])=12 THEN CAST(SUBSTRING([COSTO_UNIT],2,11) AS DECIMAL(12,2))/-100 ELSE CAST([COSTO_UNIT] AS DECIMAL(12,2))/100 END [COSTO_UNIT]
      ,[ORG_VTAS]
      ,[SECTOR]
      ,[CARACT_NEG]
      ,[TRAT_COMERCIAL]
  FROM mkt.sellout_qs_day;

DELETE FROM mkt.sellout_stage;
INSERT INTO mkt.sellout_stage (Fecha, GrpID, CadenaIDClie, OficinaIDClie, GrupoTratIDClie, VendedorIDClie, SupervisorIDClie,PromotorIDClie, ProIDClie, PdvIDClie, UnidDesp, MontoDespCliente)
SELECT
cast(A.VBRK_FKDAT as varchar(8)) [Fecha],
'307' [GrpID],
cast(COALESCE(CONVERT(VARCHAR,TRY_CONVERT(BIGINT,A.COD_CENTRO)),A.COD_CENTRO) as varchar(4))[CadenaIDClie],
cast(COALESCE(CONVERT(VARCHAR,TRY_CONVERT(BIGINT,A.COD_OFI)),A.COD_OFI) as varchar(4)) [OficinaIDClie],
cast(COALESCE(CONVERT(VARCHAR,TRY_CONVERT(BIGINT,A.TRAT_COMERCIAL)),A.TRAT_COMERCIAL) as varchar(4)) [GrupoTratIDClie],
cast(COALESCE(CONVERT(VARCHAR,TRY_CONVERT(BIGINT,A.COD_VEND)),A.COD_VEND) as varchar(7)) [VendedorIDClie],
cast(NULL as varchar(8)) [SupervisorIDClie],
cast(COALESCE(CONVERT(VARCHAR,TRY_CONVERT(BIGINT,A.COD_PROM)),A.COD_PROM) as varchar(7)) [PromotorIDClie],
cast(COALESCE(CONVERT(VARCHAR,TRY_CONVERT(BIGINT,A.VBRP_MATNR)),A.VBRP_MATNR)  as varchar(12)) [ProIDClie],
cast(COALESCE(CONVERT(VARCHAR,TRY_CONVERT(BIGINT,A.VBRK_KUNAG)),A.VBRK_KUNAG)  as varchar(11)) [PdvIDClie],
cast(A.VBRP_FKIMG as decimal(18,6)) [UnidDesp],
cast(A.ZVALNETO_SF_QS as decimal(18,6)) [MontoDespCliente]
FROM (
       SELECT
         [ID],
         [FECHAGEN],
         [VBRP_MATKL],
         [VBRP_MATNR],
         [WPROD],
         [VBRK_KUNAG],
         [KNA1_STCD1],
         [UBIGEO],
         [COD_VEND],
         [COD_PROM],
         [FREE1],
         [COD_OFI],
         [COD_CENTRO],
         [COD_ALM],
         [VBAK_VBELN],
         [VBKD_BSARK_E],
         [VBRK_VBELN],
         [VBRP_POSNR],
         [VBRK_XBLNR],
         [VBRK_ERDAT],
         [VBRK_FKART],
         [VBRK_FKDAT],
         [VBRK_ZZRFOFI],
         [VBRP_CHARG],
         [VBRK_ZTERM],
         [VBRP_AUGRU_AUFT],
         [VBRK_FKSTO],
         CASE WHEN len([VBRP_FKIMG]) = 12
           THEN CAST(SUBSTRING([VBRP_FKIMG], 2, 11) AS DECIMAL(12, 3))/-1000
         ELSE CAST([VBRP_FKIMG] AS DECIMAL(12, 3)) / 1000 END     [VBRP_FKIMG],
         [VBRP_VRKME],
         CAST([VBRP_ZZ_ZP01] AS DECIMAL(12, 2)) / 100             [VBRP_ZZ_ZP01],
         [VBRK_WAERK],
         CAST([DESC_RR] AS DECIMAL(7, 2)) / 100                   [DESC_RR],
         CAST([DESC_NR] AS DECIMAL(7, 2)) / 100                   [DESC_NR],
         CASE WHEN len([VBRP_KZWI1]) = 12
           THEN CAST(SUBSTRING([VBRP_KZWI1], 2, 11) AS DECIMAL(12, 2))/-100
         ELSE CAST([VBRP_KZWI1] AS DECIMAL(12, 2)) / 100 END      [VBRP_KZWI1],
         CASE WHEN len([ZVALVTA_UNI]) = 12
           THEN CAST(SUBSTRING([ZVALVTA_UNI], 2, 11) AS DECIMAL(12, 2))/-100
         ELSE CAST([ZVALVTA_UNI] AS DECIMAL(12, 2)) / 100 END     [ZVALVTA_UNI],
         CASE WHEN len([ZIMP_BRUTO]) = 12
           THEN CAST(SUBSTRING([ZIMP_BRUTO], 2, 11) AS DECIMAL(12, 2))/-100
         ELSE CAST([ZIMP_BRUTO] AS DECIMAL(12, 2)) / 100 END      [ZIMP_BRUTO],
         CAST([ZMARGEN] AS DECIMAL(6, 2)) / 100                   [ZMARGEN],
         CASE WHEN len([ZVAL_VTAIMP]) = 12
           THEN CAST(SUBSTRING([ZVAL_VTAIMP], 2, 11) AS DECIMAL(12, 2))/-100
         ELSE CAST([ZVAL_VTAIMP] AS DECIMAL(12, 2)) / 100 END     [ZVAL_VTAIMP],
         CASE WHEN len([ZIMP_IMPTO]) = 12
           THEN CAST(SUBSTRING([ZIMP_IMPTO], 2, 11) AS DECIMAL(12, 2))/-100
         ELSE CAST([ZIMP_IMPTO] AS DECIMAL(12, 2)) / 100 END      [ZIMP_IMPTO],
         CAST([DESC_QS] AS DECIMAL(6, 2)) / 100                   [DESC_QS],
         CASE WHEN len([ZVALNETO]) = 12
           THEN CAST(SUBSTRING([ZVALNETO], 2, 11) AS DECIMAL(12, 2))/-100
         ELSE CAST([ZVALNETO] AS DECIMAL(12, 2)) / 100 END        [ZVALNETO],
         [CLS_PED],
         [IND_BONIF],
         CASE WHEN len([ZVALNET_CFLETE]) = 12
           THEN CAST(SUBSTRING([ZVALNET_CFLETE], 2, 11) AS DECIMAL(12, 2))/-100
         ELSE CAST([ZVALNET_CFLETE] AS DECIMAL(12, 2)) / 100 END  [ZVALNET_CFLETE],
         CASE WHEN len([VAL_DESC_RR]) = 12
           THEN CAST(SUBSTRING([VAL_DESC_RR], 2, 11) AS DECIMAL(12, 2))/-100
         ELSE CAST([VAL_DESC_RR] AS DECIMAL(12, 2)) / 100 END     [VAL_DESC_RR],
         CASE WHEN len([VAL_DESC_NR]) = 12
           THEN CAST(SUBSTRING([VAL_DESC_NR], 2, 11) AS DECIMAL(12, 2))/-100
         ELSE CAST([VAL_DESC_NR] AS DECIMAL(12, 2)) / 100 END     [VAL_DESC_NR],
         CASE WHEN len([VAL_DESC_QS]) = 12
           THEN CAST(SUBSTRING([VAL_DESC_QS], 2, 11) AS DECIMAL(12, 2))/-100
         ELSE CAST([VAL_DESC_QS] AS DECIMAL(12, 2)) / 100 END     [VAL_DESC_QS],
         CASE WHEN len([VAL_FLETE_APROV]) = 12
           THEN CAST(SUBSTRING([VAL_FLETE_APROV], 2, 11) AS DECIMAL(12, 2))/-100
         ELSE CAST([VAL_FLETE_APROV] AS DECIMAL(12, 2)) / 100 END [VAL_FLETE_APROV],
         CASE WHEN len([ZVALNETO_SF_QS]) = 12
           THEN CAST(SUBSTRING([ZVALNETO_SF_QS], 2, 11) AS DECIMAL(12, 2))/-100
         ELSE CAST([ZVALNETO_SF_QS] AS DECIMAL(12, 2)) / 100 END  [ZVALNETO_SF_QS],
         CAST([TIPO_CAMBIO] AS DECIMAL(12, 5)) / 100000           [TIPO_CAMBIO],
         CAST([PJE_DSCTO_CE] AS DECIMAL(5, 2)) / 100              [PJE_DSCTO_CE],
         CASE WHEN len([VALOR_DSCTO_CE]) = 12
           THEN CAST(SUBSTRING([VALOR_DSCTO_CE], 2, 11) AS DECIMAL(12, 2))/-100
         ELSE CAST([VALOR_DSCTO_CE] AS DECIMAL(12, 2)) / 100 END  [VALOR_DSCTO_CE],
         CASE WHEN len([COSTO_UNIT]) = 12
           THEN CAST(SUBSTRING([COSTO_UNIT], 2, 11) AS DECIMAL(12, 2))/-100
         ELSE CAST([COSTO_UNIT] AS DECIMAL(12, 2)) / 100 END      [COSTO_UNIT],
         [ORG_VTAS],
         [SECTOR],
         [CARACT_NEG],
         [TRAT_COMERCIAL]
       FROM mkt.sellout_qs_day
     ) A;


print ('VALIDACIONES')
/*CHECK PRODUCTO FUENTE*/

insert into per.MAESTRO_PRODUCTO_FUENTE
SELECT
A.ProIDClie,
A.GrpID GRPID,
'0000' PROPSTID
	FROM (
		SELECT DISTINCT A.ProIDClie,A.GrpID FROM mkt.sellout_stage A
			LEFT JOIN per.MAESTRO_PRODUCTO_FUENTE B
				ON A.ProIDClie=B.ProIDClie AND B.GrpID=A.GrpID
		WHERE B.ProPstID IS NULL
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
    SELECT DISTINCT A.PdvIDClie,A.GrpID  FROM mkt.sellout_stage A
      LEFT JOIN per.MAESTRO_PDV B
        ON A.PdvIDClie=B.PdvIDClie AND A.GrpID=B.GrpID
    WHERE A.PdvIDClie IS NOT NULL AND B.PdvID IS NULL
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
			FROM mkt.sellout_stage A
			LEFT JOIN per.MAESTRO_CADENA B
				ON A.CadenaIDClie=B.CadenaIDClie AND A.GrpID=B.GrpID
		WHERE A.CadenaIDClie IS NOT NULL AND B.CadenaID IS NULL
	) A;

/*CHECK OFICINAID*/

INSERT INTO per.MAESTRO_OFICINA
(OficinaID, OficinaIDClie, DescOficina, GrpID)
SELECT NEXT VALUE FOR per.seq_oficinaid OVER(ORDER BY A.OficinaIDClie),
A.OficinaIDClie,
A.OficinaIDClie,
A.GrpID
	FROM (
		SELECT DISTINCT A.OficinaIDClie, A.GrpID
			FROM mkt.sellout_stage A
			LEFT JOIN per.MAESTRO_OFICINA B
				ON A.OficinaIDClie=B.OficinaIDClie AND A.GrpID=B.GrpID
		WHERE A.OficinaIDClie IS NOT NULL AND B.OficinaID IS NULL
	) A;

/*CHECK TARGETGROUP*/

insert into per.MAESTRO_GRUPO1
(Grupo1ID, Grupo1IDClie, DescGrupo1, GrpID)
SELECT
NEXT VALUE FOR [per].[seq_Grupo1id] OVER(ORDER BY A.GrupoTratIDClie),
A.GrupoTratIDClie,
A.GrupoTratIDClie,
A.GrpID
	FROM (
		SELECT DISTINCT A.GrupoTratIDClie,A.GrpID
			FROM mkt.sellout_stage A
			LEFT JOIN per.MAESTRO_GRUPO1 B
				ON A.GrupoTratIDClie=B.Grupo1IDClie AND A.GrpID=B.GrpID
		WHERE A.GrupoTratIDClie IS NOT NULL AND B.Grupo1ID IS NULL
	) A;

/*CHECK VENDEDOR*/

insert into per.MAESTRO_VENDEDOR
(VendedorID, VendedorIDClie, DescVendedor, GrpID)
SELECT
NEXT VALUE FOR [per].[seq_vendedorid] OVER(ORDER BY A.VendedorIDClie),
A.VendedorIDClie,
A.VendedorIDClie,
A.GrpID
	FROM (
		SELECT DISTINCT A.VendedorIDClie,A.GrpID
			FROM mkt.sellout_stage A
			LEFT JOIN per.MAESTRO_VENDEDOR B
				ON A.VendedorIDClie=B.VendedorIDClie
		WHERE A.VendedorIDClie IS NOT NULL AND B.VendedorID IS NULL
	) A;

/*CHECK SUPERVISOR*/

insert into per.MAESTRO_SUPERVISOR
(SupervisorID, SupervisorIDClie, DescSupervisor, GrpID)
SELECT
NEXT VALUE FOR [per].[seq_vendedorid] OVER(ORDER BY A.SupervisorIDClie),
A.SupervisorIDClie,
A.SupervisorIDClie,
A.GrpID
	FROM (
		SELECT DISTINCT A.SupervisorIDClie,A.GrpID
			FROM mkt.sellout_stage A
			LEFT JOIN per.MAESTRO_SUPERVISOR B
				ON A.SupervisorIDClie=B.SupervisorIDClie
		WHERE A.SupervisorIDClie IS NOT NULL AND B.SupervisorID IS NULL
	) A;

/*CHECK PRECIO**/

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
					FROM mkt.sellout_stage A
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


DELETE FROM per.GLP_SELLOUT
WHERE Fecha in (SELECT DISTINCT Fecha FROM mkt.sellout_stage)
      AND GrpID in (SELECT DISTINCT GrpID FROM mkt.sellout_stage);

INSERT INTO per.GLP_SELLOUT (Fecha, GrpID, CadenaIDClie, OficinaIDClie, GrupoTratIDClie, VendedorIDClie, SupervisorIDClie, ProIDClie, PdvIDClie, UnidDesp, MontoDespCliente)
		SELECT
		Fecha,
		GrpID,
		CadenaIDClie,
		OficinaIDClie,
		GrupoTratIDClie,
		VendedorIDClie,
		SupervisorIDClie,
		ProIDClie,
		PdvIDClie,
		sum(UnidDesp) UnidDesp,
		sum(MontoDespCliente) MontoDespCliente
			FROM mkt.sellout_stage
		GROUP BY
			Fecha,
			GrpID,
			CadenaIDClie,
			OficinaIDClie,
			GrupoTratIDClie,
			VendedorIDClie,
			SupervisorIDClie,
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

UPDATE PER.MAESTRO_PDV
SET CategoriaPdv='E(0%)';

UPDATE A
SET A.CategoriaPdv=b.CATEGORIA
    FROM PER.MAESTRO_PDV A
    INNER JOIN (
				SELECT A.GrpID,A.PdvIDClie,A.MontoDespCliente,A.SUMACUM,
				CASE WHEN SUMACUM<=0.5  THEN 'A(50%)'
				WHEN SUMACUM<=0.8  THEN 'B(30%)'
				WHEN SUMACUM<=0.95  THEN 'C(15%)'
				ELSE 'D(5%)' END CATEGORIA
				--INTO MKT.PDV_IK_CAT
				FROM
				(
				  SELECT A.GrpID,A.PdvIDClie,MontoDespCliente,SUM(MontoDespCliente) OVER
            (PARTITION BY GrpID ORDER BY MontoDespCliente DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)/SUM(MontoDespCliente) OVER (PARTITION BY GrpID) SUMACUM FROM
            (
              SELECT
                GrpID,
                PdvIDClie,
                sum(MontoDespCliente) MontoDespCliente
              FROM per.GLP_SELLOUT
              WHERE substring(fecha, 1, 4) = 2015
              GROUP BY GrpID,PdvIDClie
            ) A
          WHERE MontoDespCliente>0
				) A
	) B
ON A.PdvIDClie=B.PdvIDClie AND A.GrpID=B.GrpID;