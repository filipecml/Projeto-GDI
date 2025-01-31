CREATE TABLE Fazer_Manutencao (
    cpf_funcionario VARCHAR2(11),
    numero_quarto VARCHAR2(10),
    CONSTRAINT fk_manutencao_funcionario FOREIGN KEY (cpf_funcionario) REFERENCES Funcionario(cpf_p),
    CONSTRAINT fk_manutencao_quarto FOREIGN KEY (numero_quarto) REFERENCES Quarto(numero_quarto),
    CONSTRAINT pk_manutencao PRIMARY KEY (cpf_funcionario, numero_quarto)
);
/*
Fazer Manutencao(cpf_funcionario*, numero_quarto*)
	cpf_funcionario referencia Funcionario(cpf_p)
	numero_quarto referencia Quarto(numero_quarto)
*/