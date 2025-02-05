CREATE TABLE Pessoa (
    cpf VARCHAR2(11) PRIMARY KEY,
    nome VARCHAR2(100) NOT NULL,
    numero VARCHAR2(11),
    rua VARCHAR2(100),
    bairro VARCHAR2(100),
    CONSTRAINT nome_check CHECK (REGEXP_LIKE(nome, '^[A-Za-zÀ-ÿ\~\´\^[:space:]]+$')),
    CONSTRAINT cpf_check CHECK (LENGTH(cpf) = 11 and REGEXP_LIKE(cpf, '^\d{11}$'))
);
/*
Pessoa(cpf, nome, número, rua, bairro)
*/
