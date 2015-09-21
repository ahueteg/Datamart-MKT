DROP VIEW vw.vw_Info_Semana_SP;
CREATE VIEW vw.vw_Info_Semana_SP
  AS
SELECT * FROM vw.fn_vista_sugerido('308', 8);


CREATE VIEW vw.vwPuntodeVenta_SP
AS
SELECT
  PdvID,
  PdvIDClie,
  RUC,
  PdvNombre,
  UbigeoID,
  Direccion,
  Distrito,
  Provincia,
  Departamento,
  GrpID GrupoID,
  PdvNombreHomologo,
  StatusPdv,
  CategoriaPdv,
  Segmentacion_GL_I,
  Tipo,
  Formato,
  Denominacion,
  Tiendas
FROM [per].[MAESTRO_PDV]
WHERE GrpID='308';

CREATE VIEW vw.vwProductoFuente_SP
AS
SELECT
[ProIDClie],
--[GrpID],
[ProPstID]
FROM [per].[MAESTRO_PRODUCTO_FUENTE] A
WHERE GrpID='308'


SELECT COUNT(1) ,COUNT(DISTINCT ProIDClie),COUNT(DISTINCT ProPstID) FROM vw.vwProductoFuente_SP

DELETE FROM vw.vwProductoFuente_SP
WHERE ProPstID IN (SELECT ProPstID FROM vw.vwProductoFuente_SP GROUP BY ProPstID HAVING COUNT(1) >1)
AND LEN(ProIDClie)=12

SELECT LEN(ProIDClie), ProIDClie FROM vw.vwProductoFuente_SP
ORDER BY 1 DESC

SELECT * FROM per.MAESTRO_PRODUCTO_FUENTE
WHERE grpid='308' and ProPstID='3457'