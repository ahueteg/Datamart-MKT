UPDATE TGT
    SET TGT.PrecioLista=SRC.[PL (Sin IGV)],
      TGT.PVP=SRC.[PVP (Sin IGV)]
FROM PER.MAESTRO_PRODUCTO_PRECIO tgt
INNER JOIN (
            SELECT
                Año,
                Semana,
                GrupoID GrpID,
                GrpNombre,
                ProPstID,
                ProPstNombre,
                [PL (Sin IGV)],
                [PVP (Sin IGV)]
              FROM OPENROWSET('Microsoft.ACE.OLEDB.15.0',
                 'Excel 12.0 Xml;HDR=YES;IMEX=1;Database=\\perfile01\INFORMACION COMERCIAL - PERU\Maestros\Maestros Base\Maestro Precios\S-27 Maestro Precios.xlsx',
                 'SELECT * FROM [Maestro de Precios$]')
              WHERE grupoid IS NOT NULL
           ) SRC
  ON TGT.ProPstID=SRC.ProPstID AND TGT.GrpID=SRC.GrpID AND TGT.AñoSemana_GL=CONVERT(VARCHAR,SRC.Año*100+SRC.Semana)
