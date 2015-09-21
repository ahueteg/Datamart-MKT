USE genomma;
GO
IF OBJECT_ID('vw.FS_fn_stock_historico','IF') IS NOT NULL
    DROP FUNCTION vw.FS_fn_stock_historico;
GO
CREATE FUNCTION vw.FS_fn_stock_historico(@semanas int)
    RETURNS TABLE
  AS
  RETURN (
      SELECT
        A.GrpID,
        A.PdvID,
        A.ProPstID,
        A.ProIDClie,
        A.A�oSemana_GL,
        COALESCE(B.UnidExist, 0) UnidExist,
        COALESCE(B.MontoExist, 0) MontoExist,
        COALESCE(B.UnidCedis, 0) UnidCedis,
        COALESCE(B.MontoCedis, 0) MontoCedis
      FROM vw.FS_fn_mask_sugerido(@semanas) A
        LEFT JOIN
        (
          SELECT
            GrpID,
            PdvID,
            ProPstID,
            ProIDClie,
            A�oSemana_GL,
            SUM(UnidExist) UnidExist,
            SUM(MontoExist) MontoExist,
            SUM(UnidCedis) UnidCedis,
            SUM(MontoCedis) MontoCedis
          FROM (
            SELECT
              A.GrpID,
              C.PdvID,
              D.ProPstID,
              A.ProIDClie,
              B.A�oSemana_GL,
              A.UnidExist,
              A.UnidExist*E.PrecioLista MontoExist,
              A.UnidCedis,
              A.UnidCedis*E.PrecioLista MontoCedis,
              ROW_NUMBER()
              OVER (PARTITION BY A.GrpID,C.PdvID,D.ProPstID,B.A�oSemana_GL
                ORDER BY B.Dia_Semana desc) Dia
            FROM
              (
                SELECT *
                FROM per.GLP_STOCK
                WHERE GrpID IN ('308','309','311')--,'312','328')
                and Fecha>='20131230'
              ) A
              LEFT JOIN PER.MAESTRO_TIEMPO B
                ON A.Fecha = B.Fecha
              LEFT JOIN per.MAESTRO_PDV C
                ON A.PdvIDClie=C.PdvIDClie AND A.GrpID=C.GrpID
              LEFT JOIN per.MAESTRO_PRODUCTO_FUENTE D
                ON A.ProIDClie=D.ProIDClie AND A.GrpID=D.GrpID
              LEFT JOIN PER.MAESTRO_PRODUCTO_PRECIO E
                ON D.ProPstID=E.ProPstID AND B.A�oSemana_GL=E.A�oSemana_GL AND A.GrpID=E.GrpID
          ) A
            WHERE A.Dia=1
          GROUP BY A.GrpID,A.PdvID, A.ProPstID, A.ProIDClie, A.A�oSemana_GL
        ) B
          ON B.GrpID=A.GrpID AND B.PdvID = A.PdvID AND B.ProPstID = A.ProPstID AND B.ProIDClie=A.ProIDClie AND B.A�oSemana_GL = A.A�oSemana_GL
)