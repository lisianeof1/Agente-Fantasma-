% =====================================================================
% ESTADO:  estado(Comodo, Energia, Sustos, Feitos)
%   Comodo : onde o fantasma esta
%   Sustos : lista ORDENADA de Nome-Pontos          ex.: [ana-4, bia-0]
%   Feitos : conjunto ORDENADO do que ja aconteceu  ex.: [derrubado(quadro)]
%
% Predicados que este arquivo oferece ao grupo:
%   estado_inicial(-Estado)
%   objetivo(+Estado)
%   acao(+Estado, ?Acao, -NovoEstado, -Custo)
%   definir_cenario(+Id)      (a Pessoa 3 pode usar na executar/1)
% =====================================================================

% ---------------------------------------------------------------------
% Fatos do cenario
% ---------------------------------------------------------------------

:- multifile inicio/2, conecta/3, morador/3, objeto/4,
             porta/4, movel/4, espelho/3.
:- dynamic   inicio/2, conecta/3, morador/3, objeto/4,
             porta/4, movel/4, espelho/3.

% ---------------------------------------------------------------------
% Cenario ativo
% ---------------------------------------------------------------------

:- dynamic cenario_ativo/1.

definir_cenario(Id) :-
    (   inicio(Id, _)
    ->  retractall(cenario_ativo(_)),
        assertz(cenario_ativo(Id))
    ;   format("Cenario desconhecido: ~w~n", [Id]),
        fail
    ).

% ---------------------------------------------------------------------
% Atalhos: as regras usam os nomes sem o identificador, e os atalhos
% ---------------------------------------------------------------------

inicio(Comodo) :-
    cenario_ativo(C), inicio(C, Comodo).

conecta(De, Para) :-
    cenario_ativo(C), conecta(C, De, Para).

morador(Nome, Comodo) :-
    cenario_ativo(C), morador(C, Nome, Comodo).

objeto(Nome, Comodo, Efeito) :-
    cenario_ativo(C), objeto(C, Nome, Comodo, Efeito).

porta(Id, De, Para) :-
    cenario_ativo(C), porta(C, Id, De, Para).

movel(Id, De, Para) :-
    cenario_ativo(C), movel(C, Id, De, Para).

espelho(Id, Comodo) :-
    cenario_ativo(C), espelho(C, Id, Comodo).

estado_inicial(estado(Comodo, Energia, Sustos, [])) :-
    once(inicio(Comodo)),
    param(energia_inicial, Energia),
    findall(Nome-0, morador(Nome, _), Sustos0),
    sort(Sustos0, Sustos).

objetivo(estado(_, _, Sustos, _)) :-
    param(susto_max, Max),
    forall(member(_-Pontos, Sustos), Pontos >= Max).

porta_aberta(Porta, Feitos) :-
    memberchk(arrombada(Porta), Feitos).
porta_aberta(Porta, Feitos) :-
    objeto(Objeto, _, abre(Porta)),
    memberchk(derrubado(Objeto), Feitos).

bloqueada(De, Para, Feitos) :-
    porta(Porta, De, Para),
    \+ porta_aberta(Porta, Feitos).
bloqueada(De, Para, Feitos) :-
    movel(Movel, De, Para),
    \+ memberchk(removido(Movel), Feitos).

passagem_livre(De, Para, Feitos) :-
    conecta(De, Para),
    \+ bloqueada(De, Para, Feitos).

acao(estado(Origem, Energia, Sustos, Feitos),
     mover(Origem, Destino),
     estado(Destino, Energia1, Sustos, Feitos),
     Custo) :-
    custo(mover, Custo),
    Energia >= Custo,
    passagem_livre(Origem, Destino, Feitos),
    Energia1 is Energia - Custo.

acao(estado(Comodo, Energia, Sustos, Feitos),
     usar(Espelho),
     estado(Comodo, Energia1, Sustos, Feitos1),
     Custo) :-
    custo(usar, Custo),
    Energia >= Custo,
    param(energia_max, Max),
    Energia < Max,
    espelho(Espelho, Comodo),
    \+ memberchk(usado(Espelho), Feitos),
    param(recarga, Recarga),
    Energia1 is min(Energia + Recarga, Max),
    ord_add_element(Feitos, usado(Espelho), Feitos1).

acao(estado(Comodo, Energia, Sustos, Feitos),
     remover(Movel),
     estado(Comodo, Energia1, Sustos, Feitos1),
     Custo) :-
    custo(remover, Custo),
    Energia >= Custo,
    movel(Movel, Comodo, _),
    \+ memberchk(removido(Movel), Feitos),
    Energia1 is Energia - Custo,
    ord_add_element(Feitos, removido(Movel), Feitos1).

acao(estado(Comodo, Energia, Sustos, Feitos),
     arrombar(Porta),
     estado(Comodo, Energia1, Sustos, Feitos1),
     Custo) :-
    custo(arrombar, Custo),
    Energia >= Custo,
    porta(Porta, Comodo, _),
    \+ porta_aberta(Porta, Feitos),
    Energia1 is Energia - Custo,
    ord_add_element(Feitos, arrombada(Porta), Feitos1).

distancia(De, Para, D) :-
    param(alcance, Max),
    between(0, Max, D),
    alcanca(De, Para, D),
    !.

alcanca(Comodo, Comodo, 0).
alcanca(De, Para, N) :-
    N > 0,
    N1 is N - 1,
    conecta(De, Meio),
    alcanca(Meio, Para, N1).

pontos_susto(Tipo, Distancia, Pontos) :-
    base_susto(Tipo, Base),
    Pontos is Base // (1 + Distancia).

atualizar_sustos(Tipo, Comodo, Sustos0, Sustos) :-
    maplist(novo_susto(Tipo, Comodo), Sustos0, Sustos).

novo_susto(Tipo, Comodo, Nome-Antes, Nome-Depois) :-
    param(susto_max, Max),
    param(susto_tremor, Tremor),
    param(bonus_tremor, Bonus),
    (   Antes >= Max
    ->  Depois = Antes
    ;   morador(Nome, ComodoMorador),
        distancia(Comodo, ComodoMorador, D),
        pontos_susto(Tipo, D, Ganho),
        Ganho > 0
    ->  (   Antes >= Tremor
        ->  Extra = Bonus
        ;   Extra = 0
        ),
        Depois is min(Max, Antes + Ganho + Extra)
    ;   Depois = Antes
    ).

acao(estado(Comodo, Energia, Sustos0, Feitos),
     barulho(Comodo),
     estado(Comodo, Energia1, Sustos, Feitos1),
     Custo) :-
    custo(barulho, Custo),
    Energia >= Custo,
    \+ memberchk(barulho(Comodo), Feitos),
    atualizar_sustos(barulho, Comodo, Sustos0, Sustos),
    Sustos \== Sustos0,
    Energia1 is Energia - Custo,
    ord_add_element(Feitos, barulho(Comodo), Feitos1).

acao(estado(Comodo, Energia, Sustos0, Feitos),
     derrubar(Objeto),
     estado(Comodo, Energia1, Sustos, Feitos1),
     Custo) :-
    custo(derrubar, Custo),
    Energia >= Custo,
    objeto(Objeto, Comodo, Efeito),
    \+ memberchk(derrubado(Objeto), Feitos),
    atualizar_sustos(derrubar, Comodo, Sustos0, Sustos),
    (   Sustos \== Sustos0
    ->  true
    ;   Efeito = abre(_)
    ),
    Energia1 is Energia - Custo,
    ord_add_element(Feitos, derrubado(Objeto), Feitos1).
