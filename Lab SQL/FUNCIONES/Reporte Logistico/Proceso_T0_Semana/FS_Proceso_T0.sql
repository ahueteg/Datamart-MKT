/*DROP TABLE mkt.FS_Info_8_Semanas_00;
SELECT
A.GrpID,
A.PdvID,
A.ProPstID,
A.ProIDClie,
A.AñoSemana_GL,
cast(A.Dias as SMALLINT) Dias,
cast(A.UnidDesp as DECIMAL(11,2)) UnidDesp,
cast(A.MontoDesp as DECIMAL(11,2)) MontoDesp,
cast(A.MontoDespPvp as DECIMAL(11,2)) MontoDespPvp,
cast(B.UnidExist as DECIMAL(11,2)) UnidExist,
cast(B.MontoExist as DECIMAL(11,2)) MontoExist,
cast(B.UnidCedis as DECIMAL(11,2)) UnidCedis,
cast(B.MontoCedis as DECIMAL(11,2)) MontoCedis
into mkt.FS_Info_8_Semanas_00
FROM vw.FS_fn_ventas_historico(10) A
LEFT JOIN vw.FS_fn_stock_historico(10) B
  ON A.GrpID=B.GrpID AND A.PdvID=B.PdvID AND A.ProPstID=B.ProPstID AND A.ProIDClie=B.ProIDClie AND A.AñoSemana_GL=B.AñoSemana_GL;*/

DROP TABLE mkt.FS_Info_8_Semanas_00;
SELECT
  GrpID GrupoID,
  PdvID,
  ProPstID,
  ProIDClie,
  AñoSemana_GL,
  TotalDias,
  UnidDesp,
  MontoDesp,
  MontoDespPvp,
  UnidExist,
  MontoExist,
  UnidCedis,
  MontoCedis,
  Mix,
  PromUnidDesp4,
  PromUnidDesp8,
  PromMontoDesp4,
  Pdv_Agotado_Mix,
  Pdv_PreAgotado_Mix,
  Pdv_Agotado,
  CASE WHEN Pdv_Agotado_Mix=1 THEN PromUnidDesp4 ELSE 0 END Afect_Agotado_Mix_Unid,
  CASE WHEN Pdv_Agotado_Mix=1 THEN PromMontoDesp4 ELSE 0 END Afect_Agotado_Mix_Monto,
  CASE WHEN Pdv_PreAgotado_Mix=1 THEN PromUnidDesp4- UnidExist ELSE 0 END Afect_PreAgotado_Mix_Unid,
  CASE WHEN Pdv_PreAgotado_Mix=1 THEN PromMontoDesp4- MontoExist ELSE 0 END Afect_PreAgotado_Mix_Monto,
  Max_AñoSemana_GL
  INTO mkt.FS_Info_8_Semanas_00
FROM
  (
    SELECT
              GrpID,
              PdvID,
              ProPstID,
              ProIDClie,
              AñoSemana_GL,
              TotalDias,
              UnidDesp,
              MontoDesp,
			        MontoDespPvp,
              UnidExist,
              MontoExist,
              UnidCedis,
              MontoCedis,
              Mix,
              PromUnidDesp4,
              PromUnidDesp8,
              PromMontoDesp4,
      CAST(CASE WHEN Mix = 1 AND UnidExist <= 0
        THEN 1
      ELSE 0 END AS BIT) Pdv_Agotado_Mix,
      CAST(CASE WHEN UnidExist <= 0
        THEN 1
      ELSE 0 END AS BIT) Pdv_Agotado,
      CAST(CASE WHEN Mix = 1 AND UnidExist - PromUnidDesp4 < 0 AND UnidExist>0
        THEN 1
      ELSE 0 END AS BIT) Pdv_PreAgotado_Mix,
      Max_AñoSemana_GL
    FROM
      (
        SELECT
              GrpID,
              PdvID,
              ProPstID,
              ProIDClie,
              AñoSemana_GL,
              TotalDias,
              UnidDesp,
              MontoDesp,
              MontoDespPvp,
              UnidExist,
              MontoExist,
              UnidCedis,
              MontoCedis,
              CAST(
              CASE WHEN SumUnidExist8 > 0
                THEN 1
              ELSE 0 END AS BIT) Mix,
              CASE WHEN AñoSemana_GL=Max_AñoSemana_GL AND TotalDias<7 THEN PromUnidDesp4_0 ELSE PromUnidDesp4 END PromUnidDesp4,
              CASE WHEN AñoSemana_GL=Max_AñoSemana_GL AND TotalDias<7 THEN PromUnidDesp8_0 ELSE PromUnidDesp8 END PromUnidDesp8,
              CASE WHEN AñoSemana_GL=Max_AñoSemana_GL AND TotalDias<7 THEN PromMontoDesp4_0 ELSE PromMontoDesp4 END PromMontoDesp4,
              Max_AñoSemana_GL
        FROM
          (
            SELECT
              GrpID,
              PdvID,
              ProPstID,
              ProIDClie,
              AñoSemana_GL,
              Dias TotalDias,
              UnidDesp,
              MontoDesp,
              MontoDespPvp,
              UnidExist,
              MontoExist,
              UnidCedis,
              MontoCedis,
              CAST(SUM(UnidExist)
              OVER (PARTITION BY GrpID,PdvID, ProPstID
                ORDER BY AñoSemana_GL DESC
                ROWS BETWEEN CURRENT ROW AND 7 FOLLOWING) AS DECIMAL(11,2)) SumUnidExist8,
              CAST(AVG(UnidDesp)
              OVER (PARTITION BY GrpID,PdvID, ProPstID
                ORDER BY AñoSemana_GL DESC
              ROWS BETWEEN CURRENT ROW AND 3 FOLLOWING) AS DECIMAL(11,2)) PromUnidDesp4,
              CAST(AVG(UnidDesp)
              OVER (PARTITION BY GrpID,PdvID, ProPstID
                ORDER BY AñoSemana_GL DESC
              ROWS BETWEEN CURRENT ROW AND 7 FOLLOWING) AS DECIMAL(11,2)) PromUnidDesp8,
              CAST(AVG(UnidDesp)
              OVER (PARTITION BY GrpID,PdvID, ProPstID
                ORDER BY AñoSemana_GL DESC
              ROWS BETWEEN 1 FOLLOWING AND 4 FOLLOWING) AS DECIMAL(11,2)) PromUnidDesp4_0,
              CAST(AVG(UnidDesp)
              OVER (PARTITION BY GrpID,PdvID, ProPstID
                ORDER BY AñoSemana_GL DESC
              ROWS BETWEEN 1 FOLLOWING AND 8 FOLLOWING) AS DECIMAL(11,2)) PromUnidDesp8_0,
              CAST(AVG(MontoDesp)
              OVER (PARTITION BY GrpID,PdvID, ProPstID
                ORDER BY AñoSemana_GL DESC
              ROWS BETWEEN CURRENT ROW AND 3 FOLLOWING) AS DECIMAL(11,2)) PromMontoDesp4,
              CAST(AVG(MontoDesp)
              OVER (PARTITION BY GrpID,PdvID, ProPstID
                ORDER BY AñoSemana_GL DESC
              ROWS BETWEEN 1 FOLLOWING AND 4 FOLLOWING) AS DECIMAL(11,2)) PromMontoDesp4_0,
              max(AñoSemana_GL)OVER (PARTITION BY GrpID) Max_AñoSemana_GL
            FROM vw.FS_fn_data_historico(10)
  ) A
) A
) A;