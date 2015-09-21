
SELECT
  Fecha,
  GrpID,
  CadenaIDClie,
  ProIDClie,
  PdvIDClie,
  UnidDesp,
  UnidExist,
  UnidCedis,
  UnidTrans,
  MontoDespCliente,
  CASE WHEN numero=1 THEN A�oSemana_GL ELSE NULL END F_A�oSemama
FROM
  (
    SELECT
      B.Fecha,
      B.GrpID,
      B.CadenaIDClie,
      B.ProIDClie,
      B.PdvIDClie,
      A.UnidDesp,
      B.UnidExist,
      B.UnidCedis,
      B.UnidTrans,
      A.MontoDespCliente,
      T.A�oSemana_GL,
      T.Dia_Semana,
      DENSE_RANK()
      OVER (PARTITION BY T.A�oSemana_GL
        ORDER BY T.Dia_Semana DESC) numero
    FROM PER.GLP_STOCK B
      LEFT JOIN
      (
        SELECT *
        FROM
          PER.GLP_SELLOUT
        WHERE 1 = 2) A
        ON A.ProIDClie = B.ProIDClie
      LEFT JOIN per.MAESTRO_TIEMPO T
        ON B.Fecha = T.Fecha
    WHERE B.GrpID = '309'
  ) A

SELECT COUNT(1)  FROM PER.GLP_STOCK
WHERE GrpID='309' AND Fecha='20140529'


SELECT DISTINCT A�oSemana_GL FROM PER.MAESTRO_TIEMPO A
WHERE FECHA>=(SELECT * FROM vw.fn_primer_dia_inv('309')) and
    FECHA<=(SELECT * FROM vw.fn_ultimo_dia_inv('309'))

