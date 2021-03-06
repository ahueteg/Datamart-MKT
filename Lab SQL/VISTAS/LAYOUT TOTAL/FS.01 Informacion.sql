
DROP VIEW vw.[FS.01 Informacion vs2];
CREATE VIEW vw.[FS.01 Informacion vs2]
  AS
SELECT
CONVERT(DATE,substring(A.[Fecha],7,2)+'/'+SUBSTRING(A.fecha,5,2)+'/'+SUBSTRING(A.fecha,1,4),103)  Fecha,
substring(A.[A�o-Semana],1,4)+'-'+substring(A.[A�o-Semana],5,2) [A�o-Semana],
[A�o-Semana] A�oSemana_GL,
A.GrpID GrupoID,
B.CadenaID,
J.PdvID,
H.ProPstID,
J.PdvID+'-'+H.ProPstID ItemID,
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
A.VendedorIDClie,
A.ProIDClie,
A.PdvIDClie,
A.UnidDesp,
B.UnidExist,
B.UnidCedis,
B.UnidTrans,
A.MontoDespCliente,
t.A�oSemana_GL [A�o-Semana]
FROM PER.GLP_SELLOUT A
LEFT JOIN
(
SELECT * FROM
PER.GLP_STOCK
WHERE 1=2) B
ON A.ProIDClie=B.ProIDClie
LEFT JOIN per.MAESTRO_TIEMPO T
ON A.Fecha = T.Fecha
WHERE A.GrpID in ('308','309','311')--,'312','328')
/**/
UNION ALL
/**/
SELECT
  Fecha,
  GrpID,
  CadenaIDClie,
  OficinaIDClie,
  GrupoTratIDClie,
  SupervisorIDClie,
  VendedorIDClie,
  ProIDClie,
  PdvIDClie,
  UnidDesp,
  UnidExist,
  UnidCedis,
  UnidTrans,
  MontoDespCliente,
  CASE WHEN numero=1 THEN A�oSemana_GL ELSE NULL END [A�o-Semana]
FROM
  (
    SELECT
      B.Fecha,
      B.GrpID,
      B.CadenaIDClie,
      A.OficinaIDClie,
      A.GrupoTratIDClie,
      A.SupervisorIDClie,
      A.VendedorIDClie,
      B.ProIDClie,
      B.PdvIDClie,
      A.UnidDesp,
      B.UnidExist,
      B.UnidCedis,
      B.UnidTrans,
      A.MontoDespCliente,
      T.A�oSemana_GL,
      T.Dia_Semana,
      DENSE_RANK()
      OVER (PARTITION BY B.GrpID,T.A�oSemana_GL
        ORDER BY T.Dia_Semana DESC) numero
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
    WHERE B.GrpID in ('308','309','311')--,'312','328')
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
	ON G.A�oSemana_GL=I.A�oSemana_GL AND H.ProPstID=I.ProPstID AND A.GrpID=I.GrpID
	LEFT JOIN per.MAESTRO_PDV J
	ON A.PdvIDClie=J.PdvIDClie AND A.GrpID=J.GrpID
WHERE A.Fecha>='20131230';


CREATE VIEW vw.[FS.02 Cuenta]
AS
SELECT
[GrpID] GrupoID,
[GrpNombre],
[GrpRFC],
[GrpURL],
[GrpRazonSocial],
[Canal]
FROM [per].[MAESTRO_CLIENTE]
WHERE GrpID in ('308','309','311');--,'312','328');

CREATE VIEW vw.[FSI.02 Cuenta]
AS
SELECT
[GrpID] GrupoID,
[GrpNombre],
[GrpRFC],
[GrpURL],
[GrpRazonSocial],
[Canal]
FROM [per].[MAESTRO_CLIENTE]
WHERE GrpID in ('309');--,'312','328');


CREATE VIEW vw.[FSI.03 Centro]
AS
SELECT
[GrpID] GrupoID,
CadenaID,
CadenaIDClie,
[DescCadena] CadenaNombreClie
FROM [per].[MAESTRO_CADENA]
WHERE GrpID in ('309')--,'312','328');

CREATE VIEW vw.[FSI.04 Geografia]
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

CREATE VIEW vw.[FSI.05 Punto de Venta]
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
  Tipo,
  Formato,
  Denominacion,
  Tiendas,
  Cluster,
  [Target I],
  [Target II]
FROM [per].[MAESTRO_PDV]
WHERE GrpID in ('309');--,'312','328');

