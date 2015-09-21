UPDATE TGT
    SET TGT.Departamento=SRC.Departamento,
      TGT.Provincia=SRC.Provincia,
      TGT.Distrito=SRC.Distrito,
      TGT.Pais=SRC.Pañs,
      TGT.Region_I=SRC.[Regiñn I],
      TGT.Region_II=SRC.[Regiñn II],
      TGT.Region_III=SRC.[Regiñn III],
      TGT.Zona_I=SRC.[Zona I],
      TGT.Zona_II=SRC.[Zona II]
FROM PER.MAESTRO_UBIGEO tgt
INNER JOIN (
            SELECT
              UbigeoID,
              Pañs,
              Departamento,
              Provincia,
              Distrito,
              [Regiñn I],
              [Regiñn II],
              [Regiñn III],
              [Zona I],
              [Zona II]
            FROM OPENROWSET('Microsoft.ACE.OLEDB.15.0',
            'Excel 12.0 Xml;HDR=YES;IMEX=1;Database=\\perfile01\INFORMACION COMERCIAL - PERU\Maestros\Maestros Base\Maestro Geografia.xlsx',
            'SELECT * FROM [Maestro Geografia$]')
            WHERE ubigeoid IS NOT NULL
           ) SRC
ON TGT.UbigeoID=SRC.UbigeoID;


