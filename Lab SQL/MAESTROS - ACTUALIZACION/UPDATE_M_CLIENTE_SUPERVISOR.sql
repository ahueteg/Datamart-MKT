/*1.- QUIMICA SUIZA*/
UPDATE A
SET
  A.DescSupervisor=B.[Nombres y Apellidos],
  A.Tipo=B.Tipo,
  A.Mesa=B.Mesa,
  A.Telefono_1=B.[Telñfono 1],
  A.Telefono_2=B.[Telñfono 2],
  A.Telefono_3=B.[Telñfono 3],
  A.[E-mail]=B.[E-mail]
    FROM PER.MAESTRO_SUPERVISOR AS A
    INNER JOIN (
                SELECT *
                  FROM OPENROWSET('Microsoft.ACE.OLEDB.15.0',
                         'Excel 12.0 Xml;HDR=YES;IMEX=1;Database=\\perfile01\INFORMACION COMERCIAL - PERU\Maestros\Maestros Clientes\Perú\1.- Distributivo\1.- Quimica Suiza\S-33 Maestro Quimica Suiza.xlsx',
                         'SELECT * FROM [Maestro Supervisor$]')
               ) B
ON A.SupervisorIDClie=B.SupervisorIDClie AND A.GrpID=B.GrupoID;
/*2.- CONTINENTAL*/
UPDATE A
SET
  A.DescSupervisor=B.[Nombres y Apellidos],
  A.Tipo=B.Tipo,
  A.Mesa=B.Mesa,
  A.Telefono_1=B.[Telñfono 1],
  A.Telefono_2=B.[Telñfono 2],
  A.Telefono_3=B.[Telñfono 3],
  A.[E-mail]=B.[E-mail]
    FROM PER.MAESTRO_SUPERVISOR AS A
    INNER JOIN (
                SELECT *
                  FROM OPENROWSET('Microsoft.ACE.OLEDB.15.0',
                         'Excel 12.0 Xml;HDR=YES;IMEX=1;Database=\\perfile01\INFORMACION COMERCIAL - PERU\Maestros\Maestros Clientes\Perú\1.- Distributivo\2.- Distribuidora Continental\S-33 Maestro Continental.xlsx',
                         'SELECT * FROM [Maestro Supervisor$]')
               ) B
ON A.SupervisorIDClie=cast(B.SupervisorIDClie as VARCHAR(8)) AND A.GrpID=B.GrupoID;

/*3.- DIGALIMENTA*/
UPDATE A
SET
  A.DescSupervisor=B.[Nombres y Apellidos],
  A.Tipo=B.Tipo,
  A.Mesa=B.Mesa,
  A.Telefono_1=B.[Telñfono 1],
  A.Telefono_2=B.[Telñfono 2],
  A.Telefono_3=B.[Telñfono 3],
  A.[E-mail]=B.[E-mail]
    FROM PER.MAESTRO_SUPERVISOR AS A
    INNER JOIN (
                SELECT *
                  FROM OPENROWSET('Microsoft.ACE.OLEDB.15.0',
                         'Excel 12.0 Xml;HDR=YES;IMEX=1;Database=\\perfile01\INFORMACION COMERCIAL - PERU\Maestros\Maestros Clientes\Perú\1.- Distributivo\3.- Digalimenta\S-33 Maestro Digalimenta.xlsx',
                         'SELECT * FROM [Maestro Supervisor$]')
               ) B
ON A.SupervisorIDClie=cast(B.SupervisorIDClie as VARCHAR(8)) AND A.GrpID=B.GrupoID;
/*3.- KEYMARK*/
UPDATE A
SET
  A.DescSupervisor=B.[Nombres y Apellidos],
  A.Tipo=B.Tipo,
  A.Mesa=B.Mesa,
  A.Telefono_1=B.[Telñfono 1],
  A.Telefono_2=B.[Telñfono 2],
  A.Telefono_3=B.[Telñfono 3],
  A.[E-mail]=B.[E-mail]
    FROM PER.MAESTRO_SUPERVISOR AS A
    INNER JOIN (
                SELECT *
                  FROM OPENROWSET('Microsoft.ACE.OLEDB.15.0',
                         'Excel 12.0 Xml;HDR=YES;IMEX=1;Database=\\perfile01\INFORMACION COMERCIAL - PERU\Maestros\Maestros Clientes\Perú\1.- Distributivo\4.- Key Mark\S-33 Maestro KeyMark.xlsx',
                         'SELECT * FROM [Maestro Supervisor$]')
               ) B
ON A.SupervisorIDClie=cast(CONVERT(BIGINT,B.SupervisorIDClie) as VARCHAR(8)) AND A.GrpID=B.GrupoID;