USE genomma;
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
        A.PdvID,
        A.ProPstID,
        A.A�oSemana_GL,
        COALESCE(B.UnidDesp, 0) UnidDesp,
        COALESCE(B.MontoDesp,0) MontoDesp,
        COALESCE(B.MontoDespPVP,0) MontoDespPVP,
        max(B.TotalDias) over (PARTITION BY A.GrpID,A.A�oSemana_GL) TotalDias
      FROM vw.FS_fn_mask_sugerido(@semanas) A
        LEFT JOIN
        (
          SELECT
            A.GrpID,
            C.PdvID,
            D.ProPstID,
            B.A�oSemana_GL,
			      MAX(A.TotalDias) TotalDias,
            SUM(UnidDesp) UnidDesp,
            SUM(UnidDesp*E.PrecioLista) MontoDesp,
            SUM(UnidDesp*E.PVP) MontoDespPVP
          FROM
            (
				SELECT A.*,MAX(A.Dias) over(PARTITION BY A.GrpID,A.A�oSemana_GL) TotalDias
				FROM (
				  SELECT A.*,DENSE_RANK() over (PARTITION BY A.GrpID,B.A�oSemana_GL ORDER BY B.Fecha ASC) Dias,
				  B.A�oSemana_GL
				  FROM (
						SELECT A.*
						FROM per.GLP_SELLOUT A
						WHERE GrpID IN ('308', '309', '311')--, '312', '328')
						--and a.fecha >='20150501'
					) A
				  LEFT JOIN PER.MAESTRO_TIEMPO B
				  ON A.Fecha = B.Fecha
				) A
            ) A
            LEFT JOIN PER.MAESTRO_TIEMPO B
              ON A.Fecha = B.Fecha
            LEFT JOIN per.MAESTRO_PDV C
              ON A.PdvIDClie=C.PdvIDClie AND A.GrpID=C.GrpID
            LEFT JOIN per.MAESTRO_PRODUCTO_FUENTE D
              ON A.ProIDClie=D.ProIDClie AND A.GrpID=D.GrpID
            LEFT JOIN PER.MAESTRO_PRODUCTO_PRECIO E
              ON D.ProPstID=E.ProPstID AND B.A�oSemana_GL=E.A�oSemana_GL AND A.GrpID=E.GrpID
          GROUP BY A.GrpID,C.PdvID,D.ProPstID,B.A�oSemana_GL
        ) B
          ON B.GrpID=A.GrpID AND B.PdvID = A.PdvID AND B.ProPstID = A.ProPstID AND B.A�oSemana_GL = A.A�oSemana_GL
)