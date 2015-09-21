USE genommaPERU;
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
        C.PdvID,
        D.ProPstID,
        A.ProIDClie,
        A.AñoSemana_GL,
        UnidExist,
        CAST(COALESCE(A.UnidExist*E.PrecioLista,0) AS DECIMAL(11, 2)) MontoExist,
        UnidCedis,
        CAST(COALESCE(A.UnidCedis*E.PrecioLista,0) AS DECIMAL(11, 2)) MontoCedis
      FROM (
        SELECT
          A.GrpID,
          A.PdvIDClie,
          A.ProIDClie,
          A.AñoSemana_GL,
          CAST(COALESCE(B.UnidExist, 0) AS DECIMAL(11, 2)) UnidExist,
          CAST(COALESCE(B.UnidCedis, 0) AS DECIMAL(11, 2)) UnidCedis
        FROM vw.FS_fn_mask(@semanas) A
          LEFT JOIN
          (
            SELECT
              GrpID,
              PdvIDClie,
              ProIDClie,
              AñoSemana_GL,
              SUM(UnidExist)  UnidExist,
              SUM(UnidCedis)  UnidCedis
            FROM (
                   SELECT
                     A.GrpID,
                     A.PdvIDClie,
                     A.ProIDClie,
                     B.AñoSemana_GL,
                     A.UnidExist,
                     A.UnidCedis,
                     ROW_NUMBER()
                     OVER (PARTITION BY A.GrpID, A.PdvIDClie, A.ProIDClie, B.AñoSemana_GL
                       ORDER BY B.Dia_Semana DESC) Dia
                   FROM
                     (
                       SELECT *
                       FROM per.GLP_STOCK
                       WHERE GrpID IN ('308', '309', '311')--,'312','328')
                             AND Fecha >= '20131230'
                     ) A
                     LEFT JOIN PER.MAESTRO_TIEMPO B
                       ON A.Fecha = B.Fecha
                 ) A
            WHERE A.Dia = 1
            GROUP BY A.GrpID, A.PdvIDClie, A.ProIDClie, A.AñoSemana_GL
          ) B
            ON B.GrpID = A.GrpID AND B.PdvIDClie = A.PdvIDClie AND B.ProIDClie = A.ProIDClie AND B.AñoSemana_GL = A.AñoSemana_GL
      ) A
    LEFT JOIN per.MAESTRO_PDV C
      ON A.PdvIDClie=C.PdvIDClie AND A.GrpID=C.GrpID
    LEFT JOIN per.MAESTRO_PRODUCTO_FUENTE D
      ON A.ProIDClie=D.ProIDClie AND A.GrpID=D.GrpID
    LEFT JOIN PER.MAESTRO_PRODUCTO_PRECIO E
      ON D.ProPstID=E.ProPstID AND A.AñoSemana_GL=E.AñoSemana_GL AND A.GrpID=E.GrpID
)