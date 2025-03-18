-- Inserir dados na tabela tb_cargo
INSERT INTO tb_cargo VALUES (tp_cargo('Gerente', 5000.00));
INSERT INTO tb_cargo VALUES (tp_cargo('Recepcionista', 2500.00));
INSERT INTO tb_cargo VALUES (tp_cargo('Camareira', 2000.00));
INSERT INTO tb_cargo VALUES (tp_cargo('Manutenção', 2200.00));

-- Inserir dados na tabela tb_pessoa
INSERT INTO tb_pessoa VALUES (
    tp_pessoa(
        '12345678901', 'João Silva', '123', 'Rua A', 'Centro',
        tp_telefone_nt('81987654321', '81987654322'),
    )
);

INSERT INTO tb_pessoa VALUES (
    tp_pessoa(
        '23456789012', 'Maria Oliveira', '456', 'Rua B', 'Boa Viagem',
        tp_telefone_nt('81987654323'),
    )
);

INSERT INTO tb_pessoa VALUES (
    tp_pessoa(
        '34567890123', 'Carlos Souza', '789', 'Rua C', 'Pina',
        tp_telefone_nt('81987654324'),
    )
);

-- Inserir dados na tabela tb_tipo_quarto
INSERT INTO tb_tipo_quarto VALUES (tp_tipo_quarto('Standard', 200.00));
INSERT INTO tb_tipo_quarto VALUES (tp_tipo_quarto('Luxo', 400.00));
INSERT INTO tb_tipo_quarto VALUES (tp_tipo_quarto('Suíte Presidencial', 800.00));

-- Inserir dados na tabela tb_quarto
INSERT INTO tb_quarto VALUES (
    tp_quarto(
        '101',
        (SELECT REF(t) FROM tb_tipo_quarto t WHERE t.tipo = 'Standard')
    )
);

INSERT INTO tb_quarto VALUES (
    tp_quarto(
        '201',
        (SELECT REF(t) FROM tb_tipo_quarto t WHERE t.tipo = 'Luxo')
    )
);

INSERT INTO tb_quarto VALUES (
    tp_quarto(
        '301',
        (SELECT REF(t) FROM tb_tipo_quarto t WHERE t.tipo = 'Suíte Presidencial')
    )
);

-- Inserir dados na tabela tb_reserva
INSERT INTO tb_reserva VALUES (tp_reserva('101', '2023-10-01 a 2023-10-05'));
INSERT INTO tb_reserva VALUES (tp_reserva('201', '2023-10-10 a 2023-10-15'));
INSERT INTO tb_reserva VALUES (tp_reserva('301', '2023-11-01 a 2023-11-07'));

-- Inserir dados na tabela tb_funcionario
INSERT INTO tb_funcionario VALUES (
    tp_funcionario(
        '12345678901',
        (SELECT REF(c) FROM tb_cargo c WHERE c.cargo_funcionario = 'Gerente'),
        TO_DATE('2020-01-15', 'YYYY-MM-DD'),
        NULL
    )
);

INSERT INTO tb_funcionario VALUES (
    tp_funcionario(
        '23456789012',
        (SELECT REF(c) FROM tb_cargo c WHERE c.cargo_funcionario = 'Recepcionista'),
        TO_DATE('2021-05-20', 'YYYY-MM-DD'),
        (SELECT REF(f) FROM tb_funcionario f WHERE f.cpf_p = '12345678901')
    )
);

-- Inserir dados na tabela tb_pagamento
INSERT INTO tb_pagamento VALUES (
    tp_pagamento(
        NULL,
        (SELECT REF(q) FROM tb_quarto q WHERE q.numero_quarto = '101'),
        '2023-10-01 a 2023-10-05',
        'Cartão de Crédito',
        1000.00,
        TO_DATE('2023-10-01', 'YYYY-MM-DD')
    )
);

INSERT INTO tb_pagamento VALUES (
    tp_pagamento(
        NULL,
        (SELECT REF(q) FROM tb_quarto q WHERE q.numero_quarto = '201'),
        '2023-10-10 a 2023-10-15',
        'Dinheiro',
        2000.00,
        TO_DATE('2023-10-10', 'YYYY-MM-DD')
    )
);

-- Inserir dados na tabela tb_hospede
INSERT INTO tb_hospede VALUES (tp_hospede('34567890123'));

-- Inserir dados na tabela tb_fazer_manutencao
INSERT INTO tb_fazer_manutencao VALUES (tp_fazer_manutencao('23456789012', '101'));

-- Inserir dados na tabela tb_multa
INSERT INTO tb_multa VALUES (
    tp_multa(
        NULL,
        (SELECT REF(p) FROM tb_pagamento p WHERE p.id_pagamento = 1),
        (SELECT REF(q) FROM tb_quarto q WHERE q.numero_quarto = '101'),
        '2023-10-01 a 2023-10-05',
        'Atraso no check-out',
        100.00
    )
);

-- Inserir dados na tabela tb_realiza
INSERT INTO tb_realiza VALUES (
    tp_realiza(
        '101',
        '2023-10-01 a 2023-10-05',
        '34567890123',
        '23456789012',
        TO_DATE('2023-10-01', 'YYYY-MM-DD'),
        TO_DATE('2023-10-05', 'YYYY-MM-DD')
    )
);
