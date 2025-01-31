CREATE TABLE Reserva (
    num_quarto VARCHAR2(10),
    periodo VARCHAR2(50),
    CONSTRAINT fk_reserva_quarto FOREIGN KEY (num_quarto) REFERENCES Quarto(numero_quarto),
    CONSTRAINT pk_reserva PRIMARY KEY (num_quarto, periodo)
);
/*
Reserva(num quarto*, periodo)
	num_quarto referencia Quarto(numero_quarto)
*/