-- =====================================================
-- SCRIPT DE CRIAÇÃO DO BANCO DE DADOS EXMYNODE
-- =====================================================

-- Remover banco de dados existente (opcional - cuidado em produção!)
-- DROP DATABASE IF EXISTS exmynode;

-- Criar banco de dados com configurações otimizadas
CREATE DATABASE IF NOT EXISTS exmynode
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

-- Selecionar o banco de dados
USE exmynode;

-- =====================================================
-- TABELA: produtos
-- =====================================================
CREATE TABLE IF NOT EXISTS produtos (
    -- Chave primária
    codProduto INT AUTO_INCREMENT PRIMARY KEY,
    
    -- Colunas de informação
    descricao VARCHAR(80) NOT NULL,
    quantidade INT NOT NULL DEFAULT 0,
    preco DECIMAL(10,2) DEFAULT 0.00,
    
    -- Colunas de auditoria
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    status ENUM('ativo', 'inativo') DEFAULT 'ativo',
    
    -- Índices para melhor performance
    INDEX idx_descricao (descricao),
    INDEX idx_status (status),
    
    -- Constraints
    CONSTRAINT chk_quantidade CHECK (quantidade >= 0),
    CONSTRAINT chk_preco CHECK (preco >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- FUNÇÕES E PROCEDURES
-- =====================================================

-- Procedure para inserir produto com validação
DELIMITER //
CREATE PROCEDURE IF NOT EXISTS sp_inserir_produto(
    IN p_descricao VARCHAR(80),
    IN p_quantidade INT,
    IN p_preco DECIMAL(10,2)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Erro ao inserir produto' AS mensagem;
    END;
    
    START TRANSACTION;
    
    INSERT INTO produtos (descricao, quantidade, preco)
    VALUES (p_descricao, p_quantidade, p_preco);
    
    COMMIT;
    SELECT 'Produto inserido com sucesso' AS mensagem;
END//
DELIMITER ;

-- Procedure para atualizar quantidade
DELIMITER //
CREATE PROCEDURE IF NOT EXISTS sp_atualizar_quantidade(
    IN p_codProduto INT,
    IN p_nova_quantidade INT
)
BEGIN
    UPDATE produtos 
    SET quantidade = p_nova_quantidade,
        data_atualizacao = CURRENT_TIMESTAMP
    WHERE codProduto = p_codProduto;
    
    SELECT ROW_COUNT() AS linhas_afetadas;
END//
DELIMITER ;

-- =====================================================
-- VIEWS
-- =====================================================

-- View para produtos ativos
CREATE OR REPLACE VIEW vw_produtos_ativos AS
SELECT 
    codProduto,
    descricao,
    quantidade,
    preco,
    data_cadastro,
    CASE 
        WHEN quantidade = 0 THEN 'Esgotado'
        WHEN quantidade < 5 THEN 'Estoque Baixo'
        ELSE 'Estoque Normal'
    END AS status_estoque
FROM produtos
WHERE status = 'ativo';

-- View para resumo do estoque
CREATE OR REPLACE VIEW vw_resumo_estoque AS
SELECT 
    COUNT(*) AS total_produtos,
    SUM(quantidade) AS total_itens_estoque,
    AVG(quantidade) AS media_itens_por_produto,
    SUM(quantidade * preco) AS valor_total_estoque,
    COUNT(CASE WHEN quantidade = 0 THEN 1 END) AS produtos_esgotados,
    COUNT(CASE WHEN quantidade < 5 AND quantidade > 0 THEN 1 END) AS produtos_estoque_baixo
FROM produtos
WHERE status = 'ativo';

-- =====================================================
-- TRIGGERS
-- =====================================================

-- Trigger para log de inserções
DELIMITER //
CREATE TRIGGER trg_produtos_insert_audit
AFTER INSERT ON produtos
FOR EACH ROW
BEGIN
    INSERT INTO produtos_audit (codProduto, acao, dados_antigos, dados_novos, data_acao)
    VALUES (NEW.codProduto, 'INSERT', NULL, 
            CONCAT('{"descricao":"', NEW.descricao, '","quantidade":', NEW.quantidade, '}'),
            NOW());
END//
DELIMITER ;

-- =====================================================
-- TABELA DE AUDITORIA
-- =====================================================
CREATE TABLE IF NOT EXISTS produtos_audit (
    id_audit INT AUTO_INCREMENT PRIMARY KEY,
    codProduto INT,
    acao VARCHAR(10),
    dados_antigos TEXT,
    dados_novos TEXT,
    data_acao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_audit_produto (codProduto),
    INDEX idx_audit_data (data_acao)
);

-- =====================================================
-- INSERÇÃO DE DADOS INICIAIS
-- =====================================================

-- Limpar dados existentes (cuidado!)
-- TRUNCATE TABLE produtos;

-- Inserir produtos com mais informações
INSERT INTO produtos (descricao, quantidade, preco, data_cadastro) VALUES
('Mesa de Escritório', 5, 299.90, NOW()),
('Cadeira Gamer', 10, 899.90, NOW()),
('Mouse Óptico', 8, 49.90, NOW()),
('Teclado Mecânico', 3, 199.90, NOW()),
('Monitor 24"', 2, 899.90, NOW()),
('Notebook', 4, 2499.90, NOW()),
('Fone de Ouvido', 15, 89.90, NOW()),
('Webcam HD', 6, 159.90, NOW());

-- Inserir usando a procedure
CALL sp_inserir_produto('SSD 480GB', 12, 249.90);
CALL sp_inserir_produto('Memória RAM 8GB', 7, 189.90);

-- =====================================================
-- CONSULTAS DE EXEMPLO
-- =====================================================

-- Listar todos os produtos ativos
SELECT * FROM vw_produtos_ativos ORDER BY descricao;

-- Ver resumo do estoque
SELECT * FROM vw_resumo_estoque;

-- Produtos com estoque baixo
SELECT * FROM produtos 
WHERE quantidade < 5 
  AND quantidade > 0 
  AND status = 'ativo';

-- Produtos mais caros
SELECT descricao, preco, quantidade 
FROM produtos 
WHERE status = 'ativo'
ORDER BY preco DESC 
LIMIT 5;

-- Estatísticas por faixa de preço
SELECT 
    CASE 
        WHEN preco < 50 THEN 'Econômico'
        WHEN preco < 200 THEN 'Intermediário'
        WHEN preco < 500 THEN 'Premium'
        ELSE 'Luxo'
    END AS categoria_preco,
    COUNT(*) AS quantidade_produtos,
    AVG(preco) AS preco_medio,
    SUM(quantidade) AS estoque_total
FROM produtos
WHERE status = 'ativo'
GROUP BY categoria_preco
ORDER BY MIN(preco);

-- =====================================================
-- USUÁRIOS E PERMISSÕES (opcional)
-- =====================================================

-- Criar usuário específico para a aplicação (substitua 'senha_segura')
-- CREATE USER IF NOT EXISTS 'app_user'@'localhost' IDENTIFIED BY 'senha_segura';
-- GRANT SELECT, INSERT, UPDATE, DELETE ON exmynode.* TO 'app_user'@'localhost';
-- FLUSH PRIVILEGES;

-- =====================================================
-- INFORMAÇÕES DO BANCO
-- =====================================================

SELECT 'Banco de dados exmynode criado/atualizado com sucesso!' AS status;
SELECT CONCAT('Total de produtos: ', COUNT(*)) AS info FROM produtos;