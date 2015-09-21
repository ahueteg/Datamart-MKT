SELECT A.PdvIDClie,MontoDespCliente,SUMACUM,
CASE WHEN SUMACUM<=0.5  THEN 'A(50%)'
WHEN SUMACUM<=0.8  THEN 'B(30%)'
WHEN SUMACUM<=0.95  THEN 'C(15%)'
ELSE 'D(5%)' END CATEGORIA 
--INTO MKT.PDV_IK_CAT
FROM 
(
SELECT A.PdvIDClie,MontoDespCliente,SUM(MontoDespCliente) OVER (ORDER BY MontoDespCliente DESC
  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)/SUM(MontoDespCliente) OVER () SUMACUM FROM
  (
    SELECT
      PdvIDClie,
      sum(MontoDespCliente) MontoDespCliente
    FROM per.GLP_SELLOUT
    WHERE GrpID = '338' AND substring(fecha, 1, 4) = 2015
    GROUP BY PdvIDClie
  ) A
) A
union all
SELECT
      PdvIDClie,
      sum(MontoDespCliente) MontoDespCliente,null,'E'
    FROM per.GLP_SELLOUT
    WHERE GrpID = '338' AND substring(fecha, 1, 4) <> 2015
    GROUP BY PdvIDClie





SELECT PdvID,PdvIDClie,CategoriaPdv FROM PER.MAESTRO_PDV
WHERE GrpID='337'

SELECT
  B.GrpID,
  B.PdvID,
  B.PdvIDClie,
  B.RUC,
  B.PdvNombre,
  B.Direccion,
  B.Departamento,
  B.Provincia,
  B.Distrito,
  B.CategoriaPdv
FROM per.MAESTRO_PDV B
WHERE PdvIDClie <> PdvNombre
      AND GrpID = '337'
UNION ALL
SELECT
DISTINCT
A.GrpID,
A.PdvID,
B.COD_CLIENTE,
B.DOC_IDENTIDAD,
B.NOM_CLIENTE,
B.DIRECCION,
B.DEPARTAMENTO,
B.PROVINCIA,
B.DISTRITO,
A.CategoriaPdv
FROM
(
SELECT *
FROM per.MAESTRO_PDV
WHERE PdvIDClie = PdvNombre
      AND GrpID = '337'
) A LEFT JOIN mkt.SELLOUT_DIGA_HISTW B
  ON A.PdvIDClie=CONVERT(VARCHAR,CONVERT(BIGINT,B.COD_CLIENTE));





SELECT
  B.GrpID,
  B.PdvID,
  B.PdvIDClie,
  B.RUC,
  B.PdvNombre,
  B.Direccion,
  B.Departamento,
  B.Provincia,
  B.Distrito,
  B.CategoriaPdv
FROM per.MAESTRO_PDV B
WHERE PdvIDClie <> PdvNombre
      AND GrpID = '327'
UNION ALL
SELECT
DISTINCT
A.GrpID,
A.PdvID,
B.CODIGO,
B.R_U_C_,
B.NOMB_CLTE,
B.DIRECCION,
B.NOMB_DEPT,
B.NOMB_PROV,
B.NOMB_DIST,
A.CategoriaPdv
FROM
(
SELECT *
FROM per.MAESTRO_PDV
WHERE PdvIDClie = PdvNombre
      AND GrpID = '327'
) A LEFT JOIN mkt.SELLOUT_CONTI_HISTW B
  ON A.PdvIDClie=CONVERT(VARCHAR,CONVERT(BIGINT,B.CODIGO));


  SELECT * FROM  mkt.SELLOUT_CONTI_HISTW



  SELECT PdvID,PdvIDClie,CategoriaPdv FROM PER.MAESTRO_PDV
WHERE GrpID='338'