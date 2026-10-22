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
% ------------------------------------------------------------

resolver(Plano, Custo) :-
    estado_inicial(Estado0),
    bcu([no(Estado0, 0, [])], [], Plano, Custo).

% ------------------------------------------------------------
% Laco principal: bcu(Fronteira, Explorados, Plano, Custo)
% ------------------------------------------------------------

bcu([no(Estado, Custo, Plano)|_], _, Plano, Custo) :-
    objetivo(Estado), !.

bcu([no(Estado, _, _)|Outros], Explorados, Plano, Custo) :-
    pertence(Estado, Explorados), !,
    bcu(Outros, Explorados, Plano, Custo).

bcu([no(Estado, Custo, Acoes)|Outros], Explorados, Plano, CustoFinal) :-
    estende(Estado, [Estado|Explorados], Sucessores),
    criar_nos(Sucessores, Custo, Acoes, Filhos),
    inserir_nos(Filhos, Outros, NovaFronteira),
    bcu(NovaFronteira, [Estado|Explorados], Plano, CustoFinal).

% ------------------------------------------------------------
% Geracao dos sucessores
% ------------------------------------------------------------

estende(Estado, Explorados, Sucessores) :-
    bagof(suc(Acao, NovoEstado, CustoAcao),
          ( acao(Estado, Acao, NovoEstado, CustoAcao),
            not(pertence(NovoEstado, Explorados)) ),
          Sucessores), !.
          
estende(_, _, []).

criar_nos([], _, _, []).
criar_nos([suc(Acao, Estado2, CustoAcao)|Resto], Custo, Acoes,
          [no(Estado2, Custo2, Acoes2)|NosResto]) :-
    Custo2 is Custo + CustoAcao,
    add_ultimo(Acao, Acoes, Acoes2),
    criar_nos(Resto, Custo, Acoes, NosResto).

% ------------------------------------------------------------
% Fronteira ordenada por custo
% ------------------------------------------------------------

inserir_nos([], Fronteira, Fronteira).
inserir_nos([No|Nos], Fronteira, FronteiraFinal) :-
    inserir_no(No, Fronteira, Fronteira1),
    inserir_nos(Nos, Fronteira1, FronteiraFinal).

inserir_no(No, [], [No]) :- !.
inserir_no(no(E, C, A), [no(E2, C2, A2)|Resto], [no(E2, C2, A2)|NovoResto]) :-
    C2 =< C, !,
    inserir_no(no(E, C, A), Resto, NovoResto).
inserir_no(No, Fronteira, [No|Fronteira]).
