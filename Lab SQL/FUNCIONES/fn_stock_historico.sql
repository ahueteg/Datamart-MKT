USE genomma;
GO
IF OBJECT_ID('vw.fn_stock_historico','IF') IS NOT NULL
    DROP FUNCTION vw.fn_stock_historico;
GO
CREATE FUNCTION vw.fn_stock_historico(@grupoid VARCHAR(3),@semanas int)
    RETURNS TABLE
  AS
  RETURN (
      SELECT
        A.PdvID,
        A.ProPstID,
        A.AñoSemana_GL,
        COALESCE(B.UnidExist, 0) UnidExist,
        COALESCE(B.MontoExist, 0) MontoExist,
        COALESCE(B.UnidCedis, 0) UnidCedis,
        COALESCE(B.MontoCedis, 0) MontoCedis
      FROM vw.fn_mask_sugerido(@grupoid, @semanas) A
        LEFT JOIN
        (
          SELECT
            PdvID,
            ProPstID,
            AñoSemana_GL,
            SUM(UnidExist) UnidExist,
            SUM(MontoExist) MontoExist,
            SUM(UnidCedis) UnidCedis,
            SUM(MontoCedis) MontoCedis
          FROM (
            SELECT
              C.PdvID,
              D.ProPstID,
              B.AñoSemana_GL,
              A.UnidExist,
              A.UnidExist*E.PrecioLista MontoExist,
              A.UnidCedis,
              A.UnidCedis*E.PrecioLista MontoCedis,
              ROW_NUMBER()
              OVER (PARTITION BY C.PdvID,D.ProPstID,B.AñoSemana_GL
                ORDER BY B.Dia_Semana desc) Dia
            FROM
              (
                SELECT *
                FROM per.GLP_STOCK
                WHERE GrpID = @grupoid
              ) A
              LEFT JOIN PER.MAESTRO_TIEMPO B
                ON A.Fecha = B.Fecha
              LEFT JOIN per.MAESTRO_PDV C
                ON A.PdvIDClie=C.PdvIDClie AND A.GrpID=C.GrpID
              LEFT JOIN per.MAESTRO_PRODUCTO_FUENTE D
                ON A.ProIDClie=D.ProIDClie AND A.GrpID=D.GrpID
              LEFT JOIN PER.MAESTRO_PRODUCTO_PRECIO E
                ON D.ProPstID=E.ProPstID AND B.AñoSemana_GL=E.AñoSemana_GL AND A.GrpID=E.GrpID
          ) A
            WHERE A.Dia=1
          GROUP BY A.PdvID, A.ProPstID, A.AñoSemana_GL
        ) B
          ON B.PdvID = A.PdvID AND B.ProPstID = A.ProPstID AND B.AñoSemana_GL = A.AñoSemana_GL
)