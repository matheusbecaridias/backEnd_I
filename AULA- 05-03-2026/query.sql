CREATE SCHEMA if not exists mynode;
USE mynode;
CREATE TABLE if not exists clientes(
id INT PRIMARY KEY AUTO_INCREMENT,
nome varchar(100) NOT NULL,
sexo varchar (50)
);
insert INTO clientes (nome, sexo) values 
('Abner', 'masculino'),
('Matheus','masculino'),
('Weslei','masculino'),
('Rosi', 'feminino');

select * from clientes;


CREATE SCHEMA if not exists exmynode;
USE exmynode;
CREATE TABLE if not exists Produtos(
id INT PRIMARY KEY AUTO_INCREMENT,
descricao varchar(100) NOT NULL,
quantidade int (50)
);
insert INTO Produtos (descricao, quantidade) values 
('Camisa', '6'),
('Calça','15'),
('Gravata','10'),
('Paletó', '20');

select * from Produtos;