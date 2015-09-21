SELECT * FROM [mkt].[maestro_cadena];

SELECT * FROM [mkt].[maestro_oficina];

SELECT * FROM [mkt].[maestro_grupotarget]

/*presentacion producto*/
SELECT * FROM [mkt].[maestro_agrpro]

INSERT INTO [mkt].[maestro_agrpro]
VALUES('0000','SIN AGRUPACION PAUTA')

SELECT * FROM [mkt].[maestro_lineaproducto]

INSERT INTO [mkt].[maestro_lineaproducto]
VALUES('000','SIN LINEA PRODUCTO')

SELECT * FROM [mkt].[maestro_marcaproducto]

INSERT INTO [mkt].[maestro_marcaproducto]
VALUES('000','SIN MARCA PRODUCTO')


SELECT * FROM [mkt].[maestro_producto]

INSERT INTO [mkt].[maestro_producto]
VALUES('0000','SIN CODIGO PRODUCTO')


SELECT * FROM [mkt].[maestro_presentacion_producto]

INSERT INTO [mkt].[maestro_presentacion_producto]
VALUES('0000','000000000000','0000000000000','SIN PRODUCTO PRESENTACION','0000','0000','000','000')


SELECT * FROM [mkt].[maestro_precio]

SELECT * FROM [mkt].[maestro_añosemana_gl]

SELECT * FROM [mkt].[maestro_cliente]

SELECT * FROM [mkt].[maestro_vendedor]

SELECT * FROM [mkt].[maestro_pdv]

SELECT grpid,COUNT(1)  FROM mkt.maestro_fuente_producto
GROUP BY grpid