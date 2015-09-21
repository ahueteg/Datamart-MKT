/*1.- QUIMICA SUIZA*/
UPDATE A
SET A.RUC=b.RUC,
    A.PdvNombre=B.PdvNombreClie,
    A.Direccion=B.Direccion,
    A.PdvNombreHomologo=B.PdvNombreHomologo,
    A.StatusPdv=B.StatusPdv,
    A.Tipo=B.Tipo,
    A.CategoriaPdv=B.CategoriaPdv,
    A.Formato=B.Formato,
    A.Denominacion=B.Denominación,
    A.Segmentacion_GL_I=B.[Segmentación GLI I],
    A.Tiendas=CONVERT(INT,B.[# Tiendas]),
    --A.Distrito=B.Distrito,
    --A.Provincia=B.Provincia,
    --A.Departamento=B.Departamento,
    A.UbigeoID=B.UbigeoID
    FROM PER.MAESTRO_PDV A
    INNER JOIN
      (
        SELECT
          GrupoID GrpID,
          GrpNombre,
          PdvID,
          PdvIDClie,
          RUC,
          PdvNombreClie,
          Direccion,
          PdvNombreHomologo,
          StatusPdv,
          Tipo,
          CategoriaPdv,
          Formato,
          Denominación,
          [Segmentación GLI I],
          [Segmentación GLI II],
          [# Tiendas],
          [Target I],
          [Target II],
          UbigeoID
          --Departamento,
          --Provincia,
          --Distrito
        FROM OPENROWSET('Microsoft.ACE.OLEDB.15.0',
        'Excel 12.0 Xml;HDR=YES;IMEX=1;Database=\\perfile01\INFORMACION COMERCIAL - PERU\Perú\Maestros\Maestros Clientes\Dist_Quimica Suiza\S-38 Maestro Quimica Suiza.xlsx',
        'SELECT * FROM [Maestro Pdv$]')
        WHERE GrupoID IS NOT NULL
      )B
ON A.PdvIDClie=B.PdvIDClie AND A.GRPID=B.GrpID;
/*2.- CONTINENTAL*/
UPDATE A
SET A.RUC=b.RUC,
    A.PdvNombre=B.PdvNombreClie,
    A.Direccion=B.Direccion,
    A.PdvNombreHomologo=B.PdvNombreHomologo,
    A.StatusPdv=B.StatusPdv,
    A.Tipo=B.Tipo,
    A.CategoriaPdv=B.CategoriaPdv,
    A.Formato=B.Formato,
    A.Denominacion=B.Denominación,
    A.Segmentacion_GL_I=B.[Segmentación GLI I],
    A.Tiendas=CONVERT(INT,B.[# Tiendas]),
    --A.Distrito=B.Distrito,
    --A.Provincia=B.Provincia,
    --A.Departamento=B.Departamento,
    A.UbigeoID=B.UbigeoID
    FROM PER.MAESTRO_PDV A
    INNER JOIN
      (
        SELECT
          GrupoID GrpID,
          GrpNombre,
          PdvID,
          PdvIDClie,
          RUC,
          PdvNombreClie,
          Direccion,
          PdvNombreHomologo,
          StatusPdv,
          Tipo,
          CategoriaPdv,
          Formato,
          Denominación,
          [Segmentación GLI I],
          [Segmentación GLI II],
          [# Tiendas],
          [Target I],
          [Target II],
          UbigeoID
          --Departamento,
          --Provincia,
          --Distrito
        FROM OPENROWSET('Microsoft.ACE.OLEDB.15.0',
        'Excel 12.0 Xml;HDR=YES;IMEX=1;Database=\\perfile01\INFORMACION COMERCIAL - PERU\Perú\Maestros\Maestros Clientes\Dist_Continental\S-38 Maestro Continental.xlsx',
        'SELECT * FROM [Maestro Pdv$]')
        WHERE GrupoID IS NOT NULL
      )B
ON A.PdvIDClie=B.PdvIDClie AND A.GRPID=B.GrpID;
/*3.- DIGALIMENTA*/
UPDATE A
SET A.RUC=b.RUC,
    A.PdvNombre=B.PdvNombreClie,
    A.Direccion=B.Direccion,
    A.PdvNombreHomologo=B.PdvNombreHomologo,
    A.StatusPdv=B.StatusPdv,
    A.Tipo=B.Tipo,
    A.CategoriaPdv=B.CategoriaPdv,
    A.Formato=B.Formato,
    A.Denominacion=B.Denominación,
    A.Segmentacion_GL_I=B.[Segmentación GLI I],
    A.Tiendas=CONVERT(INT,B.[# Tiendas]),
    --A.Distrito=B.Distrito,
    --A.Provincia=B.Provincia,
    --A.Departamento=B.Departamento,
    A.UbigeoID=B.UbigeoID
    FROM PER.MAESTRO_PDV A
    INNER JOIN
      (
        SELECT
          GrupoID GrpID,
          GrpNombre,
          PdvID,
          PdvIDClie,
          RUC,
          PdvNombreClie,
          Direccion,
          PdvNombreHomologo,
          StatusPdv,
          Tipo,
          CategoriaPdv,
          Formato,
          Denominación,
          [Segmentación GLI I],
          [Segmentación GLI II],
          [# Tiendas],
          [Target I],
          [Target II],
          UbigeoID
          --Departamento,
          --Provincia,
          --Distrito
        FROM OPENROWSET('Microsoft.ACE.OLEDB.15.0',
        'Excel 12.0 Xml;HDR=YES;IMEX=1;Database=\\perfile01\INFORMACION COMERCIAL - PERU\Perú\Maestros\Maestros Clientes\Dist_Digalimenta\S-38 Maestro Digalimenta.xlsx',
        'SELECT * FROM [Maestro Pdv$]')
        WHERE GrupoID IS NOT NULL
      )B
ON A.PdvIDClie=B.PdvIDClie AND A.GRPID=B.GrpID;
/*4.- KEYMARK*/
UPDATE A
SET A.RUC=b.RUC,
    A.PdvNombre=B.PdvNombreClie,
    A.Direccion=B.Direccion,
    A.PdvNombreHomologo=B.PdvNombreHomologo,
    A.StatusPdv=B.StatusPdv,
    A.CategoriaPdv=B.CategoriaPdv,
    A.Tipo=B.Tipo,
    A.Formato=B.Formato,
    A.Denominacion=B.Denominación,
    A.Segmentacion_GL_I=B.[Segmentación GLI I],
    A.Tiendas=CONVERT(INT,B.[# Tiendas]),
    --A.Distrito=B.Distrito,
    --A.Provincia=B.Provincia,
    --A.Departamento=B.Departamento,
    A.UbigeoID=B.UbigeoID
    FROM PER.MAESTRO_PDV A
    INNER JOIN
      (
        SELECT
          GrupoID GrpID,
          GrpNombre,
          PdvID,
          PdvIDClie,
          RUC,
          PdvNombreClie,
          Direccion,
          PdvNombreHomologo,
          StatusPdv,
          Tipo,
          CategoriaPdv,
          Formato,
          Denominación,
          [Segmentación GLI I],
          [Segmentación GLI II],
          [# Tiendas],
          [Target I],
          [Target II],
          UbigeoID
          --Departamento,
          --Provincia,
          --Distrito
        FROM OPENROWSET('Microsoft.ACE.OLEDB.15.0',
        'Excel 12.0 Xml;HDR=YES;IMEX=1;Database=\\perfile01\INFORMACION COMERCIAL - PERU\Perú\Maestros\Maestros Clientes\Dist_KeyMark\S-38 Maestro KeyMark.xlsx',
        'SELECT * FROM [Maestro Pdv$]')
        WHERE GrupoID IS NOT NULL
      )B
ON A.PdvIDClie=B.PdvIDClie AND A.GRPID=B.GrpID;
/*INKAFARMA*/
UPDATE A
SET A.RUC=b.RUC,
    A.PdvNombre=B.PdvNombreClie,
    A.Direccion=B.Direccion,
    A.PdvNombreHomologo=B.PdvNombreHomologo,
    A.StatusPdv=B.StatusPdv,
    A.Tipo=B.Tipo,
    A.CategoriaPdv=B.CategoriaPdv,
    A.Formato=B.Formato,
    A.Denominacion=B.Denominación,
    A.Segmentacion_GL_I=B.[Segmentación GLI I],
    A.Tiendas=CONVERT(INT,B.[# Tiendas]),
    --A.Distrito=B.Distrito,
    --A.Provincia=B.Provincia,
    --A.Departamento=B.Departamento,
    A.UbigeoID=B.UbigeoID
    FROM PER.MAESTRO_PDV A
    INNER JOIN
      (
        SELECT
          GrupoID GrpID,
          GrpNombre,
          PdvID,
          PdvIDClie,
          RUC,
          PdvNombreClie,
          Direccion,
          PdvNombreHomologo,
          StatusPdv,
          Tipo,
          CategoriaPdv,
          Formato,
          Denominación,
          [Segmentación GLI I],
          [Segmentación GLI II],
          [# Tiendas],
          [Target I],
          [Target II],
          UbigeoID
          --Departamento,
          --Provincia,
          --Distrito
        FROM OPENROWSET('Microsoft.ACE.OLEDB.15.0',
        'Excel 12.0 Xml;HDR=YES;IMEX=1;Database=\\perfile01\INFORMACION COMERCIAL - PERU\Perú\Maestros\Maestros Clientes\F&S_Inkafarma\S-38 Maestro Inkafarma.xlsx',
        'SELECT * FROM [Maestro Pdv$]')
        WHERE GrupoID IS NOT NULL
      )B
ON A.PdvID=B.PdvID AND A.GRPID=B.GrpID;
/*ALBIS*/
UPDATE A
SET A.RUC=b.RUC,
    A.PdvNombre=B.PdvNombreClie,
    A.Direccion=B.Direccion,
    A.PdvNombreHomologo=B.PdvNombreHomologo,
    A.StatusPdv=B.StatusPdv,
    A.Tipo=B.Tipo,
    A.CategoriaPdv=B.CategoriaPdv,
    A.Formato=B.Formato,
    A.Denominacion=B.Denominación,
    A.Segmentacion_GL_I=B.[Segmentación GLI I],
    A.Tiendas=CONVERT(INT,B.[# Tiendas]),
    --A.Distrito=B.Distrito,
    --A.Provincia=B.Provincia,
    --A.Departamento=B.Departamento,
    A.UbigeoID=B.UbigeoID
    FROM PER.MAESTRO_PDV A
    INNER JOIN
      (
        SELECT
          GrupoID GrpID,
          GrpNombre,
          PdvID,
          PdvIDClie,
          RUC,
          PdvNombreClie,
          Direccion,
          PdvNombreHomologo,
          StatusPdv,
          Tipo,
          CategoriaPdv,
          Formato,
          Denominación,
          [Segmentación GLI I],
          [Segmentación GLI II],
          [# Tiendas],
          [Fecha de Apertura],
          [Fecha de Cierre],
          [Group Target I],
          [Group Target II],
          UbigeoID

          --Departamento,
          --Provincia,
          --Distrito
        FROM OPENROWSET('Microsoft.ACE.OLEDB.15.0',
        'Excel 12.0 Xml;HDR=YES;IMEX=1;Database=\\perfile01\INFORMACION COMERCIAL - PERU\Perú\Maestros\Maestros Clientes\F&S_Arcangel\S-38 Maestro Arcangel.xlsx',
        'SELECT * FROM [Maestro Pdv$]')
        WHERE GrupoID IS NOT NULL
      )B
ON A.PdvID=B.PdvID AND A.GRPID=B.GrpID;
/*SUPERMERCADOS*/
UPDATE A
SET A.RUC=b.RUC,
    A.PdvNombre=B.PdvNombreClie,
    A.Direccion=B.Direccion,
    A.PdvNombreHomologo=B.PdvNombreHomologo,
    A.StatusPdv=B.StatusPdv,
    A.Tipo=B.Tipo,
    A.CategoriaPdv=B.CategoriaPdv,
    A.Formato=B.Formato,
    A.Denominacion=B.Denominación,
    A.Segmentacion_GL_I=B.[Segmentación GLI I],
    A.Tiendas=CONVERT(INT,B.[# Tiendas]),
    --A.Distrito=B.Distrito,
    --A.Provincia=B.Provincia,
    --A.Departamento=B.Departamento,
    A.UbigeoID=B.UbigeoID,
    A.Cluster=B.Cluster,
    A.[Target I]=B.[Target I],
    A.[Target II]=B.[Target II]
    FROM PER.MAESTRO_PDV A
    INNER JOIN
      (
        SELECT
          GrupoID GrpID,
          GrpNombre,
          PdvID,
          PdvIDClie,
          RUC,
          PdvNombreClie,
          Direccion,
          PdvNombreHomologo,
          Cluster,
          StatusPdv,
          Tipo,
          CategoriaPdv,
          Formato,
          Denominación,
          [Segmentación GLI I],
          [Segmentación GLI II],
          [# Tiendas],
          [Target I],
          [Target II],
          UbigeoID
          --Departamento,
          --Provincia,
          --Distrito
        FROM OPENROWSET('Microsoft.ACE.OLEDB.15.0',
        'Excel 12.0 Xml;HDR=YES;IMEX=1;Database=\\perfile01\INFORMACION COMERCIAL - PERU\Perú\Maestros\Maestros Clientes\F&S_Supesa\S-38 Maestro Supermercados Peruanos.xlsx',
        'SELECT * FROM [Maestro Pdv$]')
        WHERE GrupoID IS NOT NULL
      )B
ON A.PdvID=B.PdvID AND A.GRPID=B.GrpID;
/*CENCOSUD*/
UPDATE A
SET A.RUC=b.RUC,
    A.PdvNombre=B.PdvNombreClie,
    A.Direccion=B.Direccion,
    A.PdvNombreHomologo=B.PdvNombreHomologo,
    A.StatusPdv=B.StatusPdv,
    A.Tipo=B.Tipo,
    A.CategoriaPdv=B.CategoriaPdv,
    A.Formato=B.Formato,
    A.Denominacion=B.Denominación,
    A.Segmentacion_GL_I=B.[Segmentación GLI I],
    A.Tiendas=CONVERT(INT,B.[# Tiendas]),
    A.Distrito=B.Distrito,
    --A.Provincia=B.Provincia,
    --A.Departamento=B.Departamento,
    --A.UbigeoID=B.UbigeoID
    FROM PER.MAESTRO_PDV A
    INNER JOIN
      (
        SELECT
          GrupoID GrpID,
          GrpNombre,
          PdvID,
          PdvIDClie,
          RUC,
          PdvNombreClie,
          Direccion,
          PdvNombreHomologo,
          StatusPdv,
          Tipo,
          CategoriaPdv,
          Formato,
          Denominación,
          [Segmentación GLI I],
          [Segmentación GLI II],
          [# Tiendas],
          [Fecha de Apertura],
          [Fecha de Cierre],
          [Group Target I],
          [Group Target II],
          UbigeoID
          --Departamento,
          --Provincia,
          --Distrito
        FROM OPENROWSET('Microsoft.ACE.OLEDB.15.0',
        'Excel 12.0 Xml;HDR=YES;IMEX=1;Database=\\perfile01\INFORMACION COMERCIAL - PERU\Maestros\Maestros Clientes\Perú\3-  Supermercados\2.- Cencosud\S-25 Maestro Cencosud.xlsx',
        'SELECT * FROM [Maestro Pdv$]')
        WHERE GrupoID IS NOT NULL
      )B
ON A.PdvID=B.PdvID AND A.GRPID=B.GrpID;
/*TOTTUS*/
UPDATE A
SET A.RUC=b.RUC,
    A.PdvNombre=B.PdvNombreClie,
    A.Direccion=B.Direccion,
    A.PdvNombreHomologo=B.PdvNombreHomologo,
    A.StatusPdv=B.StatusPdv,
    A.Tipo=B.Tipo,
    A.CategoriaPdv=B.CategoriaPdv,
    A.Formato=B.Formato,
    A.Denominacion=B.Denominación,
    A.Segmentacion_GL_I=B.[Segmentación GLI I],
    A.Tiendas=CONVERT(INT,B.[# Tiendas]),
    --A.Distrito=B.Distrito,
    --A.Provincia=B.Provincia,
    --A.Departamento=B.Departamento,
    A.UbigeoID=B.UbigeoID
    FROM PER.MAESTRO_PDV A
    INNER JOIN
      (
        SELECT
          GrupoID GrpID,
          GrpNombre,
          PdvID,
          PdvIDClie,
          RUC,
          PdvNombreClie,
          Direccion,
          PdvNombreHomologo,
          StatusPdv,
          Tipo,
          CategoriaPdv,
          Formato,
          Denominación,
          [Segmentación GLI I],
          [Segmentación GLI II],
          [# Tiendas],
          [Fecha de Apertura],
          [Fecha de Cierre],
          [Group Target I],
          [Group Target II],
          UbigeoID,
          --Departamento,
          --Provincia,
          --Distrito
        FROM OPENROWSET('Microsoft.ACE.OLEDB.15.0',
        'Excel 12.0 Xml;HDR=YES;IMEX=1;Database=\\perfile01\INFORMACION COMERCIAL - PERU\Maestros\Maestros Clientes\Perú\3-  Supermercados\3.- Tottus\S-25 Maestro Tottus.xlsx',
        'SELECT * FROM [Maestro Pdv$]')
        WHERE GrupoID IS NOT NULL
      )B
ON A.PdvID=B.PdvID AND A.GRPID=B.GrpID;