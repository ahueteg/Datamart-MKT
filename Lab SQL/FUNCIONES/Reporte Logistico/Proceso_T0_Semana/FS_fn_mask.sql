USE genommaperu;
GO
IF OBJECT_ID('vw.FS_fn_mask','IF') IS NOT NULL
    DROP FUNCTION vw.FS_fn_mask;
GO
CREATE FUNCTION vw.FS_fn_mask(@semanas int)
  RETURNS TABLE
  AS
  RETURN (
        SELECT B.GrpID,B.PdvIDClie,A.ProIDClie,C.AñoSemana_GL
        FROM
          (
            SELECT DISTINCT GrpID,ProIDClie
            FROM per.MAESTRO_PRODUCTO_FUENTE
            WHERE GrpID IN ('308','309','311')
          ) A
          INNER JOIN
          (
            SELECT DISTINCT GrpID,PdvIDClie
            FROM per.MAESTRO_PDV
            WHERE GrpID IN ('308','309','311')
          ) B ON A.GrpID=B.GrpID
          CROSS JOIN
          (
            SELECT AñoSemana_GL
            FROM vw.fn_ultimas_semanas('309',@semanas)
          ) C
  )