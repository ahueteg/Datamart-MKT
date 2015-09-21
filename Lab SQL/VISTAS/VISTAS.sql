CREATE VIEW per.Cadena
AS
SELECT
CadenaID,
CadenaIDClie,
[DescCadena] CadenaNombreClie
FROM [per].[MAESTRO_CADENA];


CREATE VIEW per.Cliente
AS
SELECT
[GrpID] GrupoID,
[GrpNombre],
[GrpRFC],
[GrpURL],
[GrpRazonSocial],
[Canal]
FROM [per].[MAESTRO_CLIENTE]


CREATE VIEW per.GrupoTratamiento
AS
SELECT
[Grupo1ID] GrupoTratID,
[Grupo1IDClie] GrupoTratIDClie,
[DescGrupo1] GrupoTratNombreClie
FROM [per].[MAESTRO_GRUPO1]


CREATE VIEW per.Oficina
AS
SELECT
[OficinaID],
[OficinaIDClie],
[DescOficina] OficinaNombreClie
FROM [per].[MAESTRO_OFICINA]

  DROP VIEW PER.PuntodeVenta;
CREATE VIEW per.PuntodeVenta
AS
SELECT
  PdvID,
  PdvIDClie,
  RUC,
  PdvNombre,
  UbigeoID,
  Direccion,
  Distrito,
  Provincia,
  Departamento,
  GrpID,
  PdvNombreHomologo,
  StatusPdv,
  CategoriaPdv,
  Segmentacion_GL_I,
  Tipo,
  Formato,
  Denominacion,
  Tiendas
FROM [per].[MAESTRO_PDV]

  CREATE VIEW per.PuntodeVentaCapon
AS
SELECT
  PdvID,
  PdvIDClie,
  RUC,
  PdvNombre,
  UbigeoID,
  Direccion,
  Distrito,
  Provincia,
  Departamento,
  GrpID,
  PdvNombreHomologo,
  StatusPdv,
  CategoriaPdv,
  Segmentacion_GL_I,
  Tipo,
  Formato,
  Denominacion,
  Tiendas
FROM [per].[MAESTRO_PDV]
  WHERE Segmentacion_GL_I='MAYORISTA GALERIA CAPÒN'


DROP VIEW PER.Producto;
CREATE VIEW per.Producto
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

DROP VIEW per.Tiempo
CREATE VIEW per.Tiempo
AS
SELECT
substring([Fecha],7,2)+'/'+SUBSTRING(fecha,5,2)+'/'+SUBSTRING(fecha,1,4) Fecha,
substring([AÒoSemana_GL],1,4)+'-'+substring([AÒoSemana_GL],5,2) [AÒoSemana_GL],
[AÒo_GL],
[Semana_GL],
[AÒo],
CASE WHEN Mes in (1,2,3) THEN 'I'
    WHEN Mes in (4,5,6) THEN 'II'
      WHEN Mes in (7,8,9) THEN 'III'
        WHEN Mes in (10,11,12) THEN 'IV' END Trimestre,
[Mes],
[AÒo.Mes],
[Dia_Mes],
[Dia_AÒo],
[Dia_Semana]
FROM [per].[MAESTRO_TIEMPO]

CREATE VIEW per.ProductoFuente
AS
SELECT 
[ProIDClie],
[GrpID],
[ProPstID]
FROM [per].[MAESTRO_PRODUCTO_FUENTE] A

CREATE VIEW per.Vendedor
AS
SELECT 
[VendedorID],
[VendedorIDClie],
[DescVendedor] VendedorNombreClie
FROM [per].[MAESTRO_VENDEDOR] A

drop view per.Precio;
CREATE VIEW per.Precio
  AS
SELECT
  PrecioID,
  GrpID,
  ProPstID,
  AÒoSemana_GL,
  PrecioLista,
  PVP
FROM per.MAESTRO_PRODUCTO_PRECIO


CREATE VIEW per.Supervisor
  AS
SELECT
  SupervisorID,
  SupervisorIDClie,
  DescSupervisor,
  GrpID
FROM per.MAESTRO_SUPERVISOR

CREATE VIEW per.Geografia
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
FROM per.MAESTRO_UBIGEO




drop view per.[1_Informacion_QS];
CREATE VIEW per.[1_Informacion_QS]
AS
SELECT * FROM 
(
SELECT 
substring(a.[Fecha],7,2)+'/'+SUBSTRING(a.fecha,5,2)+'/'+SUBSTRING(a.fecha,1,4) Fecha,
A.GrpID,
A.CadenaID,
A.OficinaID,
A.GrupoTratID,
A.VendedorID,
A.SupervisorID,
A.ProPstID,
A.PdvID,
A.PrecioID,
A.UnidDesp,
B.UnidExist,
B.UnidCedis,
B.UnidTrans,
A.MontoDespCliente,
A.MontoDesp,
B.MontoExist,
B.MontoCedis,
B.MontoTrans
FROM PER.SELLOUT_QS A
LEFT JOIN 
(
SELECT * FROM 
PER.STOCK_QS
WHERE 1=2) B
ON A.ProPstID=B.PROPSTID
UNION ALL
SELECT 
substring(b.[Fecha],7,2)+'/'+SUBSTRING(b.fecha,5,2)+'/'+SUBSTRING(b.fecha,1,4) Fecha,
B.GrpID,
B.CadenaID,
A.OficinaID,
A.GrupoTratID,
A.VendedorID,
A.SupervisorID,
B.ProPstID,
A.PdvID,
B.PrecioID,
A.UnidDesp,
B.UnidExist,
B.UnidCedis,
B.UnidTrans,
A.MontoDespCliente,
A.MontoDesp,
B.MontoExist,
B.MontoCedis,
B.MontoTrans
FROM PER.STOCK_QS B
LEFT JOIN 
(
SELECT * FROM 
PER.SELLOUT_QS
WHERE 1=2) A
ON A.ProPstID=B.ProPstID
) A

CREATE VIEW per.[1_Informacion_IK]
AS
SELECT * FROM 
(
SELECT 
substring(a.[Fecha],7,2)+'/'+SUBSTRING(a.fecha,5,2)+'/'+SUBSTRING(a.fecha,1,4) Fecha,
A.GrpID,
A.CadenaID,
A.OficinaID,
A.GrupoTratID,
A.VendedorID,
A.SupervisorID,
A.ProPstID,
A.PdvID,
A.PrecioID,
A.UnidDesp,
B.UnidExist,
B.UnidCedis,
B.UnidTrans,
A.MontoDespCliente,
A.MontoDesp,
B.MontoExist,
B.MontoCedis,
B.MontoTrans
FROM PER.SELLOUT_IK A
LEFT JOIN 
(
SELECT * FROM 
PER.STOCK_IK
WHERE 1=2) B
ON A.ProPstID=B.PROPSTID
UNION ALL
SELECT 
substring(b.[Fecha],7,2)+'/'+SUBSTRING(b.fecha,5,2)+'/'+SUBSTRING(b.fecha,1,4) Fecha,
B.GrpID,
B.CadenaID,
A.OficinaID,
A.GrupoTratID,
A.VendedorID,
A.SupervisorID,
B.ProPstID,
A.PdvID,
B.PrecioID,
A.UnidDesp,
B.UnidExist,
B.UnidCedis,
B.UnidTrans,
A.MontoDespCliente,
A.MontoDesp,
B.MontoExist,
B.MontoCedis,
B.MontoTrans
FROM PER.STOCK_IK B
LEFT JOIN 
(
SELECT * FROM 
PER.SELLOUT_IK
WHERE 1=2) A
ON A.ProPstID=B.ProPstID
) A
