CREATE VIEW vw.vwBase_Cliente
AS
SELECT
[GrpID] GrupoID,
[GrpNombre],
[GrpRFC],
[GrpURL],
[GrpRazonSocial],
[Canal]
FROM [per].[MAESTRO_CLIENTE];