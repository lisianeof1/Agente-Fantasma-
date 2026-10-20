% =====================================================================
% config.pl  --  Valores configuraveis do Agente Fantasma (Pessoa 2)
% =====================================================================
% Para mudar um numero do jogo, mude AQUI. As regras (regras.pl) nao
% precisam ser alteradas.
%
%   param(Nome, Valor)   -> valores gerais
%   custo(Acao, Valor)   -> energia gasta por cada tipo de acao
%   base_susto(Acao, V)  -> pontos-base de susto de cada acao
% =====================================================================

% --- Energia ---------------------------------------------------------
param(energia_inicial, 10).   % energia com que o fantasma comeca
param(energia_max,     10).   % limite maximo de energia
param(recarga,          5).   % energia recuperada ao usar um espelho

% --- Susto -----------------------------------------------------------
param(susto_tremor,     4).   % a partir daqui o morador comeca a tremer
param(susto_max,        8).   % a partir daqui o morador foge
param(bonus_tremor,     1).   % ponto extra para quem ja estava tremendo
param(alcance,          2).   % ate quantas passagens o susto chega

% --- Custo de energia de cada acao -----------------------------------
custo(mover,    1).
custo(barulho,  2).
custo(derrubar, 2).
custo(remover,  2).
custo(arrombar, 6).
custo(usar,     0).           % usar espelho nao gasta energia (so recupera)

% --- Pontos-base de susto (antes da divisao pela distancia) ----------
base_susto(barulho,  2).
base_susto(derrubar, 3).
