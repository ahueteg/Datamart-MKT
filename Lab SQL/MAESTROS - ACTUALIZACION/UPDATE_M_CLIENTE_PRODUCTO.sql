/*1.- QUIMICA SUIZA*/
UPDATE A
SET A.ProPstID=B.ProPstID
    FROM PER.MAESTRO_PRODUCTO_FUENTE AS A
    INNER JOIN (
          SELECT
              GrupoID GrpID,
              GrpNombre,
              ProPstIDClie,
              ProPstNombreClie,
              ProPstID,
              ProPstNombre
          FROM OPENROWSET('Microsoft.ACE.OLEDB.15.0',
          'Excel 12.0 Xml;HDR=YES;IMEX=1;Database=\\perfile01\INFORMACION COMERCIAL - PERU\Perú\Maestros\Maestros Clientes\Dist_Quimica Suiza\S-38 Maestro Quimica Suiza.xlsx',
          'SELECT * FROM [Maestro Producto$]')
          WHERE GrupoID IS NOT NULL
               ) B
ON A.ProIDClie=B.ProPstIDClie AND A.GrpID=B.GrpID
--WHERE A.ProPstID='0000'
;
/*2.- CONTINENTAL*/
UPDATE A
SET A.ProPstID=B.ProPstID
    FROM PER.MAESTRO_PRODUCTO_FUENTE AS A
    INNER JOIN (
          SELECT
              GrupoID GrpID,
              GrpNombre,
              ProPstIDClie,
              ProPstNombreClie,
              ProPstID,
              ProPstNombre
          FROM OPENROWSET('Microsoft.ACE.OLEDB.15.0',
          'Excel 12.0 Xml;HDR=YES;IMEX=1;Database=\\perfile01\INFORMACION COMERCIAL - PERU\Perú\Maestros\Maestros Clientes\Dist_Continental\S-38 Maestro Continental.xlsx',
          'SELECT * FROM [Maestro Producto$]')
            
          WHERE GrupoID IS NOT NULL
               ) B
ON A.ProIDClie=B.ProPstIDClie AND A.GrpID=B.GrpID
--WHERE A.ProPstID='0000'
;
/*3.- DIGALIMENTA*/
UPDATE A
SET A.ProPstID=B.ProPstID
    FROM PER.MAESTRO_PRODUCTO_FUENTE AS A
    INNER JOIN (
          SELECT
              GrupoID GrpID,
              GrpNombre,
              ProPstIDClie,
              ProPstNombreClie,
              ProPstID,
              ProPstNombre
          FROM OPENROWSET('Microsoft.ACE.OLEDB.15.0',
          'Excel 12.0 Xml;HDR=YES;IMEX=1;Database=\\perfile01\INFORMACION COMERCIAL - PERU\Perú\Maestros\Maestros Clientes\Dist_Digalimenta\S-38 Maestro Digalimenta.xlsx',
          'SELECT * FROM [Maestro Producto$]')
          WHERE GrupoID IS NOT NULL
               ) B
ON A.ProIDClie=CONVERT(VARCHAR,B.ProPstIDClie) AND A.GrpID=B.GrpID;
--WHERE A.ProPstID='0000'
;
/*4.- KEYMARK*/
UPDATE A
SET A.ProPstID=B.ProPstID
    FROM PER.MAESTRO_PRODUCTO_FUENTE AS A
    INNER JOIN (
          SELECT
              GrupoID GrpID,
              GrpNombre,
              ProPstIDClie,
              ProPstNombreClie,
              ProPstID,
              ProPstNombre
          FROM OPENROWSET('Microsoft.ACE.OLEDB.15.0',






          'Excel 12.0 Xml;HDR=YES;IMEX=1;Database=\\perfile01\INFORMACION COMERCIAL - PERU\Perú\Maestros\Maestros Clientes\Dist_KeyMark\S-38 Maestro KeyMark.xlsx',
          'SELECT * FROM [Maestro Producto$]')
          WHERE GrupoID IS NOT NULL
               ) B
ON A.ProIDClie=CONVERT(VARCHAR,B.ProPstIDClie) AND A.GrpID=B.GrpID
--WHERE A.ProPstID='0000'
;
/*5.- INKAFARMA*/
UPDATE A
SET A.ProPstID=B.ProPstID
    FROM PER.MAESTRO_PRODUCTO_FUENTE AS A
    INNER JOIN (
          SELECT
              GrupoID GrpID,
              GrpNombre,
              ProPstIDClie,
              ProPstNombreClie,
              ProPstID,
              ProPstNombre
          FROM OPENROWSET('Microsoft.ACE.OLEDB.15.0',
          'Excel 12.0 Xml;HDR=YES;IMEX=1;Database=\\perfile01\INFORMACION COMERCIAL - PERU\Perú\Maestros\Maestros Clientes\F&S_Inkafarma\S-38 Maestro Inkafarma.xlsx',
          'SELECT * FROM [Maestro Producto$]')
          WHERE GrupoID IS NOT NULL
               ) B
