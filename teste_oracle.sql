/* Cargo */
CREATE OR REPLACE TYPE tp_cargo AS OBJECT (
    cargo_funcionario VARCHAR2(50),
    salario NUMBER(10, 2),
    MEMBER FUNCTION calcular_salarioAnual RETURN NUMBER
);
/
/* Método para calcular salário anual (MEMBER FUCTION) */
CREATE OR REPLACE TYPE BODY tp_cargo AS 
	MEMBER FUNCTION calcular_salarioAnual RETURN NUMBER IS
        salario_Anual NUMBER(10,2);
	BEGIN
        salario_Anual := salario*12;
		RETURN salario_Anual;
	END;
END;
/
/* Telefone*/
CREATE TYPE tp_telefone AS VARRAY(5) OF VARCHAR2(15);
/
/* Dependente */

CREATE OR REPLACE TYPE tp_dependente AS OBJECT (
    nome VARCHAR2(100),
    parentesco VARCHAR2(50)
);
/
CREATE TYPE tp_nt_dependente AS TABLE OF tp_dependente;
/
/* Pessoa */
CREATE OR REPLACE TYPE tp_pessoa AS OBJECT (
    cpf VARCHAR2(11),
    nome VARCHAR2(100),
    numero VARCHAR2(11),
    rua VARCHAR2(100),
    bairro VARCHAR2(100),
    telefone tp_telefone,
    dependente tp_nt_dependente,

    MEMBER PROCEDURE detalhes_pessoa
) NOT INSTANTIABLE NOT FINAL; 
/
/* Método que detalha a pessoa (MEMBER PROCEDURE) */
CREATE OR REPLACE TYPE BODY tp_pessoa AS 
    MEMBER PROCEDURE detalhes_pessoa IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Nome: ' || nome || '.');
        DBMS_OUTPUT.PUT_LINE('CPF: ' || cpf || '.');
        DBMS_OUTPUT.PUT_LINE('Endereço: ' || rua || ', ' || numero || ', ' || bairro || '.');
    END;
END;
/
/* Tipo_Quarto */
CREATE OR REPLACE TYPE tp_tipo_quarto AS OBJECT (
    tipo VARCHAR2(50),
    valor NUMBER(10, 2)
);
/
/* Quarto */
CREATE OR REPLACE TYPE tp_quarto AS OBJECT (
    numero_quarto VARCHAR2(10),
    tipo_quarto REF tp_tipo_quarto
) 
/
/* Reserva */
CREATE OR REPLACE TYPE tp_reserva AS OBJECT (
    num_quarto VARCHAR2(10),
    periodo VARCHAR2(50)
);
/
/* Funcionário */
CREATE OR REPLACE TYPE tp_funcionario UNDER tp_pessoa (
    cargo REF tp_cargo,
    data_contratacao DATE,
    orientador REF tp_funcionario
);
/
/* Pagamento */
CREATE OR REPLACE TYPE tp_pagamento AS OBJECT (
    id_pagamento NUMBER,
    quarto REF tp_quarto,
    periodo VARCHAR2(50),
    tipo_pagamento VARCHAR2(50),
    valor NUMBER(10, 2),
    data_pagamento DATE,

    MEMBER PROCEDURE detalhes_pagamento
) 
/
/* Método que detalha o pagamento (MEMBER PROCEDURE) */
CREATE OR REPLACE TYPE BODY tp_pagamento AS 
    MEMBER PROCEDURE detalhes_pagamento IS
    BEGIN
        -- Exibindo os detalhes do pagamento
        DBMS_OUTPUT.PUT_LINE('Pagamento com ID: ' || id_pagamento || '.');
        DBMS_OUTPUT.PUT_LINE('Valor: ' || valor || '. Forma de pagamento: ' || tipo_pagamento || '.');
        DBMS_OUTPUT.PUT_LINE('Data de pagamento: ' || data_pagamento || '.');
    END;
END;
/
/* Fazer Manutenção */
CREATE OR REPLACE TYPE tp_fazer_manutencao AS OBJECT (
    cpf_funcionario VARCHAR2(11),
    numero_quarto VARCHAR2(10)
);
/
/* Hóspede */
CREATE OR REPLACE TYPE tp_hospede UNDER tp_pessoa (
    data_nascimento DATE
);
/
/* Multa */
CREATE OR REPLACE TYPE tp_multa AS OBJECT (
    id_multa NUMBER,
    pagamento REF tp_pagamento,
    quarto REF tp_quarto,
    periodo VARCHAR2(50),
    tipo VARCHAR2(50),
    valor NUMBER(10, 2)
);
/
/* Realiza */
CREATE OR REPLACE TYPE tp_realiza AS OBJECT (
    num_quarto_reserva VARCHAR2(10),
    periodo_reserva VARCHAR2(50),
    cpf_hospede VARCHAR2(11),
    cpf_funcionario VARCHAR2(11),
    data_check_in DATE,
    data_check_out DATE
);
/

