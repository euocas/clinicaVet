CREATE DATABASE clinicaVet


/* Criar tabelas com PK */
CREATE TABLE cliente (
idCliente INT PRIMARY KEY AUTO_INCREMENT,
nomeCliente VARCHAR(50) NOT NULL,
cpf CHAR(11) NOT NULL UNIQUE,
celular CHAR(11) NOT NULL,
email VARCHAR(50) NOT NULL,
cidade VARCHAR(50) NOT NULL,
estado CHAR(2) NOT NULL,
cep CHAR(8),
tipoLogradouro VARCHAR(15) NOT NULL, 
nomeLogradouro VARCHAR(60) NOT NULL,
numero VARCHAR(6) NOT NULL,
complemento VARCHAR(30)
)
 
/*exclui a tabela e respectivos dados*/
DROP TABLE cliente
 
/*Criando tabela sem FK */ 
CREATE TABLE contatoTelefonico (
idContatoTelefonico INT PRIMARY KEY, 
idcliente INT NOT NULL, /*deveria ser FK*/ 
ddi VARCHAR(5) NOT NULL,
ddd VARCHAR(5) NOT NULL,
numero CHAR(9) NOT NULL
)
 
/*Alterando a tabela anterior adicionando a FK*/
ALTER TABLE contatotelefonico
ADD CONSTRAINT fk_contatoTelefonico_Cliente
FOREIGN KEY (idCliente) REFERENCES cliente(idCliente)
 
/*Criando tabela com FK*/
CREATE TABLE Animal(
idAnimal INT PRIMARY KEY AUTO_INCREMENT,
idcliente INT NOT NULL, 
nomeAnimal VARCHAR(50) NOT NULL,
especie VARCHAR(50) NOT NULL,
raca VARCHAR(50) NOT NULL,
peso DECIMAL(5,2),
porte CHAR(1), 
sexo CHAR(1),
anoNascimento INT NOT NULL,
CONSTRAINT ck_sexoAnimal CHECK (sexo='M' OR sexo='F'),
CONSTRAINT ck_porteAnimal CHECK (porte IN ('P','M','G')),
CONSTRAINT fk_Animal_Cliente FOREIGN KEY (idcliente) 
REFERENCES cliente(idcliente)
)
 
CREATE TABLE TipoServico(
idTipoServico INT PRIMARY KEY AUTO_INCREMENT,
nomeServico VARCHAR(50) NOT NULL,
valor DECIMAL(10,2) NOT NULL
)

CREATE TABLE Veterinario(
idVeterinario INT PRIMARY KEY AUTO_INCREMENT,
nomeVeterinario VARCHAR(50) NOT NULL,
crmv VARCHAR(20) NOT NULL UNIQUE,
celular CHAR(11) NOT NULL,
especialidade VARCHAR(50)
)

CREATE TABLE Consulta (
idConsulta INT PRIMARY KEY AUTO_INCREMENT,
idAnimal INT NOT NULL,
idVeterinario INT NOT NULL,
dataHora DATETIME NOT NULL,
pago BIT NOT NULL, /*0 ou 1*/
formaPagto VARCHAR(50) NOT NULL,
qtdVezes TINYINT,
valorTotal DECIMAL(10,2) NOT NULL,
valorPago DECIMAL(10,2),
CONSTRAINT fk_Consulta_Animal FOREIGN KEY (idAnimal)
REFERENCES animal(idAnimal),
CONSTRAINT fk_Consulta_Veterinario FOREIGN KEY (idVeterinario)
REFERENCES veterinario(idVeterinario),
CONSTRAINT ck_qtdVezes CHECK 
(qtdVezes IN (1,2,3,4,5,6,7,8,9,10)),
CONSTRAINT ck_formaPgto CHECK 
(formaPagto IN ('DINHEIRO','PIX','DÉBITO','CRÉDITO','OUTROS'))
)
 
