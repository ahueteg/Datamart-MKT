SELECT B.GrpID,C.GrpNombre,A.VBRP_CHARG LOTE,B.PdvIDClie,A.CANTIDAD,A.NETO,B.PdvNombre,B.Direccion,B.Distrito,B.Departamento,B.Provincia FROM
  (
    SELECT
      VBRP_CHARG,
      VBRK_KUNAG,
      SUM(VBRP_FKIMG) CANTIDAD,
      SUM(ZVALNETO_SF_QS) NETO
    FROM mkt.SELLOUT_QS_HISTW
    WHERE VBRP_CHARG
          IN ('CA438',
              'CB354',
              'K4L74PN'
          )
    GROUP BY
      VBRP_CHARG,
      VBRK_KUNAG
  ) A
LEFT JOIN PER.MAESTRO_PDV B
  ON CONVERT(VARCHAR,CONVERT(BIGINT,A.VBRK_KUNAG))=B.PdvIDClie AND B.GrpID='307'
LEFT JOIN PER.MAESTRO_CLIENTE C
    ON B.GrpID=C.GrpID
UNION ALL
SELECT B.GrpID,C.GrpNombre,A.LOTE_PRV LOTE,B.PdvIDClie,A.CANTIDAD,A.NETO,B.PdvNombre,B.Direccion,B.Distrito,B.Departamento,B.Provincia FROM
  (
    SELECT
      LOTE_PRV,
      CODIGO,
      SUM(CANTIDAD) CANTIDAD,
      SUM(NETO) NETO
    FROM mkt.SELLOUT_CONTI_HISTW
    WHERE LOTE_PRV
          IN ('CA438',
              'CB354',
              'K4L74PN'
          )
    GROUP BY LOTE_PRV,
      CODIGO
  ) A
LEFT JOIN PER.MAESTRO_PDV B
  ON CONVERT(VARCHAR,CONVERT(BIGINT,A.CODIGO))=B.PdvIDClie AND B.GrpID='327'
LEFT JOIN PER.MAESTRO_CLIENTE C
    ON B.GrpID=C.GrpID


/*nikzon*/
SELECT
  A.PdvIdClie,
  CONVERT(DATE,substring(A.[Fecha],7,2)+'/'+SUBSTRING(A.[Fecha],5,2)+'/'+SUBSTRING(A.[Fecha],1,4),103) [Fecha],
  B.Direccion,
  C.Distrito,
  C.Provincia,
  A.UnidDesp
  UnidDesp
FROM (
  SELECT
    cast(COALESCE(CONVERT(VARCHAR, TRY_CONVERT(BIGINT, A.VBRK_KUNAG)), A.VBRK_KUNAG) AS VARCHAR(11)) PdvIdClie,
    cast(A.VBRK_FKDAT AS VARCHAR(8))                                                                 [Fecha],
    UnidDesp
  FROM (
         SELECT
           VBRK_KUNAG,
           VBRK_FKDAT,
           sum(VBRP_FKIMG) UnidDesp
         FROM mkt.SELLOUT_QS_HISTW
         WHERE VBRP_CHARG = 'VAM0303015'
         GROUP BY VBRK_KUNAG, VBRK_FKDAT
       ) A
) A LEFT JOIN PER.MAESTRO_PDV B
  ON A.PdvIdClie=B.PdvIDClie AND B.GrpID='307'
LEFT JOIN PER.MAESTRO_UBIGEO C
  ON B.UbigeoID=C.UbigeoID

SELECT
  A.PdvIdClie,
  CONVERT(DATE,substring(A.[Fecha],7,2)+'/'+SUBSTRING(A.[Fecha],5,2)+'/'+SUBSTRING(A.[Fecha],1,4),103) [Fecha],
  B.Direccion,
  C.Distrito,
  C.Provincia,
  A.UnidDesp
  UnidDesp
FROM (
  SELECT
    cast(COALESCE(CONVERT(VARCHAR, TRY_CONVERT(BIGINT, A.VBRK_KUNAG)), A.VBRK_KUNAG) AS VARCHAR(11)) PdvIdClie,
    cast(A.VBRK_FKDAT AS VARCHAR(8))                                                                 [Fecha],
    UnidDesp
  FROM (
         SELECT
           CODIGO,
           Fecha,
           sum(CANTIDAD) UnidDesp
         FROM mkt.SELLOUT_CONTI_HISTW
         WHERE LOTE_PRV  LIKE  '%VAM0303015%'
         GROUP BY CODIGO, Fecha
       ) A
) A LEFT JOIN PER.MAESTRO_PDV B
  ON A.PdvIdClie=B.PdvIDClie AND B.GrpID='307'
LEFT JOIN PER.MAESTRO_UBIGEO C
  ON B.UbigeoID=C.UbigeoID