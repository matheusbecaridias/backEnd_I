// db.js
const mysql = require('mysql2');

// Configuração da conexão
const pool = mysql.createPool({
    host: 'localhost',        // Endereço do servidor MySQL
    user: 'root',      // Seu usuário do MySQL
    password: 'escola',    // Sua senha do MySQL
    database: 'exmynode',    // Nome do banco de dados
    waitForConnections: true,
    connectionLimit: 10,      // Número máximo de conexões no pool
    queueLimit: 0,
    enableKeepAlive: true,
    keepAliveInitialDelay: 0
});

// Converter o pool para usar promises
const promisePool = pool.promise();

// Função para testar a conexão
async function testConnection() {
    try {
        const connection = await promisePool.getConnection();
        console.log('✅ Conexão com MySQL estabelecida com sucesso!');
        connection.release(); // Libera a conexão de volta para o pool
        return true;
    } catch (error) {
        console.error('❌ Erro ao conectar com MySQL:', error.message);
        return false;
    }
}

// Exportar as funções e o pool
module.exports = {
    pool: promisePool,
    testConnection,
 };