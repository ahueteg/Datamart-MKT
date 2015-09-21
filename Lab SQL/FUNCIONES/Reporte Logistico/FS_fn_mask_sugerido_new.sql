USE genomma;
GO
IF OBJECT_ID('vw.FS_fn_mask_sugerido_new','IF') IS NOT NULL
    DROP FUNCTION vw.FS_fn_mask_sugerido_new;
GO
CREATE FUNCTION vw.FS_fn_mask_sugerido_new(@semanas int)
  RETURNS TABLE
  AS
  RETURN (
    SELECT A.GrpID,A.PdvID,A.ProPstID,A.AñoSemana_GL
    FROM
      (
        SELECT B.GrpID,B.PdvID,A.ProPstID,C.AñoSemana_GL
        FROM
          (
            SELECT DISTINCT GrpID,ProPstID from per.MAESTRO_PRODUCTO_FUENTE
            WHERE GrpID IN ('308','309','311')
          ) A
          INNER JOIN
          (
            SELECT DISTINCT GrpID,PdvID from per.MAESTRO_PDV
            WHERE GrpID IN ('308','309','311')
          ) B ON A.GrpID=B.GrpID
          CROSS JOIN
          (
            SELECT AñoSemana_GL
            FROM vw.fn_ultimas_semanas('309',@semanas)
          ) C
      ) A
  )