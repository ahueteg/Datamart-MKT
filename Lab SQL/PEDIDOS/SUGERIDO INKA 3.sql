/*VENTA OPTIMO DE LOS ULTIMOS 4 MESES*/
--DROP TABLE mkt.SUG_UND_OPT;
CREATE VIEW mkt.vw_SUG_UND_OPT AS
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
		A.ProPstID;
/*INVENTARIO ULTIMO DIA*/
--DROP TABLE mkt.SUG_INV_ULT;
CREATE VIEW mkt.vw_SUG_INV_ULT AS
SELECT
A.PdvID,
A.ProPstID,
COALESCE(A.UnidExist,0) UnidExist
--INTO mkt.SUG_INV_ULT
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
  )A  WHERE A.SEMANA=1;

DROP TABLE mkt.SUG_DOI;
CREATE VIEW mkt.vw_SUG_DOI AS
SELECT
  A.PdvID,
  A.ProPstID,
  A.UnidExist,
  COALESCE(B.UnidDespOpt,0) UnidDespOpt,
  COALESCE(CASE WHEN UnidDespOpt>0 THEN UnidExist/UnidDespOpt*7
    ELSE UnidExist/(1)*7 END,0) DOI,
  10 AS DOID
--INTO mkt.SUG_DOI
FROM mkt.vw_SUG_INV_ULT A
LEFT JOIN mkt.vw_SUG_UND_OPT B
  ON A.PdvID=B.PdvID AND A.ProPstID=B.ProPstID;

DROP FUNCTION mkt.fn_sugerido;
CREATE FUNCTION mkt.fn_sugerido(@doid int)
  RETURNS TABLE
  AS
  RETURN (
      SELECT
        A.PdvID,
        V.StatusPdv,
        A.ProPstID,
        P.StatusProd,
        UnidExist,
        UnidDespOpt,
        DOI,
        DOID,
        Distribucion
      FROM (
        SELECT
              A.PdvID,
              A.ProPstID,
              A.UnidExist,
              COALESCE(B.UnidDespOpt,0) UnidDespOpt,
              COALESCE(CASE WHEN UnidDespOpt>0 THEN UnidExist/UnidDespOpt*7
                ELSE UnidExist/(1)*7 END,0) DOI,
              @doid AS DOID,
              COALESCE(CEILING(CASE WHEN @doid*UnidDespOpt/7<UnidExist THEN 0 ELSE @doid*UnidDespOpt/7-A.UnidExist END),0) Distribucion
            FROM mkt.vw_SUG_INV_ULT A
            LEFT JOIN mkt.vw_SUG_UND_OPT B
              ON A.PdvID=B.PdvID AND A.ProPstID=B.ProPstID
           ) A
      LEFT JOIN PER.MAESTRO_PRODUCTO_PRESENTACION P
        ON A.ProPstID=P.ProPstID
      LEFT JOIN PER.MAESTRO_PDV V
        ON A.PdvID=V.PdvID
  )


SELECT * FROM  mkt.fn_sugerido(33)


SELECT
  PdvID,
  ProPstID,
  UnidExist,
  UnidDespOpt,
  DOI,
  DOID,
  CEILING(CASE WHEN DOID*UnidDespOpt/7<UnidExist THEN 0 ELSE DOID*UnidDespOpt/7-A.UnidExist END) Distribucion
  INTO mkt.SUG_DISTRIBUCION
FROM mkt.SUG_DOI A;

SELECT
  A.PdvID,
  V.StatusPdv,
  A.ProPstID,
  P.StatusProd,
  UnidExist,
  UnidDespOpt,
  DOI,
  DOID,
  Distribucion
FROM (
  SELECT
        A.PdvID,
        A.ProPstID,
        A.UnidExist,
        COALESCE(B.UnidDespOpt,0) UnidDespOpt,
        COALESCE(CASE WHEN UnidDespOpt>0 THEN UnidExist/UnidDespOpt*7
          ELSE UnidExist/(1)*7 END,0) DOI,
        @doid AS DOID,
        COALESCE(CEILING(CASE WHEN @doid*UnidDespOpt/7<UnidExist THEN 0 ELSE @doid*UnidDespOpt/7-A.UnidExist END),0) Distribucion
      FROM mkt.vw_SUG_INV_ULT A
      LEFT JOIN mkt.vw_SUG_UND_OPT B
        ON A.PdvID=B.PdvID AND A.ProPstID=B.ProPstID
     ) A
LEFT JOIN PER.MAESTRO_PRODUCTO_PRESENTACION P
  ON A.ProPstID=P.ProPstID
LEFT JOIN PER.MAESTRO_PDV V
  ON A.PdvID=V.PdvID

