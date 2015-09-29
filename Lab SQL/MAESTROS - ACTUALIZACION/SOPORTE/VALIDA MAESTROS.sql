/*VALIDA MAETROS*/
SELECT * FROM per.MAESTRO_PRODUCTO_FUENTE
WHERE GrpID+'-'+ProIDClie IN (
SELECT GrpID+'-'+ProIDClie FROM per.MAESTRO_PRODUCTO_FUENTE GROUP BY GrpID+'-'+ProIDClie HAVING COUNT(1) >1
)
ORDER BY 2,3


SELECT DISTINCT B.*
            FROM
              (
                SELECT DISTINCT GrpID,ProIDClie
                FROM per.GLP_SELLOUT
                --WHERE GrpID IN ('308','309','311')--,'312','328')
                UNION ALL
                SELECT DISTINCT GrpID,ProIDClie
                FROM per.GLP_STOCK
                --WHERE GrpID IN ('308','309','311')--,'312','328')
              ) A
RIGHT JOIN PER.MAESTRO_PRODUCTO_FUENTE B
              ON A.GrpID=B.GrpID AND A.ProIDClie=B.ProIDClie
WHERE A.ProIDClie IS NULL

DELETE FROM A
FROM PER.MAESTRO_PRODUCTO_FUENTE AS A
LEFT JOIN (
                      SELECT DISTINCT GrpID,ProIDClie
                FROM per.GLP_SELLOUT
                --WHERE GrpID IN ('308','309','311')--,'312','328')
                UNION ALL
                SELECT DISTINCT GrpID,ProIDClie
                FROM per.GLP_STOCK
    ) B
  ON A.GrpID=B.GrpID AND A.ProIDClie=B.ProIDClie
WHERE B.ProIDClie IS NULL;




    SELECT DISTINCT A.GrpID,A.PdvIDClie
            FROM
              (
                SELECT DISTINCT GrpID,PdvIDClie
                FROM per.GLP_SELLOUT
                --WHERE GrpID IN ('308','309','311')--,'312','328')
                UNION ALL
                SELECT DISTINCT GrpID,PdvIDClie
                FROM per.GLP_STOCK
                --WHERE GrpID IN ('308','309','311')--,'312','328')
              ) A
LEFT JOIN PER.MAESTRO_PDV B
              ON A.GrpID=B.GrpID AND A.PdvIDClie=B.PdvIDClie
WHERE B.PdvIDClie IS NULL

DELETE  FROM A
FROM
 PER.MAESTRO_PDV AS A
LEFT JOIN (
                      SELECT DISTINCT GrpID,PdvIDClie
                FROM per.GLP_SELLOUT
                --WHERE GrpID IN ('308','309','311')--,'312','328')
                UNION ALL
                SELECT DISTINCT GrpID,PdvIDClie
                FROM per.GLP_STOCK
    ) B
  ON A.GrpID=B.GrpID AND A.PdvIDClie=B.PdvIDClie
WHERE B.PdvIDClie IS NULL;


