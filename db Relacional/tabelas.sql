CREATE TABLE Cargo (
    cargo_funcionario VARCHAR2(50) PRIMARY KEY,
    salario NUMBER(10, 2)
);
/*
Cargo(cargo_funcionário*, salário)
		cargo_funcionário referencia Funcionário(cargo)
*/


CREATE TABLE Pessoa (
    cpf VARCHAR2(11) PRIMARY KEY,
    nome VARCHAR2(100) NOT NULL,
    numero VARCHAR2(11),
    rua VARCHAR2(100),
    bairro VARCHAR2(100),
    CONSTRAINT nome_check CHECK (REGEXP_LIKE(nome, '^[A-Za-zÀ-ÿ\~\´\^[:space:]]+$')),
    CONSTRAINT cpf_check CHECK (LENGTH(cpf) = 11 and REGEXP_LIKE(cpf, '^\d{11}$'))
);
/*
Pessoa(cpf, nome, número, rua, bairro)
*/


CREATE TABLE Tipo_quarto (
    tipo VARCHAR2(50) PRIMARY KEY,
    valor NUMBER(10, 2)
);
/*
Tipo_quarto(tipo*, valor)
tipo referencia Quarto(tipo_quarto)
*/  


CREATE TABLE Quarto (
    numero_quarto VARCHAR2(10) PRIMARY KEY,
    tipo_quarto VARCHAR2(50),
    CONSTRAINT fk_quarto_tipo FOREIGN KEY (tipo_quarto) REFERENCES Tipo_quarto(tipo)
);
/*
Quarto(numero quarto, tipo_quarto)
*/


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


CREATE TABLE Pagamento (
    id_pagamento NUMBER GENERATED BY DEFAULT AS IDENTITY 
        START WITH 1 
        INCREMENT BY 1 
        PRIMARY KEY,
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


CREATE TABLE Hospede (
    cpf_p VARCHAR2(11) PRIMARY KEY,
    CONSTRAINT fk_hospede_pessoa FOREIGN KEY (cpf_p) REFERENCES Pessoa(cpf)
);
/*
Hóspede (cpf_p*)
	cpf_p referencia Pessoa(cpf)
*/


CREATE TABLE Multa (
    id_multa NUMBER GENERATED BY DEFAULT AS IDENTITY 
        START WITH 1 
        INCREMENT BY 1 
        PRIMARY KEY,
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