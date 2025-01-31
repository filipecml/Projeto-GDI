CREATE TABLE Multa (
    id_multa NUMBER PRIMARY KEY,
    id_pagamento NUMBER,
    num_quarto VARCHAR2(10),
    periodo VARCHAR2(50),
    tipo VARCHAR2(50),
    valor NUMBER(10, 2),
    CONSTRAINT fk_multa_pagamento FOREIGN KEY (id_pagamento) REFERENCES Pagamento(id_pagamento),
    CONSTRAINT fk_multa_reserva FOREIGN KEY (num_quarto, periodo) REFERENCES Reserva(num_quarto, periodo)
);
/*
Multa(id multa, id_pagamento*, num_quarto*, periodo*,  tipo, valor)
    id_pagamento referencia Pagamento(id_pagamento)
	num_quarto, periodo referenciam Reserva(num_quarto, periodo)
*/