CREATE TABLE ConsultaTipoServico(
idConsultaTipoServico INT PRIMARY KEY AUTO_INCREMENT,
idConsulta INT NOT NULL,
idtipoServico INT NOT NULL,
valorServico DECIMAL(10,2),
CONSTRAINT fk_ConsultaTipoServico_tipoServico FOREIGN KEY 
(idtipoServico) REFERENCES tipoServico(idtipoServico),
CONSTRAINT fk_ConsultaTipoServico_Consulta FOREIGN KEY 
(idConsulta) REFERENCES Consulta(idConsulta)
)


/*=====================ADICÇÃO DE CLIENTE=====================*/
INSERT INTO cliente 
(nomeCliente, cpf, celular, email, cidade, estado, cep, tipoLogradouro, nomeLogradouro, numero, complemento)
VALUES
('Mariana Souza', '12345678901', '11987654321', 'mariana.souza@email.com', 'São Paulo', 'SP', '04567000', 'Rua', 'das Flores', '123', 'Apto 12'),
 
('Carlos Henrique Lima', '98765432100', '21991234567', 'carlos.lima@email.com', 'Rio de Janeiro', 'RJ', '22040002', 'Avenida', 'Atlântica', '500', NULL),
 
('Fernanda Oliveira Martins', '45678912345', '31999887766', 'fernanda.martins@email.com', 'Belo Horizonte', 'MG', '30140071', 'Rua', 'da Bahia', '850', 'Sala 305');

/*=====================LISTAR NOME DE CIDADE E ESTADO DE TODOS OS CLIENTES=====================*/
SELECT nomeCliente,cidade,estado  FROM cliente

/*=====================LISTAR NOME E O SEU NÚMERO TELEFONICO=====================*/
SELECT nomeCliente, ddi, ddd, contatotelefonico.numero FROM cliente INNER JOIN contatotelefonico

/*=====================INSERÇÃO DO CONTATO TELEFONICO=====================*/
INSERT INTO contatotelefonico (idcliente, ddi, ddd, numero)
VALUES
(1, '55', '13', '988776655'),
(2, '55', '13', '988776655'),
(3, '55', '13', '988776655');


ALTER TABLE contatotelefonico 
MODIFY idcontatotelefonico INT NOT NULL AUTO_INCREMENT;

/*=====================JOIN=====================*/

SELECT nomeCliente, ddi, ddd, contatotelefonico.numero FROM cliente INNER JOIN contatotelefonico
ON cliente.idcliente = contatotelefonico.idcliente


INSERT INTO animal (idCliente, nomeAnimal, especie, raca, peso, porte, sexo, anoNascimento)
VALUES
(1, 'Bidu', 'Cachorro', 'Beagle',12.3,'M','M',2020),
(2, 'Penelope', 'Gato', 'Frajola',8.82,'M','F',2021),
(2, 'Tom','Gato','Frajola',9.22,'M','M',2019),
(3, 'Cofap','Cachorro','Basset',9.11,'P','M',2018)




/**/


INSERT INTO veterinario
(nomeVeterinario, crmv, celular, especialidade)
VALUES 
('Beatriz Costa', '12345SP','13988745265','Cirurgia Veterinaria'),
('Agamenom Mendes','54321RJ', '219854615322', 'Ortopedia Veterinaria'),
('José Manuel Lopez', '54874SP', '1398565412', 'Cardiologia Veterinaria');

INSERT INTO veterinario
(nomeVeterinario, crmv, celular, especialidade)
VALUES
('Gabriel da Silva', '13076/SP', '13996676512', 'Patologia Veterinaria'),
('Pamela Silveira', '32013/SP', '11991376982', 'Cirugia Veterinaria'),
('Bruna Gomes', '60491/BA', '85996676512', 'Dermatologia Veterinaria');

UPDATE veterinario
SET nomeVeterinario = 'Hugo Costa'
WHERE idVeterinario=1

