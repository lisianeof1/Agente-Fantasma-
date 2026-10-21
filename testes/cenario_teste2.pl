% =====================================================================
% cenario_teste2.pl  --  Segundo cenario de teste da Pessoa 2
% =====================================================================
% Identificador "teste2". Tem porta, movel, espelho e passagens de volta,
% para testar as etapas 3 a 6 (passagem livre, remover, arrombar, usar).
%
%        cozinha --(movel: estante)-- sala --- corredor --(porta1)-- quarto
%        [espelho1]                                [quadro]            [ana]
%
% Cada seta abaixo e um sentido; a volta e cadastrada a parte.

inicio(teste2, sala).

% Sala <-> corredor (livres nos dois sentidos)
conecta(teste2, sala, corredor).
conecta(teste2, corredor, sala).

% Corredor -> quarto (tem porta). Quarto -> corredor (livre, sem porta)
conecta(teste2, corredor, quarto).
conecta(teste2, quarto, corredor).

% Sala -> cozinha (tem movel). Cozinha -> sala (livre, sem movel)
conecta(teste2, sala, cozinha).
conecta(teste2, cozinha, sala).

porta(teste2, porta1, corredor, quarto).           % so bloqueia a ida
objeto(teste2, quadro, corredor, abre(porta1)).    % derrubar abre a porta1
movel(teste2, estante, sala, cozinha).             % so bloqueia a ida
espelho(teste2, espelho1, cozinha).

morador(teste2, ana, quarto).
