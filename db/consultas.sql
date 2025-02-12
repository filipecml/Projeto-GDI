--ALTER TABLE
ALTER TABLE Pessoa
MODIFY bairro VARCHAR2(75);

--CREATE INDEX
CREATE INDEX idx_nome_pessoa
ON Pessoa(nome);

--INSERT INTO
--No povoamento

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
SELECT num_quarto
FROM Pagamento
WHERE valor BETWEEN 500.00 AND 800.00;

--IN
SELECT num_quarto
FROM Pagamento
WHERE valor IN (900.00);

--LIKE
SELECT cpf, nome
FROM Pessoa
Where nome LIKE 'Ca%';

--IS NULL ou IS NOT NULL
--IS NOT NULL
SELECT cpf_p
FROM Funcionario
WHERE cpf_orientador IS NOT NULL;

--INNER JOIN com HAVING

-- MAX e MIN
INSERT INTO MULTA
VALUES (3, 1, '101','2024-02-01 a 2024-02-07', 'Atraso Check-out', 100);
INSERT INTO MULTA
VALUES (4, 1, '101','2024-02-01 a 2024-02-07', 'Atraso Check-out', 20);

SELECT MAX(VALOR)
FROM MULTA;

SELECT MIN(VALOR)
FROM MULTA;

-- AVG
SELECT AVG(VALOR)
FROM MULTA;

--COUNT com GROUP BY

--LEFT ou RIGHT ou >FULL OUTER JOIN< 
SELECT P.nome, F.cargo
FROM Pessoa P
FULL OUTER JOIN Funcionario F ON P.cpf = F.cpf_p;

--SUBCONSULTA COM OPERADOR RELACIONAL
SELECT cpf_p
FROM Funcionario
WHERE data_contratacao > (
    SELECT data_contratacao
    FROM Funcionario
    WHERE cpf_p = '12345678901'
);

--SUBCONSULTA COM IN
SELECT num_quarto, valor
FROM Pagamento
WHERE valor in (
	SELECT valor 
	FROM Tipo_quarto 
	WHERE valor > 100
);

--SUBCONSULTA COM ANY
SELECT num_quarto, valor
FROM Pagamento
WHERE valor >= ANY (
	SELECT valor 
	FROM Tipo_quarto
);

--SUBCONSULTA COM ALL 
-- A diferença entre o ANY e o ALL é que neste caso só serão selecionados os valores tais que são maiores que o valor máximo da consulta encadeada.
-- Enquanto que no caso do ANY será todos os valores maiores que o valor mínimo da consulta encadeada.
SELECT num_quarto, valor
FROM Pagamento
WHERE valor >= ALL (
	SELECT valor 
	FROM Tipo_quarto
);

--ORDER BY
-- Seleciona as tuplas (cargo, salario) em ordem decrescente de valor de salário
SELECT C.cargo_funcionario AS cargo, C.salario AS salario
FROM Cargo C
ORDER BY salario DESC;

--GROUP BY e COUNT
-- Seleciona cada tipo de pagamento e associa à quantidade de pagamentos daquele tipo feitos até o momento
SELECT tipo_pagamento, COUNT(*) AS total_pagamentos
FROM Pagamento
GROUP BY tipo_pagamento;

--HAVING e INNER JOIN
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

/*
GRANT INSERT, UPDATE ON Reserva TO funcionarios;
REVOKE INSERT, UPDATE ON Reserva FROM usuario_hotel;
*/

--USO DE RECORD e USO DE ESTRUTURA DE DADOS DO TIPO TABLE

DECLARE
    
    TYPE hospede_record IS RECORD (
        cpf  VARCHAR2(11),
        nome VARCHAR2(100),
        idade NUMBER
    );

    
    TYPE tabela_hospedes IS TABLE OF hospede_record INDEX BY PLS_INTEGER;

  
    v_hospedes tabela_hospedes;
BEGIN
   
    v_hospedes(1).cpf := '12345678901';
    v_hospedes(1).nome := 'João Silva';
    v_hospedes(1).idade := 30;

    v_hospedes(2).cpf := '23456789012';
    v_hospedes(2).nome := 'Maria Oliveira';
    v_hospedes(2).idade := 25;

    v_hospedes(3).cpf := '34567890123';
    v_hospedes(3).nome := 'Carlos Souza';
    v_hospedes(3).idade := 40;

    DBMS_OUTPUT.PUT_LINE('Lista de Hóspedes:');
    FOR i IN 1..v_hospedes.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Hóspede ' || i || ': ' ||
            'CPF: ' || v_hospedes(i).cpf || ', ' ||
            'Nome: ' || v_hospedes(i).nome || ', ' ||
            'Idade: ' || v_hospedes(i).idade
        );
    END LOOP;
END;
/

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

--CREATE PROCEDURE com USO DE PARÂMETROS (IN, OUT ou IN OUT)

--CREATE FUNCTION

