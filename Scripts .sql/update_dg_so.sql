
DELETE FROM MKT.SELLOUT_DIGA_HISTW
WHERE substring(FECHA,1,6) in (
		SELECT SUBSTRING(MAX(SUBSTRING(A.FECHA, 7, 4) + SUBSTRING(A.FECHA, 4, 2) + SUBSTRING(A.FECHA, 1, 2)),1,6) FROM mkt.sellout_dg_day A
);

INSERT INTO MKT.SELLOUT_DIGA_HISTW
SELECT
  SUBSTRING(A.FECHA, 7, 4) + SUBSTRING(A.FECHA, 4, 2) + SUBSTRING(A.FECHA, 1, 2) FECHA,
  A.COD_SUCURSAL,
  A.NOM_SUCURSAL,
  A.TIPO_CLIENTE,
  A.COD_CLIENTE,
  A.DOC_IDENTIDAD,
  A.NOM_CLIENTE,
  A.DIRECCION,
  A.DISTRITO,
  A.PROVINCIA,
  A.DEPARTAMENTO,
  A.COD_SUPER,
  A.NOM_SUPER,
  A.COD_VEND,
  A.NOM_VEND,
  A.COD_PROD,
  A.DESCR_PROD,
  A.CANTIDAD,
  A.VALORVTA
FROM mkt.sellout_dg_day A
WHERE SUBSTRING(A.FECHA, 7, 4) + SUBSTRING(A.FECHA, 4, 2) in (
		SELECT SUBSTRING(MAX(SUBSTRING(A.FECHA, 7, 4) + SUBSTRING(A.FECHA, 4, 2) + SUBSTRING(A.FECHA, 1, 2)),1,6) FROM mkt.sellout_dg_day A
);

--DROP TABLE mkt.sellout_stage;
DELETE FROM mkt.sellout_stage;
INSERT INTO mkt.sellout_stage (Fecha, GrpID, CadenaIDClie, OficinaIDClie, GrupoTratIDClie, VendedorIDClie, SupervisorIDClie, ProIDClie, PdvIDClie, UnidDesp, MontoDespCliente)
SELECT
cast(A.FECHA as varchar(8)) [Fecha],
'337' [GrpID],
cast(convert(int,A.COD_SUCURSAL) as varchar(4))[CadenaIDClie],
cast(null as varchar(4)) [OficinaIDClie],
cast(null as varchar(4)) [GrupoTratIDClie],
cast(A.COD_VEND as varchar(7)) [VendedorIDClie],
cast(A.COD_SUPER as varchar(7)) [SupervisorIDClie],
cast(convert(int,A.COD_PROD)  as varchar(12)) [ProIDClie],
cast(convert(int,A.COD_CLIENTE) as varchar(11)) [PdvIDClie],
cast(A.CANTIDAD as decimal(18,6)) [UnidDesp],
cast(A.VALORVTA as decimal(18,6)) [MontoDespCliente]
  FROM (
    SELECT
      SUBSTRING(A.FECHA, 7, 4) + SUBSTRING(A.FECHA, 4, 2) + SUBSTRING(A.FECHA, 1, 2) FECHA,
      A.COD_SUCURSAL,
      A.NOM_SUCURSAL,
      A.TIPO_CLIENTE,
      A.COD_CLIENTE,
      A.DOC_IDENTIDAD,
      A.NOM_CLIENTE,
      A.DIRECCION,
      A.DISTRITO,
      A.PROVINCIA,
      A.DEPARTAMENTO,
      A.COD_SUPER,
      A.NOM_SUPER,
      A.COD_VEND,
      A.NOM_VEND,
      A.COD_PROD,
      A.DESCR_PROD,
      A.CANTIDAD,
      A.VALORVTA
    FROM [mkt].[sellout_dg_day] A
		WHERE SUBSTRING(A.FECHA, 7, 4) + SUBSTRING(A.FECHA, 4, 2) in (
		SELECT SUBSTRING(MAX(SUBSTRING(A.FECHA, 7, 4) + SUBSTRING(A.FECHA, 4, 2) + SUBSTRING(A.FECHA, 1, 2)),1,6) FROM mkt.sellout_dg_day A
		)
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

--DROP TABLE per.INFO_SELLOUT;
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
