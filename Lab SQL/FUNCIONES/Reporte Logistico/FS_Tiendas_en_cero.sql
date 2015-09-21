/*drop table mkt.Sellout_Dias;
create view mkt.Sellout_Dias AS
SELECT
  GrpID,
  AñoSemana_GL,
  MinFecha,
  MaxFecha,
  DATEDIFF(DAY,CONVERT(DATE,MinFecha,103),CONVERT(DATE,MaxFecha,103))+1 Dias
FROM (
SELECT A.GrpID,B.AñoSemana_GL,MIN(B.FECHA) MinFecha,MAX(B.FECHA) MaxFecha FROM (
SELECT A.*
FROM per.GLP_SELLOUT A
WHERE GrpID IN ('308', '309', '311')--, '312', '328'
and Fecha>='20131230'
) A
LEFT JOIN PER.MAESTRO_TIEMPO B
ON A.Fecha=B.Fecha
GROUP BY A.GrpID,B.AñoSemana_GL
) A;*/


DROP TABLE mkt.Info_Semanal_00;
SELECT
A.GrpID,
A.PdvID,
A.ProPstID,
A.ProIDClie,
A.AñoSemana_GL,
A.Dias,
A.UnidDesp,
A.MontoDesp,
A.MontoDespPvp,
B.UnidExist,
B.MontoExist,
B.UnidCedis,
B.MontoCedis
into mkt.Info_Semanal_00
FROM vw.FS_fn_ventas_historico(16) A
LEFT JOIN vw.FS_fn_stock_historico(16) B
  ON A.GrpID=B.GrpID AND A.PdvID=B.PdvID AND A.ProPstID=B.ProPstID AND A.ProIDClie=B.ProIDClie AND A.AñoSemana_GL=B.AñoSemana_GL;
--3m

DROP TABLE MKT.Info_Semanal_Final_00;
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
  PromMontoDesp4,
  Agotado_Mix Num_Pdv_Agotado_Mix,
  Pre_Agotado_Mix Num_Pdv_PreAgotado_Mix,
  Agotado Num_Pdv_Agotado,
  --Pre_Agotado Num_Pdv_PreAgotado,
  CASE WHEN Agotado_Mix=1 THEN PromUnidDesp4 ELSE 0 END Afectacion_Agotado_Mix_Unid,
  CASE WHEN Agotado_Mix=1 THEN PromMontoDesp4 ELSE 0 END Afectacion_Agotado_Mix_Monto,
  --CASE WHEN Agotado=1 THEN PromUnidDesp4 ELSE 0 END Afectacion_Agotado_Unid,
  --CASE WHEN Agotado=1 THEN PromMontoDesp4 ELSE 0 END Afectacion_Agotado_Monto,
  CASE WHEN Pre_Agotado_Mix=1 THEN PromUnidDesp4- UnidExist ELSE 0 END Afectacion_PreAgotado_Mix_Unid,
  CASE WHEN Pre_Agotado_Mix=1 THEN PromMontoDesp4- MontoExist ELSE 0 END Afectacion_PreAgotado_Mix_Monto
  --CASE WHEN Pre_Agotado=1 THEN PromUnidDesp4- UnidExist ELSE 0 END Afectacion_PreAgotado_Unid,
  --CASE WHEN Pre_Agotado=1 THEN PromMontoDesp4- MontoExist ELSE 0 END Afectacion_PreAgotado_Monto
  INTO MKT.Info_Semanal_Final_00
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
              PromMontoDesp4,
      CASE WHEN Mix = 1 AND UnidExist <= 0
        THEN 1
      ELSE 0 END Agotado_Mix,
      CASE WHEN UnidExist <= 0
        THEN 1
      ELSE 0 END Agotado,
      CASE WHEN Mix = 1 AND UnidExist - PromUnidDesp4 < 0 AND UnidExist>0
        THEN 1
      ELSE 0 END Pre_Agotado_Mix
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
              CASE WHEN SumUnidExist8 > 0
                THEN 1
              ELSE 0 END Mix,
              CASE WHEN AñoSemana_GL=Max_AñoSemana_GL AND TotalDias<7 THEN PromUnidDesp4_0 ELSE PromUnidDesp4 END PromUnidDesp4,
              CASE WHEN AñoSemana_GL=Max_AñoSemana_GL AND TotalDias<7 THEN PromMontoDesp4_0 ELSE PromMontoDesp4 END PromMontoDesp4
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
              SUM(UnidExist)
              OVER (PARTITION BY GrpID,PdvID, ProPstID
                ORDER BY AñoSemana_GL DESC
                ROWS BETWEEN CURRENT ROW AND 7 FOLLOWING) SumUnidExist8,
              AVG(UnidDesp)
              OVER (PARTITION BY GrpID,PdvID, ProPstID
                ORDER BY AñoSemana_GL DESC
              ROWS BETWEEN CURRENT ROW AND 3 FOLLOWING) PromUnidDesp4,
              AVG(UnidDesp)
              OVER (PARTITION BY GrpID,PdvID, ProPstID
                ORDER BY AñoSemana_GL DESC
              ROWS BETWEEN 1 FOLLOWING AND 4 FOLLOWING) PromUnidDesp4_0,
              AVG(MontoDesp)
              OVER (PARTITION BY GrpID,PdvID, ProPstID
                ORDER BY AñoSemana_GL DESC
              ROWS BETWEEN CURRENT ROW AND 3 FOLLOWING) PromMontoDesp4,
              AVG(MontoDesp)
              OVER (PARTITION BY GrpID,PdvID, ProPstID
                ORDER BY AñoSemana_GL DESC
              ROWS BETWEEN 1 FOLLOWING AND 4 FOLLOWING) PromMontoDesp4_0,
              max(AñoSemana_GL)OVER (PARTITION BY GrpID) Max_AñoSemana_GL
            FROM mkt.Info_Semanal_00
  ) A
) A
) A;

