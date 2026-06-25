USE db_SecurityPositivo
GO
ALTER TABLE Usuarios ADD Notas VARCHAR(100) --no poner not null
--no crear columna estado sino usar columna activo