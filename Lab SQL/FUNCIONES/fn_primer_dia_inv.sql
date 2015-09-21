USE genomma;
GO
IF OBJECT_ID('vw.fn_primer_dia_inv','IF') IS NOT NULL
    DROP FUNCTION vw.fn_primer_dia_inv;
GO
CREATE FUNCTION vw.fn_primer_dia_inv(@grupoid VARCHAR(3))
  RETURNS TABLE
  AS
  RETURN (
    SELECT min(Fecha) Fecha
    FROM per.GLP_STOCK
    WHERE GrpID=@grupoid
  )