DROP TABLE MKT.SUG_COMPRA_00;
SELECT
  A.PdvID,
  A.ProPstID,
  COALESCE(B.[SO-20_Und],0) [SO-20_Und],
  COALESCE(B.[SO-21_Und],0) [SO-21_Und],
  COALESCE(B.[SO-22_Und],0) [SO-22_Und],
  COALESCE(B.[SO-23_Und],0) [SO-23_Und],
  COALESCE(B.[SO-24_Und],0) [SO-24_Und],
  COALESCE(B.[SO-25_Und],0) [SO-25_Und],
  COALESCE(B.[SO-26_Und],0) [SO-26_Und],
  COALESCE(B.[SO-27_Und],0) [SO-27_Und],
  COALESCE(B.[SO-20_Sol],0) [SO-20_Sol],
  COALESCE(B.[SO-21_Sol],0) [SO-21_Sol],
  COALESCE(B.[SO-22_Sol],0) [SO-22_Sol],
  COALESCE(B.[SO-23_Sol],0) [SO-23_Sol],
  COALESCE(B.[SO-24_Sol],0) [SO-24_Sol],
  COALESCE(B.[SO-25_Sol],0) [SO-25_Sol],
  COALESCE(B.[SO-26_Sol],0) [SO-26_Sol],
  COALESCE(B.[SO-27_Sol],0) [SO-27_Sol],
  COALESCE(A.[Inv-20_und],0) [Inv-20_und],
  COALESCE(A.[Inv-21_und],0) [Inv-21_und],
  COALESCE(A.[Inv-22_und],0) [Inv-22_und],
  COALESCE(A.[Inv-23_und],0) [Inv-23_und],
  COALESCE(A.[Inv-24_und],0) [Inv-24_und],
  COALESCE(A.[Inv-25_und],0) [Inv-25_und],
  COALESCE(A.[Inv-26_und],0) [Inv-26_und],
  COALESCE(A.[Inv-27_und],0) [Inv-27_und]
INTO mkt.SUG_COMPRA_00
FROM MKT.SUG_STOCK_00 A
LEFT JOIN MKT.SUG_VENTA_02 B
  ON A.PdvID=B.PdvID AND A.ProPstID=B.ProPstID

SELECT *  FROM mkt.SUG_COMPRA_00;
