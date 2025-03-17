CREATE OR REPLACE TRIGGER trg_pagamento
BEFORE INSERT ON tb_pagamento
FOR EACH ROW
BEGIN
    IF :NEW.id_pagamento IS NULL THEN
        :NEW.id_pagamento := seq_pagamento.NEXTVAL;
    END IF;
END;

CREATE OR REPLACE TRIGGER trg_multa
BEFORE INSERT ON tb_multa
FOR EACH ROW
BEGIN
    IF :NEW.id_multa IS NULL THEN
        :NEW.id_multa := seq_multa.NEXTVAL;
    END IF;
END;