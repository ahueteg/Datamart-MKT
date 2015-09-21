USE genomma;
GO
IF OBJECT_ID('vw.fn_dim_Vendedor','IF') IS NOT NULL
    DROP FUNCTION vw.fn_dim_Vendedor;
GO
CREATE FUNCTION vw.fn_dim_Vendedor(@grupoid VARCHAR(3))
  RETURNS TABLE
  AS
  RETURN (
    SELECT
      VendedorIDClie,
      VendedorID,
      DescVendedor,
      GrpID GrupoID
    FROM per.MAESTRO_VENDEDOR
    WHERE GrpID=@grupoid
  )