ON A.ProIDClie=CONVERT(VARCHAR,B.ProPstIDClie) AND A.GrpID=B.GrpID;
/*
UPDATE A
SET A.ProPstID=b.ProPstID
    FROM PER.MAESTRO_PRODUCTO_FUENTE AS A
    INNER JOIN mkt.Cod_productos B
ON A.ProIDClie=CONVERT(VARCHAR,B.ProIDClie) AND A.GrpID='309'
WHERE A.ProPstID='0000'
*/
/*ALBIS*/
UPDATE A
SET A.ProPstID=B.ProPstID
    FROM PER.MAESTRO_PRODUCTO_FUENTE AS A
    INNER JOIN (
          SELECT
              GrupoID GrpID,
              GrpNombre,
              ProPstIDClie,
              ProPstNombreClie,
              ProPstID,
              ProPstNombre
          FROM OPENROWSET('Microsoft.ACE.OLEDB.15.0',
          'Excel 12.0 Xml;HDR=YES;IMEX=1;Database=\\perfile01\INFORMACION COMERCIAL - PERU\Perú\Maestros\Maestros Clientes\F&S_Arcangel\S-36 Maestro Arcangel.xlsx',
          'SELECT * FROM [Maestro Producto$]')
          WHERE GrupoID IS NOT NULL
               ) B
ON A.ProIDClie=CONVERT(VARCHAR,CONVERT(BIGINT,B.ProPstIDClie)) AND A.GrpID=B.GrpID;
/*SUPESA*/
UPDATE A
SET A.ProPstID=B.ProPstID
    FROM PER.MAESTRO_PRODUCTO_FUENTE AS A
    INNER JOIN (
          SELECT
              GrupoID GrpID,
              GrpNombre,
              ProPstIDClie,
              ProPstNombreClie,
              ProPstID,
              ProPstNombre
          FROM OPENROWSET('Microsoft.ACE.OLEDB.15.0',
          'Excel 12.0 Xml;HDR=YES;IMEX=1;Database=\\perfile01\INFORMACION COMERCIAL - PERU\Perú\Maestros\Maestros Clientes\F&S_Supesa\S-38 Maestro Supermercados Peruanos.xlsx',
          'SELECT * FROM [Maestro Producto$]')
          WHERE GrupoID IS NOT NULL
               ) B
ON A.ProIDClie=CONVERT(VARCHAR,CONVERT(BIGINT,B.ProPstIDClie)) AND A.GrpID=B.GrpID;
/*CENCOSUD*/
UPDATE A
SET A.ProPstID=B.ProPstID
    FROM PER.MAESTRO_PRODUCTO_FUENTE AS A
    INNER JOIN (
          SELECT
              GrupoID GrpID,
              GrpNombre,
              ProPstIDClie,
              ProPstNombreClie,
              ProPstID,
              ProPstNombre
          FROM OPENROWSET('Microsoft.ACE.OLEDB.15.0',
          'Excel 12.0 Xml;HDR=YES;IMEX=1;Database=\\perfile01\INFORMACION COMERCIAL - PERU\Maestros\Maestros Clientes\Perú\3-  Supermercados\2.- Cencosud\S-25 Maestro Cencosud.xlsx',
          'SELECT * FROM [Maestro Producto$]')
          WHERE GrupoID IS NOT NULL
               ) B
ON A.ProIDClie=CONVERT(VARCHAR,CONVERT(BIGINT,B.ProPstIDClie)) AND A.GrpID=B.GrpID;
/*TOTTUS*/
UPDATE A
SET A.ProPstID=B.ProPstID
    FROM PER.MAESTRO_PRODUCTO_FUENTE AS A
    INNER JOIN (
          SELECT
              GrupoID GrpID,
              GrpNombre,
              ProPstIDClie,
              ProPstNombreClie,
              ProPstID,
              ProPstNombre
          FROM OPENROWSET('Microsoft.ACE.OLEDB.15.0',
          'Excel 12.0 Xml;HDR=YES;IMEX=1;Database=\\perfile01\INFORMACION COMERCIAL - PERU\Maestros\Maestros Clientes\Perú\3-  Supermercados\3.- Tottus\S-25 Maestro Tottus.xlsx',
          'SELECT * FROM [Maestro Producto$]')
          WHERE GrupoID IS NOT NULL
               ) B
ON A.ProIDClie=CONVERT(VARCHAR,CONVERT(BIGINT,B.ProPstIDClie)) AND A.GrpID=B.GrpID;