CREATE VIEW vw.[FSI.06 Producto]
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

DROP VIEW vw.[FS.07 Tiempo];
CREATE VIEW vw.[FS.07 Tiempo]
AS
SELECT
CONVERT(DATE,substring([Fecha],7,2)+'/'+SUBSTRING(fecha,5,2)+'/'+SUBSTRING(fecha,1,4),103) Fecha,
substring([A�oSemana_GL],1,4)+'-'+substring([A�oSemana_GL],5,2) [A�oSemana_GL],
[A�o_GL],
[Semana_GL],
[A�o],
CASE WHEN Mes in (1,2,3) THEN 'I'
    WHEN Mes in (4,5,6) THEN 'II'
      WHEN Mes in (7,8,9) THEN 'III'
        WHEN Mes in (10,11,12) THEN 'IV' END Trimestre,
[Mes],
[A�o.Mes],
[Dia_Mes],
[Dia_A�o],
[Dia_Semana]
FROM [per].[MAESTRO_TIEMPO]
WHERE Fecha >=(
  SELECT min(Fecha) FROM per.GLP_SELLOUT WHERE GrpID in  ('309','311')--,'312','328')
) and Fecha <=(
  SELECT max(Fecha) FROM per.GLP_SELLOUT WHERE GrpID in  ('308','309','311')--,'312','328')
);

--DROP VIEW vw.[FS.08 TiempoSemana];
CREATE VIEW vw.[FS.08 TiempoSemana] AS
SELECT
  A�oSemana_GL,
  A�o_GL,
  Semana_GL,
  Fecha_Inicio,
  Fecha_Fin,
  A�oSemanaID,
  MIN(A�oSemanaID) OVER(PARTITION BY A�o_GL) YTDID
FROM (
  SELECT
    A�oSemana_GL,
    A�o_GL,
    Semana_GL,
    Fecha_Inicio,
    Fecha_Fin,
    ROW_NUMBER()
    OVER (
      ORDER BY A�o_GL ASC, Semana_GL ASC) A�oSemanaID
  FROM (
         SELECT
           CONVERT(VARCHAR, A.A�o_GL * 100 + A.Semana_GL) A�oSemana_GL,
           A.A�o_GL,
           A.Semana_GL,
           MIN(CONVERT(DATE,Fecha,103))                            Fecha_Inicio,
           MAX(CONVERT(DATE,Fecha,103))                            Fecha_Fin
         FROM vw.[FS.07 Tiempo] A
         GROUP BY A�oSemana_GL, A.A�o_GL, A.Semana_GL
       ) A
) A;

DROP VIEW vw.[FS.09 Logistica];
CREATE VIEW vw.[FS.09 Logistica]
  as
SELECT
  GrupoID+PdvID+ProPstID+A�oSemana_GL LogisticaID,
  GrupoID,
  PdvID,
  ProPstID,
  PdvID+'-'+ProPstID ItemID,
  A�oSemana_GL,
  Mix,
  1 Item,
  Activo,
  Pdv_Agotado_Mix,
  Pdv_PreAgotado_Mix,
  Pdv_Agotado,
  Afect_Agotado_Mix_Unid,
  Afect_Agotado_Mix_Monto,
  Afect_PreAgotado_Mix_Unid,
  Afect_PreAgotado_Mix_Monto,
  Max_A�oSemana_GL,
  Afect_Activo_No_Mix_Dist_Unid,
  Afect_Activo_No_Mix_Dist_Monto,
  Afect_Activo_No_Mix_Dept_Unid,
  Afect_Activo_No_Mix_Dept_Monto,
  Afect_Activo_No_Mix_Reg_Unid,
  Afect_Activo_No_Mix_Reg_Monto
FROM mkt.FS_InfoSemana_Hist;

DROP VIEW vw.[FS.10 Item];
CREATE VIEW vw.[FS.10 Item] as
SELECT
  DISTINCT
  A.GrpID,
  PdvID,
  ProPstID,
  PdvID+'-'+ProPstID ItemID
FROM
  (
    SELECT
      GrpID,
      PdvID
    FROM per.MAESTRO_PDV
    WHERE GrpID IN ('308', '309', '311')
    ) A
LEFT JOIN (
  SELECT
    GrpID,
    ProPstID
  FROM per.MAESTRO_PRODUCTO_FUENTE
  WHERE GrpID IN ('308', '309', '311')
  ) B
  ON A.GrpID=B.GrpID


SELECT CONVERT(DATE,'15/06/2015',103)