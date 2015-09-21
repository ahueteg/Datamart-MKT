DROP TABLE mkt.FS_Info_Dia;
SELECT
A.GrpID,
A.PdvIDClie,
A.ProIDClie,
A.Fecha,
A.UnidDesp,
A.MontoDesp,
A.MontoDespPvp,
B.UnidExist,
B.MontoExist,
B.UnidCedis,
B.MontoCedis
into mkt.FS_Info_Dia
FROM mkt.FS_Venta_90S A
LEFT JOIN mkt.FS_Stock_90S B
  ON A.GrpID=B.GrpID AND A.PdvIDClie=B.PdvIDClie AND A.ProIDClie=B.ProIDClie AND A.Fecha=B.Fecha;

CREATE VIEW vw.[FS.01 Informacion]
  AS
SELECT
substring(A.[Fecha],7,2)+'/'+SUBSTRING(A.fecha,5,2)+'/'+SUBSTRING(A.fecha,1,4) Fecha,
substring(G.AñoSemana_GL,1,4)+'-'+substring(G.AñoSemana_GL,5,2) [Año-Semana],
G.AñoSemana_GL,
A.GrpID GrupoID,
J.PdvID,
H.ProPstID,
A.ProIDClie,
A.UnidDesp,
A.UnidExist,
A.UnidCedis,
A.UnidDesp*I.PVP MontoDespPvp,
A.UnidDesp*I.PrecioLista MontoDesp,
A.UnidExist*I.PrecioLista MontoExist,
A.UnidCedis*I.PrecioLista MontoCedis
FROM
(
SELECT * FROM mkt.FS_Info_Dia
) A
	LEFT JOIN per.MAESTRO_TIEMPO G
	ON A.Fecha=G.Fecha
	LEFT JOIN per.MAESTRO_PRODUCTO_FUENTE H
	ON A.ProIDClie=H.ProIDClie AND A.GrpID=H.GrpID
	LEFT JOIN per.MAESTRO_PRODUCTO_PRECIO I
	ON G.AñoSemana_GL=I.AñoSemana_GL AND H.ProPstID=I.ProPstID AND A.GrpID=I.GrpID
	LEFT JOIN per.MAESTRO_PDV J
	ON A.PdvIDClie=J.PdvIDClie AND A.GrpID=J.GrpID;

