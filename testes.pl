% =====================================================================
% testes.pl  --  Etapa 8: testes das regras (Pessoa 2)
% =====================================================================
% Como rodar (na pasta com todos os arquivos):
%     swipl -q -s testes.pl -g rodar_testes -t halt
% ou, dentro do swipl:
%     ?- [testes].
%     ?- rodar_testes.
%
% Cada teste imprime "ok" ou "FALHOU". No fim sai o total.
% Precisa de: config.pl, regras.pl, cenario_teste.pl, cenario_teste2.pl

:- ensure_loaded(regras).
:- ensure_loaded(cenario_teste).
:- ensure_loaded(cenario_teste2).

:- dynamic teste/1.

% Cenario "teste3": dois moradores cadastrados FORA de ordem alfabetica,
% para conferir que Sustos sai ordenado. Criado aqui so para o teste.
:- assertz(inicio(teste3, a)).
:- assertz(conecta(teste3, a, b)).
:- assertz(conecta(teste3, b, a)).
:- assertz(morador(teste3, bia, b)).
:- assertz(morador(teste3, ana, a)).
:- assertz(objeto(teste3, vaso3, a, nenhum)).

% ---------------------------------------------------------------------
% Ajudante: passo(+E0, +Acao, -E1, -Custo)
% Garante que, com a acao ja escolhida, acao/4 da EXATAMENTE um resultado.
% ---------------------------------------------------------------------
passo(E0, Acao, E1, Custo) :-
    findall(E-K, acao(E0, Acao, E, K), L),
    L = [E1-Custo].

% Sem resultado nenhum (acao nao permitida)
nao_permite(E0, Acao) :-
    \+ acao(E0, Acao, _, _).

% ---------------------------------------------------------------------
% 1. Plano do exemplo (5 passos, custo 8), estado por estado
% ---------------------------------------------------------------------
:- assertz((teste(plano_exemplo_passo_a_passo) :-
    definir_cenario(teste),
    estado_inicial(E0),
    E0 == estado(sala, 10, [ana-0], []),
    passo(E0, mover(sala, corredor), E1, C1),
    E1 == estado(corredor, 9, [ana-0], []),
    passo(E1, derrubar(quadro), E2, C2),
    E2 == estado(corredor, 7, [ana-1], [derrubado(quadro)]),
    passo(E2, mover(corredor, quarto), E3, C3),
    E3 == estado(quarto, 6, [ana-1], [derrubado(quadro)]),
    passo(E3, derrubar(vaso), E4, C4),
    E4 == estado(quarto, 4, [ana-4], [derrubado(quadro), derrubado(vaso)]),
    passo(E4, derrubar(cadeira), E5, C5),
    E5 == estado(quarto, 2, [ana-8],
                 [derrubado(cadeira), derrubado(quadro), derrubado(vaso)]),
    \+ objetivo(E4),
    objetivo(E5),
    Total is C1 + C2 + C3 + C4 + C5,
    Total =:= 8)).

% A porta so abre depois de derrubar o quadro
:- assertz((teste(porta_trancada_ate_derrubar_quadro) :-
    definir_cenario(teste),
    estado_inicial(E0),
    passo(E0, mover(sala, corredor), E1, _),
    nao_permite(E1, mover(corredor, quarto)),
    passo(E1, derrubar(quadro), E2, _),
    passo(E2, mover(corredor, quarto), _, _))).

% ---------------------------------------------------------------------
% 2. Ordem alfabetica de Feitos e Sustos
% ---------------------------------------------------------------------
:- assertz((teste(feitos_em_ordem_alfabetica) :-
    definir_cenario(teste2),
    E0 = estado(cozinha, 5, [ana-0], [removido(estante)]),
    passo(E0, usar(espelho1), estado(_, _, _, F1), _),
    F1 == [removido(estante), usado(espelho1)],
    passo(estado(corredor, 10, [ana-0], [usado(espelho1)]),
          derrubar(quadro), estado(_, _, _, F2), _),
    F2 == [derrubado(quadro), usado(espelho1)],
    passo(estado(quarto, 10, [ana-0], [derrubado(quadro)]),
          barulho(quarto), estado(_, _, _, F3), _),
    F3 == [barulho(quarto), derrubado(quadro)],
    sort(F3, F3))).

:- assertz((teste(sustos_em_ordem_alfabetica) :-
    definir_cenario(teste3),
    estado_inicial(estado(_, _, S0, _)),
    S0 == [ana-0, bia-0],
    passo(estado(a, 10, S0, []), derrubar(vaso3), estado(_, _, S1, _), _),
    S1 == [ana-3, bia-1])).

% ---------------------------------------------------------------------
% 3. Unicidade: com a acao escolhida, so um resultado
% ---------------------------------------------------------------------
:- assertz((teste(estado_inicial_unico) :-
    definir_cenario(teste),
    findall(E, estado_inicial(E), L),
    length(L, 1))).

