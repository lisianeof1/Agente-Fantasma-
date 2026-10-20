% ==========================================
% SAIDA EM LINGUAGEM NATURAL
% ==========================================
% Este arquivo transforma as acoes do plano em mensagens faceis de ler.
% Tambem apresenta o plano, o custo acumulado e o resultado da busca.
%
% A selecao do cenario pode ser feita de duas formas:
%   executar(desafiador).  seleciona e executa esse cenario
%   executar.              executa o cenario que ja esta ativo
%
% A busca precisa fornecer resolver(Plano, Custo).

% Traduz uma acao de movimento.
mostrar_acao(mover(Origem, Destino)) :-
    format(
        'O fantasma se move de ~w para ~w.~n',
        [Origem, Destino]
    ),
    !.

% Traduz uma acao de fazer barulho.
mostrar_acao(barulho(Comodo)) :-
    format(
        'O fantasma faz barulho em ~w.~n',
        [Comodo]
    ),
    !.

% Traduz a queda de um objeto que abre uma porta.
mostrar_acao(derrubar(Objeto)) :-
    cenario_ativo(Cenario),
    objeto(Cenario, Objeto, _, abre(Porta)),
    format(
        'O fantasma derruba ~w e abre a porta ~w.~n',
        [Objeto, Porta]
    ),
    !.

% Traduz a queda de um objeto comum.
mostrar_acao(derrubar(Objeto)) :-
    cenario_ativo(Cenario),
    objeto(Cenario, Objeto, Comodo, nenhum),
    format(
        'O fantasma derruba ~w em ~w.~n',
        [Objeto, Comodo]
    ),
    !.

% Traduz a remocao de um movel que bloqueia uma passagem.
mostrar_acao(remover(Movel)) :-
    cenario_ativo(Cenario),
    movel(Cenario, Movel, De, Para),
    format(
        'O fantasma remove ~w e libera a passagem de ~w para ~w.~n',
        [Movel, De, Para]
    ),
    !.

% Traduz o arrombamento de uma porta.
mostrar_acao(arrombar(Porta)) :-
    cenario_ativo(Cenario),
    porta(Cenario, Porta, De, Para),
    format(
        'O fantasma arromba a porta entre ~w e ~w.~n',
        [De, Para]
    ),
    !.

% Traduz o uso de um espelho.
mostrar_acao(usar(Espelho)) :-
    cenario_ativo(Cenario),
    espelho(Cenario, Espelho, Comodo),
    format(
        'O fantasma usa o espelho em ~w para recuperar energia.~n',
        [Comodo]
    ),
    !.

% Esta mensagem aparece apenas se nenhuma traducao acima servir.
mostrar_acao(Acao) :-
    format(
        'Acao ainda sem traducao: ~w.~n',
        [Acao]
    ).


% ==========================================
% MOSTRAR AS ACOES DO PLANO
% ==========================================

% Comeca a numeracao do plano em 1.
mostrar_plano(Plano) :-
    mostrar_plano(Plano, 1).

% Quando nao ha mais acoes, encerra a apresentacao.
mostrar_plano([], _) :-
    writeln('Fim do plano.').

% Mostra a acao atual e continua com o restante da lista.
mostrar_plano([Acao | Restantes], Numero) :-
    format('~d. ', [Numero]),
    mostrar_acao(Acao),
    Proximo is Numero + 1,
    mostrar_plano(Restantes, Proximo).


% ==========================================
% APRESENTAR OS RESULTADOS DA BUSCA
% ==========================================

% Esta mensagem so e chamada quando resolver/2 encontra um plano.
mostrar_solucao(Plano, Custo) :-
    nl,
    writeln('========== PLANO ENCONTRADO =========='),
    length(Plano, Quantidade),
    format('Quantidade de acoes: ~d~n~n', [Quantidade]),
    mostrar_plano(Plano),
    format(
        'Custo total acumulado retornado pela busca: ~w.~n',
        [Custo]
    ),
    writeln('VITORIA! Todos os moradores fugiram!'),
    writeln('======================================').

% Mensagem usada quando resolver/2 falha e nao encontra um plano.
mostrar_sem_solucao :-
    nl,
    writeln(
        'Nao foi encontrada uma sequencia de acoes capaz de fazer todos os moradores fugirem neste cenario.'
    ).


% ==========================================
% EXECUCAO DO AGENTE
% ==========================================

% Executa o cenario que ja estiver ativo.
executar :-
    (   cenario_ativo(Cenario)
    ->  executar_cenario(Cenario)
    ;   writeln('Nenhum cenario esta selecionado. Use executar(Id).')
    ).

% Seleciona explicitamente um cenario e depois executa a busca.
% Exemplos: executar(simples), executar(desafiador), executar(impossivel).
executar(Cenario) :-
    definir_cenario(Cenario),
    executar_cenario(Cenario).

% Mostra qual cenario esta sendo executado e apresenta o resultado.
executar_cenario(Cenario) :-
    format('~nCenario selecionado: ~w~n', [Cenario]),
    (   resolver(Plano, Custo)
    ->  mostrar_solucao(Plano, Custo)
    ;   mostrar_sem_solucao
    ).
