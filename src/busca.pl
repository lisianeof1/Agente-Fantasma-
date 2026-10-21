% ============================================================
% Busca de custo uniforme
%
% Predicados esperados (definidos em outro arquivo):
%   estado_inicial(Estado)
%   acao(Estado, Acao, NovoEstado, Custo)   % um resultado por vez (retrocesso)
%   objetivo(Estado)
%
% Predicado oferecido:
%   resolver(Plano, Custo)
%     Plano = lista de acoes, da primeira ate a ultima
%     Custo = soma dos custos das acoes do plano
%     Se nao existe solucao, resolver/2 falha.
% ============================================================

% ------------------------------------------------------------
% Predicados de lista
% ------------------------------------------------------------

% pertence(Elem, Lista): Elem e elemento da Lista
pertence(Elem, [Elem|_]).
pertence(Elem, [_|Cauda]) :- pertence(Elem, Cauda).

% add_ultimo(Elem, Lista, NovaLista): NovaLista e a Lista com Elem no fim
add_ultimo(Elem, [], [Elem]).
add_ultimo(Elem, [Cabeca|Cauda], [Cabeca|CaudaResultante]) :-
    add_ultimo(Elem, Cauda, CaudaResultante).

% ------------------------------------------------------------
% Ponto de entrada
%
% Um no da fronteira tem a forma  no(Estado, Custo, Acoes):
%   Estado = situacao do jogo
%   Custo  = custo acumulado ate chegar nesse estado (nao faz parte do estado)
%   Acoes  = acoes executadas ate aqui, da primeira para a ultima
% ------------------------------------------------------------

resolver(Plano, Custo) :-
    estado_inicial(Estado0),
    bcu([no(Estado0, 0, [])], [], Plano, Custo).

% ------------------------------------------------------------
% Laco principal: bcu(Fronteira, Explorados, Plano, Custo)
% A fronteira esta sempre em ordem crescente de custo.
% ------------------------------------------------------------

% O primeiro no da fronteira e o objetivo: como ele e o de menor custo,
% o plano encontrado e o de menor custo total.
bcu([no(Estado, Custo, Plano)|_], _, Plano, Custo) :-
    objetivo(Estado), !.

% O estado do primeiro no ja foi explorado: descarta o no.
bcu([no(Estado, _, _)|Outros], Explorados, Plano, Custo) :-
    pertence(Estado, Explorados), !,
    bcu(Outros, Explorados, Plano, Custo).

% Caso contrario, expande o no: gera os sucessores, cria os novos nos
% e os insere na fronteira em ordem de custo.
bcu([no(Estado, Custo, Acoes)|Outros], Explorados, Plano, CustoFinal) :-
    estende(Estado, [Estado|Explorados], Sucessores),
    criar_nos(Sucessores, Custo, Acoes, Filhos),
    inserir_nos(Filhos, Outros, NovaFronteira),
    bcu(NovaFronteira, [Estado|Explorados], Plano, CustoFinal).

% Fronteira vazia: nenhuma clausula de bcu/4 se aplica e a busca falha.

% ------------------------------------------------------------
% Geracao dos sucessores
% ------------------------------------------------------------

% estende(Estado, Explorados, Sucessores): lista com todos os sucessores
% de Estado que ainda nao foram explorados, no formato
% suc(Acao, NovoEstado, CustoDaAcao).
estende(Estado, Explorados, Sucessores) :-
    bagof(suc(Acao, NovoEstado, CustoAcao),
          ( acao(Estado, Acao, NovoEstado, CustoAcao),
            not(pertence(NovoEstado, Explorados)) ),
          Sucessores), !.
% Sem sucessores o bagof falha; nesse caso a lista e vazia.
estende(_, _, []).

% criar_nos(Sucessores, CustoAtual, AcoesAtuais, Nos): transforma cada
% sucessor em um no, somando o custo da acao e acrescentando a acao ao plano.
criar_nos([], _, _, []).
criar_nos([suc(Acao, Estado2, CustoAcao)|Resto], Custo, Acoes,
          [no(Estado2, Custo2, Acoes2)|NosResto]) :-
    Custo2 is Custo + CustoAcao,
    add_ultimo(Acao, Acoes, Acoes2),
    criar_nos(Resto, Custo, Acoes, NosResto).

% ------------------------------------------------------------
% Fronteira ordenada por custo
% ------------------------------------------------------------

% inserir_nos(Nos, Fronteira, NovaFronteira): insere cada no na fronteira
inserir_nos([], Fronteira, Fronteira).
inserir_nos([No|Nos], Fronteira, FronteiraFinal) :-
    inserir_no(No, Fronteira, Fronteira1),
    inserir_nos(Nos, Fronteira1, FronteiraFinal).

% inserir_no(No, Fronteira, NovaFronteira): insere um no mantendo a ordem
% crescente de custo. Em caso de empate, o no novo fica depois dos antigos.
inserir_no(No, [], [No]) :- !.
inserir_no(no(E, C, A), [no(E2, C2, A2)|Resto], [no(E2, C2, A2)|NovoResto]) :-
    C2 =< C, !,
    inserir_no(no(E, C, A), Resto, NovoResto).
inserir_no(No, Fronteira, [No|Fronteira]).