CREATE TABLE Quarto (
    numero_quarto VARCHAR2(10) PRIMARY KEY,
    tipo_quarto VARCHAR2(50),
    CONSTRAINT fk_quarto_tipo FOREIGN KEY (tipo_quarto) REFERENCES Tipo_quarto(tipo)
);
/*
Quarto(numero quarto, tipo_quarto)
*/