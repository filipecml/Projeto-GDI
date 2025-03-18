/* Cargo */
CREATE TABLE tb_cargo OF tp_cargo (
    cargo_funcionario PRIMARY KEY,
    salario NOT NULL
);
/

/* Tipo_Quarto */
CREATE TABLE tb_tipo_quarto OF tp_tipo_quarto (
    tipo PRIMARY KEY
);
/

/* Quarto */
CREATE TABLE tb_quarto OF tp_quarto (
    numero_quarto PRIMARY KEY,
    SCOPE FOR (tipo_quarto) IS tb_tipo_quarto
);
/

/* Reserva */
CREATE TABLE tb_reserva OF tp_reserva;
/
ALTER TABLE tb_reserva
ADD CONSTRAINT pk_reserva PRIMARY KEY (num_quarto, periodo);
/

/* Funcionário */
CREATE TABLE tb_funcionario OF tp_funcionario (
    cargo WITH ROWID REFERENCES tb_cargo,
    data_contratacao NOT NULL,
    SCOPE FOR (orientador) IS tb_funcionario,
    CONSTRAINT pk_funcionario PRIMARY KEY (cpf),
    CONSTRAINT fk_funcionario_pessoa FOREIGN KEY (cpf) REFERENCES tb_pessoa(cpf)
);
/

/* Pagamento */
CREATE TABLE tb_pagamento OF tp_pagamento (
    id_pagamento PRIMARY KEY,
    SCOPE FOR (num_quarto) IS tb_quarto,
    periodo NOT NULL,
    tipo_pagamento NOT NULL,
    valor NOT NULL,
    data_pagamento NOT NULL
);
/

/* Fazer Manutenção */
CREATE TABLE tb_fazer_manutencao OF tp_fazer_manutencao (
    CONSTRAINT pk_manutencao PRIMARY KEY (cpf_funcionario, numero_quarto),
    CONSTRAINT fk_fazer_manutencao_funcionario FOREIGN KEY (cpf_funcionario) REFERENCES tb_funcionario(cpf_p),
    CONSTRAINT fk_fazer_manutencao_quarto FOREIGN KEY (numero_quarto) REFERENCES tb_quarto(numero_quarto)
);
/

/* Hóspede */
CREATE TABLE tb_hospede OF tp_hospede (
    CONSTRAINT pk_hospede PRIMARY KEY (cpf_p),
    CONSTRAINT fk_hospede_pessoa FOREIGN KEY (cpf_p) REFERENCES tb_pessoa(cpf)
);
/

/* Multa */
CREATE TABLE tb_multa OF tp_multa (
    id_multa PRIMARY KEY,
    SCOPE FOR (id_pagamento) IS tb_pagamento,
    SCOPE FOR (num_quarto) IS tb_quarto,
    periodo NOT NULL,
    tipo NOT NULL,
    valor NOT NULL
);
/

/* Realiza */
CREATE TABLE tb_realiza OF tp_realiza (
    data_check_in NOT NULL,
    data_check_out NOT NULL,
    CONSTRAINT pk_realiza PRIMARY KEY (num_quarto_reserva, periodo_reserva, cpf_hospede, cpf_funcionario),
    CONSTRAINT fk_realiza_reserva FOREIGN KEY (num_quarto_reserva, periodo_reserva) REFERENCES tb_reserva(num_quarto, periodo),
    CONSTRAINT fk_realiza_hospede FOREIGN KEY (cpf_hospede) REFERENCES tb_hospede(cpf_p),
    CONSTRAINT fk_realiza_funcionario FOREIGN KEY (cpf_funcionario) REFERENCES tb_funcionario(cpf_p)
);
/