--SELECT *  FROM mkt.Info_Semanal_Final;
DROP TABLE MKT.Info_Semanal_Final_01;
SELECT
  GrupoID,
  PdvID,
  ProPstID,
  ProIDClie,
  AñoSemana_GL,
  UnidDesp,
  MontoDesp,
  MontoDespPvp,
  UnidExist,
  MontoExist,
  UnidCedis,
  MontoCedis,
  Mix,
  Activo,
  PromUnidDesp4,
  PromMontoDesp4,
  Num_Pdv_Agotado_Mix,
  Num_Pdv_PreAgotado_Mix,
  Num_Pdv_Agotado,
  Afectacion_Agotado_Mix_Unid,
  Afectacion_Agotado_Mix_Monto,
  Afectacion_PreAgotado_Mix_Unid,
  Afectacion_PreAgotado_Mix_Monto,
  CASE WHEN Activo=1 and Mix=0 and CountUnidDesp4xTipoPDV_Dist>0 then SumPromUnidDesp4xTipoPDV_Dist/CountUnidDesp4xTipoPDV_Dist else 0 end Afectacion_Activo_No_Mix_Dist_Unid,
  CASE WHEN Activo=1 and Mix=0 and CountMontoDesp4xTipoPDV_Dist>0 then SumPromMontoDesp4xTipoPDV_Dist/CountMontoDesp4xTipoPDV_Dist else 0 end Afectacion_Activo_No_Mix_Dist_Monto,
  CASE WHEN Activo=1 and Mix=0 and CountUnidDesp4xTipoPDV_Dept>0 then SumPromUnidDesp4xTipoPDV_Dept/CountUnidDesp4xTipoPDV_Dept else 0 end Afectacion_Activo_No_Mix_Dept_Unid,
  CASE WHEN Activo=1 and Mix=0 and CountMontoDesp4xTipoPDV_Dept>0 then SumPromMontoDesp4xTipoPDV_Dept/CountMontoDesp4xTipoPDV_Dept else 0 end Afectacion_Activo_No_Mix_Dept_Monto,
  CASE WHEN Activo=1 and Mix=0 and CountUnidDesp4xTipoPDV_Reg>0 then SumPromUnidDesp4xTipoPDV_Reg/CountUnidDesp4xTipoPDV_Reg else 0 end Afectacion_Activo_No_Mix_Reg_Unid,
  CASE WHEN Activo=1 and Mix=0 and CountMontoDesp4xTipoPDV_Reg>0 then SumPromMontoDesp4xTipoPDV_Reg/CountMontoDesp4xTipoPDV_Reg else 0 end Afectacion_Activo_No_Mix_Reg_Monto
