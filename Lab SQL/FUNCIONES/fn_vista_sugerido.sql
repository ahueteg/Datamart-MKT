USE genomma;
GO
IF OBJECT_ID('vw.fn_vista_sugerido','IF') IS NOT NULL
    DROP FUNCTION vw.fn_vista_sugerido;
GO
CREATE FUNCTION vw.fn_vista_sugerido(@grupoid VARCHAR(3),@semanas int)
    RETURNS TABLE
  AS
  RETURN (
    SELECT
      B.PdvID,
      C.ProPstID,
      Columna,
      Valor
    FROM
      (
        SELECT
          A.PdvIDClie,
          A.ProIDClie,
          CASE WHEN CATEGORIA = 'UnidDesp'
            THEN 'SO_' + SUBSTRING(AñoSemana_GL, 5, 2) + '_Und'
          WHEN CATEGORIA = 'MontoDespCliente'
            THEN 'SO_' + SUBSTRING(AñoSemana_GL, 5, 2) + '_Sol' END Columna,
          A.Valor
        FROM
          (
            SELECT
              A.PdvIDClie,
              A.ProIDClie,
              A.AñoSemana_GL,
              Categoria,
              Valor
            FROM vw.fn_ventas_historico(@grupoid, @semanas)
            UNPIVOT (VALOR FOR CATEGORIA IN ([UnidDesp], [MontoDespCliente])) AS A
          ) A
        UNION ALL
        SELECT
          A.PdvIDClie,
          A.ProIDClie,
          'Inv_' + substring(A.AñoSemana_GL, 5, 2) + '_und' Columna,
          A.Inventario                                      Valor
        FROM vw.fn_stock_historico(@grupoid, @semanas) A
      ) A LEFT JOIN PER.MAESTRO_PDV B
        ON A.PdvIDClie = B.PdvIDClie
      LEFT JOIN PER.MAESTRO_PRODUCTO_FUENTE C
        ON A.ProIDClie = C.ProIDClie AND c.GrpID = @grupoid
)