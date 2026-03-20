-- =============================================================
-- Script de Inicialização do Banco de Dados
-- Projeto: Automação de Boletos — Condomínio Búzios
-- =============================================================

-- Criação da tabela principal de unidades e moradores
CREATE TABLE IF NOT EXISTS cadastro_unidades (
    id            SERIAL PRIMARY KEY,
    nome_morador  VARCHAR(255) NOT NULL,
    cpf           VARCHAR(14)  UNIQUE NOT NULL,  -- CPF usado como chave de busca no chatbot
    unidade       VARCHAR(50)  NOT NULL,
    bloco         VARCHAR(50),
    link_boleto   TEXT                            -- URL do PDF do boleto mais recente
);

-- Índice para otimizar a busca por CPF (consulta mais frequente)
CREATE INDEX IF NOT EXISTS idx_cpf ON cadastro_unidades(cpf);

-- =============================================================
-- Dados de exemplo para teste
-- (Substitua pelos dados reais via importação de CSV)
-- =============================================================
INSERT INTO cadastro_unidades (nome_morador, cpf, unidade, bloco, link_boleto)
VALUES
    ('Morador Teste A', '111.222.333-44', '101', 'A', 'https://exemplo.com/boletos/101A.pdf'),
    ('Morador Teste B', '555.666.777-88', '202', 'B', 'https://exemplo.com/boletos/202B.pdf')
ON CONFLICT (cpf) DO NOTHING;  -- Evita erro ao rodar o script mais de uma vez
