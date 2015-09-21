CREATE VIEW vw.vwBase_Geografia
AS
SELECT
  UbigeoID,
  Pais,
  Departamento,
  Provincia,
  Distrito,
  Region_I,
  Region_II,
  Region_III,
  Zona_I,
  Zona_II
FROM per.MAESTRO_UBIGEO;