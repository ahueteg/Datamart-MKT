SELECT
SUBSTRING(A.FECHA,7,4)+SUBSTRING(A.FECHA,4,2)+ SUBSTRING(A.FECHA,1,2) FECHA,
A.COD_SUCURSAL,
A.NOMSUCURSAL,
A.TIPCOMERCIAL,
A.COD_CLIENTE,
A.RUC,
A.NOMCLIENTE,
A.DIRECci�n,
A.DIST,
A.PROV,
A.DEPT,
A.COD_SUPERVISOR,
A.NOMSUPERVISOR,
A.COD_VENDEDOR,
A.NOMVENDEDOR,
A.COD_PRODUCTO,
A.NOMPRODUCTO,
A.CANTIDAD,
A.VENTA_NETA
INTO MKT.SELLOUT_KEYMARK_HISTW
FROM MKT.SELLOUT_KEYMARK_HIST A

DELETE FROM mkt.sellout_stage;
INSERT INTO mkt.sellout_stage (Fecha, GrpID, CadenaIDClie, OficinaIDClie, GrupoTratIDClie, VendedorIDClie, SupervisorIDClie, ProIDClie, PdvIDClie, UnidDesp, MontoDespCliente)
SELECT
cast(A.FECHA as varchar(8)) [Fecha],
'338' [GrpID],
cast(A.COD_SUCURSAL as varchar(4))[CadenaIDClie],
cast(null as varchar(4)) [OficinaIDClie],
cast(TIPCOMERCIAL as varchar(4)) [GrupoTratIDClie],
cast(A.COD_VENDEDOR as varchar(7)) [VendedorIDClie],
cast(A.COD_SUPERVISOR as varchar(8)) [SupervisorIDClie],
cast(convert(bigint,A.COD_PRODUCTO)  as varchar(12)) [ProIDClie],
cast(COALESCE(CONVERT(VARCHAR,TRY_CONVERT(BIGINT,A.COD_CLIENTE)),A.COD_CLIENTE) as varchar(11)) [PdvIDClie],
cast(A.CANTIDAD as decimal(18,6)) [UnidDesp],
cast(A.VENTA_NETA as decimal(18,6)) [MontoDespCliente]
FROM mkt.SELLOUT_KEYMARK_HISTW A;


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


DELETE FROM per.GLP_SELLOUT
WHERE GrpID IN
			(SELECT DISTINCT GrpID FROM mkt.sellout_stage)

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
			PdvIDClie