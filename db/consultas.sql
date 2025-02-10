--ALTER TABLE
--CREATE INDEX
--INSERT INTO

--UPDATE
update funcionario set cargo = 'Camareira' where cpf_p =23456789012;

--DELETE
SELECT * FROM multa;
DELETE FROM multa WHERE id_multa = 3;

--SELECT-FROM-WHERE

-- Seleciona as tuplas (id_multa, num_quarto) das reservas em que houve multa do tipo 'Atraso Check-out'.

SELECT M.id_multa AS id_multa, M.num_quarto AS num_quarto
FROM Multa M
WHERE M.tipo = 'Atraso Check-out';

--BETWEEN
--IN
--LIKE
--IS NULL ou IS NOT NULL
--INNER JOIN
--MAX
--MIN
--AVG
--COUNT
--LEFT ou RIGHT ou FULL OUTER JOIN 

--SUBCONSULTA COM OPERADOR RELACIONAL
SELECT cpf_p
FROM Funcionario
WHERE data_contratacao > (
    SELECT data_contratacao
    FROM Funcionario
    WHERE cpf_p = '12345678901'
);

--SUBCONSULTA COM IN
--SUBCONSULTA COM ANY
--SUBCONSULTA COM ALL
--ORDER BY

-- Seleciona as tuplas (cargo, salario) em ordem decrescente de valor de salário

SELECT C.cargo_funcionario AS cargo, C.salario AS salario
FROM Cargo C
ORDER BY salario DESC;

--GROUP BY

-- Seleciona cada tipo de pagamento e associa à quantidade de pagamentos daquele tipo feitos até o momento

SELECT tipo_pagamento, COUNT(*) AS total_pagamentos
FROM Pagamento
GROUP BY tipo_pagamento;

--HAVING

-- Seleciona os CPF's dos hóspedes que já visitaram o hotel e realizaram um gasto histórico maior que 2000.00

SELECT H.cpf_p AS cpf, SUM(P.valor) AS total_gasto
FROM Hospede H
INNER JOIN Realiza R ON R.hospede = H.cpf_p
INNER JOIN Pagamento P ON P.num_quarto = R.num_quarto_reserva
GROUP BY H.cpf_p
HAVING SUM(P.valor) > 2000.00;

--UNION ou INTERSECT ou MINUS
SELECT cpf FROM Pessoa
MINUS
SELECT cpf_p FROM Funcionario;

--CREATE VIEW
CREATE VIEW Gerentes AS
SELECT cpf_p
FROM Funcionario
WHERE cargo = 'Gerente';

select * from Gerentes;

--GRANT / REVOKE*
--USO DE RECORD
--USO DE ESTRUTURA DE DADOS DO TIPO TABLE
--BLOCO ANÔNIMO
--CREATE PROCEDURE
--CREATE FUNCTION
--%TYPE
--%ROWTYPE
--IF ELSIF
--CASE WHEN
--LOOP EXIT WHEN
--WHILE LOOP
--FOR IN LOOP

--SELECT … INTO
DECLARE
    v_numero varchar(11);
    v_rua VARCHAR(100);
    v_bairro VARCHAR(100);
BEGIN
    SELECT numero, rua, bairro INTO v_numero, v_rua, v_bairro
    FROM Pessoa
    WHERE cpf = '12345678901';
    
    DBMS_OUTPUT.PUT_LINE('Endereço: ' || v_rua || ', ' || v_numero || ' - ' || v_bairro);
END;
/

--CURSOR (OPEN, FETCH e CLOSE)
DECLARE
    CURSOR pessoa_cursor IS SELECT cpf, nome, numero, rua, bairro FROM Pessoa;
    pessoa_record Pessoa%ROWTYPE;
BEGIN
    OPEN pessoa_cursor;
    LOOP
        FETCH pessoa_cursor INTO pessoa_record;
        EXIT WHEN pessoa_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('CPF: ' || pessoa_record.cpf || ', Nome: ' || pessoa_record.nome);
    END LOOP;
    CLOSE pessoa_cursor;
END;
/

--EXCEPTION WHEN

--USO DE PARÂMETROS (IN, OUT ou IN OUT)
CREATE OR REPLACE PROCEDURE preco_diarias (
    valor_quarto IN NUMBER,
    qtd IN OUT NUMBER,
    total OUT NUMBER
) AS
BEGIN
    total := valor_quarto * qtd;
END;
/

DECLARE
    valor_quarto NUMBER := 150;
    qtd NUMBER := 3;
    total NUMBER;
BEGIN
    preco_diarias(valor_quarto, qtd, total);
    DBMS_OUTPUT.PUT_LINE('O total para ' ||qtd || ' diarias é ' || total);
END;
/

--CREATE OR REPLACE PACKAGE
CREATE OR REPLACE PACKAGE util IS
    PROCEDURE listar_pessoas;
END util;
/

-- CREATE OR REPLACE PACKAGE BODY
CREATE OR REPLACE PACKAGE BODY util IS
    PROCEDURE listar_pessoas IS
        CURSOR pessoa_cursor IS SELECT cpf, nome, numero, rua, bairro FROM Pessoa;
        pessoa_record Pessoa%ROWTYPE;
    BEGIN
        OPEN pessoa_cursor;
        LOOP
            FETCH pessoa_cursor INTO pessoa_record;
            EXIT WHEN pessoa_cursor%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('CPF: ' || pessoa_record.cpf || ', Nome: ' || pessoa_record.nome);
        END LOOP;
        CLOSE pessoa_cursor;
    END listar_pessoas;
END util;

BEGIN
    util.listar_pessoas;
END;

--CREATE OR REPLACE TRIGGER (COMANDO)
CREATE OR REPLACE TRIGGER trg_auditoria_ddl
AFTER DROP ON SCHEMA
BEGIN
    DBMS_OUTPUT.PUT_LINE('ALERTA: Um objeto foi removido do banco de dados!');
END;
/

--CREATE OR REPLACE TRIGGER (LINHA)
CREATE OR REPLACE TRIGGER trg_before_update_funcionario
BEFORE UPDATE ON Funcionario
FOR EACH ROW
BEGIN
    IF :NEW.cargo != :OLD.cargo THEN
        DBMS_OUTPUT.PUT_LINE('Cargo alterado de ' || :OLD.cargo || ' para ' || :NEW.cargo);
    END IF;
END;
/

-- DELETE 
SELECT * FROM multa;
DELETE FROM multa WHERE id_multa = 3;
SELECT * FROM pagamento;
DELETE FROM pagamento WHERE id_pagamento = 1;
-- BLOCO ANONIMO
DECLARE 
 	v_nome VARCHAR2(100) := 'João Silva';
	mensagem VARCHAR2(100);
BEGIN
	mensagem := 'Olá, ' || v_nome || '!';
	DBMS_OUTPUT.PUT_LINE(mensagem);
END;
/

SELECT * FROM funcionario;
-- %TYPE
DECLARE
    cargo_funcionario funcionario.cargo%TYPE;
  	cpf_funcionario funcionario.cpf_p%TYPE;
BEGIN
 	cargo_funcionario := 'Gerente';
	cpf_funcionario := '12345678901';

	DBMS_OUTPUT.PUT_LINE('Cargo Funcionário: ' || cargo_funcionario);
  	DBMS_OUTPUT.PUT_LINE('CPF Funcionário: ' || cpf_funcionario);
END;
/


