SELECT * FROM vw.fn_dim_Vendedor('338')

SELECT * FROM vw.fn_dim_Supervisor('338')

/*2.-CONTINENTAL*/
SELECT
  B.GrpID,
  B.VendedorID,
  B.VendedorIDClie,
  B.DescVendedor,
  B.SupervisorNombreClie,
  B.Tipo,
  B.Mesa,
  B.Telefono_1,
  B.Telefono_2,
  B.Telefono_3,
  B.[E-mail]
FROM per.MAESTRO_VENDEDOR B
WHERE VendedorIDClie <> DescVendedor
      AND GrpID = '327'
UNION ALL
SELECT
DISTINCT
  A.GrpID,
  A.VendedorID,
  A.VendedorIDClie,
  B.NOMB_VDOR DescVendedor,
  A.SupervisorNombreClie,
  A.Tipo,
  A.Mesa,
  A.Telefono_1,
  A.Telefono_2,
  A.Telefono_3,
  A.[E-mail]
FROM
(
SELECT *
FROM per.MAESTRO_VENDEDOR
WHERE VendedorIDClie = DescVendedor
      AND GrpID = '327'
) A LEFT JOIN mkt.SELLOUT_CONTI_HISTW B
  ON A.VendedorIDClie=COALESCE(CONVERT(VARCHAR,TRY_CONVERT(BIGINT,B.VENDEDOR)),B.VENDEDOR);
/*3.-DIGALIMENTA*/
SELECT
  B.GrpID,
  B.VendedorID,
  B.VendedorIDClie,
  B.DescVendedor,
  B.SupervisorNombreClie,
  B.Tipo,
  B.Mesa,
  B.Telefono_1,
  B.Telefono_2,
  B.Telefono_3,
  B.[E-mail]
FROM per.MAESTRO_VENDEDOR B
WHERE VendedorIDClie <> DescVendedor
      AND GrpID = '337'
UNION ALL
SELECT
DISTINCT
  A.GrpID,
  A.VendedorID,
  A.VendedorIDClie,
  B.NOM_VEND DescVendedor,
  A.SupervisorNombreClie,
  A.Tipo,
  A.Mesa,
  A.Telefono_1,
  A.Telefono_2,
  A.Telefono_3,
  A.[E-mail]
FROM
(
SELECT *
FROM per.MAESTRO_VENDEDOR
WHERE VendedorIDClie = DescVendedor
      AND GrpID = '337'
) A LEFT JOIN mkt.SELLOUT_DIGA_HISTW B
  ON A.VendedorIDClie=COALESCE(CONVERT(VARCHAR,TRY_CONVERT(BIGINT,B.COD_VEND)),COD_VEND);
/*4.-KEYMARK*/
SELECT
  B.GrpID,
  B.VendedorID,
  B.VendedorIDClie,
  B.DescVendedor,
  B.SupervisorNombreClie,
  B.Tipo,
  B.Mesa,
  B.Telefono_1,
  B.Telefono_2,
  B.Telefono_3,
  B.[E-mail]
FROM per.MAESTRO_VENDEDOR B
WHERE VendedorIDClie <> DescVendedor
      AND GrpID = '338'
UNION ALL
SELECT
DISTINCT
  A.GrpID,
  A.VendedorID,
  A.VendedorIDClie,
  B.NOMVENDEDOR DescVendedor,
  A.SupervisorNombreClie,
  A.Tipo,
  A.Mesa,
  A.Telefono_1,
  A.Telefono_2,
  A.Telefono_3,
  A.[E-mail]
FROM
(
SELECT *
FROM per.MAESTRO_VENDEDOR
WHERE VendedorIDClie = DescVendedor
      AND GrpID = '338'
) A LEFT JOIN mkt.SELLOUT_KEYMARK_HISTW B
  ON A.VendedorIDClie=COALESCE(CONVERT(VARCHAR,TRY_CONVERT(BIGINT,B.COD_VENDEDOR)),COD_VENDEDOR);