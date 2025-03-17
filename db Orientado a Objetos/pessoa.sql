-- VARRAY (tabela telefones não existe mais)
CREATE TYPE tp_telefone AS VARRAY(5) OF VARCHAR2(15);

CREATE OR REPLACE TYPE tp_dependente AS OBJECT (
    nome VARCHAR2(100),
    parentesco VARCHAR2(50)
);

-- NESTED TABLE (foi inserido dependente em Pessoa)
CREATE TYPE tp_nt_dependente AS TABLE OF tp_dependente;

CREATE OR REPLACE TYPE tp_pessoa AS OBJECT (
    cpf VARCHAR2(11),
    nome VARCHAR2(100),
    numero VARCHAR2(11),
    rua VARCHAR2(100),
    bairro VARCHAR2(100),
    telefone tp_telefone,
    dependente tp_nt_dependente
);

CREATE TABLE tb_pessoa OF tp_pessoa (
    PRIMARY KEY (cpf)
)
NESTED TABLE dependente STORE AS dependente_nt;