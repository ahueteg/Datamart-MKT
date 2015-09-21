CREATE VIEW vw.vwBase_Tiempo
AS
SELECT
substring([Fecha],7,2)+'/'+SUBSTRING(fecha,5,2)+'/'+SUBSTRING(fecha,1,4) Fecha,
substring([A�oSemana_GL],1,4)+'-'+substring([A�oSemana_GL],5,2) [A�oSemana_GL],
[A�o_GL],
[Semana_GL],
[A�o],
CASE WHEN Mes in (1,2,3) THEN 'I'
    WHEN Mes in (4,5,6) THEN 'II'
      WHEN Mes in (7,8,9) THEN 'III'
        WHEN Mes in (10,11,12) THEN 'IV' END Trimestre,
[Mes],
[A�o.Mes],
[Dia_Mes],
[Dia_A�o],
[Dia_Semana]
FROM [per].[MAESTRO_TIEMPO];