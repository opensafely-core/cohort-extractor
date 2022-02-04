CREATE DATABASE Test_OpenCorona;
ALTER DATABASE Test_OpenCorona SET COMPATIBILITY_LEVEL = 100;
CREATE DATABASE OPENCoronaTempTables;
-- Set compatibility level to match the TPP database (uses SQL Server 2016, but with
-- compatibility set to 100 - equivalent to SQL Server 2008)
ALTER DATABASE OPENCoronaTempTables SET COMPATIBILITY_LEVEL = 100;
CREATE DATABASE Test_EMIS;

GO