:- assertz((teste(acao_escolhida_um_resultado) :-
    definir_cenario(teste2),
    E = estado(sala, 10, [ana-0], []),
    findall(x, acao(E, mover(sala, corredor), _, _), L1), L1 = [_],
    findall(x, acao(E, remover(estante), _, _), L2), L2 = [_])).

% ---------------------------------------------------------------------
% 4. Passagem livre (teste2: ida bloqueada, volta livre)
% ---------------------------------------------------------------------
:- assertz((teste(porta_bloqueia_so_a_ida) :-
    definir_cenario(teste2),
    \+ passagem_livre(corredor, quarto, []),
    passagem_livre(quarto, corredor, []),
    passagem_livre(corredor, quarto, [derrubado(quadro)]),
    passagem_livre(corredor, quarto, [arrombada(porta1)]))).

:- assertz((teste(movel_bloqueia_so_a_ida) :-
    definir_cenario(teste2),
    \+ passagem_livre(sala, cozinha, []),
    passagem_livre(cozinha, sala, []),
    passagem_livre(sala, cozinha, [removido(estante)]))).

:- assertz((teste(mover_sem_conexao_falha) :-
    definir_cenario(teste),
    \+ passagem_livre(corredor, sala, []),     % conexao nao e de volta
    nao_permite(estado(corredor, 10, [ana-0], []), mover(corredor, sala)))).

% ---------------------------------------------------------------------
% 5. Acoes sem susto
% ---------------------------------------------------------------------
:- assertz((teste(remover_movel) :-
    definir_cenario(teste2),
    passo(estado(sala, 10, [ana-0], []), remover(estante),
          E1, 2),
    E1 == estado(sala, 8, [ana-0], [removido(estante)]),
    nao_permite(E1, remover(estante)),                 % so uma vez
    nao_permite(estado(corredor, 10, [ana-0], []), remover(estante)),
    nao_permite(estado(sala, 1, [ana-0], []), remover(estante)),  % sem energia
    passo(E1, mover(sala, cozinha), _, 1))).

:- assertz((teste(arrombar_porta) :-
    definir_cenario(teste2),
    passo(estado(corredor, 10, [ana-0], []), arrombar(porta1), E1, 6),
    E1 == estado(corredor, 4, [ana-0], [arrombada(porta1)]),
    passo(E1, mover(corredor, quarto), _, 1),
    nao_permite(E1, arrombar(porta1)),
    nao_permite(estado(corredor, 5, [ana-0], []), arrombar(porta1)),
    % porta ja aberta pelo quadro: arrombar nao faz sentido
    nao_permite(estado(corredor, 10, [ana-0], [derrubado(quadro)]),
                arrombar(porta1)))).

:- assertz((teste(usar_espelho) :-
    definir_cenario(teste2),
    passo(estado(cozinha, 3, [ana-0], []), usar(espelho1), E1, 0),
    E1 == estado(cozinha, 8, [ana-0], [usado(espelho1)]),
    passo(estado(cozinha, 8, [ana-0], []), usar(espelho1), E2, 0),
    E2 = estado(_, 10, _, _),                          % nao passa de 10
    nao_permite(estado(cozinha, 10, [ana-0], []), usar(espelho1)),   % cheia
    nao_permite(E1, usar(espelho1)),                   % so uma vez
    nao_permite(estado(sala, 3, [ana-0], []), usar(espelho1)))).     % outro comodo

:- assertz((teste(mover_exige_energia) :-
    definir_cenario(teste),
    nao_permite(estado(sala, 0, [ana-0], []), mover(sala, corredor)),
    passo(estado(sala, 1, [ana-0], []), mover(sala, corredor), _, 1))).

% ---------------------------------------------------------------------
% 6. Susto: distancia, pontos, bonus e teto
% ---------------------------------------------------------------------
:- assertz((teste(distancia) :-
    definir_cenario(teste2),
    distancia(quarto, quarto, 0),
    distancia(corredor, quarto, 1),
    distancia(sala, quarto, 2),
    \+ distancia(cozinha, quarto, _),                  % 3 passagens: fora do alcance
    definir_cenario(teste),
    \+ distancia(quarto, corredor, _))).               % so existe a ida

:- assertz((teste(pontos_conforme_tabela) :-
    pontos_susto(barulho, 0, 2), pontos_susto(barulho, 1, 1),
    pontos_susto(barulho, 2, 0),
    pontos_susto(derrubar, 0, 3), pontos_susto(derrubar, 1, 1),
    pontos_susto(derrubar, 2, 1))).

