SELECT DISTINCT LEN(CONVERT(VARCHAR,CONVERT(BIGINT,DOC_IDENTIDAD)))  FROM ['MAESTRO PDV DIGA$']
ORDER BY 1

SELECT LEN(CONVERT(VARCHAR,DOC_IDENTIDAD)),'_'+CONVERT(VARCHAR,DOC_IDENTIDAD)+'_',DOC_IDENTIDAD  FROM ['MAESTRO PDV DIGA$']
ORDER BY 1 DESC



SELECT DISTINCT LEN(DIRECCION),DIRECCION FROM ['MAESTRO PDV DIGA$']
ORDER BY 1 DESC

UPDATE PD
SET PD.RUC=CONVERT(VARCHAR,CONVERT(BIGINT,DOC_IDENTIDAD)),PD.PDVNOMBRE=NOM_CLIENTE,
  PD.DIRECCION=B.DIRECCION,PD.DISTRITO=B.DISTRITO,PD.PROVINCIA=B.PROVINCIA,PD.DEPARTAMENTO=B.DEPARTAMENTO
    FROM PER.MAESTRO_PDV AS PD
    INNER JOIN DBO.['MAESTRO PDV DIGA$'] B
ON PD.PdvIDClie=CONVERT(VARCHAR,CONVERT(BIGINT,B.COD_CLIENTE))  AND PD.GrpID='337'
;

SELECT *
    FROM PER.MAESTRO_PDV AS PD
INNER JOIN DBO.['MAESTRO PDV DIGA$'] B
ON PD.PdvIDClie=CONVERT(VARCHAR,B.COD_CLIENTE) AND PD.GrpID='337'
WHERE B.COD_CLIENTE IS NULL


SELECT *
    FROM PER.MAESTRO_PDV
WHERE GrpID='337'

SELECT * FROM ['MAESTRO PDV DIGA$']



DROP TABLE mkt.maestro_pdv_qs
SELECT *
into mkt.maestro_pdv_qs
FROM   OPENROWSET('Microsoft.ACE.OLEDB.15.0',
       'Excel 12.0 Xml;HDR=YES;IMEX=1;Database=D:\1.- Distributivo\4.- Key Mark\S-23 Maestro KeyMark.xlsx',
       'SELECT * FROM [Maestro Pdv$]')


SELECT COUNT(1)  FROM mkt.maestro_pdv_qs
WHERE PdvID IS NOT NULL

SELECT
  PdvID,
  PdvIDClie,
  RUC,
  PdvNombre,
  Status,
  UbigeoID,
  Direccion,
  N,
  Interior,
  Distrito,
  Provincia,
  Departamento,
  GrpID,
  PdvNombreHomologo,
  StatusPdv,
  CategoriaPdv,
  Segmentacion_GL_I
FROM PER.MAESTRO_PDV

SELECT
  GrpID,--OK
  GrpNombre,--OK
  PdvID,--OK
  PdvIDClie,--OK
  RUC,--OK
  PdvNombreClie,--OK
  Direccion,--OK
  PdvNombreHomologo,--OK
  StatusPdv,--OK
  Tipo,--VACIO
  CategoriaPdv,--OK
  Formato,--VACIO
  Denominación,--VACIO
  [Segmentación GLI I],--ok
  [Segmentación GLI II],--vacio
  [# Tiendas],--vacio
  [Fecha de Apertura],--vacio
  [Fecha de Cierre],--vacio
  [Group Target I],
  [Group Target II],
  Ubigeo,
  Departamento,
  Provincia,
  Distrito,
  Departamento1,
  Provincia1,
  Distrito1
FROM MKT.maestro_pdv_qs



ALTER TABLE genomma.per.MAESTRO_PDV ADD [# Tiendas] VARCHAR(30)  NULL;

SELECT DISTINCT LEN( Ubigeo),Ubigeo FROM MKT.maestro_pdv_qs
ORDER BY 1 DESC

UPDATE A
SET A.RUC=b.RUC,A.PdvNombre=B.PdvNombreClie,A.UbigeoID=B.Ubigeo,A.Direccion=B.Direccion,
  A.Distrito=B.Distrito,A.Provincia=B.Provincia,A.Departamento=B.Departamento,
A.PdvNombreHomologo=B.PdvNombreHomologo,A.StatusPdv=B.StatusPdv,A.CategoriaPdv=B.CategoriaPdv,
A.Segmentacion_GL_I=B.[Segmentación GLI I]
    FROM PER.MAESTRO_PDV A
    INNER JOIN mkt.[maestro_pdv_qs] B
ON A.PdvID=B.PdvID AND A.GRPID=B.GrpID;


SELECT
  PdvID,
  PdvIDClie,
  RUC,
  PdvNombre,
  Status,
  UbigeoID,
  Direccion,
  N,
  Interior,
  Distrito,
  Provincia,
  Departamento,
  GrpID,
  PdvNombreHomologo,
  StatusPdv,
  CategoriaPdv,
  Segmentacion_GL_I
FROM PER.MAESTRO_PDV
WHERE GrpID='307'