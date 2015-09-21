UPDATE TGT
    SET TGT.AñoSemana_GL =SRC.AñoSemana_GL,
      TGT.Año_GL         =SRC.Año_GL,
      TGT.Semana_GL      =SRC.Semana_GL,
      TGT.Año            =SRC.Año,
      TGT.Mes            =SRC.Mes,
      TGT.Dia_Mes        =SRC.Dia_Mes,
      TGT.Dia_Año        =SRC.Dia_Año,
      TGT.Dia_Semana     =SRC.Dia_Semana,
      TGT.[Año.Mes]      =SRC.[Año.Mes],
      TGT.Trimestre      =SRC.Trimestre
FROM PER.MAESTRO_TIEMPO tgt
INNER JOIN (
            SELECT
                Fecha,
                Año,
                Trimestre,
                Mes,
                [Año.Mes],
                Dia_Mes,
                Dia_Año,
                Dia_Semana,
                AñoSemana_GL,
                Año_GL,
                Semana_GL
            FROM OPENROWSET('Microsoft.ACE.OLEDB.15.0',
            'Excel 12.0 Xml;HDR=YES;IMEX=1;Database=\\perfile01\INFORMACION COMERCIAL - PERU\Perú\Maestros\Maestros Base\Maestro Tiempo.xlsx',
            'SELECT * FROM [Tiempo$]')
            WHERE Fecha IS NOT NULL
           ) SRC
ON TGT.Fecha=SRC.Fecha;


