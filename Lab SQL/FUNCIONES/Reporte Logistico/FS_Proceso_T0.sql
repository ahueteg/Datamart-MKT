DROP TABLE mkt.FS_Info_8_Semanas_00;
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
  ON A.GrpID=B.GrpID AND A.PdvID=B.PdvID AND A.ProPstID=B.ProPstID AND A.ProIDClie=B.ProIDClie AND A.AñoSemana_GL=B.AñoSemana_GL;

DROP TABLE mkt.FS_Info_8_Semanas_01;
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
  INTO mkt.FS_Info_8_Semanas_01
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
            FROM mkt.FS_Info_8_Semanas_00
  ) A
) A
) A;

DROP TABLE mkt.FS_Info_8_Semanas_02;
SELECT
  GrupoID,
  PdvID,
  ProPstID,
  ProIDClie ProPstIDClie,
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
  PromUnidDesp8,
  PromMontoDesp4,
  Pdv_Agotado_Mix,
  Pdv_PreAgotado_Mix,
  Pdv_Agotado,
  Afect_Agotado_Mix_Unid,
  Afect_Agotado_Mix_Monto,
  Afect_PreAgotado_Mix_Unid,
  Afect_PreAgotado_Mix_Monto,
  Max_AñoSemana_GL,
  CAST(CASE WHEN Activo=1 and Mix=0 and CountUnidDesp4xTipoPDV_Dist>0 then SumPromUnidDesp4xTipoPDV_Dist/CountUnidDesp4xTipoPDV_Dist else 0 end AS DECIMAL(11,2)) Afect_Activo_No_Mix_Dist_Unid,
  CAST(CASE WHEN Activo=1 and Mix=0 and CountMontoDesp4xTipoPDV_Dist>0 then SumPromMontoDesp4xTipoPDV_Dist/CountMontoDesp4xTipoPDV_Dist else 0 end AS DECIMAL(11,2)) Afect_Activo_No_Mix_Dist_Monto,
  CAST(CASE WHEN Activo=1 and Mix=0 and CountUnidDesp4xTipoPDV_Dept>0 then SumPromUnidDesp4xTipoPDV_Dept/CountUnidDesp4xTipoPDV_Dept else 0 end AS DECIMAL(11,2)) Afect_Activo_No_Mix_Dept_Unid,
  CAST(CASE WHEN Activo=1 and Mix=0 and CountMontoDesp4xTipoPDV_Dept>0 then SumPromMontoDesp4xTipoPDV_Dept/CountMontoDesp4xTipoPDV_Dept else 0 end AS DECIMAL(11,2)) Afect_Activo_No_Mix_Dept_Monto,
  CAST(CASE WHEN Activo=1 and Mix=0 and CountUnidDesp4xTipoPDV_Reg>0 then SumPromUnidDesp4xTipoPDV_Reg/CountUnidDesp4xTipoPDV_Reg else 0 end AS DECIMAL(11,2)) Afect_Activo_No_Mix_Reg_Unid,
  CAST(CASE WHEN Activo=1 and Mix=0 and CountMontoDesp4xTipoPDV_Reg>0 then SumPromMontoDesp4xTipoPDV_Reg/CountMontoDesp4xTipoPDV_Reg else 0 end AS DECIMAL(11,2)) Afect_Activo_No_Mix_Reg_Monto
  INTO mkt.FS_Info_8_Semanas_02
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
      CAST(CASE WHEN b.StatusPdv = 'INACTIVO'
        THEN 0
      ELSE 1 END AS BIT) Activo,
      A.PromUnidDesp4,
      A.PromUnidDesp8,
      A.PromMontoDesp4,
      A.Pdv_Agotado_Mix,
      A.Pdv_PreAgotado_Mix,
      A.Pdv_Agotado,
      A.Afect_Agotado_Mix_Unid,
      A.Afect_Agotado_Mix_Monto,
      A.Afect_PreAgotado_Mix_Unid,
      A.Afect_PreAgotado_Mix_Monto,
      A.Max_AñoSemana_GL,
      CAST(SUM(CASE WHEN A.PromUnidDesp4 > 0
        THEN A.PromUnidDesp4
          ELSE 0 END)
      OVER (PARTITION BY B.CategoriaPdv, C.UbigeoID, ProPstID, AñoSemana_GL) AS DECIMAL (11,2)) SumPromUnidDesp4xTipoPDV_Dist,
      SUM(CASE WHEN A.PromUnidDesp4 > 0
        THEN 1
          ELSE 0 END)
      OVER (PARTITION BY B.CategoriaPdv, C.UbigeoID, ProPstID, AñoSemana_GL) CountUnidDesp4xTipoPDV_Dist,
      CAST(SUM(CASE WHEN A.PromMontoDesp4 > 0
        THEN A.PromMontoDesp4
          ELSE 0 END)
      OVER (PARTITION BY B.CategoriaPdv, C.UbigeoID, ProPstID, AñoSemana_GL) AS DECIMAL (11,2)) SumPromMontoDesp4xTipoPDV_Dist,
      SUM(CASE WHEN A.PromMontoDesp4 > 0
        THEN 1
          ELSE 0 END)
      OVER (PARTITION BY B.CategoriaPdv, C.UbigeoID, ProPstID, AñoSemana_GL) CountMontoDesp4xTipoPDV_Dist,
      CAST(SUM(CASE WHEN A.PromUnidDesp4 > 0
        THEN A.PromUnidDesp4
          ELSE 0 END)
      OVER (PARTITION BY B.CategoriaPdv, C.Departamento, ProPstID, AñoSemana_GL) AS DECIMAL (11,2)) SumPromUnidDesp4xTipoPDV_Dept,
      SUM(CASE WHEN A.PromUnidDesp4 > 0
        THEN 1
          ELSE 0 END)
      OVER (PARTITION BY B.CategoriaPdv, C.Departamento, ProPstID, AñoSemana_GL) CountUnidDesp4xTipoPDV_Dept,
      CAST(SUM(CASE WHEN A.PromMontoDesp4 > 0
        THEN A.PromMontoDesp4
          ELSE 0 END)
      OVER (PARTITION BY B.CategoriaPdv, C.Departamento, ProPstID, AñoSemana_GL) AS DECIMAL (11,2)) SumPromMontoDesp4xTipoPDV_Dept,
      SUM(CASE WHEN A.PromMontoDesp4 > 0
        THEN 1
          ELSE 0 END)
      OVER (PARTITION BY B.CategoriaPdv, C.Departamento, ProPstID, AñoSemana_GL) CountMontoDesp4xTipoPDV_Dept,
      CAST(SUM(CASE WHEN A.PromUnidDesp4 > 0
        THEN A.PromUnidDesp4
          ELSE 0 END)
      OVER (PARTITION BY B.CategoriaPdv, C.Region_III, ProPstID, AñoSemana_GL) AS DECIMAL (11,2)) SumPromUnidDesp4xTipoPDV_Reg,
      SUM(CASE WHEN A.PromUnidDesp4 > 0
        THEN 1
          ELSE 0 END)
      OVER (PARTITION BY B.CategoriaPdv, C.Region_III, ProPstID, AñoSemana_GL) CountUnidDesp4xTipoPDV_Reg,
      CAST(SUM(CASE WHEN A.PromMontoDesp4 > 0
        THEN A.PromMontoDesp4
          ELSE 0 END)
      OVER (PARTITION BY B.CategoriaPdv, C.Region_III, ProPstID, AñoSemana_GL) AS DECIMAL (11,2)) SumPromMontoDesp4xTipoPDV_Reg,
      SUM(CASE WHEN A.PromMontoDesp4 > 0
        THEN 1
          ELSE 0 END)
      OVER (PARTITION BY B.CategoriaPdv, C.Region_III, ProPstID, AñoSemana_GL) CountMontoDesp4xTipoPDV_Reg
    FROM mkt.FS_Info_8_Semanas_01 A
      LEFT JOIN PER.MAESTRO_PDV B
        ON A.PdvID = B.PdvID AND A.GrupoID = B.GrpID
      LEFT JOIN PER.MAESTRO_UBIGEO C
        ON B.UbigeoID = C.UbigeoID
  ) A;