:- assertz((teste(bonus_so_se_ja_tremia) :-
    definir_cenario(teste),
    atualizar_sustos(derrubar, quarto, [ana-3], S1), S1 == [ana-6],   % 3 nao treme
    atualizar_sustos(derrubar, quarto, [ana-4], S2), S2 == [ana-8],   % 4+3+1
    atualizar_sustos(barulho, quarto, [ana-4], S3), S3 == [ana-7],    % 4+2+1
    atualizar_sustos(barulho, quarto, [ana-2], S4), S4 == [ana-4])).  % chega a 4 sem bonus

:- assertz((teste(teto_de_8_e_fugitivo_nao_muda) :-
    definir_cenario(teste),
    atualizar_sustos(derrubar, quarto, [ana-7], S1), S1 == [ana-8],
    atualizar_sustos(derrubar, quarto, [ana-8], S2), S2 == [ana-8])).

:- assertz((teste(fora_do_alcance_nao_muda) :-
    definir_cenario(teste2),
    atualizar_sustos(derrubar, cozinha, [ana-0], S1), S1 == [ana-0],
    atualizar_sustos(barulho, sala, [ana-0], S2), S2 == [ana-0],      % dist 2 = 0 ponto
    atualizar_sustos(derrubar, sala, [ana-0], S3), S3 == [ana-1])).   % dist 2 = 1 ponto

% ---------------------------------------------------------------------
% 7. Barulho e derrubar
% ---------------------------------------------------------------------
:- assertz((teste(barulho_basico) :-
    definir_cenario(teste),
    passo(estado(quarto, 10, [ana-0], []), barulho(quarto), E1, 2),
    E1 == estado(quarto, 8, [ana-2], [barulho(quarto)]),
    nao_permite(E1, barulho(quarto)),                  % so uma vez por comodo
    passo(estado(corredor, 10, [ana-0], []), barulho(corredor), E2, 2),
    E2 == estado(corredor, 8, [ana-1], [barulho(corredor)]),
    nao_permite(estado(quarto, 1, [ana-0], []), barulho(quarto)),     % sem energia
    nao_permite(estado(sala, 10, [ana-0], []), barulho(quarto)))).    % outro comodo

:- assertz((teste(barulho_inutil_nao_e_permitido) :-
    definir_cenario(teste),
    nao_permite(estado(sala, 10, [ana-0], []), barulho(sala)),        % dist 2 = 0
    nao_permite(estado(quarto, 10, [ana-8], []), barulho(quarto)))).  % ja fugiu

:- assertz((teste(derrubar_basico) :-
    definir_cenario(teste),
    passo(estado(quarto, 10, [ana-0], []), derrubar(vaso), E1, 2),
    E1 == estado(quarto, 8, [ana-3], [derrubado(vaso)]),
    nao_permite(E1, derrubar(vaso)),                   % so uma vez
    nao_permite(estado(corredor, 10, [ana-0], []), derrubar(vaso)),   % outro comodo
    nao_permite(estado(quarto, 1, [ana-0], []), derrubar(vaso)))).    % sem energia

:- assertz((teste(derrubar_objeto_chave_sem_morador_por_perto) :-
    definir_cenario(teste2),
    % ana ja fugiu: derrubar o quadro nao assusta ninguem, mas abre a porta
    passo(estado(corredor, 10, [ana-8], []), derrubar(quadro), E1, 2),
    E1 == estado(corredor, 8, [ana-8], [derrubado(quadro)]),
    passagem_livre(corredor, quarto, [derrubado(quadro)]),
    % objeto comum nessa situacao seria inutil (teste com o vaso do cenario teste)
    definir_cenario(teste),
    nao_permite(estado(quarto, 10, [ana-8], []), derrubar(vaso)))).

% ---------------------------------------------------------------------
% 8. Objetivo
% ---------------------------------------------------------------------
:- assertz((teste(objetivo) :-
    definir_cenario(teste),
    \+ objetivo(estado(quarto, 5, [ana-7], [])),
    objetivo(estado(quarto, 5, [ana-8], [])),
    definir_cenario(teste3),
    \+ objetivo(estado(a, 5, [ana-8, bia-7], [])),
    objetivo(estado(a, 5, [ana-8, bia-8], [])))).

% ---------------------------------------------------------------------
% Execucao
% ---------------------------------------------------------------------
rodar_testes :-
    findall(Nome-Corpo, clause(teste(Nome), Corpo), Testes),
    length(Testes, Total),
    foldl(executa, Testes, 0, Acertos),
    format("~n~w de ~w testes passaram.~n", [Acertos, Total]),
    (   Acertos =:= Total
    ->  format("Tudo certo!~n")
    ;   format("Ha testes falhando: veja as linhas FALHOU acima.~n")
    ).

executa(Nome-Corpo, A0, A) :-
    (   catch(Corpo, Erro,
              ( format("ERRO   ~w: ~w~n", [Nome, Erro]), fail ))
    ->  format("ok     ~w~n", [Nome]),
        A is A0 + 1
    ;   format("FALHOU ~w~n", [Nome]),
        A = A0
    ).
