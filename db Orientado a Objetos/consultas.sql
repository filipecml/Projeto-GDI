-- SELECT REF
DECLARE
    v_funcionario tp_funcionario;
    v_cargo REF tp_cargo;
    v_cargo_nome VARCHAR2(50);
BEGIN
    SELECT VALUE(f), f.cargo INTO v_funcionario, v_cargo
    FROM tb_funcionario f
    WHERE f.cpf = '12345678901';

    SELECT c.cargo_funcionario INTO v_cargo_nome
    FROM tb_cargo c
    WHERE REF(c) = v_cargo;

    DBMS_OUTPUT.PUT_LINE('Funcionário: ' || v_funcionario.nome);
    DBMS_OUTPUT.PUT_LINE('Cargo: ' || v_cargo_nome);
END;
/

-- SELECT DEREF
DECLARE
    v_funcionario tp_funcionario;
    v_cargo tp_cargo;
BEGIN
    SELECT VALUE(f), DEREF(f.cargo) INTO v_funcionario, v_cargo
    FROM tb_funcionario f
    WHERE f.cpf = '12345678901';

    DBMS_OUTPUT.PUT_LINE('Funcionário: ' || v_funcionario.nome);
    DBMS_OUTPUT.PUT_LINE('Cargo: ' || v_cargo.cargo_funcionario);
    DBMS_OUTPUT.PUT_LINE('Salário: ' || v_cargo.salario);
END;
/

-- CONSULTA À VARRAY
DECLARE
    v_telefones tp_telefone_v; 
BEGIN
    SELECT telefones INTO v_telefones
    FROM tb_funcionario
    WHERE cpf = '12345678901';

    FOR i IN 1 .. v_telefones.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('Telefone ' || i || ': ' || v_telefones(i));
    END LOOP;
END;
/

-- CONSULTA À NESTED TABLE  
DECLARE
    v_telefones nt_telefone; 
BEGIN
    SELECT telefones INTO v_telefones
    FROM tb_funcionario
    WHERE cpf = '12345678901';

    FOR i IN 1 .. v_telefones.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('Telefone ' || i || ': ' || v_telefones(i).numero);
    END LOOP;
END;
/

-- calcular_salarioAnual
DECLARE
    v_cargo tp_cargo;
    v_salario_anual NUMBER; 
BEGIN
    SELECT VALUE(c) INTO v_cargo
    FROM tb_cargo c
    WHERE c.cargo_funcionario = 'Gerente';

    v_salario_anual := v_cargo.calcular_salarioAnual();

    DBMS_OUTPUT.PUT_LINE('Salário Anual do Gerente: ' || v_salario_anual);
END;
/

DECLARE
    v_funcionario tp_funcionario; 
    v_cargo tp_cargo;
    v_salario_anual NUMBER; 
BEGIN
    SELECT VALUE(f) INTO v_funcionario
    FROM tb_funcionario f
    WHERE f.cpf = '12345678901';

    SELECT DEREF(v_funcionario.cargo) INTO v_cargo
    FROM DUAL;

    v_salario_anual := v_cargo.calcular_salarioAnual();

    DBMS_OUTPUT.PUT_LINE('Salário Anual do Funcionário: ' || v_salario_anual);
END;
/

-- criar_reserva
DECLARE
    v_nova_reserva tp_reserva; 
BEGIN
    v_nova_reserva := criar_reserva('102', '2023-12-01 a 2023-12-05');

    INSERT INTO tb_reserva VALUES (v_nova_reserva);

    DBMS_OUTPUT.PUT_LINE('Reserva criada com sucesso:');
    DBMS_OUTPUT.PUT_LINE('Número do Quarto: ' || v_nova_reserva.num_quarto);
    DBMS_OUTPUT.PUT_LINE('Período: ' || v_nova_reserva.periodo);
END;
/
SELECT num_quarto, periodo
FROM tb_reserva
WHERE num_quarto = '102';

-- calcular_bonus
DECLARE
    v_funcionario tp_funcionario; 
    v_bonus NUMBER; 
BEGIN
    SELECT VALUE(f) INTO v_funcionario
    FROM tb_funcionario f
    WHERE f.cpf = '12345678901';

    v_bonus := v_funcionario.calcular_bonus();

    DBMS_OUTPUT.PUT_LINE('Bônus do Funcionário: ' || v_bonus);
END;
/

-- calcular_bonus
DECLARE
    v_bonus NUMBER;
    CURSOR c_funcionarios IS
        SELECT VALUE(f) AS funcionario
        FROM tb_funcionario f;
BEGIN
    FOR r_funcionario IN c_funcionarios LOOP

        v_bonus := r_funcionario.funcionario.calcular_bonus();

        DBMS_OUTPUT.PUT_LINE('Funcionário: ' || r_funcionario.funcionario.nome || ', Bônus: ' || v_bonus);
    END LOOP;
END;
/

-- comparar_multas
DECLARE
    v_multa1 tp_multa; 
    v_multa2 tp_multa; 
    v_resultado NUMBER; 
