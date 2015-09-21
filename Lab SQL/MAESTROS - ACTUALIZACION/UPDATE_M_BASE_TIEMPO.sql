UPDATE TGT
    SET TGT.A�oSemana_GL =SRC.A�oSemana_GL,
      TGT.A�o_GL         =SRC.A�o_GL,
      TGT.Semana_GL      =SRC.Semana_GL,
      TGT.A�o            =SRC.A�o,
      TGT.Mes            =SRC.Mes,
      TGT.Dia_Mes        =SRC.Dia_Mes,
      TGT.Dia_A�o        =SRC.Dia_A�o,
      TGT.Dia_Semana     =SRC.Dia_Semana,
      TGT.[A�o.Mes]      =SRC.[A�o.Mes],
      TGT.Trimestre      =SRC.Trimestre
FROM PER.MAESTRO_TIEMPO tgt
INNER JOIN (
            SELECT
                Fecha,
                A�o,
                Trimestre,
                Mes,
                [A�o.Mes],
                Dia_Mes,
                Dia_A�o,
                Dia_Semana,
                A�oSemana_GL,
                A�o_GL,
                Semana_GL
            FROM OPENROWSET('Microsoft.ACE.OLEDB.15.0',
            'Excel 12.0 Xml;HDR=YES;IMEX=1;Database=\\perfile01\INFORMACION COMERCIAL - PERU\Per�\Maestros\Maestros Base\Maestro Tiempo.xlsx',
            'SELECT * FROM [Tiempo$]')
            WHERE Fecha IS NOT NULL
           ) SRC
ON TGT.Fecha=SRC.Fecha;


