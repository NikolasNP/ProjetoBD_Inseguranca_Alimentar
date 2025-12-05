# ProjetoBD_Inseguranca_Alimentar

Grupo K

Lucas Rafael Mendes Santos - 200023021

Nikolas Negrão Pessoa - 202024722

William Alves Virissimo - 232031307

Este documento descreve, em tópicos, as funcionalidades principais do sistema desenvolvido em Python
com Tkinter e MySQL para gestão de dados relacionados ao projeto de Insegurança Alimentar.

## 1. Visão Geral do Sistema

• Aplicação desktop desenvolvida com Tkinter.

• Conexão direta com banco de dados MySQL.

• Funções para consulta, inserção, atualização e deleção de dados.

• Interface gráfica intuitiva com caixas de seleção, tabelas e filtros dinâmicos.

## 2. Tela de Login

• Validação de usuário com verificação no banco de dados.

• Carregamento do perfil do usuário (Administrador, Pesquisador etc.).

• Controle de acesso às funcionalidades conforme o perfil.

Exemplo de usuário de acesso:

login: ana_silva

senha: $2y$10$HASH1


## 3. Painel Principal

• Menu com três funções principais:

• Inserir / Atualizar / Deletar registros;

• Consultar tabelas e aplicar filtros avançados;

• Visualizar relatório básico com dados completos.

## 4. Relatório Básico

• Executa consulta `SELECT * FROM relatorio_basico`.

• Exibe os resultados em componente Treeview com rolagem horizontal e vertical.

• Mostra nomes das colunas automaticamente.

• Exibe aviso caso não existam dados.

## 5. Inserção, Atualização e Deleção de Dados

• Carrega automaticamente todas as tabelas do banco via `SHOW TABLES`.

• Ao escolher uma tabela, os campos são exibidos conforme `DESCRIBE tabela`.

• Identifica a chave primária automaticamente (primeira coluna).

• UPDATE executado quando o ID já existe.

• INSERT executado quando o ID está vazio ou não existe.

• DELETE realizado mediante confirmação do usuário.

## 6. Consulta Avançada com Filtros Dinâmicos

• Filtros criados dinamicamente conforme o tipo da coluna da tabela.

• Tipos numéricos: operadores (=, >, <, >=, <=, BETWEEN).

• Tipos de texto: campo com autocomplete + busca via LIKE.

• Tipos de data: intervalo usando DateEntry.

• Montagem automática da cláusula WHERE com base nos filtros.

• Resultados exibidos em Treeview, totalmente dinâmico.

## 7. Visualização da Tabela Completa

• Executa `SELECT * FROM tabela` sem filtros.

• Atualiza dinamicamente cabeçalhos e linhas exibidas.

• Indica ao usuário quantos registros foram carregados.

## 8. Limpeza e Ajustes de Filtros

• Função para resetar todos os campos de pesquisa.

• Limpa comboboxes, entries e campos de data.

• Mantém a estrutura de layout e reaproveita os widgets.

## 9. Navegação e Estrutura Interna

• Todas as telas possuem botão para retornar ao painel.

• Funções organizadas por responsabilidade (login, painel, consultas, CRUD).

• Uso consistente de tratamento de exceções.

• Conexões com o banco são abertas e fechadas corretamente.
