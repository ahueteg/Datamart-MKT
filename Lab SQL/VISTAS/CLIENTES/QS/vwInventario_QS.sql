
create view vw.vwInventario_QS AS
SELECT
substring(A.[Fecha],7,2)+'/'+SUBSTRING(A.fecha,5,2)+'/'+SUBSTRING(A.fecha,1,4) Fecha,
A.GrpID GrupoID,
B.CadenaID,
H.ProPstID,
I.PrecioID,
A.UnidExist,
A.UnidCedis,
A.UnidTrans,
A.UnidExist*I.PrecioLista MontoExist,
A.UnidCedis*I.PrecioLista MontoCedis,
A.UnidTrans*I.PrecioLista MontoTrans
FROM
(
SELECT
B.Fecha,
B.GrpID,
B.CadenaIDClie,
B.ProIDClie,
B.UnidExist,
B.UnidCedis,
B.UnidTrans
FROM PER.GLP_STOCK B
  WHERE b.Fecha in (SELECT * FROM vw.fn_ultimo_dia_inv('307')) and b.GrpID='307'
) A
	LEFT JOIN per.MAESTRO_CADENA B
	ON A.CadenaIDClie=B.CadenaIDClie AND A.GrpID=B.GrpID
	LEFT JOIN per.MAESTRO_TIEMPO G
	ON A.Fecha=G.Fecha
	LEFT JOIN per.MAESTRO_PRODUCTO_FUENTE H
	ON A.ProIDClie=H.ProIDClie AND A.GrpID=H.GrpID
	LEFT JOIN per.MAESTRO_PRODUCTO_PRECIO I
	ON G.AñoSemana_GL=I.AñoSemana_GL AND H.ProPstID=I.ProPstID AND A.GrpID=I.GrpID
