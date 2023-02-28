create database carteirinha_de_onibus;
use carteirinha_de_onibus;

create table Empresa (
id_Empresa int not null auto_increment,
cnpj varchar(20),
nome varchar(30) not null,
frotas int,
linhas varchar(80),
primary key (id_Empresa)
);

create table CartaoVirtual (
   id_CartaoVirtual int not null auto_increment,
   Qrcode int,
   nome varchar(25),
   email varchar(25),
   diasDeUso varchar(35),
   faculdade varchar(20),
   curso varchar(35),
   periodo int,
   senha varchar(12),
   primary key (id_CartaoVirtual)
);

create table Motorista (
  id_Motorista int not null auto_increment,
  id_Empresa int,
  nome varchar(50),
  cnh varchar (20),
  salario real,
  primary key (id_Motorista),
  foreign key (id_Empresa) references Empresa(id_Empresa)
);

create table Linha(
id_Linha int not null auto_increment,
partida varchar(20),
destino varchar(20),
primary key (id_Linha)
);

create table Onibus(
id_Onibus int not null auto_increment,
id_Linha int,
id_Motorista int,
id_Empresa int,
placa int,
qtd_Assentos int,
primary key (id_Onibus),
foreign key(id_Linha) references Linha(id_Linha),
foreign key(id_Motorista) references Motorista(id_Motorista),
foreign key(id_Empresa) references Empresa(id_Empresa)
);

create table Usuarios (
  id_Usuarios int not null auto_increment,
  id_CartaoVirtual int,
  id_Onibus int,
  primary key(id_Usuarios),
  foreign key(id_CartaoVirtual) references CartaoVirtual(id_CartaoVirtual),
  foreign key(id_Onibus) references Onibus(id_Onibus)
);

/*************** Inserção da Empresa ***************/
insert into Empresa (cnpj, nome, frotas, linhas) 
values (12345678901234, 'Via Express', 20, 'BAIRRO PALMEIRAS/DUVAL DE BARROS/FLAMENGO/BELO HORIZONTE');

/*************** Inserção das linhas ***************/
insert into Linha(partida, destino) values ('Bairro Palmeiras' , 'Duval de Barros'),
                                            ('Flamengo' , 'Belo Horizonte'),
                                            ('Sol Nascente' , 'Jatobá'),
                                            ('Água Branca' , 'Tancredo Neves'),
                                            ('Centro' , 'Varginha');
                                            
/*************** Inserção dos Motoristas ***************/

insert into Motorista (id_Empresa, nome, cnh, salario) values (1, 'Fernando', 'Categoria D', 1000 ),
                                                               (1, 'Maria', 'Categoria D', 1500),
                                                               (1, 'João', 'Categoria D', 2000),
                                                               (1, 'Gustavo', 'Categoria D', 2500);
                                                               
/*************** Inserindo dados do cartão virtual ***************/

insert into CartaoVirtual (Qrcode, nome, email, diasDeUso, faculdade, curso, periodo, senha) 
values (5, 'Matheus', 'matheus@gmail.com', 'Terça, Quarta, Quinta', 'FEPI', 'Sistemas de informação', 5, '12345678'),
       (3, 'Igor', 'igor@gmail.com', 'Terça, Quarta, Quinta', 'FEPI', 'Sistemas de informação', 4, '12345778'),
       (4, 'Felipe', 'felipe@gmail.com', 'Terça, Quarta, Quinta', 'FEPI', 'Medicina Veterinária', 3, '123456543'),
       (5, 'Roger', 'roger@gmail.com', 'Terça, Quarta, Quinta, Sexta', 'FEPI', 'Educação Física', 4, '12445669'),
       (9, 'Raissa', 'raissa@gmail.com', 'Segunda, Terça, Quarta, Quinta, Sexta', 'FEPI', 'Pedagogia', 1, '75445669'),
       (8, 'Ana Flavia', 'anaFlavia@gmail.com', 'Terça, Quinta, Sexta', 'FEPI', 'Pedagogia', 1, '75445669'),
       (2, 'Gabriel Silveira', 'gabriel.silveira@gmail.com', 'Quarta, Quinta, Sexta', 'FEPI', 'Engenharia de Produção', 8, '4679852');
       
/*************** Inserção do Ônibus ***************/
insert into Onibus (id_Linha ,id_Motorista ,id_Empresa, placa , qtd_Assentos) 
values (1, 1, 1, 1234, 35),
       (2, 2, 1, 1453, 40),
       (3, 3, 1, 1275, 45),
       (4, 3, 1, 9878, 50),
       (5, 4, 1, 4685, 55);
       
/*************** Inserção dos usuários ***************/
insert into Usuarios (id_CartaoVirtual, id_Onibus) values (1, 1),
                                                          (2, 1),
                                                          (3, 3),
                                                          (4, 2),
                                                          (5, 1),
                                                          (6, 1),
                                                          (7, 5);
                                                          
/*************** Consultas ***************/
-- Seleciona o nome e a cnh do motorista e a placa do ônibus quando estes estão em direção a Belo Horizonte
select M.nome, M.cnh, O.placa
from motorista as M, onibus as O
where M.id_motorista in (select O.id_motorista 
                        from onibus as O);
