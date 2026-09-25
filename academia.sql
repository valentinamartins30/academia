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

ALTER TABLE modalidades add column nome VARCHAR(200) not null

insert into modalidades (plano_id, sala, capacidade_max, disponivel, nome) VALUES
(1, 'Arena 01', 30, 'yes', 'Crossfit Pro'),
(2,'Studio 02', 15, 'no', 'Pilates Avançado'),
(3,'Academia', 100, 'yes', 'Musculação Livre')


INSERT into matriculas (aluno_id) values
(1),
(2),
(3),
(4)

INSERT INTO itens_matricula (matricula_id, modalidade_id,duracao_meses,valor_mensal_aplicado,taxa_adesao) VALUES
(1, 1, 12, 300.00, 50.00),
(2, 2, 6, 150.00, 30.00),
(3, 3, 3, 100.00, 20.00),
(4, 1, 12, 300.00, 50.00)

CREATE VIEW vw_modalidades_custo_estimado AS
SELECT 
    m.nome AS modalidade,
    m.sala,
    p.nome AS plano,
    (p.valor_mensal_base * 1.10) AS valor_mensal_ajustado
FROM 
    modalidades m
JOIN 
    planos p ON m.plano_id = p.id
ORDER BY 
    valor_mensal_ajustado DESC;

CREATE VIEW vw_matriculas_ativas AS
SELECT 
    a.nome AS aluno,
    a.cpf,
 	m_mod.nome AS modalidade,
    m_mod.sala,
    i.duracao_meses,
    m.data_inicio
FROM 
    matriculas m
JOIN 
    alunos a ON m.aluno_id = a.id
JOIN 
    itens_matricula i ON i.matricula_id = m.id
JOIN 
    modalidades m_mod ON i.modalidade_id = m_mod.id
WHERE 
    m.status = 'em aberto';

    CREATE OR REPLACE VIEW vw_alunos_vip AS
SELECT 
    a.nome AS aluno,
    COUNT(m.id) AS contratos_ativos,
    SUM((i.valor_mensal_aplicado * i.duracao_meses) + i.taxa_adesao) AS total_investido
FROM 
    alunos a
JOIN 
    matriculas m ON m.aluno_id = a.id
JOIN 
    itens_matricula i ON i.matricula_id = m.id
WHERE 
    m.status = 'em aberto'
GROUP BY a.nome
HAVING SUM((i.valor_mensal_aplicado * i.duracao_meses) + i.taxa_adesao) > 1000.00;

SELECT 
    m.nome AS modalidade,
    m.capacidade_max,
    m.sala,
    p.nome AS plano,
    p.valor_mensal_base
FROM 
    modalidades m
JOIN 
    planos p ON m.plano_id = p.id
WHERE 
    m.capacidade_max >= 15
    AND p.valor_mensal_base > 100.00
    AND m.disponivel = TRUE;
CREATE VIEW vw_faturamento_medio_plano AS
SELECT 
    p.nome AS plano,
    SUM((i.valor_mensal_aplicado * i.duracao_meses) + i.taxa_adesao) AS faturamento_total,
    ROUND(AVG(i.duracao_meses), 1) AS media_duracao_meses
FROM 
    planos p
JOIN 
    modalidades m ON m.plano_id = p.id
JOIN 
    itens_matricula i ON i.modalidade_id = m.id
JOIN 
    matriculas mat ON i.matricula_id = mat.id
WHERE 
    mat.status = 'em aberto'
GROUP BY 
    p.nome;

