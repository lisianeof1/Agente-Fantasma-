:- consult('busca.pl').

% estado_inicial/1 e objetivo/1 mudam a cada teste
:- dynamic estado_inicial/1, objetivo/1.

% Mapa 1: o caminho de 1 passo custa 10; o de 3 passos custa 3;
% existe um ciclo (c -> a)
acao(a, ir(a,fim), fim, 10).
acao(a, ir(a,b),   b,   1).
acao(b, ir(b,c),   c,   1).
acao(c, ir(c,fim), fim, 1).
acao(c, ir(c,a),   a,   1).

% Mapa 2: dois caminhos ate r (p->r custa 5; p->q->r custa 2)
acao(p, ir(p,r), r, 5).
acao(p, ir(p,q), q, 1).
acao(q, ir(q,r), r, 1).
acao(r, ir(r,s), s, 1).

% Mapa 3: uma acao de custo zero
acao(z0, usa(z0),   z1, 0).
acao(z1, ir(z1,z2), z2, 2).

% testar(Nome, Inicio, Meta): define inicio e meta, chama resolver/2
% e imprime o plano e o custo, ou SEM SOLUCAO se a consulta falhar.
testar(Nome, Inicio, Meta) :-
    retractall(estado_inicial(_)),
    retractall(objetivo(_)),
    assertz(estado_inicial(Inicio)),
    assertz(objetivo(Meta)),
    (   resolver(Plano, Custo)
    ->  format("~w: plano=~w custo=~w~n", [Nome, Plano, Custo])
    ;   format("~w: SEM SOLUCAO~n", [Nome])
    ).

:- testar(t1_menos_passos_nao_e_o_mais_barato, a, fim).
:- testar(t2_meta_impossivel_com_ciclo, a, nao_existe).
:- testar(t3_ja_comeca_na_meta, a, a).
:- testar(t4_dois_caminhos_ate_o_mesmo_estado, p, s).
:- testar(t5_acao_de_custo_zero, z0, z2).
