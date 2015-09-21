
DROP TABLE mkt.Info_Semanal;
SELECT
A.PdvID,
A.ProPstID,
A.AñoSemana_GL,
A.UnidDesp,
A.MontoDesp,
A.MontoDespPvp,
B.UnidExist,
B.MontoExist,
B.UnidCedis,
B.MontoCedis
into mkt.Info_Semanal
FROM vw.fn_ventas_historico ('309',16) A
LEFT JOIN vw.fn_STOCK_historico ('309',16) B
  ON A.PdvID=B.PdvID AND A.ProPstID=B.ProPstID AND A.AñoSemana_GL=B.AñoSemana_GL;


DROP TABLE MKT.Info_Semanal_Final;
  SELECT
  PdvID,
  ProPstID,
  AñoSemana_GL,
  UnidDesp,
  MontoDesp,
  MontoDespPvp,
  UnidExist,
  MontoExist,
  UnidCedis,
  MontoCedis,
  Mix,
  PromUnidDesp4,
  PromMontoDesp4,
  Agotado Num_Pdv_Agotado,
  Pre_Agotado Num_Pdv_PreAgotado,
  CASE WHEN Agotado=1 THEN PromUnidDesp4 ELSE 0 END Afectacion_Agotado_Unid,
  CASE WHEN Agotado=1 THEN PromMontoDesp4 ELSE 0 END Afectacion_Agotado_Monto,
  CASE WHEN Pre_Agotado=1 THEN PromUnidDesp4- UnidExist ELSE 0 END Afectacion_PreAgotado_Unid,
  CASE WHEN Pre_Agotado=1 THEN PromMontoDesp4- MontoExist ELSE 0 END Afectacion_PreAgotado_Monto
  INTO MKT.Info_Semanal_Final
FROM
  (
    SELECT
              PdvID,
              ProPstID,
              AñoSemana_GL,
              UnidDesp,
              MontoDesp,
			  MontoDespPvp,
              UnidExist,
              MontoExist,
			  UnidCedis,
			  MontoCedis,
      Mix,
      PromUnidDesp4,
      PromMontoDesp4,
      CASE WHEN Mix = 1 AND UnidExist <= 0
        THEN 1
      ELSE 0 END Agotado,
      CASE WHEN Mix = 1 AND UnidExist - PromUnidDesp4 < 0 AND UnidExist>0
        THEN 1
      ELSE 0 END Pre_Agotado
    FROM
      (
        SELECT
              PdvID,
              ProPstID,
              AñoSemana_GL,
              UnidDesp,
              MontoDesp,
			  MontoDespPvp,
              UnidExist,
              MontoExist,
			  UnidCedis,
			  MontoCedis,
          CASE WHEN SumUnidExist8 > 0
            THEN 1
          ELSE 0 END Mix,
          PromUnidDesp4,
          PromMontoDesp4
        FROM
          (
            SELECT
              PdvID,
              ProPstID,
              AñoSemana_GL,
              UnidDesp,
              MontoDesp,
			  MontoDespPvp,
              UnidExist,
              MontoExist,
			  UnidCedis,
			  MontoCedis,
              SUM(UnidExist)
              OVER (PARTITION BY PdvID, ProPstID
                ORDER BY AñoSemana_GL DESC
                ROWS BETWEEN CURRENT ROW AND 7 FOLLOWING) SumUnidExist8,
              AVG(UnidDesp)
              OVER (PARTITION BY PdvID, ProPstID
                ORDER BY AñoSemana_GL DESC
              ROWS BETWEEN CURRENT ROW AND 3 FOLLOWING) PromUnidDesp4,
              AVG(MontoDesp)
              OVER (PARTITION BY PdvID, ProPstID
                ORDER BY AñoSemana_GL DESC
              ROWS BETWEEN CURRENT ROW AND 3 FOLLOWING) PromMontoDesp4
    FROM mkt.Info_Semanal
  ) A
) A
) A