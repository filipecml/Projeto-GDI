CREATE TABLE Funcionario (
    cpf_p VARCHAR2(11) PRIMARY KEY,
    cargo VARCHAR2(50),
    data_contratacao DATE,
    cpf_orientador VARCHAR2(11),
    CONSTRAINT fk_funcionario_pessoa FOREIGN KEY (cpf_p) REFERENCES Pessoa(cpf),
    CONSTRAINT fk_funcionario_orientador FOREIGN KEY (cpf_orientador) REFERENCES Funcionario(cpf_p)
);
/*
Funcionário(cpf_p*, cargo, data_contratação, cpf_orientador*)
    cpf_p referencia Pessoa(cpf)
    cpf_orientador referencia Funcionário(cpf_p)
*/