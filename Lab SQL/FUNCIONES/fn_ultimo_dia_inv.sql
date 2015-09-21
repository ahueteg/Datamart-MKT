USE genomma;
GO
IF OBJECT_ID('vw.fn_ultimo_dia_inv','IF') IS NOT NULL
    DROP FUNCTION vw.fn_ultimo_dia_inv;
GO
CREATE FUNCTION vw.fn_ultimo_dia_inv(@grupoid VARCHAR(3))
  RETURNS TABLE
  AS
  RETURN (
    SELECT max(Fecha) Fecha
    FROM per.GLP_STOCK
    WHERE GrpID=@grupoid
  )