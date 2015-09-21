USE genomma;
GO
IF OBJECT_ID('vw.FS_fn_mask_sugerido','IF') IS NOT NULL
    DROP FUNCTION vw.FS_fn_mask_sugerido;
GO
CREATE FUNCTION vw.FS_fn_mask_sugerido(@semanas int)
  RETURNS TABLE
  AS
  RETURN (
    SELECT A.GrpID,B.PdvID,C.ProPstID,A.ProIDClie,A.AñoSemana_GL
    FROM
      (
        SELECT B.GrpID,B.PdvIDClie,A.ProIDClie,C.AñoSemana_GL
        FROM
          (
            SELECT DISTINCT GrpID,ProIDClie
            FROM
              (
                SELECT DISTINCT GrpID,ProIDClie
                FROM per.GLP_SELLOUT
                WHERE GrpID IN ('308','309','311')--,'312','328')
                UNION ALL
                SELECT DISTINCT GrpID,ProIDClie
                FROM per.GLP_STOCK
                WHERE GrpID IN ('308','309','311')--,'312','328')
              ) A
          ) A
          INNER JOIN
          (
            SELECT DISTINCT GrpID,PdvIDClie
            FROM
              (
                SELECT DISTINCT GrpID,PdvIDClie
                FROM per.GLP_SELLOUT
                WHERE GrpID IN ('308','309','311')--,'312','328')
                UNION ALL
                SELECT DISTINCT GrpID,PdvIDClie
                FROM per.GLP_STOCK
                WHERE GrpID IN ('308','309','311')--,'312','328')
              ) A
          ) B ON A.GrpID=B.GrpID
          CROSS JOIN
          (
            SELECT AñoSemana_GL
            FROM vw.fn_ultimas_semanas('309',@semanas)
          ) C
      ) A LEFT JOIN per.MAESTRO_PDV B
      ON A.PdvIDClie=B.PdvIDClie AND A.GrpID=B.GrpID
      LEFT JOIN PER.MAESTRO_PRODUCTO_FUENTE C
      ON A.ProIDClie=C.ProIDClie AND A.GrpID=C.GrpID
  )