USE genomma;
GO
IF OBJECT_ID('vw.fn_ultimas_semanas','IF') IS NOT NULL
    DROP FUNCTION vw.fn_ultimas_semanas;
GO
CREATE FUNCTION vw.fn_ultimas_semanas(@grupoid VARCHAR(3),@num_semanas int)
  RETURNS TABLE
  AS
  RETURN (
    SELECT A.A�oSemana_GL
    FROM
      (
        SELECT
          A.A�oSemana_GL,
          ROW_NUMBER()
          OVER (
            ORDER BY A.A�oSemana_GL DESC) SEMANA
        FROM
          (
            SELECT DISTINCT
              A�oSemana_GL,
              A�o_GL,
              Semana_GL
            FROM
              per.MAESTRO_TIEMPO) A
          LEFT JOIN
          (
            SELECT
              B.A�oSemana_GL,
              B.A�o_GL,
              B.Semana_GL
            FROM
              (
                SELECT max(Fecha) Fecha
                FROM per.GLP_SELLOUT
                WHERE GrpID = @grupoid
              ) A
              LEFT JOIN per.MAESTRO_TIEMPO B
                ON A.Fecha = b.Fecha
          ) B
            ON A.A�oSemana_GL <= B.A�oSemana_GL
        WHERE B.A�oSemana_GL IS NOT NULL
      ) A
    WHERE SEMANA <= @num_semanas
  )