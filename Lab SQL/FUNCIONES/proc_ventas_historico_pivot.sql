CREATE PROCEDURE vw.proc_ventas_historico_pivot
AS
  BEGIN
WITH PIVOTDATA AS
(
SELECT
  A.PdvIDClie,
  A.ProIDClie,
  CASE WHEN CATEGORIA='UnidDesp' THEN 'SO_'+SUBSTRING(AñoSemana_GL,5,2)+'_Und'
    WHEN CATEGORIA='MontoDespCliente' THEN 'SO_'+SUBSTRING(AñoSemana_GL,5,2)+'_Sol' END Columna,
  A.Valor
FROM
  (
    SELECT
      A.PdvIDClie,
      A.ProIDClie,
      A.AñoSemana_GL,
      Categoria,
      Valor
    FROM vw.fn_ventas_historico('308', 8)
    UNPIVOT (VALOR FOR CATEGORIA IN ([UnidDesp], [MontoDespCliente])) AS A
  ) A
)
SELECT *
FROM
PIVOTDATA PIVOT(SUM(Valor) FOR Columna IN (
[SO_27_Und],
[SO_27_Sol],
[SO_26_Und],
[SO_26_Sol],
[SO_25_Und],
[SO_25_Sol],
[SO_24_Und],
[SO_24_Sol],
[SO_23_Und],
[SO_23_Sol],
[SO_22_Und],
[SO_22_Sol],
[SO_21_Und],
[SO_21_Sol],
[SO_20_Und],
[SO_20_Sol]
)) AS P;
    END
  GO
EXEC vw.proc_ventas_historico_pivot