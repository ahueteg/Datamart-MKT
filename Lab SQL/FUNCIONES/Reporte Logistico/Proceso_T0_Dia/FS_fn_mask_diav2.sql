USE genommaperu;
GO
IF OBJECT_ID('vw.FS_fn_mask_dia','IF') IS NOT NULL
    DROP FUNCTION vw.FS_fn_mask_dia;
GO
CREATE FUNCTION vw.FS_fn_mask_dia(@semanas int)
  RETURNS TABLE
  AS
  RETURN (
        SELECT B.GrpID,B.PdvIDClie,A.ProIDClie,C.Fecha
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
            SELECT Fecha
            FROM [per].[MAESTRO_TIEMPO]
            WHERE AñoSemana_GL in (
              SELECT AñoSemana_GL
            FROM vw.fn_ultimas_semanas('309',@semanas)
            )
          ) C
  )