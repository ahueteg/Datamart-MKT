
SELECT
  Cod_Cliente,
  Desc_Cliente,
  Cod_Producto,
  Desc_Producto,
  Stock1,
  Stock2,
  Fecha
  INTO mkt.STOCK_ALBIS_HISTW
FROM mkt.STOCK_ALBIS_HIST A
LEFT JOIN (
            SELECT * FROM per.MAESTRO_TIEMPO WHERE Dia_Semana=7
          )B
  ON SUBSTRING(A.archivo,1,4)+SUBSTRING(archivo,6,2)=B.AñoSemana_GL;