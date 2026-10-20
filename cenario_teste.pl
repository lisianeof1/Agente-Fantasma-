% =====================================================================
% cenario_teste.pl  --  Cenario de teste da Pessoa 2
% =====================================================================
% Serve so para testar as regras. Usa o identificador "teste" para nao
% se misturar com os cenarios oficiais (simples, desafiador, impossivel).
%
% Plano esperado (custo total 8):
%   1. mover(sala, corredor)
%   2. derrubar(quadro)        -> abre a porta1
%   3. mover(corredor, quarto)
%   4. derrubar(vaso)
%   5. derrubar(cadeira)       -> ana foge (8 pontos)

inicio(teste, sala).

conecta(teste, sala, corredor).
conecta(teste, corredor, quarto).

porta(teste, porta1, corredor, quarto).            % toda porta comeca trancada
objeto(teste, quadro, corredor, abre(porta1)).     % derrubar abre a porta1
objeto(teste, vaso, quarto, nenhum).
objeto(teste, cadeira, quarto, nenhum).

morador(teste, ana, quarto).
