

create view vistas.Sugerido_Distribucion as
SELECT
  PdvID,
  ProPstID,
  UnidExist,
  UnidDespOpt,
  DOI,
  DOID,
  CEILING(CASE WHEN DOID*UnidDespOpt/7<UnidExist THEN 0 ELSE DOID*UnidDespOpt/7-A.UnidExist END) Distribucion
  --INTO mkt.SUG_DISTRIBUCION
FROM (
  SELECT
  A.PdvID,
  A.ProPstID,
  A.UnidExist,
  COALESCE(B.UnidDespOpt,0) UnidDespOpt,
  COALESCE(CASE WHEN UnidDespOpt>0 THEN UnidExist/UnidDespOpt*7
    ELSE UnidExist/(1)*7 END,0) DOI,
  10 AS DOID
--INTO mkt.SUG_DOI
FROM (
  SELECT
A.PdvID,
A.ProPstID,
COALESCE(A.UnidExist,0) UnidExist
FROM
  (
    SELECT
      A.PdvID,
      A.ProPstID,
      A.AñoSemana_GL,
      A.UnidExist,
      ROW_NUMBER()
      OVER (PARTITION BY PdvID, ProPstID
        ORDER BY AñoSemana_GL DESC) SEMANA
    FROM
      (
        SELECT
          C.PdvID,
          D.ProPstID,
          B.AñoSemana_GL,
          SUM(A.UnidExist) UnidExist
        FROM
          (
            SELECT *
            FROM per.GLP_STOCK
            WHERE GrpID = '309' AND Fecha >= '20150101') A
          LEFT JOIN PER.MAESTRO_TIEMPO B
            ON A.Fecha = B.Fecha
          LEFT JOIN PER.MAESTRO_PDV C
            ON A.PdvIDClie = C.PdvIDClie AND A.GrpID = C.GrpID
          LEFT JOIN PER.MAESTRO_PRODUCTO_FUENTE D
            ON A.ProIDClie = D.ProIDClie AND A.GrpID = D.GrpID
        GROUP BY C.PdvID, D.ProPstID, B.AñoSemana_GL
      ) A
  )A  WHERE A.SEMANA=1
     ) A
LEFT JOIN (
    SELECT
		A.PdvID,
		A.ProPstID,
		coalesce(AVG(A.UnidDesp),0) UnidDespOpt
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
							WHERE GrpID = '309' AND Fecha >= '20150101') A
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
	WHERE SEMANA <= 4
) A
	WHERE VENTA <=2
GROUP BY A.PdvID,
		A.ProPstID
          ) B
  ON A.PdvID=B.PdvID AND A.ProPstID=B.ProPstID
     ) A;

SELECT * FROM vistas.Sugerido_Distribucion