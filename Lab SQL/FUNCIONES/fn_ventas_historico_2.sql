USE genomma;
GO
IF OBJECT_ID('vw.fn_ventas_historico_2','IF') IS NOT NULL
    DROP FUNCTION vw.fn_ventas_historico_2;
GO
CREATE FUNCTION vw.fn_ventas_historico_2(@grupoid VARCHAR(3),@semanas int)
    RETURNS TABLE
  AS
  RETURN (
SELECT
        A.PdvID,
        A.ProPstID,
        A.A�oSemana_GL,
        COALESCE(B.UnidDesp, 0) UnidDesp,
        COALESCE(B.MontoDesp,0) MontoDesp,
        COALESCE(B.MontoDespPVP,0) MontoDespPVP
      FROM vw.fn_mask_sugerido(@grupoid, @semanas) A
        LEFT JOIN
        (
          SELECT
            C.PdvID,
            D.ProPstID,
            B.A�oSemana_GL,
            C.StatusPdv,
            SUM(UnidDesp) UnidDesp,
            SUM(UnidDesp*E.PrecioLista) MontoDesp,
            SUM(UnidDesp*E.PVP) MontoDespPVP
          FROM
            (
              SELECT *
              FROM per.GLP_SELLOUT
              WHERE GrpID = @grupoid
            ) A
            LEFT JOIN PER.MAESTRO_TIEMPO B
              ON A.Fecha = B.Fecha
            LEFT JOIN per.MAESTRO_PDV C
              ON A.PdvIDClie=C.PdvIDClie AND A.GrpID=C.GrpID
            LEFT JOIN per.MAESTRO_PRODUCTO_FUENTE D
              ON A.ProIDClie=D.ProIDClie AND A.GrpID=D.GrpID
            LEFT JOIN PER.MAESTRO_PRODUCTO_PRECIO E
              ON D.ProPstID=E.ProPstID AND B.A�oSemana_GL=E.A�oSemana_GL AND A.GrpID=E.GrpID
          GROUP BY C.PdvID,D.ProPstID,B.A�oSemana_GL,C.StatusPdv
        ) B
          ON B.PdvID = A.PdvID AND B.ProPstID = A.ProPstID AND B.A�oSemana_GL = A.A�oSemana_GL
)