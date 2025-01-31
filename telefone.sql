CREATE TABLE Telefone (
    cpf_p VARCHAR2(11),
    numero VARCHAR2(15),
    CONSTRAINT fk_telefone_pessoa FOREIGN KEY (cpf_p) REFERENCES Pessoa(cpf),
    CONSTRAINT pk_telefone PRIMARY KEY (cpf_p, numero)
);
/*
Telefone(cpf_p*, numero);
	cpf_p referencia Pessoa(cpf)
*/