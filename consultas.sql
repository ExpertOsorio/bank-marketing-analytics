-- ========================================================================
-- PROJETO DE ANÁLISE DE DADOS: CAMPANHA DE MARKETING BANCÁRIO (UCI)
-- Banco de Dados: SQLite (bank.db) | Tabela: clientes_campanha
-- Autor: Osório Júnior
-- ========================================================================

-- ------------------------------------------------------------------------
-- 1. TAXA GERAL DE CONVERSÃO DA CAMPANHA
-- Objetivo: Identificar o percentual macro de sucesso da campanha.
-- ------------------------------------------------------------------------
SELECT 
    COUNT(*) AS total_contactados,
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS total_aderiram,
    SUM(CASE WHEN y = 'no' THEN 1 ELSE 0 END) AS total_recusaram,
    ROUND(CAST(SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100, 2) AS taxa_conversao_pct
FROM clientes_campanha;


-- ------------------------------------------------------------------------
-- 2. EFICIÊNCIA DE CONVERSÃO POR PROFISSÃO (JOB SEGMENT)
-- Objetivo: Revelar quais nichos profissionais mais compram depósitos a prazo.
-- ------------------------------------------------------------------------
SELECT 
    job AS profissao,
    COUNT(*) AS total_contactados,
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS total_aderiram,
    ROUND(CAST(SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100, 2) AS taxa_conversao_pct
FROM clientes_campanha
GROUP BY job
ORDER BY taxa_conversao_pct DESC;


-- ------------------------------------------------------------------------
-- 3. FADIGA OPERACIONAL DE CAMPANHA (NÚMERO DE LIGAÇÕES)
-- Objetivo: Medir a partir de quantas chamadas a insistência vira prejuízo.
-- ------------------------------------------------------------------------
SELECT 
    CASE 
        WHEN campaign = 1 THEN '1 contato'
        WHEN campaign = 2 THEN '2 contatos'
        WHEN campaign = 3 THEN '3 contatos'
        WHEN campaign BETWEEN 4 AND 5 THEN '4 a 5 contatos'
        ELSE '6 ou mais contatos'
    END AS faixa_tentativas,
    COUNT(*) AS total_contactados,
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS total_aderiram,
    ROUND(CAST(SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100, 2) AS taxa_conversao_pct
FROM clientes_campanha
GROUP BY faixa_tentativas
ORDER BY taxa_conversao_pct DESC;


-- ------------------------------------------------------------------------
-- 4. DURAÇÃO DA CHAMADA TELEFÔNICA (CALL DURATION)
-- Objetivo: Avaliar a diferença de tempo de conversa entre 'SIM' e 'NÃO'.
-- ------------------------------------------------------------------------
SELECT 
    y AS decisao_cliente,
    COUNT(*) AS volume_chamadas,
    ROUND(AVG(duration), 1) AS duracao_media_segundos,
    ROUND(AVG(duration) / 60.0, 1) AS duracao_media_minutos,
    MIN(duration) AS menor_chamada_seg,
    MAX(duration) AS maior_chamada_seg
FROM clientes_campanha
GROUP BY y;


-- ------------------------------------------------------------------------
-- 5. VALOR DO HISTÓRICO ANTERIOR DO CLIENTE (POUTCOME)
-- Objetivo: Identificar a probabilidade de recompra de clientes antigos.
-- ------------------------------------------------------------------------
SELECT 
    poutcome AS resultado_campanha_anterior,
    COUNT(*) AS total_clientes,
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS total_aderiram,
    ROUND(CAST(SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100, 2) AS taxa_conversao_pct
FROM clientes_campanha
GROUP BY poutcome
ORDER BY taxa_conversao_pct DESC;


-- ------------------------------------------------------------------------
-- 6. SAÚDE FINANCEIRA E SALDO EM CONTA (BALANCE)
-- Objetivo: Analisar se clientes endividados ou com saldo zero aderem a depósitos.
-- ------------------------------------------------------------------------
SELECT 
    CASE 
        WHEN balance < 0 THEN '1. Saldo Negativo (Devedor)'
        WHEN balance = 0 THEN '2. Saldo Zero'
        WHEN balance BETWEEN 1 AND 1000 THEN '3. Saldo Baixo (1 a 1.000)'
        WHEN balance BETWEEN 1001 AND 5000 THEN '4. Saldo Medio (1.001 a 5.000)'
        ELSE '5. Saldo Alto (> 5.000)'
    END AS faixa_saldo,
    COUNT(*) AS total_clientes,
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS total_aderiram,
    ROUND(CAST(SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100, 2) AS taxa_conversao_pct
FROM clientes_campanha
GROUP BY faixa_saldo
ORDER BY faixa_saldo;
