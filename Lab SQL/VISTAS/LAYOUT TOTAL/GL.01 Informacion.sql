DROP VIEW vw.[GL.01 Informacion];
CREATE VIEW vw.[GL.01 Informacion]
AS
SELECT
substring(A.[Fecha],7,2)+'/'+SUBSTRING(A.fecha,5,2)+'/'+SUBSTRING(A.fecha,1,4) Fecha,
substring(A.[Año-Semana],1,4)+'-'+substring(A.[Año-Semana],5,2) [Año-Semana],
A.GrpID GrupoID,
B.CadenaID,
J.PdvID,
H.ProPstID,
A.ProIDClie,
A.UnidDesp,
A.UnidExist,
A.UnidCedis,
A.UnidTrans,
A.MontoDespCliente,
A.UnidDesp*I.PVP MontoDespPvp,
A.UnidDesp*I.PrecioLista MontoDesp--,
--A.UnidExist*I.PrecioLista MontoExist,
--A.UnidCedis*I.PrecioLista MontoCedis,
--A.UnidTrans*I.PrecioLista MontoTrans,
--A.GrpID+'-'+H.ProPstID [GrupoID-ProPstID]
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
t.AñoSemana_GL [Año-Semana]
FROM PER.GLP_SELLOUT A
LEFT JOIN
(
SELECT * FROM
PER.GLP_STOCK
WHERE 1=2) B
ON A.ProIDClie=B.ProIDClie
LEFT JOIN per.MAESTRO_TIEMPO T
ON A.Fecha = T.Fecha
WHERE A.GrpID in ('307','327','337','338','308','309','311','312','328')
/*
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
  CASE WHEN numero=1 THEN AñoSemana_GL ELSE NULL END [Año-Semana]
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
      T.AñoSemana_GL,
      T.Dia_Semana,
      DENSE_RANK()
      OVER (PARTITION BY B.GrpID,T.AñoSemana_GL
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
    WHERE B.GrpID in ('307','327','337','338','308','309','311','312','328')
  ) A
  WHERE numero=1
/**/*/
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
	ON A.PdvIDClie=J.PdvIDClie AND A.GrpID=J.GrpID;


CREATE VIEW vw.[GL.02 Cuenta]
AS
SELECT
[GrpID] GrupoID,
[GrpNombre],
[GrpRFC],
[GrpURL],
[GrpRazonSocial],
[Canal]
FROM [per].[MAESTRO_CLIENTE]
WHERE GrpID in ('307','327','337','338','308','309','311','312','328');


CREATE VIEW vw.[GL.03 Cadena]
AS
SELECT
[GrpID] GrupoID,
CadenaID,
CadenaIDClie,
[DescCadena] CadenaNombreClie
FROM [per].[MAESTRO_CADENA]
WHERE GrpID in ('307','327','337','338','308','309','311','312','328');

CREATE VIEW vw.[GL.04 Geografia]
AS
SELECT
  UbigeoID,
  Pais,
  Departamento,
  Provincia,
  Distrito,
  Region_I,
  Region_II,
  Region_III,
  Zona_I,
  Zona_II
FROM per.MAESTRO_UBIGEO;

CREATE VIEW vw.[GL.05 Punto de Venta]
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
  Tiendas
FROM [per].[MAESTRO_PDV]
WHERE GrpID in ('307','327','337','338','308','309','311','312','328');

CREATE VIEW vw.[GL.06 Producto]
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


CREATE VIEW vw.[GL.07 Tiempo]
AS
SELECT
substring([Fecha],7,2)+'/'+SUBSTRING(fecha,5,2)+'/'+SUBSTRING(fecha,1,4) Fecha,
substring([AñoSemana_GL],1,4)+'-'+substring([AñoSemana_GL],5,2) [AñoSemana_GL],
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
  SELECT min(Fecha) FROM per.GLP_SELLOUT WHERE GrpID in  ('307','327','337','338','308','309','311','312','328')
) and Fecha <=(
  SELECT max(Fecha) FROM per.GLP_SELLOUT WHERE GrpID in  ('307','327','337','338','308','309','311','312','328')
);





CREATE VIEW vw.[GL.08 ProductoFuente]
AS
SELECT
[ProIDClie],
[GrpID] GrupoID,
[ProPstID],
GrpID+'-'+ProPstID [GrupoID-ProPstID]
FROM [per].[MAESTRO_PRODUCTO_FUENTE] A
WHERE GrpID in  ('307','327','337','338','308','309','311','312','328');

CREATE VIEW vw.[GL.09 TiempoSemana]
AS
SELECT
substring([AñoSemana_GL],1,4)+'-'+substring([AñoSemana_GL],5,2) [AñoSemana_GL],
[Año_GL],
[Semana_GL],
min(Fecha) FechaInicio,
max(Fecha) FechaFin
FROM [per].[MAESTRO_TIEMPO]
WHERE Fecha >=(
  SELECT min(Fecha) FROM per.GLP_SELLOUT WHERE GrpID in  ('307','327','337','338','308','309','311','312','328')
) and Fecha <=(
  SELECT max(Fecha) FROM per.GLP_SELLOUT WHERE GrpID in  ('307','327','337','338','308','309','311','312','328')
)
GROUP BY [AñoSemana_GL],[Año_GL],[Semana_GL];



SELECT GrupoID, COUNT(1) ,COUNT(DISTINCT ProIDClie),COUNT(DISTINCT ProPstID) FROM vw.[GL.08 ProductoFuente]
GROUP BY GrupoID

SELECT GrupoID, COUNT(1) ,COUNT(DISTINCT PdvIDClie),COUNT(DISTINCT PdvID) FROM vw.[GL.05 Punto de Venta]
GROUP BY GrupoID