UPDATE veterinario
SET nomeVeterinario = 'Cristina Mendes'
WHERE idVeterinario=2

UPDATE veterinario
SET nomeVeterinario = 'José Manuel Lopez Mendonza'
WHERE idVeterinario=3

INSERT INTO tipoServico  (nomeServico , valor )
VALUES 
('Banho/Tosa' , 90.00),
('Castração' , 200.00),
('Vacina' , 150.00),
('MicroChipagem' , 300.00),
('Ultrasom', 350.00);


INSERT INTO consulta
(idAnimal, idVeterinario, dataHora, pago, formaPagto, qtdVezes, valorTotal, valorPago)
VALUES
(
(SELECT idAnimal FROM animal WHERE nomeAnimal = 'Bidu'),
1,
NOW(),
1,
'Cartão',
1,
150.00,
150.00
);
INSERT INTO consulta
(idAnimal, idVeterinario, dataHora, pago, formaPagto, qtdVezes, valorTotal, valorPago)
VALUES
(
(SELECT idAnimal FROM animal WHERE nomeAnimal = 'Bidu'),
1,
NOW(),
1,
'Pix',
1,
90.00,
90.00
);

INSERT INTO consultatiposervico 
(idconsulta, idTipoServico, valorServico)
VALUES
(1,3,150.00),
(2,1,90.00);

INSERT INTO consulta (idanimal, idVeterinario, datahora, pago, formapagto, qtdvezes, valortotal, valorpago)
VALUES
(5, 2, '2026-03-10 14:30:00', 0, 'Dinheiro', '0', 90.00, NULL),
(6, 2, '2026-01-25 09:00:00', 1, 'Pix', '0', 150.00, 150.00), 
(7, 2, '2026-03-29 18:00:00', 0, 'Crédito', '2', 300.00, NULL);

INSERT INTO consultatiposervico (idconsulta,idtiposervico, valorservico)
VALUES
(2, 1, 90.00), 
(1, 3, 150.00), 
(17, 4, 300.00)

INSERT INTO consulta (idAnimal, idVeterinario, dataHora, pago, formaPagto, qtdVezes, valorTotal, valorPago)
VALUES
(5, 3, '2026-03-03 10:00', 1, 'PIX', 1, 350.00, 350.00),
(6, 3, '2026-03-04 12:00', 1, 'Credito', 2, 150.00, 150.00)
 
INSERT INTO consultatiposervico(idConsulta, idTipoServico, valorServico)
VALUES
(17, 5, 350.00),
(16, 3, 150.00)

INSERT INTO consulta(idAnimal, idVeterinario, dataHora, pago, formaPagto, qtdVezes, valorTotal, valorPago)
VALUES
(5,1,'2026-03-14 13:00:00', 'S','dinheiro',1,'300.00','300.00'),
(6,3,'2026-03-14 16:30:00', 'S','credito',3,'300.00','300.00'),
(7,3,'2026-03-17 08:10:00', 'S','pix',1,'150.00','150.00');

INSERT INTO consultatiposervico(idConsulta, valorServico, idTipoServico)
VALUES
(17,'300.00',4),
(17,'300.00',4),
(1,'150.00',3);

/*=====================SELECT==========================*/
SELECT * FROM veterinario;
SELECT * FROM animal;
SELECT * FROM cliente;
SELECT * FROM tiposervico;
SELECT * FROM consulta;
SELECT * FROM consultatiposervico;


/*JOIN MANIPULAÇÃO AVANÇADA*/

SELECT consulta.dataHora, 
		 a.nomeAnimal,
		 c.nomeCliente,
		 veterinario.nomeVeterinario
FROM cliente c
INNER JOIN animal a
ON c.idCliente = a.idCliente
INNER JOIN consulta
ON a.idAnimal = consulta.idAnimal
INNER JOIN veterinario
ON consulta.idVeterinario = veterinario.idVeterinario
