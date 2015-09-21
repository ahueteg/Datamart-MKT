/* CADA INICIO DE SEMANA*/

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
                 'Excel 12.0 Xml;HDR=YES;IMEX=1;Database=\\perfile01\INFORMACION COMERCIAL - PERU\Maestros\Maestros Base\Perú\Maestro Precios\S-31 Maestro Precios.xlsx',
                 'SELECT * FROM [Maestro de Precios$]')
              WHERE grupoid IS NOT NULL
           ) SRC
  ON TGT.ProPstID=SRC.ProPstID AND TGT.GrpID=SRC.GrpID AND TGT.AñoSemana_GL=CONVERT(VARCHAR,SRC.Año*100+SRC.Semana)


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
                 'Excel 12.0 Xml;HDR=YES;IMEX=1;Database=\\perfile01\INFORMACION COMERCIAL - PERU\Perú\Maestros\Maestros Base\Maestro Precios.xlsx',
                 'SELECT * FROM [Maestro de Precios$]')
              WHERE grupoid IS NOT NULL
           ) SRC
  ON TGT.ProPstID=SRC.ProPstID AND TGT.GrpID=SRC.GrpID AND TGT.AñoSemana_GL=CONVERT(VARCHAR,SRC.Año*100+SRC.Semana)


insert into per.MAESTRO_PRODUCTO_PRECIO
(PrecioID, GrpID, ProPstID, AñoSemana_GL, PrecioLista)
SELECT
NEXT VALUE FOR [per].[seq_precioid] OVER(ORDER BY A.GrpID,A.ProPstID,A.AñoSemana_GL),
A.GrpID,
A.ProPstID,
A.AñoSemana_GL,
0 PrecioLista
	FROM (
SELECT A.GrpID, A.ProPstID, A.AñoSemana_GL, 'SELLOUT' TAG
FROM (
SELECT A.GrpID, B.ProPstID, C.AñoSemana_GL, SUM(A.UnidDesp) UnidDesp
FROM PER.GLP_SELLOUT A
LEFT JOIN per.MAESTRO_PRODUCTO_FUENTE B
ON A.ProIDClie=B.ProIDClie AND A.GrpID=B.GrpID
LEFT JOIN per.MAESTRO_TIEMPO C
ON A.Fecha=C.Fecha
WHERE A.ProIDClie IS NOT NULL AND A.GrpID<>'313'
GROUP BY A.GrpID, B.ProPstID, C.AñoSemana_GL
) A
LEFT JOIN (SELECT * FROM per.MAESTRO_PRODUCTO_PRECIO) B
ON A.GrpID=B.GrpID AND A.ProPstID=B.ProPstID AND A.AñoSemana_GL=B.AñoSemana_GL
WHERE B.PrecioLista IS NULL
UNION ALL
SELECT A.GrpID, A.ProPstID, A.AñoSemana_GL, 'STOCK' TAG
FROM (
SELECT A.GrpID, B.ProPstID, C.AñoSemana_GL, SUM(COALESCE(A.UnidExist, 0)+ COALESCE(A.UnidCedis, 0)+ COALESCE(A.UnidTrans, 0)) UnidStock
FROM PER.GLP_STOCK A
LEFT JOIN per.MAESTRO_PRODUCTO_FUENTE B
ON A.ProIDClie=B.ProIDClie AND A.GrpID=B.GrpID
LEFT JOIN per.MAESTRO_TIEMPO C
ON A.Fecha=C.Fecha
WHERE A.ProIDClie IS NOT NULL AND A.GrpID<>'313'
GROUP BY A.GrpID, B.ProPstID, C.AñoSemana_GL
) A
LEFT JOIN (SELECT * FROM per.MAESTRO_PRODUCTO_PRECIO) B
ON A.GrpID=B.GrpID AND A.ProPstID=B.ProPstID AND A.AñoSemana_GL=B.AñoSemana_GL
WHERE B.PrecioLista IS NULL
) A;

SELECT A.GrpID, A.ProPstID, A.AñoSemana_GL,'SELLOUT' TAG,UnidDesp Unid
	FROM (
		SELECT A.GrpID, B.ProPstID, C.AñoSemana_GL,SUM(A.UnidDesp) UnidDesp
			FROM PER.GLP_SELLOUT A
			LEFT JOIN per.MAESTRO_PRODUCTO_FUENTE B
				ON A.ProIDClie=B.ProIDClie AND A.GrpID=B.GrpID
			LEFT JOIN per.MAESTRO_TIEMPO C
				ON A.Fecha=C.Fecha
		WHERE A.ProIDClie IS NOT NULL AND A.GrpID<>'313'
		GROUP BY A.GrpID, B.ProPstID, C.AñoSemana_GL
	) A
	LEFT JOIN (SELECT * FROM per.MAESTRO_PRODUCTO_PRECIO WHERE PrecioLista>0) B
		ON A.GrpID=B.GrpID  AND A.ProPstID=B.ProPstID AND A.AñoSemana_GL=B.AñoSemana_GL
WHERE B.PrecioLista IS NULL and UnidDesp<>0
UNION ALL
SELECT A.GrpID, A.ProPstID, A.AñoSemana_GL,'STOCK' TAG,UnidStock Unid
	FROM (
		SELECT A.GrpID, B.ProPstID, C.AñoSemana_GL,SUM(COALESCE(A.UnidExist,0)+COALESCE(A.UnidCedis,0)+COALESCE(A.UnidTrans,0)) UnidStock
			FROM PER.GLP_STOCK A
			LEFT JOIN per.MAESTRO_PRODUCTO_FUENTE B
				ON A.ProIDClie=B.ProIDClie AND A.GrpID=B.GrpID
			LEFT JOIN per.MAESTRO_TIEMPO C
				ON A.Fecha=C.Fecha
		WHERE A.ProIDClie IS NOT NULL AND A.GrpID<>'313'
		GROUP BY A.GrpID, B.ProPstID, C.AñoSemana_GL
	) A
	LEFT JOIN (SELECT * FROM per.MAESTRO_PRODUCTO_PRECIO WHERE PrecioLista>0) B
		ON A.GrpID=B.GrpID  AND A.ProPstID=B.ProPstID AND A.AñoSemana_GL=B.AñoSemana_GL
WHERE B.PrecioLista IS NULL and UnidStock<>0;
