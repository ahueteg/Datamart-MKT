SELECT 
[Fecha],
'309' [GrpID],
'1050'[CadenaID],
[OficinaID],
[GrupoTratID],
[VendedorID],
NULL [SupervisorID],
[ProPstID],
[PdvID],
[PrecioID],
[UnidDesp],
[MontoDespCliente],
[MontoDesp],
[AñoSemana_GL]
INTO per.SELLOUT_IK_2
FROM  per.SELLOUT_IK


DROP TABLE per.SELLOUT_IK

EXEC sp_rename 'per.SELLOUT_IK_2', 'SELLOUT_IK';

SELECT * FROM per.SELLOUT_IK;

SELECT * FROM PER.MAESTRO_CLIENTE

SELECT * FROM per.MAESTRO_CADENA

UPDATE per.SELLOUT_IK
SET CADENAID='1050'