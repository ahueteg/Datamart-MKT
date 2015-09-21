
/*MAESTRO CLIENTE*/
SELECT * FROM  [mkt].maestro_clientex

DROP TABLE per.MAESTRO_CLIENTE

SELECT
[GrpID]
      ,[GrpNombre]
      ,[GrpRFC]
      ,[GrpURL]
      ,[GrpRazonSocial]
      ,[Canal]
	  into per.MAESTRO_CLIENTE
	  FROM [mkt].maestro_clientex

ALTER TABLE per.MAESTRO_CLIENTE ALTER COLUMN [GrpID] VARCHAR(3) NOT NULL;
alter table per.MAESTRO_CLIENTE add primary key ([GrpID]);

SELECT * FROM per.MAESTRO_CLIENTE

INSERT INTO [per].[MAESTRO_CLIENTE]
VALUES('000','Sin Cliente',null,null,null,null)