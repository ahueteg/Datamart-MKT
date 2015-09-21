CREATE FUNCTION mkt.fn_venta_optima_4s(@grupoid VARCHAR(3))
  RETURNS TABLE
  AS
  RETURN (
      SELECT
		A.PdvID,
		A.ProPstID,
		coalesce(AVG(A.UnidDesp),0) UnidDespOpt
--INTO mkt.SUG_UND_OPT
FROM (
	SELECT
		A.PdvID,
		A.ProPstID,
		A.AñoSemana_GL,
		A.UnidDesp,
		ROW_NUMBER()
		OVER (PARTITION BY PdvID, ProPstID
			ORDER BY UnidDesp DESC) VENTA
	FROM
		(
			SELECT
				A.PdvID,
				A.ProPstID,
				A.AñoSemana_GL,
				A.UnidDesp,
				ROW_NUMBER()
				OVER (PARTITION BY PdvID, ProPstID
					ORDER BY AñoSemana_GL DESC) SEMANA
			FROM
				(
					SELECT
						C.PdvID,
						D.ProPstID,
						B.AñoSemana_GL,
						SUM(UnidDesp) UnidDesp
					FROM
						(
							SELECT *
							FROM per.GLP_SELLOUT
							WHERE GrpID = @grupoid AND Fecha >= '20150101') A
						LEFT JOIN PER.MAESTRO_TIEMPO B
							ON A.Fecha = B.Fecha
						LEFT JOIN PER.MAESTRO_PDV C
							ON A.PdvIDClie = C.PdvIDClie AND A.GrpID = C.GrpID
						LEFT JOIN PER.MAESTRO_PRODUCTO_FUENTE D
							ON A.ProIDClie = D.ProIDClie AND A.GrpID = D.GrpID
					GROUP BY C.PdvID, D.ProPstID, B.AñoSemana_GL
					--ORDER BY 1,2,3
				) A
			--ORDER BY 1, 2, 3
		) A
	WHERE SEMANA <= 4 and AñoSemana_GL>=201401
) A
	WHERE VENTA <=2
GROUP BY A.PdvID,
		A.ProPstID
  )
