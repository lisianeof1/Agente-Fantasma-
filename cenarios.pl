% Fatos dos tres cenarios do Agente Fantasma.
% As regras usam o identificador do cenario para consultar somente
% os comodos, moradores e objetos da configuracao selecionada.

% Cenario selecionado ao carregar este arquivo.
% Para executar outro cenario, use definir_cenario(Id) nas consultas.
cenario_ativo(desafiador).


% ==========================================
% COMODOS
% ==========================================

comodo(simples, sala).
comodo(simples, corredor).
comodo(simples, cozinha).

comodo(desafiador, sala).
comodo(desafiador, corredor).
comodo(desafiador, cozinha).
comodo(desafiador, biblioteca).
comodo(desafiador, quarto).

comodo(impossivel, sala).
comodo(impossivel, corredor).
comodo(impossivel, quarto_isolado).


% ==========================================
% CONEXOES DIRECIONADAS
% Cada fato permite atravessar somente de De para Para.
% Para permitir a volta, seria preciso declarar outra conexao.
% ==========================================

conecta(simples, sala, corredor).
conecta(simples, corredor, cozinha).

conecta(desafiador, sala, corredor).
conecta(desafiador, corredor, cozinha).
conecta(desafiador, cozinha, biblioteca).
conecta(desafiador, biblioteca, quarto).

conecta(impossivel, sala, corredor).


% ==========================================
% POSICAO INICIAL DO FANTASMA
% ==========================================

inicio(simples, sala).
inicio(desafiador, sala).
inicio(impossivel, sala).


% ==========================================
% MORADORES
% ==========================================

morador(simples, maria, cozinha).

morador(desafiador, ana, quarto).
morador(desafiador, bruno, quarto).

morador(impossivel, joao, quarto_isolado).


% ==========================================
% OBJETOS DERRUBAVEIS
% O ultimo argumento indica se o objeto abre uma porta.
% ==========================================

% No cenario simples, os dois objetos sao comuns.
objeto(simples, vaso, cozinha, nenhum).
objeto(simples, brinquedo, cozinha, nenhum).

% No desafiador, o quadro abre a porta do quarto.
% Os outros dois objetos sao comuns.
objeto(desafiador, quadro_chave, sala, abre(porta_quarto)).
objeto(desafiador, vaso_quarto, quarto, nenhum).
objeto(desafiador, livro_quarto, quarto, nenhum).


% ==========================================
% PORTAS
% A porta declarada comeca fechada.
% ==========================================

porta(desafiador, porta_quarto, biblioteca, quarto).


% ==========================================
% MOVEIS QUE BLOQUEIAM PASSAGENS
% ==========================================

movel(desafiador, armario, corredor, cozinha).


% ==========================================
% ESPELHOS
% ==========================================

espelho(desafiador, espelho_biblioteca, biblioteca).
