USE genommaperu;
GO
IF OBJECT_ID('vw.FS_fn_stock_dia','IF') IS NOT NULL
    DROP FUNCTION vw.FS_fn_stock_dia;
GO
CREATE FUNCTION vw.FS_fn_stock_dia(@semanas int)
    RETURNS TABLE
  AS
  RETURN (
      SELECT
        A.GrpID,
        A.PdvIDClie,
        A.ProIDClie,
        A.Fecha,
        COALESCE(B.UnidExist, 0) UnidExist,
        COALESCE(B.MontoExist, 0) MontoExist,
        COALESCE(B.UnidCedis, 0) UnidCedis,
        COALESCE(B.MontoCedis, 0) MontoCedis
      FROM vw.FS_fn_mask_dia(@semanas) A
        LEFT JOIN
        (
          SELECT
            GrpID,
            PdvIDClie,
            ProIDClie,
            Fecha,
            SUM(UnidExist) UnidExist,
            SUM(MontoExist) MontoExist,
            SUM(UnidCedis) UnidCedis,
            SUM(MontoCedis) MontoCedis
          FROM (
            SELECT
              A.GrpID,
              A.PdvIDClie,
              A.ProIDClie,
              A.Fecha,
              A.UnidExist,
              A.UnidExist*E.PrecioLista MontoExist,
              A.UnidCedis,
              A.UnidCedis*E.PrecioLista MontoCedis,
              ROW_NUMBER()
              OVER (PARTITION BY A.GrpID,A.PdvIDClie,A.ProIDClie,B.AñoSemana_GL
                ORDER BY B.Dia_Semana desc) Dia,
              B.AñoSemana_GL,
              max(B.AñoSemana_GL)OVER () Max_AñoSemana_GL
            FROM
              (
                SELECT *
                FROM per.GLP_STOCK
                WHERE GrpID IN ('308','309','311')--,'312','328')
                and Fecha>='20131230'
              ) A
              LEFT JOIN PER.MAESTRO_TIEMPO B
                ON A.Fecha = B.Fecha
              LEFT JOIN per.MAESTRO_PRODUCTO_FUENTE D
                ON A.ProIDClie=D.ProIDClie AND A.GrpID=D.GrpID
              LEFT JOIN PER.MAESTRO_PRODUCTO_PRECIO E
                ON D.ProPstID=E.ProPstID AND B.AñoSemana_GL=E.AñoSemana_GL AND A.GrpID=E.GrpID
          ) A
            WHERE (A.Dia=1 and A.AñoSemana_GL<A.Max_AñoSemana_GL) OR A.AñoSemana_GL=A.Max_AñoSemana_GL
          GROUP BY A.GrpID,A.PdvIDClie, A.ProIDClie, A.Fecha
        ) B
          ON B.GrpID=A.GrpID AND B.PdvIDClie = A.PdvIDClie AND B.ProIDClie=A.ProIDClie AND B.Fecha = A.Fecha
)