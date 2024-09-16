# Processa Pedidos
Código simples de exemplo de como criar uma função em PL/SQL para processar um objeto xml.

## Preparando
Por favor realize o clone desse repositório.

### Banco de dados - Docker Image
A maneira simples é executar uma imagem Oracle Docker, dessa maneira todos os scripts serão executados de maneira automática será possível executar a package e testes atráves da conexão: `ORDERUSER/OrderUser@FREEPDB1`

Abaixo as instruções para executar uma instância Oracle em Docker extraído na [repositório oficial](https://container-registry.oracle.com/). **Lembre-se de utilizar a pasta 'script' deste repositório como o ponto de montagem para os scripts de startup**:
```
docker run --name <container name> \
-p <host port>:1521 -p  \
-e ORACLE_PDB=<your PDB name> \
-e ORACLE_PWD=<your database passwords> \
-v [<host mount point>:]/opt/oracle/oradata \
-v [<host mount startup scripts>:]/opt/oracle/scripts/startup
container-registry.oracle.com/database/free:23.5.0.0-lite
```

**Exemplo Práticos**
```
docker run --name MyOracleDBLite `
-p 1521:1521 `
-v D:\repos\ProcessOrders\db_scripts:/opt/oracle/scripts/startup `
container-registry.oracle.com/database/free:23.5.0.0-lite
```


### Banco de dados - Configuração manual
**ATENÇÃO:** Se for executar os scripts individualmente, por favor remover a primeira linha, essa linha é utilizada apenas para criar os objetos do PDB adequado em um container.

Para a execução desse código é necessário executar os scripts listados abaixo na seguinte ordem:
1. [db_scripts/02_CreateTables.sql](./db_scripts/02_CreateTables.sql)
1. [db_scripts/03_PKS_ORDERS.sql](./db_scripts/03_PKS_ORDERS.sql)
1. [db_scripts/04_PKB_ORDERS.sql](./db_scripts/04_PKB_ORDERS.sql)

Executando os arquivos acima é o suficiente para executar as chamadas das packages, mas esse projeto também oferece alguns exemplos de realizar a chamada. Para a execução dos exemplos é necessário executar os scripts:
1. [db_scripts/05_TESTS_OBJECTS.sql](./db_scripts/05_TESTS_OBJECTS.sql)
1. [db_scripts/06_TEST_PROCESS.sql](./db_scripts/06_TEST_PROCESS.sql)

Também é possível executar o script abaixo, caso queira criar um usuário específico para esse código:
1. [db_scripts/01_CreateUser.sql](./db_scripts/01_CreateUser.sql)


## Exemplos
Como exemplo de arquivos, com erro e sucesso, foi criado uma tabela `ORDERTESTS` com duas colunas, uma descrição sobre arquivo e o arquivo.

A procedure `TEST_PROCESS` executa cada um dos arquivos e ao final recupera todos os items de um pedido específico (o único pedido que não continha erros).
