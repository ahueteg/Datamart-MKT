/*1.- QUIMICA SUIZA*/
UPDATE A
SET
  A.DescVendedor=B.[Nombres y Apellidos],
  A.SupervisorNombreClie=B.SupervisorNombreClie,
  A.Tipo=B.Tipo,
  A.Mesa=B.Mesa,
  A.Telefono_1=B.[Teléfono 1],
  A.Telefono_2=B.[Teléfono 2],
  A.Telefono_3=B.[Teléfono 3],
  A.[E-mail]=B.[E-mail]
    FROM PER.MAESTRO_VENDEDOR AS A
    INNER JOIN (
                SELECT *
                  FROM OPENROWSET('Microsoft.ACE.OLEDB.15.0',
                         'Excel 12.0 Xml;HDR=YES;IMEX=1;Database=\\perfile01\INFORMACION COMERCIAL - PERU\Perú\Maestros\Maestros Clientes\Dist_Quimica Suiza\S-38 Maestro Quimica Suiza.xlsx',
                         'SELECT * FROM [Maestro Vendedor$]')
               ) B
ON A.VendedorIDClie=B.VendedorIDClie AND A.GrpID=B.GrupoID;
/*2.- CONTINENTAL*/
UPDATE A
SET


  A.DescVendedor=B.[Nombres y Apellidos],
  A.SupervisorNombreClie=B.SupervisorNombreClie,
  A.Tipo=B.Tipo,
  A.Mesa=B.Mesa,
  A.Telefono_1=B.[Teléfono 1],
  A.Telefono_2=B.[Teléfono 2],
  A.Telefono_3=B.[Teléfono 3],
  A.[E-mail]=B.[E-mail]
    FROM PER.MAESTRO_VENDEDOR AS A
    INNER JOIN (
                SELECT *
                  FROM OPENROWSET('Microsoft.ACE.OLEDB.15.0',
                         'Excel 12.0 Xml;HDR=YES;IMEX=1;Database=\\perfile01\INFORMACION COMERCIAL - PERU\Perú\Maestros\Maestros Clientes\Dist_Continental\S-38 Maestro Continental.xlsx',
                         'SELECT * FROM [Maestro Vendedor$]')
               ) B
ON A.VendedorIDClie=cast(B.VendedorIDClie as VARCHAR(7)) AND A.GrpID=B.GrupoID;
/*3.- DIGALIMENTA*/
UPDATE A
SET
  A.DescVendedor=B.[Nombres y Apellidos],
  A.SupervisorNombreClie=B.SupervisorNombreClie,
  A.Tipo=B.Tipo,
  A.Mesa=B.Mesa,
  A.Telefono_1=B.[Teléfono 1],
  A.Telefono_2=B.[Teléfono 2],
  A.Telefono_3=B.[Teléfono 3],
  A.[E-mail]=B.[E-mail]
    FROM PER.MAESTRO_VENDEDOR AS A
    INNER JOIN (
                SELECT *
                  FROM OPENROWSET('Microsoft.ACE.OLEDB.15.0',
                         'Excel 12.0 Xml;HDR=YES;IMEX=1;Database=\\perfile01\INFORMACION COMERCIAL - PERU\Perú\Maestros\Maestros Clientes\Dist_Digalimenta\S-38 Maestro Digalimenta.xlsx',
                         'SELECT * FROM [Maestro Vendedor$]')
               ) B
ON A.VendedorIDClie=cast(B.VendedorIDClie as VARCHAR(7)) AND A.GrpID=B.GrupoID;
/*4.- KEYMARK*/
UPDATE A
SET
  A.DescVendedor=B.[Nombres y Apellidos],
  A.SupervisorNombreClie=B.SupervisorNombreClie,
  A.Tipo=B.Tipo,
  A.Mesa=B.Mesa,
  A.Telefono_1=B.[Teléfono 1],
  A.Telefono_2=B.[Teléfono 2],
  A.Telefono_3=B.[Teléfono 3],
  A.[E-mail]=B.[E-mail]
    FROM PER.MAESTRO_VENDEDOR AS A
    INNER JOIN (
                SELECT *
                  FROM OPENROWSET('Microsoft.ACE.OLEDB.15.0',
                         'Excel 12.0 Xml;HDR=YES;IMEX=1;Database=\\perfile01\INFORMACION COMERCIAL - PERU\Perú\Maestros\Maestros Clientes\Dist_Keymark\S-38 Maestro KeyMark.xlsx',
                         'SELECT * FROM [Maestro Vendedor$]')
               ) B
ON A.VendedorIDClie=cast(B.VendedorIDClie as VARCHAR(7)) AND A.GrpID=B.GrupoID;