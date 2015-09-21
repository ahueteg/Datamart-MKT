SELECT *
    FROM PER.MAESTRO_PRODUCTO_FUENTE AS A
INNER JOIN DBO.['maestro producto$'] B
ON A.ProIDClie=CONVERT(VARCHAR,B.ProIDClie) AND A.GrpID='338'
WHERE A.ProPstID='0000'


SELECT * FROM PER.MAESTRO_PRODUCTO_FUENTE
WHERE GrpID='338'


SELECT * FROM DBO.['maestro producto$']


UPDATE A
SET A.ProPstID=b.ProPstID
    FROM PER.MAESTRO_PRODUCTO_FUENTE AS A
    INNER JOIN DBO.['maestro producto$'] B
ON A.ProIDClie=CONVERT(VARCHAR,B.ProIDClie) AND A.GrpID='338'
WHERE A.ProPstID='0000'
;

SELECT * FROM PER.MAESTRO_PRODUCTO_FUENTE
WHERE GrpID='338'



DROP TABLE mkt.maestro_vendedor_qs
SELECT *
into mkt.maestro_vendedor_qs
FROM   OPENROWSET('Microsoft.ACE.OLEDB.15.0',
       'Excel 12.0 Xml;HDR=YES;IMEX=1;Database=D:\1.- Distributivo\1.- Quimica Suiza\S-23 Maestro Quimica Suiza.xlsx',
       'SELECT * FROM [Maestro Vendedor$]')


SELECT
*
FROM mkt.maestro_vendedor_qs

SELECT * FROM per.MAESTRO_PRODUCTO_FUENTE
WHERE GrpID='307' and ProPstID='0000'


SELECT * FROM per.Cliente

UPDATE A
SET A.propstid=b.ProPstID
    FROM PER.MAESTRO_PRODUCTO_FUENTE A
    INNER JOIN mkt.[maestro_producto_qs] B
ON A.proidclie=B.ProPstIDClie AND A.GRPID=B.GrpID;


SELECT * FROM mkt.maestro_producto_qs

DROP TABLE mkt.maestro
SELECT *
into mkt.maestro
FROM   OPENROWSET('Microsoft.ACE.OLEDB.15.0',
       'Excel 12.0 Xml;HDR=YES;IMEX=1;Database=D:\1.- Distributivo\1.- Quimica Suiza\S-23 Maestro Quimica Suiza.xlsx',
       'SELECT * FROM [Maestro Supervisor$]')

SELECT
    GrpID,
    GrpNombre,
    SupervisorID,
    SupervisorIDClie,
    SupervisorNombreClie,
    Nombres,
    [Apellido Paterno],
    [Apellido Materno],
    Tipo,
    Grupo,
    [Telñfono 1],
    [Telñfono 2],
    [Telñfono 3],
    [E-mail]
FROM mkt.maestro



UPDATE A
SET A.SupervisorIDClie=B.SupervisorIDClie,
    a.DescSupervisor=B.SupervisorNombreClie
    FROM PER.MAESTRO_SUPERVISOR A
    INNER JOIN mkt.[maestro] B
ON A.SupervisorID=B.SupervisorID AND A.GRPID=B.GrpID;

SELECT
    SupervisorID,
    SupervisorIDClie,
    DescSupervisor,
    GrpID
FROM PER.MAESTRO_SUPERVISOR
WHERE GrpID='307'

INSERT INTO PER.MAESTRO_SUPERVISOR
SELECT
    SupervisorID,
    SupervisorIDClie,
    SupervisorNombreClie,
    GrpID
FROM mkt.maestro
WHERE GrpID IS NOT NULL