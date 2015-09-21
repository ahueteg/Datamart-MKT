SELECT A.GrupoID,B.GrpNombre,A.[Año-Semana],A.MontoDesp FROM (
  SELECT
    A.GrupoID,
    A.[Año-Semana],
    SUM(A.MontoDesp) MontoDesp
  FROM vw.[GL.01 Informacion] A
  WHERE A.[Año-Semana] IN ('2015-37', '2015-36', '2015-35')
  GROUP BY A.GrupoID,
    A.[Año-Semana]
) A LEFT JOIN PER.MAESTRO_CLIENTE B
  ON A.GrupoID=B.GrpID