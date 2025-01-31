CREATE TABLE Hospede (
    cpf_p VARCHAR2(11) PRIMARY KEY,
    CONSTRAINT fk_hospede_pessoa FOREIGN KEY (cpf_p) REFERENCES Pessoa(cpf)
);
/*
Hóspede (cpf_p*)
	cpf_p referencia Pessoa(cpf)
*/