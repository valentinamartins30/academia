CREATE TABLE alunos (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    cpf VARCHAR(11) UNIQUE NOT NULL,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE planos (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    valor_mensal_base NUMERIC(10,2) NOT NULL CHECK (valor_mensal_base > 0)
);

CREATE TABLE modalidades (
    id SERIAL PRIMARY KEY,
    plano_id INTEGER NOT NULL,
    sala VARCHAR(200) NOT NULL,
    capacidade_max NUMERIC NOT NULL CHECK (capacidade_max > 0),
    disponivel BOOLEAN DEFAULT TRUE
);

CREATE TABLE matriculas (
    id SERIAL PRIMARY KEY,
    aluno_id INTEGER NOT NULL,
	status VARCHAR(20) DEFAULT 'em aberto' CHECK (status IN ('em aberto', 'concluida', 'cancelada')), 
    data_inicio TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE itens_matricula (
    id SERIAL PRIMARY KEY,
    matricula_id INTEGER NOT NULL,
	modalidade_id INTEGER NOT NULL,
	duracao_meses NUMERIC not null check (duracao_meses > 0),
	valor_mensal_aplicado NUMERIC not null check (valor_mensal_aplicado > 0),
	taxa_adesao numeric not null check (taxa_adesao >= 0)
);

insert into alunos (nome, email, telefone, cpf) VALUES
('Valen', 'valen@gmail.com', '48984700357', '05235211030'),
('Bella', 'bella@gmail.com', '46578930789', '36574890274'),
('Madu', 'madu@gmail.com', '4758391036', '08946738928'),
('Lucca', 'lucca@gmail.com', '09876543214', '00094125066')

insert into planos (nome, valor_mensal_base) VALUES
('VIP Premium', '300.00'),
('Fitness Standard', '150.00'),
('Basic Fit', '100.00'),
('Plano Black', '160.00')

