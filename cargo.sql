CREATE TABLE Cargo (
    cargo_funcionario VARCHAR2(50) PRIMARY KEY,
    salario NUMBER(10, 2)
);
/*
Cargo(cargo_funcionário*, salário)
		cargo_funcionário referencia Funcionário(cargo)
*/