SELECT
  substring(FECHA,1,4)+substring(FECHA,6,2)+substring(FECHA,9,2) FECHA,
  COD_CENCOSUD,
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
  INVENTARIO,
  TRANSITO,
  MIX,
  QUIEBRE,
  PRECIO_COSTO,
  ARCHIVO
INTO mkt.STOCK_CENCO_HISTW
FROM mkt.STOCK_CENCO_HIST_2015

INSERT INTO mkt.STOCK_CENCO_HISTW
SELECT
  substring(FECHA,1,4)+substring(FECHA,6,2)+substring(FECHA,9,2) FECHA,
  CONVERT(VARCHAR,CONVERT(DECIMAL(15,0),REPLACE(RTRIM(LTRIM(COD_CENCOSUD)),',','.'))) COD_CENCOSUD ,
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
  CONVERT(DECIMAL(15,6),REPLACE(RTRIM(LTRIM(INVENTARIO)),',','.')) INVENTARIO,
  CONVERT(DECIMAL(15,6),REPLACE(RTRIM(LTRIM(TRANSITO)),',','.')) TRANSITO,
  CONVERT(VARCHAR,CONVERT(DECIMAL(2,0),REPLACE(RTRIM(LTRIM(MIX)),',','.'))) MIX,
  CONVERT(VARCHAR,CONVERT(DECIMAL(2,0),REPLACE(RTRIM(LTRIM(QUIEBRE)),',','.'))) QUIEBRE,
  CONVERT(DECIMAL(15,6),REPLACE(RTRIM(LTRIM(PRECIO_COSTO)),',','.')) PRECIO_COSTO,
  archivo
FROM mkt.STOCK_CENCO_HIST_2014