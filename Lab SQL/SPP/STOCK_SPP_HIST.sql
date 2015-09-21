SELECT
  substring(FECHA,1,4)+substring(FECHA,6,2)+substring(FECHA,9,2) FECHA,
  COD_SPSA,
  COD_PRODUCTO_PROVEEDOR,
  DESCRIPCION,
  UMB,
  MARCA,
  COD_LOCAL,
  DESCRIPCION_LOCAL,
  TIPO,
  INVENTARIO,
  MIX,
  QUIEBRE,
  ARCHIVO
INTO mkt.STOCK_SPP_HISTW
FROM mkt.STOCK_SPP_HIST_2015;