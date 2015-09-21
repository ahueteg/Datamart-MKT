SELECT * into mkt.ST_IK_BACKUP FROM PER.STOCK_IK

SELECT 
[Fecha],
'309' [GrpID],
'1050'[CadenaID],
[ProPstID],
[PdvID],
[PrecioID],
[UnidExist],
[UnidCedis],
NULL [UnidTrans],
NULL [MontoExist],
NULL [MontoCedis],
NULL [MontoTrans],
[AñoSemana_GL]
INTO PER.[STOCK_IK_2]
FROM [per].[STOCK_IK]

SELECT * FROM  PER.[STOCK_IK_2]

DROP TABLE [per].[STOCK_IK]

EXEC sp_rename 'per.STOCK_IK_2', 'STOCK_IK';
