DELETE
  FROM [OptimiDoc].[dbo].[Credentials]
  WHERE Type = '8' and (
              Value = '12345'
					or  Value = '123456'
					or  Value = '1234567')