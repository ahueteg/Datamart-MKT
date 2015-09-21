CREATE VIEW vw.vwBase_Producto
AS
SELECT
A.[ProPstID],
A.[ProPstCodBarras],
A.[ProPstCodigoAtlas],
A.[ProPstNombre],
B.[ProNombre],
C.[AgrProNombre],
D.[LinNombre],
E.[MrcNombre],
A.Rubro,
  A.SegmentacionGL,
  A.StatusLanzamiento,
  A.StatusProd
FROM [per].[MAESTRO_PRODUCTO_PRESENTACION] A
LEFT JOIN [per].[MAESTRO_PRODUCTO] B
ON A.[ProID]= B.PROID
LEFT JOIN [per].[MAESTRO_PRODUCTO_AGRPAUTA] C
ON A.[AgrProID]= C.[AgrProID]
LEFT JOIN [per].[MAESTRO_PRODUCTO_LINEA] D
ON A.[LinID]= D.[LinID]
LEFT JOIN [per].[MAESTRO_PRODUCTO_MARCA] E
ON A.[MrcID]= E.[MrcID];