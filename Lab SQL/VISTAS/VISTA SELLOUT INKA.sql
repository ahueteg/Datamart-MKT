create SCHEMA vistas;

DROP VIEW per.[Sellout_Inka]
CREATE VIEW vistas.[Sellout_Inka]
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
A.MontoDespCliente,
A.UnidDesp*I.PVP MontoDespPvp,
A.UnidDesp*I.PrecioLista MontoDesp
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
A.MontoDespCliente
FROM PER.GLP_SELLOUT A
WHERE A.Fecha>'20131230' and A.GrpID in ('309')
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
	ON G.A�oSemana_GL=I.A�oSemana_GL AND H.ProPstID=I.ProPstID AND A.GrpID=I.GrpID
	LEFT JOIN per.MAESTRO_PDV J
	ON A.PdvIDClie=J.PdvIDClie AND A.GrpID=J.GrpID;

CREATE VIEW vistas.[Sellout_Cadena_Farmacias]
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
A.MontoDespCliente,
A.UnidDesp*I.PVP MontoDespPvp,
A.UnidDesp*I.PrecioLista MontoDesp
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
A.MontoDespCliente
FROM PER.GLP_SELLOUT A
WHERE A.Fecha>'20131230' and A.GrpID in ('309','311')
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
	ON G.A�oSemana_GL=I.A�oSemana_GL AND H.ProPstID=I.ProPstID AND A.GrpID=I.GrpID
	LEFT JOIN per.MAESTRO_PDV J
	ON A.PdvIDClie=J.PdvIDClie AND A.GrpID=J.GrpID;