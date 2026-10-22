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
% ==========================================

objeto(simples, vaso, cozinha, nenhum).
objeto(simples, brinquedo, cozinha, nenhum).

objeto(desafiador, quadro_chave, sala, abre(porta_quarto)).
objeto(desafiador, vaso_quarto, quarto, nenhum).
objeto(desafiador, livro_quarto, quarto, nenhum).


% ==========================================
% PORTAS
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
