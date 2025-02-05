CREATE TABLE Realiza (
    num_quarto_reserva VARCHAR2(10),
    periodo_reserva VARCHAR2(50),
    hospede VARCHAR2(11),
    funcionario VARCHAR2(11),
    data_check_in DATE,
    data_check_out DATE,
    CONSTRAINT fk_realiza_reserva FOREIGN KEY (num_quarto_reserva, periodo_reserva) REFERENCES Reserva(num_quarto, periodo),
    CONSTRAINT fk_realiza_hospede FOREIGN KEY (hospede) REFERENCES Hospede(cpf_p),
    CONSTRAINT fk_realiza_funcionario FOREIGN KEY (funcionario) REFERENCES Funcionario(cpf_p),
    CONSTRAINT pk_realiza PRIMARY KEY (num_quarto_reserva, periodo_reserva, hospede, funcionario)
);
/*
Realiza(num quarto reserva*, periodo reserva*, hospede*, funcionario*, data_check_in, data_check_out)
    hospede referencia Hospede(cpf_p)
	num_quarto_reserva, periodo_reserva referenciam Reserva(num_quarto, periodo)
    uncionario referencia Funcionario(cpf_p)
*/