/* Cargo */
CREATE TABLE tb_cargo OF tp_cargo (
    cargo_funcionario PRIMARY KEY,
    salario NOT NULL
);
/

/* Pessoa */
CREATE TABLE tb_pessoa OF tp_pessoa (
    PRIMARY KEY (cpf),
    nome NOT NULL,
    CONSTRAINT nome_check CHECK (REGEXP_LIKE(nome, '^[A-Za-zÀ-ÿ\~\´\^[:space:]]+$')),
    CONSTRAINT cpf_check CHECK (LENGTH(cpf) = 11 AND REGEXP_LIKE(cpf, '^\d{11}$')) 
)
NESTED TABLE telefones STORE AS telefones_nt;
/

/* Tipo_Quarto */
CREATE TABLE tb_tipo_quarto OF tp_tipo_quarto (
    tipo PRIMARY KEY
);
/

/* Quarto */
CREATE TABLE tb_quarto OF tp_quarto (
    numero_quarto PRIMARY KEY,
    SCOPE FOR (tipo_quarto) IS tb_tipo_quarto
);
/

/* Reserva */
CREATE TABLE tb_reserva OF tp_reserva (
    numero_quarto VARCHAR2(10),
    periodo VARCHAR2(50) NOT NULL,
    CONSTRAINT pk_reserva PRIMARY KEY (numero_quarto, periodo),
    CONSTRAINT fk_reserva_num_quarto FOREIGN KEY (numero_quarto) REFERENCES tb_quarto(numero_quarto)
);
/

/* Funcionário */
CREATE TABLE tb_funcionario OF tp_funcionario (
    cargo WITH ROWID REFERENCES tb_cargo,
    data_contratacao NOT NULL,
    SCOPE FOR (orientador) IS tb_funcionario,
    CONSTRAINT pk_funcionario PRIMARY KEY (cpf),
    CONSTRAINT fk_funcionario_pessoa FOREIGN KEY (cpf) REFERENCES tb_pessoa(cpf)
);
/

/* Pagamento */
CREATE TABLE tb_pagamento OF tp_pagamento (
    id_pagamento PRIMARY KEY,
    SCOPE FOR (num_quarto) IS tb_quarto,
    periodo NOT NULL,
    tipo_pagamento NOT NULL,
    valor NOT NULL,
    data_pagamento NOT NULL
);
/

/* Fazer Manutenção */
CREATE TABLE tb_fazer_manutencao OF tp_fazer_manutencao (
    CONSTRAINT pk_manutencao PRIMARY KEY (cpf_funcionario, numero_quarto),
    CONSTRAINT fk_fazer_manutencao_funcionario FOREIGN KEY (cpf_funcionario) REFERENCES tb_funcionario(cpf_p),
    CONSTRAINT fk_fazer_manutencao_quarto FOREIGN KEY (numero_quarto) REFERENCES tb_quarto(numero_quarto)
);
/

/* Hóspede */
CREATE TABLE tb_hospede OF tp_hospede (
    CONSTRAINT pk_hospede PRIMARY KEY (cpf_p),
    CONSTRAINT fk_hospede_pessoa FOREIGN KEY (cpf_p) REFERENCES tb_pessoa(cpf)
);
/

/* Multa */
CREATE TABLE tb_multa OF tp_multa (
    id_multa PRIMARY KEY,
    SCOPE FOR (id_pagamento) IS tb_pagamento,
    SCOPE FOR (num_quarto) IS tb_quarto,
    periodo NOT NULL,
    tipo NOT NULL,
    valor NOT NULL
);
/

/* Realiza */
CREATE TABLE tb_realiza OF tp_realiza (
    data_check_in NOT NULL,
    data_check_out NOT NULL,
    CONSTRAINT pk_realiza PRIMARY KEY (num_quarto_reserva, periodo_reserva, cpf_hospede, cpf_funcionario),
    CONSTRAINT fk_realiza_reserva FOREIGN KEY (num_quarto_reserva, periodo_reserva) REFERENCES tb_reserva(num_quarto, periodo),
    CONSTRAINT fk_realiza_hospede FOREIGN KEY (cpf_hospede) REFERENCES tb_hospede(cpf_p),
    CONSTRAINT fk_realiza_funcionario FOREIGN KEY (cpf_funcionario) REFERENCES tb_funcionario(cpf_p)
);
/

CREATE SEQUENCE seq_pagamento
    START WITH 1
    INCREMENT BY 1
    NOCACHE;
/

CREATE SEQUENCE seq_multa
    START WITH 1
    INCREMENT BY 1
    NOCACHE;
/

CREATE OR REPLACE TRIGGER trg_pagamento
BEFORE INSERT ON tb_pagamento
FOR EACH ROW
BEGIN
    IF :NEW.id_pagamento IS NULL THEN
        :NEW.id_pagamento := seq_pagamento.NEXTVAL;
    END IF;
END;

