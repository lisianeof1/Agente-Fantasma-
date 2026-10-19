% ==========================================
% SAIDA EM LINGUAGEM NATURAL
% ==========================================

% Traduz uma acao de movimento
mostrar_acao(mover(Origem, Destino)) :-
    format(
        'O fantasma se move de ~w para ~w.~n',
        [Origem, Destino]
    ).

% Traduz uma acao de fazer barulho
mostrar_acao(barulho(Comodo)) :-
    format(
        'O fantasma faz barulho em ~w.~n',
        [Comodo]
    ).

% Traduz a queda de um objeto especial
mostrar_acao(derrubar(Objeto)) :-
    cenario_ativo(Cenario),
    objeto(Cenario, Objeto, _, abre(Porta)),
    format(
        'O fantasma derruba ~w e abre a porta ~w.~n',
        [Objeto, Porta]
    ).

% Traduz a queda de um objeto comum
mostrar_acao(derrubar(Objeto)) :-
    cenario_ativo(Cenario),
    objeto(Cenario, Objeto, Comodo, nenhum),
    format(
        'O fantasma derruba ~w em ~w.~n',
        [Objeto, Comodo]
    ).

% Traduz a remocao de um movel
mostrar_acao(remover(Movel)) :-
    cenario_ativo(Cenario),
    movel(Cenario, Movel, De, Para),
    format(
        'O fantasma remove ~w e libera a passagem de ~w para ~w.~n',
        [Movel, De, Para]
    ).

% Traduz o arrombamento de uma porta
mostrar_acao(arrombar(Porta)) :-
    cenario_ativo(Cenario),
    porta(Cenario, Porta, De, Para),
    format(
        'O fantasma arromba a porta entre ~w e ~w.~n',
        [De, Para]
    ).

% Traduz o uso de um espelho
mostrar_acao(usar(Espelho)) :-
    cenario_ativo(Cenario),
    espelho(Cenario, Espelho, Comodo),
    format(
        'O fantasma usa o espelho em ~w para recuperar energia.~n',
        [Comodo]
    ).

% Caso uma acao ainda nao tenha uma traducao
mostrar_acao(Acao) :-
    format(
        'Acao ainda sem traducao: ~w.~n',
        [Acao]
    ).

% ==========================================
% MOSTRAR TODAS AS ACOES DO PLANO
% ==========================================

% Caso a lista esteja vazia
mostrar_plano([]) :-
    writeln('Fim do plano.').

% Caso ainda existam acoes na lista
mostrar_plano([Acao | Restantes]) :-
    mostrar_acao(Acao),
    mostrar_plano(Restantes).


% ==========================================
% APRESENTAR OS RESULTADOS DA BUSCA
% ==========================================

% Apresenta uma solucao encontrada
mostrar_solucao(Plano, Custo) :-
    writeln(''),
    writeln('========== PLANO ENCONTRADO =========='),
    mostrar_plano(Plano),
    format(
        'Custo total do plano: ~w unidades de energia.~n',
        [Custo]
    ),
    writeln('VITORIA! Todos os moradores fugiram!'),
    writeln('======================================').

% Apresenta uma mensagem quando nao ha solucao
mostrar_sem_solucao :-
    writeln(''),
    writeln(
        'Nao foi encontrada uma sequencia de acoes capaz de fazer todos os moradores fugirem neste cenario.'
    ).

% ==========================================
% EXECUCAO COMPLETA DO AGENTE
% ==========================================

executar :-
    cenario_ativo(Cenario),
    format('~nCenario selecionado: ~w~n', [Cenario]),
    (
        resolver(Plano, Custo)
        ->
        mostrar_solucao(Plano, Custo)
        ;
        mostrar_sem_solucao
    ).
