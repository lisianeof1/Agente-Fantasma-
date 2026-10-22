% =====================================================================
% config.pl  --  Valores configuraveis do Agente Fantasma (Pessoa 2)
% =====================================================================
%   param(Nome, Valor)   -> valores gerais
%   custo(Acao, Valor)   -> energia gasta por cada tipo de acao
%   base_susto(Acao, V)  -> pontos-base de susto de cada acao
% =====================================================================

% --- Energia ---------------------------------------------------------
param(energia_inicial, 10).   
param(energia_max,     10).   
param(recarga,          5).   

% --- Susto -----------------------------------------------------------
param(susto_tremor,     4).   
param(susto_max,        8).   
param(bonus_tremor,     1).   
param(alcance,          2).   

% --- Custo de energia de cada acao -----------------------------------
custo(mover,    1).
custo(barulho,  2).
custo(derrubar, 2).
custo(remover,  2).
custo(arrombar, 6).
custo(usar,     0).          

% --- Pontos-base de susto (antes da divisao pela distancia) ----------
base_susto(barulho,  2).
base_susto(derrubar, 3).
