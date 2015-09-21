/*1.- QUIMICA SUIZA*/
UPDATE A
SET A.CadenaID=B.CadenaID,
    A.DescCadena=b.CadenaNombreClie
    FROM PER.MAESTRO_CADENA AS A
    INNER JOIN (
          SELECT
            GrupoID GrpID,
            GrpNombre,
            CadenaID,
            CadenaIDClie,
            CadenaNombreClie
          FROM OPENROWSET('Microsoft.ACE.OLEDB.15.0',
          'Excel 12.0 Xml;HDR=YES;IMEX=1;Database=\\perfile01\INFORMACION COMERCIAL - PERU\Maestros\Maestros Clientes\Perú\1.- Distributivo\1.- Quimica Suiza\S-23 Maestro Quimica Suiza.xlsx',
          'SELECT * FROM [Maestro Cadena$]')
          WHERE GrupoID IS NOT NULL
               ) B
ON A.CadenaIDClie=CONVERT(VARCHAR,B.CadenaIDClie) AND A.GrpID=B.GrpID;
/*2.- CONTINENTAL*/
UPDATE A
SET A.CadenaID=B.CadenaID,
    A.DescCadena=b.CadenaNombreClie
    FROM PER.MAESTRO_CADENA AS A
    INNER JOIN (
          SELECT
            GrupoID GrpID,
            GrpNombre,
            CadenaID,
            CadenaIDClie,
            CadenaNombreClie
          FROM OPENROWSET('Microsoft.ACE.OLEDB.15.0',
          'Excel 12.0 Xml;HDR=YES;IMEX=1;Database=\\perfile01\INFORMACION COMERCIAL - PERU\Maestros\Maestros Clientes\Perú\1.- Distributivo\2.- Distribuidora Continental\S-23 Maestro Continental.xlsx',
          'SELECT * FROM [Maestro Cadena$]')
          WHERE GrupoID IS NOT NULL
               ) B
ON A.CadenaIDClie=CONVERT(VARCHAR,B.CadenaIDClie) AND A.GrpID=B.GrpID;
/*3.- DIGALIMENTA*/
UPDATE A
SET A.CadenaID=B.CadenaID,
    A.DescCadena=b.CadenaNombreClie
    FROM PER.MAESTRO_CADENA AS A
    INNER JOIN (
          SELECT
            GrupoID GrpID,
            GrpNombre,
            CadenaID,
            CadenaIDClie,
            CadenaNombreClie
          FROM OPENROWSET('Microsoft.ACE.OLEDB.15.0',
          'Excel 12.0 Xml;HDR=YES;IMEX=1;Database=\\perfile01\INFORMACION COMERCIAL - PERU\Maestros\Maestros Clientes\Perú\1.- Distributivo\3.- Digalimenta\S-23 Maestro Digalimenta.xlsx',
          'SELECT * FROM [Maestro Cadena$]')
          WHERE GrupoID IS NOT NULL
               ) B
ON A.CadenaIDClie=CONVERT(VARCHAR,B.CadenaIDClie) AND A.GrpID=B.GrpID;
/*4.- KEYMARK*/
UPDATE A
SET A.CadenaID=B.CadenaID,
    A.DescCadena=b.CadenaNombreClie
    FROM PER.MAESTRO_CADENA AS A
    INNER JOIN (
          SELECT
            GrupoID GrpID,
            GrpNombre,
            CadenaID,
            CadenaIDClie,
            CadenaNombreClie
          FROM OPENROWSET('Microsoft.ACE.OLEDB.15.0',
          'Excel 12.0 Xml;HDR=YES;IMEX=1;Database=\\perfile01\INFORMACION COMERCIAL - PERU\Maestros\Maestros Clientes\Perú\1.- Distributivo\4.- Key Mark\S-23 Maestro KeyMark.xlsx',
          'SELECT * FROM [Maestro Cadena$]')
          WHERE GrupoID IS NOT NULL
               ) B
ON A.CadenaIDClie=CONVERT(VARCHAR,B.CadenaIDClie) AND A.GrpID=B.GrpID;
/*5.- INKAFARMA*/
UPDATE A
SET A.CadenaID=B.CadenaID,
    A.DescCadena=b.CadenaNombreClie
    FROM PER.MAESTRO_CADENA AS A
    INNER JOIN (
          SELECT
            GrupoID GrpID,
            GrpNombre,
            CadenaID,
            CadenaIDClie,
            CadenaNombreClie
          FROM OPENROWSET('Microsoft.ACE.OLEDB.15.0',
          'Excel 12.0 Xml;HDR=YES;IMEX=1;Database=\\perfile01\INFORMACION COMERCIAL - PERU\Maestros\Maestros Clientes\Perú\2.- Cadena de farmacia\S-23 Maestro Inkafarma.xlsx',
          'SELECT * FROM [Maestro Cadena$]')
          WHERE GrupoID IS NOT NULL
               ) B
ON A.CadenaIDClie=CONVERT(VARCHAR,B.CadenaIDClie) AND A.GrpID=B.GrpID;