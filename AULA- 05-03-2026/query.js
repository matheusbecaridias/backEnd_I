// query.js
// Importar o pool do db.js
const { pool } = require('./db.js');

// Função para executar queries
async function executeQuery(query, params = []) {
    try {
        const [results] = await pool.execute(query, params);
        return results;
    } catch (error) {
        console.error('❌ Erro ao executar query:', error);
        throw error;
    }
}

// Função para executar transações
async function executeTransaction(queries) {
    const connection = await pool.getConnection();
    try {
        await connection.beginTransaction();
        
        const results = [];
        for (const { query, params } of queries) {
            const [result] = await connection.execute(query, params || []);
            results.push(result);
        }
        
        await connection.commit();
        return results;
    } catch (error) {
        await connection.rollback();
        console.error('❌ Erro na transação:', error);
        throw error;
    } finally {
        connection.release();
    }
}

// Função para buscar um único registro
async function fetchOne(query, params = []) {
    try {
        const results = await executeQuery(query, params);
        return results[0] || null;
    } catch (error) {
        console.error('❌ Erro ao buscar registro:', error);
        throw error;
    }
}

// Função para inserir e retornar o ID inserido
async function insert(query, params = []) {
    try {
        const result = await executeQuery(query, params);
        return result.insertId;
    } catch (error) {
        console.error('❌ Erro ao inserir:', error);
        throw error;
    }
}

// Exportar as funções
module.exports = {
    executeQuery,
    executeTransaction,
    fetchOne,
    insert
};