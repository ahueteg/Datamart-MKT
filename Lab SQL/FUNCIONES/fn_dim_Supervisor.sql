USE genomma;
GO
IF OBJECT_ID('vw.fn_dim_Supervisor','IF') IS NOT NULL
    DROP FUNCTION vw.fn_dim_Supervisor;
GO
CREATE FUNCTION vw.fn_dim_Supervisor(@grupoid VARCHAR(3))
  RETURNS TABLE
  AS
  RETURN (
    SELECT
      SupervisorIDClie,
      SupervisorID,
      DescSupervisor,
      GrpID GrupoID
    FROM per.MAESTRO_SUPERVISOR
    WHERE GrpID=@grupoid
  )