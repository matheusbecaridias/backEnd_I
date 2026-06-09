// index.js
const readline = require('readline');
const { pool, testConnection } = require('./db.js');

// Cria a interface de input/output no terminal
const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

// Função para fazer perguntas no terminal
function pergunta(texto) {
    return new Promise(resolve => rl.question(texto, resolve));
}

// ─────────────────────────────────────────
//   FUNÇÕES DO CRUD
// ─────────────────────────────────────────

async function InserirProdutos() {
    console.log('\n-- INSERIR produtos--');
    const descricao  = await pergunta('descricao: ');
    const quantidade = await pergunta('quantidade: ');
    const preco = await pergunta('preco: ');

    const [resultado] = await pool.execute(
        'INSERT INTO produtos (descricao, quantidade, preco) VALUES (?, ?, ?)',
        [descricao, quantidade, preco]
    );

    console.log('produtosinserido! ID:', resultado.insertId);
}

async function listarUsuarios() {
    console.log('\n-- LISTA DE produtos --');

    const [usuarios] = await pool.execute('SELECT * FROM produtos');

    if (usuarios.length === 0) {
        console.log('Nenhum produto cadastrado.');
        return;
    }

    usuarios.forEach(u => {
        console.log(`Produto: ${u.codProduto} | descrição: ${u.descricao} | Quantidade: ${u.quantidade} | Preço: ${u.preco}`);
    });
}

async function atualizarUsuario() {
    console.log('\n-- ATUALIZAR produtos--');
    const id    = await pergunta('ID do produtos ');
    const descricao  = await pergunta('Novo descricao: ');
    const quantidade = await pergunta('Novo quantidade: ');
    const preco = await pergunta('Novo preco: ');

    const [resultado] = await pool.execute(
        'UPDATE produtos SET descricao = ?, quantidade = ?, preco = ? WHERE codProduto = ?',
        [descricao, quantidade, preco, id]
    );

    console.log('Linhas atualizadas:', resultado.affectedRows);
}

async function deletarUsuario() {
    console.log('\n-- DELETAR produtos--');
    const id = await pergunta('ID do produtos ');

    const [resultado] = await pool.execute(
        'DELETE FROM produtos WHERE codProduto = ?',
        [id]
    );

    console.log('Linhas removidas:', resultado.affectedRows);
}

// ─────────────────────────────────────────
//   MENU
// ─────────────────────────────────────────

async function menu() {
    console.log('\n=== MENU ===');
    console.log('1 - Inserir produtos');
    console.log('2 - Listar produtos');
    console.log('3 - Atualizar produtos');
    console.log('4 - Deletar produtos');
    console.log('0 - Sair');

    const opcao = await pergunta('\nEscolha: ');
    return opcao;
}

// ─────────────────────────────────────────
//   INÍCIO DO PROGRAMA
// ─────────────────────────────────────────

async function main() {
    const conectado = await testConnection();
    if (!conectado) {
        rl.close();
        return;
    }

    let rodando = true;
    while (rodando) {
        const opcao = await menu();

        if (opcao === '1') await InserirProdutos();
        else if (opcao === '2') await listarUsuarios();
        else if (opcao === '3') await atualizarUsuario();
        else if (opcao === '4') await deletarUsuario();
        else if (opcao === '0') {
            console.log('\nEncerrando...');
            rodando = false;
        } else {
            console.log('Opção inválida!');
        }
    }

    rl.close();
    process.exit(0);
}

main();