INTO MKT.Info_Semanal_Final_01
FROM
  (
    SELECT
      A.GrupoID,
      A.PdvID,
      A.ProPstID,
      A.ProIDClie,
      A.AñoSemana_GL,
      A.UnidDesp,
      A.MontoDesp,
      A.MontoDespPvp,
      A.UnidExist,
      A.MontoExist,
      A.UnidCedis,
      A.MontoCedis,
      A.Mix,
      CASE WHEN b.StatusPdv = 'INACTIVO'
        THEN 0
      ELSE 1 END                                                             Activo,
      A.PromUnidDesp4,
      A.PromMontoDesp4,
      A.Num_Pdv_Agotado_Mix,
      A.Num_Pdv_PreAgotado_Mix,
      A.Num_Pdv_Agotado,
      A.Afectacion_Agotado_Mix_Unid,
      A.Afectacion_Agotado_Mix_Monto,
      A.Afectacion_PreAgotado_Mix_Unid,
      A.Afectacion_PreAgotado_Mix_Monto,
      SUM(CASE WHEN A.PromUnidDesp4 > 0
        THEN A.PromUnidDesp4
          ELSE 0 END)
      OVER (PARTITION BY B.CategoriaPdv, C.UbigeoID, ProPstID, AñoSemana_GL) SumPromUnidDesp4xTipoPDV_Dist,
      SUM(CASE WHEN A.PromUnidDesp4 > 0
        THEN 1
          ELSE 0 END)
      OVER (PARTITION BY B.CategoriaPdv, C.UbigeoID, ProPstID, AñoSemana_GL) CountUnidDesp4xTipoPDV_Dist,
      SUM(CASE WHEN A.PromMontoDesp4 > 0
        THEN A.PromMontoDesp4
          ELSE 0 END)
      OVER (PARTITION BY B.CategoriaPdv, C.UbigeoID, ProPstID, AñoSemana_GL) SumPromMontoDesp4xTipoPDV_Dist,
      SUM(CASE WHEN A.PromMontoDesp4 > 0
        THEN 1
          ELSE 0 END)
      OVER (PARTITION BY B.CategoriaPdv, C.UbigeoID, ProPstID, AñoSemana_GL) CountMontoDesp4xTipoPDV_Dist,
      SUM(CASE WHEN A.PromUnidDesp4 > 0
        THEN A.PromUnidDesp4
          ELSE 0 END)
      OVER (PARTITION BY B.CategoriaPdv, C.Departamento, ProPstID, AñoSemana_GL) SumPromUnidDesp4xTipoPDV_Dept,
      SUM(CASE WHEN A.PromUnidDesp4 > 0
        THEN 1
          ELSE 0 END)
      OVER (PARTITION BY B.CategoriaPdv, C.Departamento, ProPstID, AñoSemana_GL) CountUnidDesp4xTipoPDV_Dept,
      SUM(CASE WHEN A.PromMontoDesp4 > 0
        THEN A.PromMontoDesp4
          ELSE 0 END)
      OVER (PARTITION BY B.CategoriaPdv, C.Departamento, ProPstID, AñoSemana_GL) SumPromMontoDesp4xTipoPDV_Dept,
      SUM(CASE WHEN A.PromMontoDesp4 > 0
        THEN 1
          ELSE 0 END)
      OVER (PARTITION BY B.CategoriaPdv, C.Departamento, ProPstID, AñoSemana_GL) CountMontoDesp4xTipoPDV_Dept,
      SUM(CASE WHEN A.PromUnidDesp4 > 0
        THEN A.PromUnidDesp4
          ELSE 0 END)
      OVER (PARTITION BY B.CategoriaPdv, C.Region_III, ProPstID, AñoSemana_GL) SumPromUnidDesp4xTipoPDV_Reg,
      SUM(CASE WHEN A.PromUnidDesp4 > 0
        THEN 1
          ELSE 0 END)
      OVER (PARTITION BY B.CategoriaPdv, C.Region_III, ProPstID, AñoSemana_GL) CountUnidDesp4xTipoPDV_Reg,
      SUM(CASE WHEN A.PromMontoDesp4 > 0
        THEN A.PromMontoDesp4
          ELSE 0 END)
      OVER (PARTITION BY B.CategoriaPdv, C.Region_III, ProPstID, AñoSemana_GL) SumPromMontoDesp4xTipoPDV_Reg,
      SUM(CASE WHEN A.PromMontoDesp4 > 0
        THEN 1
          ELSE 0 END)
      OVER (PARTITION BY B.CategoriaPdv, C.Region_III, ProPstID, AñoSemana_GL) CountMontoDesp4xTipoPDV_Reg
    FROM MKT.Info_Semanal_Final_00 A
      LEFT JOIN PER.MAESTRO_PDV B
        ON A.PdvID = B.PdvID AND A.GrupoID = B.GrpID
      LEFT JOIN PER.MAESTRO_UBIGEO C
        ON B.UbigeoID = C.UbigeoID
  ) A;
/*
DROP TABLE mkt.Info_Inkafarma_Historico;
SELECT
  PdvID,
  ProPstID,
  ProIDClie,
  AñoSemana_GL,
  UnidDesp,
  MontoDesp,
  MontoDespPvp,
  UnidExist,
  MontoExist,
  UnidCedis,
  MontoCedis,
  Mix,
  Activo,
  PromUnidDesp4,
  PromMontoDesp4,
  Num_Pdv_Agotado_Mix,
  Num_Pdv_PreAgotado_Mix,
  Num_Pdv_Agotado,
  Afectacion_Agotado_Mix_Unid,
  Afectacion_Agotado_Mix_Monto,
  Afectacion_PreAgotado_Mix_Unid,
  Afectacion_PreAgotado_Mix_Monto,
  Afectacion_Activo_No_Mix_Dist_Unid,
  Afectacion_Activo_No_Mix_Dist_Monto,
  Afectacion_Activo_No_Mix_Dept_Unid,
  Afectacion_Activo_No_Mix_Dept_Monto,
  Afectacion_Activo_No_Mix_Reg_Unid,
  Afectacion_Activo_No_Mix_Reg_Monto
  INTO mkt.Info_Inkafarma_Historico
FROM MKT.Info_Semanal_Final_01
WHERE GrupoID='309';*/