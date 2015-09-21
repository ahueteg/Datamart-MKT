CREATE VIEW vw.vwBase_Tiempo
AS
SELECT
substring([Fecha],7,2)+'/'+SUBSTRING(fecha,5,2)+'/'+SUBSTRING(fecha,1,4) Fecha,
substring([AñoSemana_GL],1,4)+'-'+substring([AñoSemana_GL],5,2) [AñoSemana_GL],
[Año_GL],
[Semana_GL],
[Año],
CASE WHEN Mes in (1,2,3) THEN 'I'
    WHEN Mes in (4,5,6) THEN 'II'
      WHEN Mes in (7,8,9) THEN 'III'
        WHEN Mes in (10,11,12) THEN 'IV' END Trimestre,
[Mes],
[Año.Mes],
[Dia_Mes],
[Dia_Año],
[Dia_Semana]
FROM [per].[MAESTRO_TIEMPO];