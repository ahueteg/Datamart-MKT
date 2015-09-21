USE genomma;
GO
IF OBJECT_ID('vw.fn_mask_sugerido','IF') IS NOT NULL
    DROP FUNCTION vw.fn_mask_sugerido;
GO
CREATE FUNCTION vw.fn_mask_sugerido(@grupoid VARCHAR(3),@semanas int)
  RETURNS TABLE
  AS
  RETURN (
    SELECT B.PdvID,C.ProPstID,AñoSemana_GL
    FROM
      (
        SELECT *
        FROM
          (
            SELECT DISTINCT ProIDClie
            FROM
              (
                SELECT DISTINCT ProIDClie
                FROM per.GLP_SELLOUT
                WHERE GrpID = @grupoid
                UNION ALL
                SELECT DISTINCT ProIDClie
                FROM per.GLP_STOCK
                WHERE GrpID = @grupoid ) A
          ) A
          CROSS JOIN
          (
            SELECT DISTINCT PdvIDClie
            FROM
              (
                SELECT DISTINCT PdvIDClie
                FROM per.GLP_SELLOUT
                WHERE GrpID = @grupoid
                UNION ALL
                SELECT DISTINCT PdvIDClie
                FROM per.GLP_STOCK
                WHERE GrpID = @grupoid ) A
          ) B
          CROSS JOIN
          (
            SELECT AñoSemana_GL
            FROM vw.fn_ultimas_semanas(@grupoid,@semanas)
          ) C
      ) A LEFT JOIN per.MAESTRO_PDV B
      ON A.PdvIDClie=B.PdvIDClie AND @grupoid=B.GrpID
      LEFT JOIN PER.MAESTRO_PRODUCTO_FUENTE C
      ON A.ProIDClie=C.ProIDClie AND @grupoid=C.GrpID
  )