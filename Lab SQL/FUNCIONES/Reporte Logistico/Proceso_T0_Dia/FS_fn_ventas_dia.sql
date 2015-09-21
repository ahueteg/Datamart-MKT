USE genommaperu;
GO
IF OBJECT_ID('vw.FS_fn_ventas_dia','IF') IS NOT NULL
    DROP FUNCTION vw.FS_fn_ventas_dia;
GO
CREATE FUNCTION vw.FS_fn_ventas_dia(@semanas int)
    RETURNS TABLE
  AS
  RETURN (
  SELECT
    A.GrpID,
    A.PdvID,
    A.ProPstID,
    A.ProIDClie,
    A.Fecha,
    COALESCE(B.UnidDesp, 0)     UnidDesp,
    COALESCE(B.MontoDesp, 0)    MontoDesp,
    COALESCE(B.MontoDespPVP, 0) MontoDespPVP
  FROM vw.FS_fn_mask_dia(@semanas) A
    LEFT JOIN
    (
      SELECT
        A.GrpID,
        C.PdvID,
        D.ProPstID,
        A.ProIDClie,
        B.Fecha,
        SUM(UnidDesp)                               UnidDesp,
        SUM(UnidDesp * E.PrecioLista)               MontoDesp,
        SUM(UnidDesp * E.PVP)                       MontoDespPVP
      FROM
        (
          SELECT A.*
          FROM per.GLP_SELLOUT A
          WHERE GrpID IN ('308', '309', '311')--, '312', '328'
		      and Fecha>='20131230'
        ) A
        LEFT JOIN PER.MAESTRO_TIEMPO B
          ON A.Fecha = B.Fecha
        LEFT JOIN per.MAESTRO_PDV C
          ON A.PdvIDClie = C.PdvIDClie AND A.GrpID = C.GrpID
        LEFT JOIN per.MAESTRO_PRODUCTO_FUENTE D
          ON A.ProIDClie = D.ProIDClie AND A.GrpID = D.GrpID
        LEFT JOIN PER.MAESTRO_PRODUCTO_PRECIO E
          ON D.ProPstID = E.ProPstID AND B.[AñoSemana_GL] = E.AñoSemana_GL AND A.GrpID = E.GrpID
      GROUP BY A.GrpID, C.PdvID, D.ProPstID, A.ProIDClie,B.Fecha
    ) B
      ON B.GrpID = A.GrpID AND B.PdvID = A.PdvID AND B.ProPstID = A.ProPstID AND B.ProIDClie = A.ProIDClie AND B.Fecha = A.Fecha
)