BEGIN

    SELECT VALUE(m) INTO v_multa1
    FROM tb_multa m
    WHERE m.id_multa = 1;

    SELECT VALUE(m) INTO v_multa2
    FROM tb_multa m
    WHERE m.id_multa = 2;

    v_resultado := v_multa1.comparar_multas(v_multa2);

    IF v_resultado = -1 THEN
        DBMS_OUTPUT.PUT_LINE('Multa 1 é menor que Multa 2.');
    ELSIF v_resultado = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Multa 1 é igual à Multa 2.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Multa 1 é maior que Multa 2.');
    END IF;
END;
/
SELECT m1.id_multa AS multa1_id,
       m2.id_multa AS multa2_id,
       m1.comparar_multas(m2) AS resultado_comparacao
FROM tb_multa m1, tb_multa m2
WHERE m1.id_multa = 1 AND m2.id_multa = 2;

-- tempo_hospedado
DECLARE
    v_realiza tp_realiza; 
    v_tempo_hospedado NUMBER;
BEGIN
    SELECT VALUE(r) INTO v_realiza
    FROM tb_realiza r
    WHERE r.num_quarto_reserva = '101'
      AND r.periodo_reserva = '2023-10-01 a 2023-10-05';

    v_tempo_hospedado := v_realiza.tempo_hospedado();

    DBMS_OUTPUT.PUT_LINE('Tempo de hospedagem: ' || v_tempo_hospedado || ' dias.');
END;
/


DECLARE
    v_tempo_hospedado NUMBER;
    CURSOR c_realiza IS
        SELECT VALUE(r) AS realiza
        FROM tb_realiza r;
BEGIN
    FOR r_realiza IN c_realiza LOOP
        v_tempo_hospedado := r_realiza.realiza.tempo_hospedado();

        DBMS_OUTPUT.PUT_LINE('Reserva no quarto ' || r_realiza.realiza.num_quarto_reserva || ', Tempo de hospedagem: ' || v_tempo_hospedado || ' dias.');
    END LOOP;
END;
/

-- detalhes_pessoa
DECLARE
    v_funcionario tp_funcionario;
BEGIN
    SELECT VALUE(f) INTO v_funcionario
    FROM tb_funcionario f
    WHERE f.cpf = '12345678901';

    v_funcionario.detalhes_pessoa();
END;
/
DECLARE
    v_hospede tp_hospede;
BEGIN
    SELECT VALUE(h) INTO v_hospede
    FROM tb_hospede h
    WHERE h.cpf = '34567890123';

    v_hospede.detalhes_pessoa();
END;
/

-- detalhes_pagamento
DECLARE
    v_pagamento tp_pagamento;
BEGIN
    SELECT VALUE(p) INTO v_pagamento
    FROM tb_pagamento p
    WHERE p.id_pagamento = 1;

    v_pagamento.detalhes_pagamento();
END;
/
DECLARE
    CURSOR c_pagamentos IS
        SELECT VALUE(p) AS pagamento
        FROM tb_pagamento p;
BEGIN
    FOR r_pagamento IN c_pagamentos LOOP
        r_pagamento.pagamento.detalhes_pagamento();
        DBMS_OUTPUT.PUT_LINE('-----------------------------');
    END LOOP;
END;
/

-- detalhes_pessoa
DECLARE
    CURSOR c_funcionarios IS
        SELECT VALUE(f) AS funcionario
        FROM tb_funcionario f;

    CURSOR c_hospedes IS
        SELECT VALUE(h) AS hospede
        FROM tb_hospede h;
BEGIN
    FOR r_funcionario IN c_funcionarios LOOP
        DBMS_OUTPUT.PUT_LINE('Detalhes do Funcionário:');
        r_funcionario.funcionario.detalhes_pessoa();
        DBMS_OUTPUT.PUT_LINE('-----------------------------');
    END LOOP;

    FOR r_hospede IN c_hospedes LOOP
        DBMS_OUTPUT.PUT_LINE('Detalhes do Hóspede:');
        r_hospede.hospede.detalhes_pessoa();
        DBMS_OUTPUT.PUT_LINE('-----------------------------');
    END LOOP;
END;
/


DECLARE
    v_funcionario tp_funcionario;
BEGIN
    SELECT VALUE(f) INTO v_funcionario
    FROM tb_funcionario f
    WHERE f.cpf = '12345678901';

    v_funcionario.detalhes_pessoa();
END;
/

DECLARE
    v_hospede tp_hospede;
BEGIN
    SELECT VALUE(h) INTO v_hospede
    FROM tb_hospede h
    WHERE h.cpf = '34567890123';

    v_hospede.detalhes_pessoa();
END;
/

DECLARE
    CURSOR c_funcionarios IS
        SELECT VALUE(f) AS funcionario
        FROM tb_funcionario f;

    CURSOR c_hospedes IS
        SELECT VALUE(h) AS hospede
        FROM tb_hospede h;
BEGIN
    FOR r_funcionario IN c_funcionarios LOOP
        DBMS_OUTPUT.PUT_LINE('Detalhes do Funcionário:');
        r_funcionario.funcionario.detalhes_pessoa();
        DBMS_OUTPUT.PUT_LINE('-----------------------------');
    END LOOP;

    FOR r_hospede IN c_hospedes LOOP
        DBMS_OUTPUT.PUT_LINE('Detalhes do Hóspede:');
        r_hospede.hospede.detalhes_pessoa();
        DBMS_OUTPUT.PUT_LINE('-----------------------------');
    END LOOP;
END;
/