select M.nome, M.cnh
from motorista as M
where M.id_Motorista = (select O.id_motorista 
                        from onibus as O
                        where O.id_Linha = (select L.id_Linha
                                            from linha as L
                                            where L.destino = 'Belo Horizonte'));

-- Mostra o curso e o período de quem pega o ônibus com destino de Belo Horizonte
select C.nome, C.curso, C.periodo
from cartaovirtual as C
where C.id_CartaoVirtual = (select U.id_CartaoVirtual
                            from usuarios as U
                            where U.id_Onibus = (select O.id_Onibus
                                                from onibus as O
                                                where O.id_Linha = (select L.id_Linha
                                                                    from linha as L
                                                                    where L.destino = 'Belo Horizonte')));

/*************** Visão ***************/

/* Mostra as linhas da empresa */
create view linhas_da_empresaaa as
select E.nome, E.frotas, L.destino
from empresa as E, linha as L, onibus as O
where E.id_Empresa = O.id_Empresa and O.id_Linha = L.id_Linha;

select * from linhas_da_empresaaa;

/* Mostra as linhas da empresa (aninhada) */ 
create view linhas_da_empresa as
select E.nome, E.frotas, L.destino
from empresa as E, linha as L
where E.id_Empresa in (select O.id_Empresa
                      from onibus as O
                      where O.id_Linha in (select L.id_Linha
                                          from linha as L));
select * from linhas_da_empresa;

-- Quero saber a partida e o destino dos ônibus que tem mais de 40 lugares
create view onibus40 as
select L.partida, L.destino
from Linha as L
where L.id_Linha in (select O.id_Linha
                     from Onibus as O
                     where O.qtd_Assentos > 40);
                     
select * from onibus40;

/*************** Segurança ***************/
drop user 'chefe'@'localhost';
drop user 'admin'@'localhost';
drop user 'aluno'@'localhost';
drop user 'motorista'@'localhost';

create user 'chefe'@'localhost' identified by '1@chefe';
grant all on TDE_Buzz.* to '1@chefe';
show grants for '1@chefe';

create user 'admin'@'localhost' identified by '2@admin';
grant alter, create, select , update, delete on TDE_Buzz.Usuario to '2@admin';
grant alter, create, select, update, delete on TDE_Buzz.Motorista to '2@admin';
show grants for '2@admin'; 

create user 'aluno'@'localhost' identified by '3@aluno';
grant select (nome) on TDE_Buzz.Motorista to '3@aluno';
grant select (id_CartaoVirtual) on TDE_Buzz.Usuarios to '3@aluno';
show grants for '3@aluno';

create user 'motorista'@'localhost' identified by '4@motorista';
grant select (nome, email) on TDE_Buzz.CartaoVirtual to '4@motorista';
grant select (nome, cnh , salario) on TDE_Buzz.Motorista to '4@motorista';
show grants for '4@motorista';

/*************** Expressões condicionais e regulares ***************/

-- Cria uma coluna que mostra quais ônibus tem mais de 40 assentos
select placa, qtd_Assentos,
case 
    when qtd_Assentos > 40 then 'Esse ônibus tem mais de 40 assentos'
    else 'Esse ônibus tem menos que 40 assentos' end as qtdAssentos
from onibus;

-- Cria uma coluna que mostra quais ônibus que vão para Jatobá
select L.destino, O.placa,
case
    when L.destino = "Jatobá" then "Esse onibus tem Jatobá como destino"
    else "Esse onibus não tem Jatobá como destino" end as tem_destino
from linha as L, onibus as O;

-- Seleciona os cursos do cartão virtual que termine com a letra 'o'
select curso 
from CartaoVirtual
where curso LIKE '%o';

-- Seleciona os nomes dos motoristas que começa com Fe
select nome 
from Motorista
where nome regexp '^fe'; 

-- Exibe o nome, faculdade e período do aluno quando o salário do motorista começa com 20
select Cv.nome, Cv.faculdade, Cv.periodo, M.salario
from CartaoVirtual Cv, Motorista M
where M.salario regexp '^[20]';  
-- ???

-- Verifica se o email dos usuários é válido
select email,
		case 
			when email like '%@%' then 'Email Válido'
			else 'Não válido' end as tipoemail
from CartaoVirtual;

/*************** Procedimentos ***************/
-- Procedure que mostra alunos veteranos
DELIMITER $$
create procedure exibeAlunos()
begin
select C.nome, C.email
from CartaoVirtual as C
where C.periodo > 3;
end $$
DELIMITER ;

call exibeAlunos();

-- Procedure que conta a quantidade de ônibus presente na frota
DELIMITER $$
create procedure contaOnibus()
begin
select count(*) quantidade from Onibus;
end $$
DELIMITER ;

call contaOnibus();

-- Seleciona todos os motoristas com categoria D
DELIMITER $$
create procedure motoristasD(in categoria varchar(20))
begin
SELECT * 
 	FROM Motorista
	WHERE cnh = categoria;
end $$
DELIMITER ;

call motoristasD('Categoria D');
