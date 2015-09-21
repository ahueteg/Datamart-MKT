DROP VIEW vw.[FS.01.01 Avance Ventas];
CREATE VIEW vw.[FS.01.01 Avance Ventas]
AS
SELECT
substring(A.[Fecha],7,2)+'/'+SUBSTRING(A.fecha,5,2)+'/'+SUBSTRING(A.fecha,1,4) Fecha,
--substring(A.[Año-Semana],1,4)+'-'+substring(A.[Año-Semana],5,2) [Año-Semana],
A.GrpID GrupoID,
B.CadenaID,
J.PdvID,
H.ProPstID,
A.ProIDClie,
A.UnidDesp,
A.MontoDespCliente,
A.UnidDesp*I.PVP MontoDespPvp,
A.UnidDesp*I.PrecioLista MontoDesp
FROM
(
/**/
SELECT
A.Fecha,
A.GrpID,
A.CadenaIDClie,
A.OficinaIDClie,
A.GrupoTratIDClie,
A.SupervisorIDClie,
A.VendedorIDClie,
A.ProIDClie,
A.PdvIDClie,
A.UnidDesp,
A.MontoDespCliente,
t.AñoSemana_GL [Año-Semana]
FROM PER.GLP_SELLOUT A
LEFT JOIN per.MAESTRO_TIEMPO T
ON A.Fecha = T.Fecha
WHERE A.GrpID in ('308','309','311')--,'312','328')
) A
	LEFT JOIN per.MAESTRO_CADENA B
	ON A.CadenaIDClie=B.CadenaIDClie AND A.GrpID=B.GrpID
	LEFT JOIN per.MAESTRO_TIEMPO G
	ON A.Fecha=G.Fecha
	LEFT JOIN per.MAESTRO_PRODUCTO_FUENTE H
	ON A.ProIDClie=H.ProIDClie AND A.GrpID=H.GrpID
	LEFT JOIN per.MAESTRO_PRODUCTO_PRECIO I
	ON G.AñoSemana_GL=I.AñoSemana_GL AND H.ProPstID=I.ProPstID AND A.GrpID=I.GrpID
	LEFT JOIN per.MAESTRO_PDV J
	ON A.PdvIDClie=J.PdvIDClie AND A.GrpID=J.GrpID
WHERE G.AñoSemana_GL IN (SELECT * FROM VW.fn_ultimas_semanas('309',4));