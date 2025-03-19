/* Cargo */
CREATE OR REPLACE TYPE tp_cargo AS OBJECT (
    cargo_funcionario VARCHAR2(50),
    salario NUMBER(10, 2),
    MEMBER FUNCTION calcular_salarioAnual RETURN NUMBER
);

/* Método para calcular salário anual (MEMBER FUCTION) */
CREATE OR REPLACE TYPE BODY tp_cargo AS 
	MEMBER FUNCTION calcular_salarioAnual RETURN NUMBER IS
        salario_Anual NUMBER(10,2);
	BEGIN
        salario_Anual := salario*12;
		RETURN salario_Anual;
	END;
END;

/* Telefone*/
--(Com VARRAY)
 --CREATE TYPE tp_telefone_v AS VARRAY(5) OF VARCHAR2(15);

--(Com NESTED TABLE)
CREATE TYPE tp_telefone_nt AS OBJECT (
     numero VARCHAR2(15)
 );

 CREATE TYPE nt_telefone AS TABLE OF tp_telefone_nt;

/* Pessoa */
CREATE OR REPLACE TYPE tp_pessoa AS OBJECT (
    cpf VARCHAR2(11),
    nome VARCHAR2(100),
    numero VARCHAR2(11),
    rua VARCHAR2(100),
    bairro VARCHAR2(100),
    telefones nt_telefone,

    MEMBER PROCEDURE detalhes_pessoa
) NOT INSTANTIABLE NOT FINAL; 
/* A classe pessoa não pode ser instânciada de forma independente, pois precisa de subtipos para a instanciação dos objetos */ 

/* Método que detalha a pessoa (MEMBER PROCEDURE) */
CREATE OR REPLACE TYPE BODY tp_pessoa AS 
    MEMBER PROCEDURE detalhes_pessoa IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Nome: ' || nome || '.');
        DBMS_OUTPUT.PUT_LINE('CPF: ' || cpf || '.');
        DBMS_OUTPUT.PUT_LINE('Endereço: ' || rua || ', ' || numero || ', ' || bairro || '.');
    END;
END;

/* Tipo_Quarto */
CREATE OR REPLACE TYPE tp_tipo_quarto AS OBJECT (
    tipo VARCHAR2(50),
    valor NUMBER(10, 2)
);

/* Quarto */
CREATE OR REPLACE TYPE tp_quarto AS OBJECT (
    numero_quarto VARCHAR2(10),
    tipo_quarto REF tp_tipo_quarto
);

/* Reserva */
CREATE OR REPLACE TYPE tp_reserva AS OBJECT (
    num_quarto VARCHAR2(10),
    periodo VARCHAR2(50)
);

/* Criação da CONSTRUCTOR FUNCTION do tipo de objeto reserva */
CREATE OR REPLACE FUNCTION criar_reserva (
    num_quarto VARCHAR2, 
    periodo VARCHAR2
) RETURN tp_reserva IS
BEGIN
    RETURN tp_reserva(num_quarto, periodo);
END;

/* Funcionário */
CREATE OR REPLACE TYPE tp_funcionario UNDER tp_pessoa (
    cargo REF tp_cargo,
    data_contratacao DATE,
    orientador REF tp_funcionario,

    FINAL MEMBER FUNCTION calcular_bonus RETURN NUMBER
);
/

/* Método que retorna o tempo de contribuição de um funcionário (MAP MEMBER FUNCTION) */
CREATE OR REPLACE TYPE BODY tp_funcionario AS
    FINAL MEMBER FUNCTION calcular_bonus RETURN NUMBER IS
        bonus NUMBER(10, 2);
    BEGIN
        bonus := (SYSDATE - data_contratacao) * 0.1;
        RETURN bonus;
    END;
END;
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
);

/* Método que detalha o pagamento (MEMBER PROCEDURE) */
CREATE OR REPLACE TYPE BODY tp_pagamento AS 
    MEMBER PROCEDURE detalhes_pagamento IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Pagamento com ID: ' || id_pagamento || '.');
        DBMS_OUTPUT.PUT_LINE('Valor: ' || valor || '. Forma de pagamento: ' || tipo_pagamento || '.');
        DBMS_OUTPUT.PUT_LINE('Data de pagamento: ' || data_pagamento || '.');
    END;
END;

/* Fazer Manutenção */
CREATE OR REPLACE TYPE tp_fazer_manutencao AS OBJECT (
    cpf_funcionario VARCHAR2(11),
    numero_quarto VARCHAR2(10)
);

/* Hospede */
CREATE OR REPLACE TYPE tp_hospede UNDER tp_pessoa (
    OVERRIDING MEMBER PROCEDURE detalhes_pessoa -- Sobrescreve o método da superclasse
);
/

CREATE OR REPLACE TYPE BODY tp_hospede AS 
    OVERRIDING MEMBER PROCEDURE detalhes_pessoa IS
    BEGIN
        -- Chama o método da superclasse (tp_pessoa)
        (SELF AS tp_pessoa).detalhes_pessoa;

        -- Adiciona funcionalidades específicas do subtipo (tp_hospede)
        DBMS_OUTPUT.PUT_LINE('CPF do Hospede: ' || cpf || '.');
    END;
END;

/* Multa */
CREATE OR REPLACE TYPE tp_multa AS OBJECT (
    id_multa NUMBER,
    pagamento REF tp_pagamento,
    quarto REF tp_quarto,
    periodo VARCHAR2(50),
    tipo VARCHAR2(50),
    valor NUMBER(10, 2),

    ORDER MEMBER FUNCTION comparar_multas(p tp_multa) RETURN NUMBER
);

/* Método que compara valores de multas para determinar qual é maior (ORDER MEMBER FUNCTION) */
CREATE TYPE BODY tp_multa AS
    ORDER MEMBER FUNCTION comparar_multas(p tp_multa) RETURN NUMBER IS
    BEGIN
        IF self.valor < p.valor THEN
            RETURN -1; /* Multa menor */
        ELSIF self.valor = p.valor THEN
            RETURN 0; /* Multa maior */
        ELSE
            RETURN 1;
        END IF;
    END;
END;


/* Realiza */
CREATE OR REPLACE TYPE tp_realiza AS OBJECT (
    num_quarto_reserva VARCHAR2(10),
    periodo_reserva VARCHAR2(50),
    cpf_hospede VARCHAR2(11),
    cpf_funcionario VARCHAR2(11),
    data_check_in DATE,

    MAP MEMBER FUNCTION tempo_hospedado RETURN NUMBER
);
ALTER TYPE tp_realiza ADD ATTRIBUTE (data_check_out DATE) CASCADE;

/* Método que retorna o tempo de hospedagem de um quarto (MAP MEMBER) */
CREATE OR REPLACE TYPE BODY tp_realiza AS
    MAP MEMBER FUNCTION tempo_hospedado RETURN NUMBER IS
    BEGIN
        RETURN SYSDATE - data_check_in;
    END;
END;
