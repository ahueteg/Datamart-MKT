SELECT
  A.Periodo,
  A.VendedorIDClie,
  B.DescVendedor,
  A.cobertura
FROM
  (
    SELECT
      A.Periodo,
      A.VendedorIDClie,
      COUNT(1) cobertura
    FROM
      (
        SELECT
          substring(Fecha, 1, 6) Periodo,
          VendedorIDClie,
          PdvIDClie,
          sum(UnidDesp)          unid,
          sum(MontoDespCliente)  monto
        FROM per.GLP_SELLOUT
        WHERE GrpID = '338' and fecha>='20150801'
        GROUP BY substring(Fecha, 1, 6), VendedorIDClie, PdvIDClie
      ) A
    WHERE monto > 0
    GROUP BY A.Periodo, A.VendedorIDClie
    ) A
LEFT JOIN PER.MAESTRO_VENDEDOR B
  ON A.VendedorIDClie=B.VendedorIDClie
ORDER BY 1,4 DESC


SELECT
  A.Periodo,
  A.VendedorIDClie,
  B.DescVendedor,
  A.cobertura
FROM
  (
    SELECT
      A.Periodo,
      A.VendedorIDClie,
      COUNT(1) cobertura
    FROM
      (
        SELECT
          substring(Fecha, 1, 6) Periodo,
          VendedorIDClie,
          PdvIDClie,
          sum(UnidDesp)          unid,
          sum(MontoDespCliente)  monto
        FROM per.GLP_SELLOUT
        WHERE GrpID = '337' and fecha>='20150501'
        GROUP BY substring(Fecha, 1, 6), VendedorIDClie, PdvIDClie
      ) A
    WHERE monto > 0
    GROUP BY A.Periodo, A.VendedorIDClie
    ) A
LEFT JOIN PER.MAESTRO_VENDEDOR B
  ON A.VendedorIDClie=B.VendedorIDClie
ORDER BY 1,4 DESC