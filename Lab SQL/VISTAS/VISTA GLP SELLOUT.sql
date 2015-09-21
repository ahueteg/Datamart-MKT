
/*demo*/
SELECT
A.Fecha,
A.GrpID GrupoID,
B.CadenaID,
C.OficinaID,
D.Grupo1ID GrupoTratID,
F.SupervisorID,
E.VendedorID,
NULL UbigeoID,
H.ProPstID,
J.PdvID,
I.PrecioID,
A.UnidDesp,
A.MontoDespCliente,
A.UnidDesp*I.PrecioLista MontoDesp
	FROM per.GLP_SELLOUT A
	LEFT JOIN per.MAESTRO_CADENA B
	ON A.CadenaIDClie=B.CadenaIDClie AND A.GrpID=B.GrpID
	LEFT JOIN per.MAESTRO_OFICINA C
	ON A.OficinaIDClie=C.OficinaIDClie AND A.GrpID=C.GrpID
	LEFT JOIN per.MAESTRO_GRUPO1 D
	ON A.GrupoTratIDClie=D.Grupo1IDClie AND A.GrpID=D.GrpID
	LEFT JOIN per.MAESTRO_VENDEDOR E
	ON A.VendedorIDClie=E.VendedorIDClie AND A.GrpID=E.GrpID
	LEFT JOIN per.MAESTRO_SUPERVISOR F
	ON A.SupervisorIDClie=F.SupervisorIDClie AND A.GrpID=F.GrpID
	LEFT JOIN per.MAESTRO_TIEMPO G
	ON A.Fecha=G.Fecha
	LEFT JOIN per.MAESTRO_PRODUCTO_FUENTE H
	ON A.ProIDClie=H.ProIDClie AND A.GrpID=H.GrpID
	LEFT JOIN per.MAESTRO_PRODUCTO_PRECIO I
	ON G.AñoSemana_GL=I.AñoSemana_GL AND H.ProPstID=I.ProPstID AND A.GrpID=I.GrpID
	LEFT JOIN per.MAESTRO_PDV J
	ON A.PdvIDClie=J.PdvIDClie AND A.GrpID=J.GrpID

/*VISTA DISTRIBUTIVO*/

DROP VIEW per.[1:Informacion]
CREATE VIEW per.[1:Informacion]
AS
SELECT
substring(A.[Fecha],7,2)+'/'+SUBSTRING(A.fecha,5,2)+'/'+SUBSTRING(A.fecha,1,4) Fecha,
A.GrpID GrupoID,
B.CadenaID,
C.OficinaID,
D.Grupo1ID GrupoTratID,
F.SupervisorID,
E.VendedorID,
NULL UbigeoID,
J.PdvID,
H.ProPstID,
I.PrecioID,
A.UnidDesp,
A.UnidExist,
A.UnidCedis,
A.UnidTrans,
A.MontoDespCliente,
A.UnidDesp*I.PVP MontoDespPvp,
A.UnidDesp*I.PrecioLista MontoDesp,
A.UnidExist*I.PrecioLista MontoExist,
A.UnidCedis*I.PrecioLista MontoCedis,
A.UnidTrans*I.PrecioLista MontoTrans
FROM
(
SELECT
A.Fecha,
A.GrpID,
A.CadenaIDClie,
A.OficinaIDClie,
A.GrupoTratIDClie,
A.VendedorIDClie,
A.SupervisorIDClie,
A.ProIDClie,
A.PdvIDClie,
A.UnidDesp,
B.UnidExist,
B.UnidCedis,
B.UnidTrans,
A.MontoDespCliente
FROM PER.GLP_SELLOUT A
LEFT JOIN
(
SELECT * FROM
PER.GLP_STOCK
WHERE 1=2) B
ON A.ProIDClie=B.ProIDClie
UNION ALL
SELECT
B.Fecha,
B.GrpID,
B.CadenaIDClie,
A.OficinaIDClie,
A.GrupoTratIDClie,
A.VendedorIDClie,
A.SupervisorIDClie,
B.ProIDClie,
A.PdvIDClie,
A.UnidDesp,
B.UnidExist,
B.UnidCedis,
B.UnidTrans,
A.MontoDespCliente
FROM PER.GLP_STOCK B
LEFT JOIN
(
SELECT * FROM
PER.GLP_SELLOUT
WHERE 1=2) A
ON A.ProIDClie=B.ProIDClie
) A
	LEFT JOIN per.MAESTRO_CADENA B
	ON A.CadenaIDClie=B.CadenaIDClie AND A.GrpID=B.GrpID
	LEFT JOIN per.MAESTRO_OFICINA C
	ON A.OficinaIDClie=C.OficinaIDClie AND A.GrpID=C.GrpID
	LEFT JOIN per.MAESTRO_GRUPO1 D
	ON A.GrupoTratIDClie=D.Grupo1IDClie AND A.GrpID=D.GrpID
	LEFT JOIN per.MAESTRO_VENDEDOR E
	ON A.VendedorIDClie=E.VendedorIDClie AND A.GrpID=E.GrpID
	LEFT JOIN per.MAESTRO_SUPERVISOR F
	ON A.SupervisorIDClie=F.SupervisorIDClie AND A.GrpID=F.GrpID
	LEFT JOIN per.MAESTRO_TIEMPO G
	ON A.Fecha=G.Fecha
	LEFT JOIN per.MAESTRO_PRODUCTO_FUENTE H
	ON A.ProIDClie=H.ProIDClie AND A.GrpID=H.GrpID
	LEFT JOIN per.MAESTRO_PRODUCTO_PRECIO I
	ON G.AñoSemana_GL=I.AñoSemana_GL AND H.ProPstID=I.ProPstID AND A.GrpID=I.GrpID
	LEFT JOIN per.MAESTRO_PDV J
	ON A.PdvIDClie=J.PdvIDClie AND A.GrpID=J.GrpID
WHERE A.Fecha>'20131230'




SELECT COUNT(1)  FROM PER.[1:Informacion]