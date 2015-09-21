DELETE FROM mkt.SELLOUT_SPP_HISTW
WHERE Fecha in
(SELECT DISTINCT CONCAT(SUBSTRING(PERIODO,1,4),SUBSTRING(PERIODO,6,2),SUBSTRING(PERIODO,9,2)) FROM mkt.sellout_sp_day A)
;

INSERT INTO mkt.SELLOUT_SPP_HISTW
SELECT
  substring(PERIODO,1,4)+substring(PERIODO,6,2)+substring(PERIODO,9,2) FECHA,
  COD_SPSA,
  COD_PRODUCTO_PROVEEDOR,
  DESCRIPCION,
  MARCA,
  ESTADO_PROD,
  UMB,
  COD_LOCAL,
  COD_LOCAL_PROVEEDOR,
  DESCRIPCION_LOCAL,
  ESTADO_LOCAL,
  FORMATO,
  TIPO,
  VTA_PERIODO,
  VTA_PUBLICO,
  VTA_COSTO,
  ARCHIVO
FROM mkt.sellout_sp_day;

DELETE FROM mkt.sellout_stage;
INSERT INTO mkt.sellout_stage (Fecha, GrpID, CadenaIDClie, OficinaIDClie, GrupoTratIDClie, VendedorIDClie, SupervisorIDClie, ProIDClie, PdvIDClie, UnidDesp, MontoDespCliente)
SELECT
cast(A.FECHA as varchar(8)) [Fecha],
'308' [GrpID],
cast('1001' as varchar(4))[CadenaIDClie],
cast(NULL as varchar(4)) [OficinaIDClie],
cast(NULL as varchar(4)) [GrupoTratIDClie],
cast(NULL as varchar(7)) [VendedorIDClie],
cast(NULL as varchar(8)) [SupervisorIDClie],
cast(convert(bigint,A.COD_SPSA)  as varchar(12)) [ProIDClie],
cast(A.COD_LOCAL as varchar(11)) [PdvIDClie],
cast(A.VTA_PERIODO as decimal(18,6)) [UnidDesp],
cast(A.VTA_PUBLICO as decimal(18,6)) [MontoDespCliente]
FROM (
      SELECT
        substring(PERIODO,1,4)+substring(PERIODO,6,2)+substring(PERIODO,9,2) FECHA,
        COD_SPSA,
        COD_PRODUCTO_PROVEEDOR,
        DESCRIPCION,
        MARCA,
        ESTADO_PROD,
        UMB,
        COD_LOCAL,
        COD_LOCAL_PROVEEDOR,
        DESCRIPCION_LOCAL,
        ESTADO_LOCAL,
        FORMATO,
        TIPO,
        VTA_PERIODO,
        VTA_PUBLICO,
        VTA_COSTO,
        ARCHIVO
          FROM mkt.sellout_sp_day
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
					FROM mkt.sellout_stage A
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
		CAST(SUM(UnidDesp) as DECIMAL(18,6)) UnidDesp,
		CAST(SUM(MontoDespCliente) as DECIMAL(18,6)) MontoDespCliente
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
                Año,
                Semana,
                GrupoID GrpID,
                GrpNombre,
                ProPstID,
                ProPstNombre,
                [PL (Sin IGV)],
                [PVP (Sin IGV)]
              FROM OPENROWSET('Microsoft.ACE.OLEDB.15.0',
                 'Excel 12.0 Xml;HDR=YES;IMEX=1;Database=\\perfile01\INFORMACION COMERCIAL - PERU\Perú\Maestros\Maestros Base\Maestro Precios.xlsx',
                 'SELECT * FROM [Maestro de Precios$]')
              WHERE grupoid IS NOT NULL
           ) SRC
  ON TGT.ProPstID=SRC.ProPstID AND TGT.GrpID=SRC.GrpID AND TGT.AñoSemana_GL=CONVERT(VARCHAR,SRC.Año*100+SRC.Semana);

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