CREATE OR REPLACE TRIGGER trg_multa
BEFORE INSERT ON tb_multa
FOR EACH ROW
BEGIN
    IF :NEW.id_multa IS NULL THEN
        :NEW.id_multa := seq_multa.NEXTVAL;
    END IF;
END;

ALTER TYPE tp_pessoa MODIFY ATTRIBUTE (numero VARCHAR2(15));

-- Inserir dados na tabela tb_cargo
INSERT INTO tb_cargo VALUES (tp_cargo('Gerente', 5000.00));
INSERT INTO tb_cargo VALUES (tp_cargo('Recepcionista', 2500.00));
INSERT INTO tb_cargo VALUES (tp_cargo('Camareira', 2000.00));
INSERT INTO tb_cargo VALUES (tp_cargo('Manutenção', 2200.00));

-- Inserir dados na tabela tb_tipo_quarto
INSERT INTO tb_tipo_quarto VALUES (tp_tipo_quarto('Standard', 200.00));
INSERT INTO tb_tipo_quarto VALUES (tp_tipo_quarto('Luxo', 400.00));
INSERT INTO tb_tipo_quarto VALUES (tp_tipo_quarto('Suíte Presidencial', 800.00));

-- Inserir dados na tabela tb_quarto
INSERT INTO tb_quarto VALUES (
    tp_quarto(
        '101',
        (SELECT REF(t) FROM tb_tipo_quarto t WHERE t.tipo = 'Standard')
    )
);

INSERT INTO tb_quarto VALUES (
    tp_quarto(
        '201',
        (SELECT REF(t) FROM tb_tipo_quarto t WHERE t.tipo = 'Luxo')
    )
);

INSERT INTO tb_quarto VALUES (
    tp_quarto(
        '301',
        (SELECT REF(t) FROM tb_tipo_quarto t WHERE t.tipo = 'Suíte Presidencial')
    )
);

-- Inserir dados na tabela tb_reserva
INSERT INTO tb_reserva VALUES (tp_reserva('101', '2023-10-01 a 2023-10-05'));
INSERT INTO tb_reserva VALUES (tp_reserva('201', '2023-10-10 a 2023-10-15'));
INSERT INTO tb_reserva VALUES (tp_reserva('301', '2023-11-01 a 2023-11-07'));

-- Inserir dados na tabela tb_funcionario
INSERT INTO tb_funcionario VALUES (
    tp_funcionario(
        '12345678901',
        (SELECT REF(c) FROM tb_cargo c WHERE c.cargo_funcionario = 'Gerente'),
        TO_DATE('2020-01-15', 'YYYY-MM-DD'),
        NULL
    )
);

INSERT INTO tb_funcionario VALUES (
    tp_funcionario(
        '23456789012',
        (SELECT REF(c) FROM tb_cargo c WHERE c.cargo_funcionario = 'Recepcionista'),
        TO_DATE('2021-05-20', 'YYYY-MM-DD'),
        (SELECT REF(f) FROM tb_funcionario f WHERE f.cpf_p = '12345678901')
    )
);

-- Inserir dados na tabela tb_pagamento
INSERT INTO tb_pagamento VALUES (
    tp_pagamento(
        NULL,
        (SELECT REF(q) FROM tb_quarto q WHERE q.numero_quarto = '101'),
        '2023-10-01 a 2023-10-05',
        'Cartão de Crédito',
        1000.00,
        TO_DATE('2023-10-01', 'YYYY-MM-DD')
    )
);

INSERT INTO tb_pagamento VALUES (
    tp_pagamento(
        NULL,
        (SELECT REF(q) FROM tb_quarto q WHERE q.numero_quarto = '201'),
        '2023-10-10 a 2023-10-15',
        'Dinheiro',
        2000.00,
        TO_DATE('2023-10-10', 'YYYY-MM-DD')
    )
);

-- Inserir dados na tabela tb_hospede
INSERT INTO tb_hospede VALUES (tp_hospede('34567890123'));

-- Inserir dados na tabela tb_fazer_manutencao
INSERT INTO tb_fazer_manutencao VALUES (tp_fazer_manutencao('23456789012', '101'));

-- Inserir dados na tabela tb_multa
INSERT INTO tb_multa VALUES (
    tp_multa(
        NULL,
        (SELECT REF(p) FROM tb_pagamento p WHERE p.id_pagamento = 1),
        (SELECT REF(q) FROM tb_quarto q WHERE q.numero_quarto = '101'),
        '2023-10-01 a 2023-10-05',
        'Atraso no check-out',
        100.00
    )
);

-- Inserir dados na tabela tb_realiza
INSERT INTO tb_realiza VALUES (
    tp_realiza(
        '101',
        '2023-10-01 a 2023-10-05',
        '34567890123',
        '23456789012',
        TO_DATE('2023-10-01', 'YYYY-MM-DD'),
        TO_DATE('2023-10-05', 'YYYY-MM-DD')
    )
);


