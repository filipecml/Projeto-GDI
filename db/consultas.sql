--ALTER TABLE
--CREATE INDEX
--INSERT INTO

--UPDATE
update funcionario set cargo = 'Camareira' where cpf_p =23456789012;

--DELETE
--SELECT-FROM-WHERE
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
SELECT * FROM tipo_quarto where valor < 200;

--SUBCONSULTA COM IN
--SUBCONSULTA COM ANY
--SUBCONSULTA COM ALL
--ORDER BY
--GROUP BY
--HAVING

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
--CREATE OR REPLACE PACKAGE BODY
--CREATE OR REPLACE TRIGGER (COMANDO)

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