DELETE FROM  mkt.FS_InfoSemana_Hist
WHERE AñoSemana_GL in (SELECT AñoSemana_GL
            FROM vw.fn_ultimas_semanas('309',2));

insert into mkt.FS_InfoSemana_Hist
    SELECT * FROM mkt.FS_Info_8_Semanas_02
    WHERE AñoSemana_GL in (SELECT AñoSemana_GL
            FROM vw.fn_ultimas_semanas('309',2));


DELETE FROM MKT.Info_Semanal_Final_01
WHERE AñoSemana_GL in (SELECT AñoSemana_GL
            FROM vw.fn_ultimas_semanas('309',2));

insert into MKT.Info_Semanal_Final_01
SELECT
  A.GrupoID,
  A.PdvID,
  A.ProPstID,
  A.ProPstIDClie,
  A.AñoSemana_GL,
  A.UnidDesp,
  A.MontoDesp,
  A.MontoDespPvp,
  A.UnidExist,
  A.MontoExist,
  A.UnidCedis,
  A.MontoCedis,
  A.Mix,
  A.Activo,
  A.PromUnidDesp4,
  A.PromMontoDesp4,
  A.Pdv_Agotado_Mix,
  A.Pdv_PreAgotado_Mix,
  A.Pdv_Agotado,
  A.Afect_Agotado_Mix_Unid,
  A.Afect_Agotado_Mix_Monto,
  A.Afect_PreAgotado_Mix_Unid,
  A.Afect_PreAgotado_Mix_Monto,
  A.Afect_Activo_No_Mix_Dist_Unid,
  A.Afect_Activo_No_Mix_Dist_Monto,
  A.Afect_Activo_No_Mix_Dept_Unid,
  A.Afect_Activo_No_Mix_Dept_Monto,
  A.Afect_Activo_No_Mix_Reg_Unid,
  A.Afect_Activo_No_Mix_Reg_Monto
FROM 
mkt.FS_InfoSemana_Hist A
    WHERE AñoSemana_GL in (SELECT AñoSemana_GL
            FROM vw.fn_ultimas_semanas('309',2));