CREATE OR REPLACE FUNCTION verificar_disponibilidade_quarto(
    p_num_quarto IN VARCHAR2,
    p_data_inicio IN DATE,
    p_data_fim IN DATE
) RETURN VARCHAR2
IS
    v_quarto_ocupado NUMBER;
BEGIN
    -- Verifica se há reservas com sobreposição de períodos
    SELECT COUNT(*)
    INTO v_quarto_ocupado
    FROM Reserva
    WHERE num_quarto = p_num_quarto
      AND (
          (TO_DATE(SUBSTR(periodo, 1, 10), 'YYYY-MM-DD') <= p_data_fim) AND
          (TO_DATE(SUBSTR(periodo, 14, 10), 'YYYY-MM-DD') >= p_data_inicio)
      );

    -- Retorna uma mensagem indicando se o quarto está disponível ou não
    IF v_quarto_ocupado = 0 THEN
        RETURN 'Quarto ' || p_num_quarto || ' está disponível para o período: ' || TO_CHAR(p_data_inicio, 'YYYY-MM-DD') || ' a ' || TO_CHAR(p_data_fim, 'YYYY-MM-DD');
    ELSE
        RETURN 'Quarto ' || p_num_quarto || ' NÃO está disponível para o período: ' || TO_CHAR(p_data_inicio, 'YYYY-MM-DD') || ' a ' || TO_CHAR(p_data_fim, 'YYYY-MM-DD');
    END IF;
END;
/
	
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

--%ROWTYPE com LOOP EXIT WHEN

--IF ELSIF
DECLARE
    v_cpf Funcionario.cpf_p%TYPE;
    v_cargo Funcionario.cargo%TYPE;
    v_categoria VARCHAR2(20);
BEGIN
   
    SELECT cpf_p, cargo INTO v_cpf, v_cargo
    FROM Funcionario
	WHERE cpf_p = '12345678901';   

    IF v_cargo = 'Gerente' THEN
        v_categoria := 'Administracao';
    ELSIF v_cargo = 'Camareira' THEN
        v_categoria := 'Limpeza';
    ELSE
        v_categoria := 'Atendimento';
    END IF;

    DBMS_OUTPUT.PUT_LINE('Funcionário: ' || v_cpf || ' - Categoria: ' || v_categoria);
END;

--CASE WHEN
SELECT P.nome, 
       F.cargo,
       CASE 
           WHEN P.cpf IS NULL THEN 'Apenas funcionário'
           WHEN F.cpf_p IS NULL THEN 'Apenas pessoa'
           ELSE 'Pessoa e funcionário'
       END AS status
FROM Pessoa P
FULL OUTER JOIN Funcionario F 
ON P.cpf = F.cpf_p;

--LOOP EXIT WHEN e %ROWTYPE
DECLARE
    CURSOR pessoa_cursor IS
        SELECT P.nome
        FROM Pessoa P
        JOIN Funcionario F ON P.cpf = F.cpf_p;
    pessoa_record pessoa_cursor%ROWTYPE;
BEGIN
    OPEN pessoa_cursor;
    LOOP
        FETCH pessoa_cursor INTO pessoa_record;
        EXIT WHEN pessoa_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Funcionario: ' || pessoa_record.nome);
    END LOOP;
    CLOSE pessoa_cursor;
END;

--WHILE LOOP
DECLARE
    v_contador NUMBER := 1;
    v_multa NUMBER;
BEGIN
    WHILE v_contador <= 3 LOOP  

        SELECT valor INTO v_multa
        FROM multa
        WHERE id_multa = v_contador;

        DBMS_OUTPUT.PUT_LINE('Multa encontrada para o contador ' || v_contador || ': ' || v_multa);
        
        v_contador := v_contador + 1;
    END LOOP;
END;

--FOR IN LOOP
DECLARE
    v_contador NUMBER := 1;
    v_multa NUMBER;
BEGIN
    FOR i IN 1..3 LOOP  
        
        SELECT valor INTO v_multa
        FROM multa
        WHERE id_multa = v_contador;

        DBMS_OUTPUT.PUT_LINE('Multa encontrada para o contador ' || v_contador || ': ' || v_multa);
        
        v_contador := v_contador + 1;
    END LOOP;
END;
/
	
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
CREATE TABLE log_table (
    id_log NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY, 
    info VARCHAR2(4000),
    data_log TIMESTAMP DEFAULT SYSTIMESTAMP
);

DECLARE
    v_nome VARCHAR(20) := 'Pedro Elias';
    v_resultado VARCHAR(100);
BEGIN
    BEGIN
        SELECT nome INTO v_resultado FROM Pessoa WHERE nome = v_nome;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            INSERT INTO log_table (info)
            VALUES ('Pessoa com nome ' || v_nome || ' não encontrada!');
    END;
END;
	
--USO DE PARÂMETROS (IN, OUT ou IN OUT) e CREATE PROCEDURE
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
        CURSOR pessoa_cursor IS SELECT cpf, nome FROM Pessoa;
        pessoa_record pessoa_cursor%ROWTYPE;
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
/

BEGIN
    util.listar_pessoas;
END;
/

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

