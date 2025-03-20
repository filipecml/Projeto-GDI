-- Table tb_cargo
SELECT c.cargo_funcionario, c.salario, c.calcular_salarioAnual() AS salario_anual
FROM tb_cargo c;

-- Table tb_tipo_quarto
SELECT t.tipo, t.valor
FROM tb_tipo_quarto t;

-- Table tb_quarto
SELECT q.numero_quarto, DEREF(q.tipo_quarto).tipo AS tipo_quarto
FROM tb_quarto q;

-- Table tb_reserva
SELECT r.num_quarto, r.periodo
FROM tb_reserva r;

-- Table tb_funcionario
SELECT f.cpf, f.nome, f.data_contratacao, DEREF(f.cargo).cargo_funcionario AS cargo, 
       DEREF(f.orientador).nome AS nome_orientador, f.calcular_bonus() AS bonus
FROM tb_funcionario f;

-- Table tb_pagamento
SELECT p.id_pagamento, DEREF(p.quarto).numero_quarto AS numero_quarto, p.periodo, 
       p.tipo_pagamento, p.valor, p.data_pagamento
FROM tb_pagamento p;

-- Table tb_fazer_manutencao
SELECT fm.cpf_funcionario, fm.numero_quarto
FROM tb_fazer_manutencao fm;

-- Table tb_hospede
SELECT h.cpf, h.nome, h.numero, h.rua, h.bairro, t.numero AS telefone
FROM tb_hospede h, TABLE(h.telefones) t;

-- Table tb_multa
SELECT m.id_multa, DEREF(m.pagamento).id_pagamento AS id_pagamento, 
       DEREF(m.quarto).numero_quarto AS numero_quarto, m.periodo, m.tipo, m.valor
FROM tb_multa m;

-- Table tb_realiza
SELECT r.num_quarto_reserva, r.periodo_reserva, r.cpf_hospede, r.cpf_funcionario, 
       r.data_check_in, r.data_check_out, r.tempo_hospedado() AS tempo_hospedado
FROM tb_realiza r;