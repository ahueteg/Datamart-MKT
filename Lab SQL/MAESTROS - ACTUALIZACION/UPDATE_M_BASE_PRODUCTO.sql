MERGE INTO PER.MAESTRO_PRODUCTO_PRESENTACION AS TGT
  USING (
      SELECT
          ProPstID,
          ProPstCodBarras,
          ProPstCodigoAtlas,
          ProPstNombre,
          ProNombre,
          AgrProNombre,
          LinNombre,
          MrcNombre,
          [Segmentación GL],
          Rubro,
          StatusProd,
          StatusLanzamiento,
          [Master Pack]
        FROM OPENROWSET('Microsoft.ACE.OLEDB.15.0',
     'Excel 12.0 Xml;HDR=YES;IMEX=1;Database=\\perfile01\INFORMACION COMERCIAL - PERU\Perú\Maestros\Maestros Base\Maestro Producto.xlsx',
     'SELECT * FROM [Producto$]')
      WHERE Propstid IS NOT NULL
  ) AS SRC
  ON TGT.ProPstID=SRC.ProPstID
WHEN MATCHED THEN UPDATE
SET TGT.ProPstCodBarras=CONVERT(VARCHAR,CONVERT(BIGINT,SRC.ProPstCodBarras)),
    TGT.ProPstCodigoAtlas=SRC.ProPstCodigoAtlas,
    TGT.ProPstNombre=SRC.ProPstNombre,
    TGT.SegmentacionGL=SRC.[Segmentación GL],
    TGT.Rubro=SRC.Rubro,
    TGT.StatusProd=SRC.StatusProd,
    TGT.StatusLanzamiento=SRC.StatusLanzamiento,
    TGT.[Master Pack]=SRC.[Master Pack]
WHEN NOT MATCHED THEN INSERT
VALUES(
  SRC.ProPstID,
  SRC.ProPstCodBarras,
  SRC.ProPstCodigoAtlas,
  SRC.ProPstNombre,
    '0000',
    '0000',
    '000',
    '000',
  SRC.[Segmentación GL],
  SRC.Rubro,
  SRC.StatusProd,
  SRC.StatusLanzamiento,
  SRC.[Master Pack]
  );
