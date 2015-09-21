DROP VIEW vw.[Dist.01 Informacion];
CREATE VIEW vw.[Dist.01 Informacion]
AS
SELECT
substring(A.[Fecha],7,2)+'/'+SUBSTRING(A.fecha,5,2)+'/'+SUBSTRING(A.fecha,1,4) Fecha,
substring(A.AñoSemana_GL,1,4)+'-'+substring(A.AñoSemana_GL,5,2) [Año-Semana],
A.[Año-Mes],
A.GrpID GrupoID,
B.CadenaID,
C.OficinaID,
D.Grupo1ID GrupoTratID,
F.SupervisorID,
P.PromotorID,
E.VendedorID,
J.PdvID,
H.ProPstID,
A.ProIDClie,
A.UnidDesp,
A.UnidExist,
A.UnidCedis,
A.UnidTrans,
A.MontoDespCliente,
A.UnidDesp*I.PVP MontoDespPvp,
A.UnidDesp*I.PrecioLista MontoDesp,
A.UnidExist*I.PrecioLista MontoExist,
A.UnidCedis*I.PrecioLista MontoCedis,
A.UnidTrans*I.PrecioLista MontoTrans
FROM
(
/**/
SELECT
A.Fecha,
A.GrpID,
A.CadenaIDClie,
A.OficinaIDClie,
A.GrupoTratIDClie,
A.SupervisorIDClie,
A.PromotorIDClie,
A.VendedorIDClie,
A.ProIDClie,
A.PdvIDClie,
A.UnidDesp,
B.UnidExist,
B.UnidCedis,
B.UnidTrans,
A.MontoDespCliente,
t.AñoSemana_GL,
concat(t.Año,'-',RIGHT('00'+ CAST(t.mes AS VARCHAR(2)), 2)) [Año-Mes]
FROM PER.GLP_SELLOUT A
LEFT JOIN
(
SELECT * FROM
PER.GLP_STOCK
WHERE 1=2) B
ON A.ProIDClie=B.ProIDClie
LEFT JOIN per.MAESTRO_TIEMPO T
ON A.Fecha = T.Fecha
WHERE A.GrpID in('307','327','337','338')
/*--*/
UNION ALL
/**/
SELECT
  Fecha,
  GrpID,
  CadenaIDClie,
  OficinaIDClie,
  GrupoTratIDClie,
  SupervisorIDClie,
  PromotorIDClie,
  VendedorIDClie,
  ProIDClie,
  PdvIDClie,
  UnidDesp,
  UnidExist,
  UnidCedis,
  UnidTrans,
  MontoDespCliente,
  CASE WHEN numero=1 THEN AñoSemana_GL ELSE NULL END [Año-Semana],
  CASE WHEN numero_mes=1 THEN [Año-Mes] ELSE NULL END [Año-Mes]
FROM
  (
    SELECT
      B.Fecha,
      B.GrpID,
      B.CadenaIDClie,
      A.OficinaIDClie,
      A.GrupoTratIDClie,
      A.SupervisorIDClie,
      A.PromotorIDClie,
      A.VendedorIDClie,
      B.ProIDClie,
      B.PdvIDClie,
      A.UnidDesp,
      B.UnidExist,
      B.UnidCedis,
      B.UnidTrans,
      A.MontoDespCliente,
      T.AñoSemana_GL,
      concat(t.Año,'-',RIGHT('00'+ CAST(t.mes AS VARCHAR(2)), 2)) [Año-Mes],
      --T.Dia_Semana,
      DENSE_RANK()
      OVER (PARTITION BY T.AñoSemana_GL
        ORDER BY T.Dia_Semana DESC) numero,
      DENSE_RANK()
      OVER (PARTITION BY concat(t.Año,'-',RIGHT('00'+ CAST(t.mes AS VARCHAR(2)), 2))
        ORDER BY T.Dia_Mes DESC) numero_mes
    FROM PER.GLP_STOCK B
      LEFT JOIN
      (
        SELECT *
        FROM
          PER.GLP_SELLOUT
        WHERE 1 = 2) A
        ON A.ProIDClie = B.ProIDClie
      LEFT JOIN per.MAESTRO_TIEMPO T
        ON B.Fecha = T.Fecha
    WHERE B.GrpID in ('307','327','337','338')
  ) A
/**/
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
	LEFT JOIN per.MAESTRO_OFICINA C
	ON A.OficinaIDClie=C.OficinaIDClie AND A.GrpID=C.GrpID
	LEFT JOIN per.MAESTRO_GRUPO1 D
	ON A.GrupoTratIDClie=D.Grupo1IDClie AND A.GrpID=D.GrpID
	LEFT JOIN per.MAESTRO_VENDEDOR E
	ON A.VendedorIDClie=E.VendedorIDClie AND A.GrpID=E.GrpID
	LEFT JOIN per.MAESTRO_SUPERVISOR F
	ON A.SupervisorIDClie=F.SupervisorIDClie AND A.GrpID=F.GrpID
	LEFT JOIN per.MAESTRO_PROMOTOR P
	ON A.PromotorIDClie=P.PromotorIDClie AND A.GrpID=P.GrpID
WHERE A.Fecha>='20131230';

CREATE VIEW vw.[Dist.02 Cuenta]
AS
SELECT
[GrpID] GrupoID,
[GrpNombre],
[GrpRFC],
[GrpURL],
[GrpRazonSocial],
[Canal]
FROM [per].[MAESTRO_CLIENTE]
WHERE GrpID in ('307','327','337','338');


CREATE VIEW vw.[Dist.03 Centro]
AS
SELECT
[GrpID] GrupoID,
CadenaID,
CadenaIDClie,
[DescCadena] CadenaNombreClie
FROM [per].[MAESTRO_CADENA]
WHERE GrpID in ('307','327','337','338');

DROP VIEW vw.[Dist.04 Geografia];
CREATE VIEW vw.[Dist.04 Geografia]
AS
SELECT
  UbigeoID,
  Pais,
  Departamento,
  Provincia,
  Distrito,
  Region_I,
  Region_II,
  Region_III
FROM per.MAESTRO_UBIGEO;

DROP VIEW vw.[Dist.05 Punto de Venta];
CREATE VIEW vw.[Dist.05 Punto de Venta]
AS
SELECT
  PdvID,
  PdvIDClie,
  RUC,
  PdvNombre,
  UbigeoID,
  Direccion,
  GrpID GrupoID,
  PdvNombreHomologo,
  StatusPdv,
  CategoriaPdv,
  Segmentacion_GL_I,
  Segmentacion_GL_II,
  Tipo,
  Formato,
  Denominacion,
  Tiendas,
  Longitud,
  Latitud,
  [Target I],
  [Target II]
FROM [per].[MAESTRO_PDV]
WHERE GrpID in ('307','327','337','338');

CREATE VIEW vw.[Dist.06 Producto]
AS
SELECT
A.[ProPstID],
A.[ProPstCodBarras],
A.[ProPstCodigoAtlas],
A.[ProPstNombre],
B.[ProNombre],
C.[AgrProNombre],
D.[LinNombre],
E.[MrcNombre],
A.Rubro,
  A.SegmentacionGL,
  A.StatusLanzamiento,
  A.StatusProd
FROM [per].[MAESTRO_PRODUCTO_PRESENTACION] A
LEFT JOIN [per].[MAESTRO_PRODUCTO] B
ON A.[ProID]= B.PROID
LEFT JOIN [per].[MAESTRO_PRODUCTO_AGRPAUTA] C
ON A.[AgrProID]= C.[AgrProID]
LEFT JOIN [per].[MAESTRO_PRODUCTO_LINEA] D
ON A.[LinID]= D.[LinID]
LEFT JOIN [per].[MAESTRO_PRODUCTO_MARCA] E
ON A.[MrcID]= E.[MrcID];

DROP VIEW vw.[Dist.07 Tiempo];
CREATE VIEW vw.[Dist.07 Tiempo]
AS
SELECT
substring([Fecha],7,2)+'/'+SUBSTRING(fecha,5,2)+'/'+SUBSTRING(fecha,1,4) Fecha,
substring([AñoSemana_GL],1,4)+'-'+substring([AñoSemana_GL],5,2) [Año-Semana_GL],
[Año_GL],
[Semana_GL],
[Año],
CASE WHEN Mes in (1,2,3) THEN 'I'
    WHEN Mes in (4,5,6) THEN 'II'
      WHEN Mes in (7,8,9) THEN 'III'
        WHEN Mes in (10,11,12) THEN 'IV' END Trimestre,
[Mes],
[Año.Mes],
[Dia_Mes],
[Dia_Año],
[Dia_Semana]
FROM [per].[MAESTRO_TIEMPO]
WHERE Fecha >=(
  SELECT min(Fecha) FROM per.GLP_SELLOUT WHERE GrpID in  ('307','327','337','338')
) and Fecha <=(
  SELECT max(Fecha) FROM per.GLP_SELLOUT WHERE GrpID in  ('307','327','337','338')
);

DROP VIEW vw.[Dist.08 TiempoMes];
CREATE VIEW vw.[Dist.08 TiempoMes] AS
SELECT
  AñoMes,
  Año,
  Mes,
  [Año.Mes],
  Fecha_Inicio,
  Fecha_Fin,
  AñoMesID,
  MIN(AñoMesID) OVER(PARTITION BY Año) YTDID
FROM (
  SELECT
    AñoMes,
    Año,
    Mes,
    [Año.Mes],
    Fecha_Inicio,
    Fecha_Fin,
    ROW_NUMBER()
    OVER (
      ORDER BY AñO ASC, Mes ASC) AñoMesID
  FROM (
         SELECT
           CONVERT(VARCHAR, A.Año * 100 + A.Mes) AñoMes,
           A.Año,
           A.Mes,
           A.[Año.Mes],
           MIN(Fecha)                            Fecha_Inicio,
           MAX(Fecha)                            Fecha_Fin
         FROM vw.[Dist.07 Tiempo] A
         GROUP BY CONVERT(VARCHAR, A.Año * 100 + A.Mes), A.Año, A.Mes, A.[Año.Mes]
       ) A
) A;

CREATE VIEW vw.[Dist.09 Oficina]
AS
SELECT
GrpID GrupoID,
[OficinaID],
[OficinaIDClie],
[DescOficina] OficinaNombreClie
FROM [per].[MAESTRO_OFICINA]
WHERE GrpID in  ('307','327','337','338');



CREATE VIEW vw.[Dist.10 Tratamiento Comercial]
AS
SELECT
GrpID GrupoID,
[Grupo1ID] GrupoTratID,
[Grupo1IDClie] GrupoTratIDClie,
[DescGrupo1] GrupoTratNombreClie
FROM [per].[MAESTRO_GRUPO1]
WHERE GrpID in  ('307','327','337','338');

CREATE VIEW vw.[Dist.11 Supervisor]
  AS
SELECT
  GrpID GrupoID,
  SupervisorID,
  SupervisorIDClie,
  DescSupervisor
FROM per.MAESTRO_SUPERVISOR
WHERE GrpID in  ('307','327','337','338');

CREATE VIEW vw.[Dist.12 Promotor]
  AS
SELECT
  GrpID GrupoID,
  PromotorID,
  PromotorIDClie,
  DescPromotor
FROM per.MAESTRO_PROMOTOR
WHERE GrpID in  ('307','327','337','338');

CREATE VIEW vw.[Dist.13 Vendedor]
AS
SELECT
GrpID GrupoID,
[VendedorID],
[VendedorIDClie],
[DescVendedor] VendedorNombreClie
FROM [per].[MAESTRO_VENDEDOR]
WHERE GrpID in  ('307','327','337','338');


