UPDATE PER.MAESTRO_PDV
SET CategoriaPdv='E(0%)';

UPDATE A
SET A.CategoriaPdv=b.CATEGORIA
    FROM PER.MAESTRO_PDV A
    INNER JOIN (
				SELECT A.GrpID,A.PdvIDClie,A.MontoDespCliente,A.SUMACUM,
				CASE WHEN SUMACUM<=0.5  THEN 'A(50%)'
				WHEN SUMACUM<=0.8  THEN 'B(30%)'
				WHEN SUMACUM<=0.95  THEN 'C(15%)'
				ELSE 'D(5%)' END CATEGORIA
				--INTO MKT.PDV_IK_CAT
				FROM
				(
				  SELECT A.GrpID,A.PdvIDClie,MontoDespCliente,SUM(MontoDespCliente) OVER
            (PARTITION BY GrpID ORDER BY MontoDespCliente DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)/SUM(MontoDespCliente) OVER (PARTITION BY GrpID) SUMACUM FROM
            (
              SELECT
                GrpID,
                PdvIDClie,
                sum(MontoDespCliente) MontoDespCliente
              FROM per.GLP_SELLOUT
              WHERE substring(fecha, 1, 4) = 2015
              GROUP BY GrpID,PdvIDClie
            ) A
          WHERE MontoDespCliente>0
				) A
	) B
ON A.PdvIDClie=B.PdvIDClie AND A.GrpID=B.GrpID;