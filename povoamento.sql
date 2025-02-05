-- Inserindo Pessoas
INSERT INTO Pessoa (cpf, nome, numero, rua, bairro) VALUES
('12345678901', 'João Silva', '101', 'Rua A', 'Centro'),
('23456789012', 'Maria Oliveira', '202', 'Rua B', 'Jardins'),
('34567890123', 'Carlos Souza', '303', 'Rua C', 'Vila Nova');

-- Inserindo Funcionários
INSERT INTO Funcionario (cpf_p, cargo, data_contratacao, cpf_orientador) VALUES
('12345678901', 'Gerente', TO_DATE('2022-01-15', 'YYYY-MM-DD'), NULL),
('23456789012', 'Recepcionista', TO_DATE('2023-03-20', 'YYYY-MM-DD'), '12345678901');

-- Inserindo Hóspedes
INSERT INTO Hospede (cpf_p) VALUES
('34567890123');

-- Inserindo Tipos de Quarto
INSERT INTO Tipo_quarto (tipo, valor) VALUES
('Standard', 100.00),
('Luxo', 250.00);

-- Inserindo Quartos
INSERT INTO Quarto (numero_quarto, tipo_quarto) VALUES
('101', 'Standard'),
('102', 'Luxo');

-- Inserindo Reservas
INSERT INTO Reserva (num_quarto, periodo) VALUES
('101', '2024-02-01 a 2024-02-07'),
('102', '2024-03-10 a 2024-03-15');

-- Inserindo Realizações de Reserva
INSERT INTO Realiza (num_quarto_reserva, periodo_reserva, hospede, funcionario, data_check_in, data_check_out) VALUES
('101', '2024-02-01 a 2024-02-07', '34567890123', '23456789012', TO_DATE('2024-02-01', 'YYYY-MM-DD'), TO_DATE('2024-02-07', 'YYYY-MM-DD'));

-- Inserindo Pagamentos
INSERT INTO Pagamento (id_pagamento, num_quarto, periodo, tipo_pagamento, valor, data) VALUES
(1, '101', '2024-02-01 a 2024-02-07', 'Cartão', 700.00, TO_DATE('2024-02-01', 'YYYY-MM-DD'));

-- Inserindo Multas
INSERT INTO Multa (id_multa, id_pagamento, num_quarto, periodo, tipo, valor) VALUES
(1, 1, '101', '2024-02-01 a 2024-02-07', 'Atraso Check-out', 50.00);

-- Inserindo Telefones
INSERT INTO Telefone (cpf_p, numero) VALUES
('12345678901', '11987654321'),
('23456789012', '11912345678'),
('34567890123', '11955556666');

-- Selecionando dados de cada tabela
SELECT * FROM Pessoa;
SELECT * FROM Funcionario;
SELECT * FROM Hospede;
SELECT * FROM Tipo_quarto;
SELECT * FROM Quarto;
SELECT * FROM Reserva;
SELECT * FROM Realiza;
SELECT * FROM Pagamento;
SELECT * FROM Multa;
SELECT * FROM Telefone;
