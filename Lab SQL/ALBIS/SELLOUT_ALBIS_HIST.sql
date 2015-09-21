

SELECT
  substring(Fecha,1,4)+substring(Fecha,6,2)+substring(Fecha,9,2) Fecha,
  Cod_Cliente,
  Desc_Cliente,
  Cod_Producto,
  Desc_Producto,
  Cantidad,
  Neto
into mkt.SELLOUT_ALBIS_HISTW
FROM mkt.SELLOUT_ALBIS_HIST

SELECT MIN(Fecha),MAX(Fecha) FROM mkt.SELLOUT_ALBIS_HISTW


SELECT MIN(Fecha),MAX(Fecha) FROM mkt.SELLOUT_ALBIS_HIST_2

insert into mkt.SELLOUT_ALBIS_HISTW
SELECT
  substring(Fecha,1,4)+substring(Fecha,6,2)+substring(Fecha,9,2) Fecha,
  Cod_Cliente,
  Desc_Cliente,
  Cod_Producto,
  Desc_Producto,
  Cantidad,
  Neto
FROM mkt.SELLOUT_ALBIS_HIST_2

SELECT MIN(Fecha),MAX(Fecha) FROM mkt.SELLOUT_ALBIS_HISTW


SELECT MIN(Fecha),MAX(Fecha) FROM mkt.SELLOUT_ALBIS_HIST_3

insert into mkt.SELLOUT_ALBIS_HISTW
SELECT
  substring(Fecha,1,4)+substring(Fecha,6,2)+substring(Fecha,9,2) Fecha,
  Cod_Cliente,
  Desc_Cliente,
  Cod_Producto,
  Desc_Producto,
  Cantidad,
  Neto
FROM mkt.SELLOUT_ALBIS_HIST_3

SELECT MIN(Fecha),MAX(Fecha) FROM mkt.SELLOUT_ALBIS_HISTW
SELECT MIN(Fecha),MAX(Fecha) FROM mkt.SELLOUT_ALBIS_HIST_3

insert into mkt.SELLOUT_ALBIS_HISTW
SELECT
  substring(Fecha,1,4)+substring(Fecha,6,2)+substring(Fecha,9,2) Fecha,
  Cod_Cliente,
  Desc_Cliente,
  Cod_Producto,
  Desc_Producto,
  Cantidad,
  Neto
FROM mkt.SELLOUT_ALBIS_HIST_3

SELECT MIN(Fecha),MAX(Fecha) FROM mkt.SELLOUT_ALBIS_HISTW

SELECT MIN(Fecha),MAX(Fecha) FROM mkt.SELLOUT_ALBIS_HIST_3

insert into mkt.SELLOUT_ALBIS_HISTW
SELECT
  substring(Fecha,1,4)+substring(Fecha,6,2)+substring(Fecha,9,2) Fecha,
  Cod_Cliente,
  Desc_Cliente,
  Cod_Producto,
  Desc_Producto,
  Cantidad,
  Neto
FROM mkt.SELLOUT_ALBIS_HIST_3


SELECT DISTINCT Fecha FROM mkt.sellout_stage
ORDER BY 1

SELECT MIN(Fecha),MAX(Fecha) FROM PER.MAESTRO_TIEMPO