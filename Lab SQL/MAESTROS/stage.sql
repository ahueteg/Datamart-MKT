SELECT * FROM mkt.SELLOUT_QS_HIST
WHERE VBRP_MATNR in ('186271','116854')


SELECT DISTINCT VBRP_MATNR FROM mkt.SELLOUT_QS_HIST
WHERE VBRP_MATNR not IN (
  SELECT ProIDClie FROM per.MAESTRO_PRODUCTO_FUENTE
  WHERE GrpID='307'
)