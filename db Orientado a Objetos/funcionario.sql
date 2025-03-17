-- REF
CREATE TYPE tp_funcionario AS OBJECT (
    cpf_p REF tp_pessoa,
    cargo VARCHAR2(50),
    data_contratacao DATE,
    cpf_orientador REF tp_funcionario
);

-- SCOPE IS
CREATE TABLE tb_funcionario OF tp_funcionario (
    SCOPE FOR (cpf_p) IS tb_pessoa,
    SCOPE FOR (cpf_orientador) IS tb_funcionario
);