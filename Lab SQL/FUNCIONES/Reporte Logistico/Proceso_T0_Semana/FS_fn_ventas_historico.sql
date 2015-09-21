USE genommaperu;
GO
IF OBJECT_ID('vw.FS_fn_ventas_historico','IF') IS NOT NULL
    DROP FUNCTION vw.FS_fn_ventas_historico;
GO
CREATE FUNCTION vw.FS_fn_ventas_historico(@semanas int)
    RETURNS TABLE
  AS
  RETURN (
SELECT
  A.GrpID,
  C.PdvID,
  D.ProPstID,
  A.ProIDClie,
  A.A�oSemana_GL,
  CAST(B.Dias AS SMALLINT) Dias,
  A.UnidDesp,
  CAST(coalesce(A.UnidDesp * E.PrecioLista,0) AS DECIMAL(11,2)) MontoDesp,
  CAST(coalesce(A.UnidDesp * E.PVP,0) AS DECIMAL(11,2)) MontoDespPVP
FROM (
  SELECT
    A.GrpID,
    A.PdvIDClie,
    A.ProIDClie,
    A.A�oSemana_GL,
    CAST(COALESCE(B.UnidDesp, 0) AS DECIMAL(11,2)) UnidDesp
  FROM vw.FS_fn_mask(@semanas) A
    LEFT JOIN
    (
      SELECT
        A.GrpID,
        A.PdvIDClie,
        A.ProIDClie,
        B.A�oSemana_GL,
        SUM(UnidDesp) UnidDesp
      FROM
        (
          SELECT A.*
          FROM per.GLP_SELLOUT A
          WHERE GrpID IN ('308', '309', '311')--, '312', '328'
		      and Fecha>='20131230'
        ) A
        LEFT JOIN PER.MAESTRO_TIEMPO B
          ON A.Fecha = B.Fecha
      GROUP BY A.GrpID, A.PdvIDClie, A.ProIDClie,B.A�oSemana_GL
    ) B
      ON B.GrpID = A.GrpID AND B.PdvIDClie = A.PdvIDClie AND B.ProIDClie = A.ProIDClie AND B.A�oSemana_GL = A.A�oSemana_GL
  ) A LEFT JOIN MKT.SELLOUT_DIAS B
  ON A.GrpID=B.GrpID AND A.A�oSemana_GL=B.A�oSemana_GL
  LEFT JOIN per.MAESTRO_PDV C
    ON A.PdvIDClie = C.PdvIDClie AND A.GrpID = C.GrpID
  LEFT JOIN per.MAESTRO_PRODUCTO_FUENTE D
    ON A.ProIDClie = D.ProIDClie AND A.GrpID = D.GrpID
  LEFT JOIN PER.MAESTRO_PRODUCTO_PRECIO E
    ON D.ProPstID = E.ProPstID AND B.A�oSemana_GL = E.A�oSemana_GL AND A.GrpID = E.GrpID

)