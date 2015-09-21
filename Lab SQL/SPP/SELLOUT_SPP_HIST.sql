

DROP TABLE mkt.SELLOUT_SPP_HISTW;
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
INTO mkt.SELLOUT_SPP_HISTW
FROM mkt.SELLOUT_SPP_HIST_2014



SELECT
  SUBSTRING(RTRIM(LTRIM(FECHA)),1,8) FECHA,
  CONVERT(VARCHAR,CONVERT(DECIMAL(18,0),REPLACE(RTRIM(LTRIM(COD_PDV)),',','.'))) COD_PDV,
  DESC_PDV,
  CONVERT(VARCHAR,CONVERT(DECIMAL(18,0),REPLACE(RTRIM(LTRIM(COD_PROD)),',','.'))) COD_PROD,
  DESC_PROD,
  CONVERT(DECIMAL(15,6),REPLACE(RTRIM(LTRIM(CANTIDAD)),',','.')) CANTIDAD,
  CONVERT(DECIMAL(15,6),REPLACE(RTRIM(LTRIM(NETO)),',','.')) NETO,
  ARCHIVO
INTO mkt.SELLOUT_SPP_HIST_2013_AUX
FROM mkt.SELLOUT_SPP_HIST_2013;


DROP TABLE  mkt.SELLOUT_SPP_HIST_2013;
EXEC sp_rename 'mkt.SELLOUT_SPP_HIST_2013_AUX', 'SELLOUT_SPP_HIST_2013';

SELECT
          *
INTO mkt.SPP_PDV_EXC
        FROM OPENROWSET('Microsoft.ACE.OLEDB.15.0',
     'Excel 12.0 Xml;HDR=YES;IMEX=1;Database=D:\CODIGOS_SUPESA.xlsx',
     'SELECT * FROM [Local$]')

DROP TABLE MKT.SPP_PDV_2013;
SELECT DISTINCT COD_PDV into MKT.SPP_PDV_2013 FROM mkt.SELLOUT_SPP_HIST_2013;

SELECT
  FECHA,
  B.COD_LOCAL_NV COD_PDV,
  B.DESC_LOCAL_NV DESC_PDV,
  COD_PROD,
  DESC_PROD,
  CANTIDAD,
  NETO,
  ARCHIVO
INTO  mkt.SELLOUT_SPP_HIST_2013_AUX
FROM mkt.SELLOUT_SPP_HIST_2013 A
  LEFT JOIN mkt.SPP_PDV_EXC B
    ON A.COD_PDV=B.COD_LOCAL_ANT;

DROP TABLE  mkt.SELLOUT_SPP_HIST_2013;
EXEC sp_rename 'mkt.SELLOUT_SPP_HIST_2013_AUX', 'SELLOUT_SPP_HIST_2013';

SELECT
          *
INTO mkt.SPP_PRD_EXC
        FROM OPENROWSET('Microsoft.ACE.OLEDB.15.0',
     'Excel 12.0 Xml;HDR=YES;IMEX=1;Database=D:\CODIGOS_SUPESA.xlsx',
     'SELECT * FROM [Producto$]')

DROP TABLE MKT.SPP_PRD_2013;
SELECT DISTINCT COD_PROD into MKT.SPP_PRD_2013 FROM mkt.SELLOUT_SPP_HIST_2013;

SELECT
  FECHA,
  COD_PDV,
  DESC_PDV,
  B.COD_PROD_NV COD_PROD,
  DESC_PROD,
  CANTIDAD,
  NETO,
  ARCHIVO
  INTO mkt.SELLOUT_SPP_HIST_2013_AUX
FROM  mkt.SELLOUT_SPP_HIST_2013 A
LEFT JOIN MKT.SPP_PRD_EXC B
  ON A.COD_PROD=B.COD_PROD_ANT

DROP TABLE  mkt.SELLOUT_SPP_HIST_2013;
EXEC sp_rename 'mkt.SELLOUT_SPP_HIST_2013_AUX', 'SELLOUT_SPP_HIST_2013';


INSERT INTO mkt.SELLOUT_SPP_HISTW
(FECHA,COD_LOCAL,DESCRIPCION_LOCAL,COD_SPSA,DESCRIPCION,VTA_PERIODO,VTA_PUBLICO,ARCHIVO)
SELECT
  FECHA,
  COD_PDV,
  DESC_PDV,
  COD_PROD,
  DESC_PROD,
  CANTIDAD,
  NETO,
  ARCHIVO
FROM mkt.SELLOUT_SPP_HIST_2013;

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
FROM mkt.SELLOUT_SPP_HIST_2015

SELECT DISTINCT substring(PERIODO,1,4)+substring(PERIODO,6,2)+substring(PERIODO,9,2) FECHA FROM mkt.SELLOUT_SPP_HIST_2015
ORDER BY 1 DESC