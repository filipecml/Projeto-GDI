CREATE TABLE Pagamento (
    id_pagamento NUMBER PRIMARY KEY,
    num_quarto VARCHAR2(10),
    periodo VARCHAR2(50),
    tipo_pagamento VARCHAR2(50),
    valor NUMBER(10, 2),
    data DATE,
    CONSTRAINT fk_pagamento_reserva FOREIGN KEY (num_quarto, periodo) REFERENCES Reserva(num_quarto, periodo)
);
/*
Pagamento(id pagamento, num_quarto*, período*,  tipo pagamento, valor, data)
	num_quarto, periodo referenciam Reserva(num_quarto, periodo)
*/
