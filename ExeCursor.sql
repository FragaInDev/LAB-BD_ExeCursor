CREATE DATABASE exeCursor
GO
USE exeCursor

CREATE TABLE curso(
codigo		INT				NOT NULL,
nome		VARCHAR(60)		NOT NULL,
duracao		INT				NOT NULL
PRIMARY KEY(codigo)
)
GO
CREATE TABLE disciplina(
codigo			CHAR(6)		not null,
nome			VARCHAR(90)	NOT NULL,
carga_horaria	INT			NOT NULL
PRIMARY KEY(codigo)
)
GO
CREATE TABLE disciplina_curso(
codigo_disciplina	CHAR(6)		NOT NULL,
codigo_curso		INT			NOT NULL
PRIMARY KEY(codigo_disciplina, codigo_curso)
FOREIGN KEY(codigo_disciplina) REFERENCES disciplina(codigo),
FOREIGN KEY(codigo_curso) REFERENCES curso(codigo)
)

select * from curso
select * from disciplina
select * from disciplina_curso

CREATE FUNCTION fn_cursor(@curso INT)
RETURNS @tabela TABLE(
cod_disciplina	CHAR(6)		NOT NULL,
nome_disciplina	VARCHAR(90)	NOT NULL,
carga_horaria	INT			NOT NULL,
nome_curso		VARCHAR(60)	NOT NULL
)
AS
BEGIN
	DECLARE @cod_disciplina CHAR(6),
			@nome_dis		VARCHAR(90),
			@carga_horaria	INT,
			@nome_curso		VARCHAR(60),
			@cod_curso		INT

	DECLARE c CURSOR FOR SELECT codigo_disciplina, codigo_curso FROM disciplina_curso
	OPEN c
	FETCH NEXT FROM c INTO @cod_disciplina, @cod_curso
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF(@cod_curso = @curso)
		BEGIN
			SELECT @cod_disciplina = d.codigo, @nome_dis = d.nome, @carga_horaria = d.carga_horaria, @nome_curso = c.nome
			FROM disciplina d, curso c
			WHERE @cod_disciplina = d.codigo AND @cod_curso = c.codigo

			INSERT INTO @tabela VALUES (@cod_disciplina, @nome_dis, @carga_horaria, @nome_curso)
		END

		FETCH NEXT FROM c INTO @cod_disciplina, @cod_curso
	END
	CLOSE c
	DEALLOCATE c
	RETURN
END

SELECT * FROM dbo.fn_cursor(48)