% =====================================================================
% regras.pl  --  Regras do jogo (Pessoa 2)
% =====================================================================
% Este arquivo diz A BUSCA (Pessoa 1) o que o fantasma pode fazer em
% cada momento e o que acontece depois. Segue o CONTRATO do grupo.
%
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
%
% ETAPAS:
%   [x] 1. Arquivos base e atalhos do cenario ativo
%   [x] 2. estado_inicial/1 e objetivo/1
%   [x] 3. porta_aberta/2, bloqueada/3 e passagem_livre/3
%   [x] 4. acoes sem susto: mover, usar, remover, arrombar
%   [x] 5. susto: distancia, pontos e atualizacao de Sustos
%   [x] 6. acoes de susto: barulho e derrubar
% =====================================================================

:- ensure_loaded(config).

% ---------------------------------------------------------------------
% Fatos do cenario
% ---------------------------------------------------------------------
% Os fatos dos cenarios (arquivo da Pessoa 3) levam o identificador do
% cenario como PRIMEIRO argumento. Os predicados abaixo sao declarados
% aqui para o Prolog aceitar que eles venham de outro arquivo e para
% nao dar erro quando um cenario nao tiver, por exemplo, nenhum movel.

:- multifile inicio/2, conecta/3, morador/3, objeto/4,
             porta/4, movel/4, espelho/3.
:- dynamic   inicio/2, conecta/3, morador/3, objeto/4,
             porta/4, movel/4, espelho/3.

% ---------------------------------------------------------------------
% Cenario ativo
% ---------------------------------------------------------------------
% cenario_ativo(Id) guarda qual cenario esta sendo executado.
% Quem troca o cenario e a executar/1 (Pessoa 3), usando definir_cenario/1.

:- dynamic cenario_ativo/1.

%% definir_cenario(+Id)
%  Escolhe o cenario ativo. Falha com aviso se o cenario nao existir.
definir_cenario(Id) :-
    (   inicio(Id, _)
    ->  retractall(cenario_ativo(_)),
        assertz(cenario_ativo(Id))
    ;   format("Cenario desconhecido: ~w~n", [Id]),
        fail
    ).

% ---------------------------------------------------------------------
% Atalhos: as regras usam os nomes SEM o identificador, e os atalhos
% leem so os fatos do cenario ativo.
%   conecta(sala, corredor)  ==>  conecta(<ativo>, sala, corredor)
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

% ---------------------------------------------------------------------
% ETAPA 2: estado inicial e teste de objetivo
% ---------------------------------------------------------------------

%% estado_inicial(-Estado)
%  Monta a primeira "foto" do jogo, de onde a busca comeca:
%    - Comodo : o comodo de inicio/1 do cenario ativo
%    - Energia: energia_inicial (config.pl)
%    - Sustos : todos os moradores com 0 pontos, em ordem alfabetica
%    - Feitos : vazio, porque ainda nao foi feito nada
%  Exemplo: estado(sala, 10, [ana-0], [])
estado_inicial(estado(Comodo, Energia, Sustos, [])) :-
    once(inicio(Comodo)),
    param(energia_inicial, Energia),
    findall(Nome-0, morador(Nome, _), Sustos0),
    sort(Sustos0, Sustos).

%% objetivo(+Estado)
%  Verdadeiro quando TODOS os moradores chegaram a susto_max pontos
%  (ou seja, todos fugiram). Basta um morador abaixo disso para ser falso.
objetivo(estado(_, _, Sustos, _)) :-
    param(susto_max, Max),
    forall(member(_-Pontos, Sustos), Pontos >= Max).

% ---------------------------------------------------------------------
% ETAPA 3: portas, moveis e passagem livre
% ---------------------------------------------------------------------
% Porta aberta e movel removido NAO tem registro proprio no estado.
% O programa descobre olhando a lista Feitos.

%% porta_aberta(+Porta, +Feitos)
%  Uma porta esta aberta se:
%    - ela foi arrombada, ou
%    - o objeto que a abre (objeto com efeito abre(Porta)) ja foi derrubado.
porta_aberta(Porta, Feitos) :-
    memberchk(arrombada(Porta), Feitos).
porta_aberta(Porta, Feitos) :-
    objeto(Objeto, _, abre(Porta)),
    memberchk(derrubado(Objeto), Feitos).

%% bloqueada(+De, +Para, +Feitos)
%  A passagem De -> Para esta bloqueada se:
%    - existe uma porta nela que ainda nao foi aberta, ou
%    - existe um movel nela que ainda nao foi removido.
%  O bloqueio vale so no sentido cadastrado: uma porta/movel de De para
%  Para NAO bloqueia a volta (Para -> De), a menos que o cenario cadastre
%  tambem a volta.
bloqueada(De, Para, Feitos) :-
    porta(Porta, De, Para),
    \+ porta_aberta(Porta, Feitos).
bloqueada(De, Para, Feitos) :-
    movel(Movel, De, Para),
    \+ memberchk(removido(Movel), Feitos).

%% passagem_livre(+De, +Para, +Feitos)
%  O fantasma pode ir de De para Para: a ligacao existe e nada bloqueia.
%  (E esta regra que a acao mover/2 usa na etapa 4.)
passagem_livre(De, Para, Feitos) :-
    conecta(De, Para),
    \+ bloqueada(De, Para, Feitos).

% ---------------------------------------------------------------------
% ETAPA 4: acoes sem susto (mover, usar, remover, arrombar)
% ---------------------------------------------------------------------
% acao(+Estado, ?Acao, -NovoEstado, -Custo)
%   Uma clausula por tipo de acao. Em backtracking entrega uma
%   possibilidade por vez; se Acao ja vier escolhida (ex.: mover(sala,
%   corredor)), so a clausula daquele tipo casa e sai um unico resultado.
%   Custo = so o custo DESTA acao (a soma total e feita pela busca).
%   Toda acao com custo exige Energia >= Custo.

%% mover(Origem, Destino)
%  Pre : fantasma na Origem, passagem livre ate o Destino.
%  Faz : fantasma vai para o Destino. Sustos e Feitos nao mudam.
acao(estado(Origem, Energia, Sustos, Feitos),
     mover(Origem, Destino),
     estado(Destino, Energia1, Sustos, Feitos),
     Custo) :-
    custo(mover, Custo),
    Energia >= Custo,
    passagem_livre(Origem, Destino, Feitos),
    Energia1 is Energia - Custo.

%% usar(Espelho)
%  Pre : fantasma no comodo do espelho, espelho ainda nao usado e
%        energia abaixo do maximo (evita desperdicio).
%  Faz : energia sobe 'recarga' pontos, sem passar de energia_max;
%        usado(Espelho) entra em Feitos. Custo 0.
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

%% remover(Movel)
%  Pre : fantasma no comodo de ORIGEM da passagem do movel e o
%        movel ainda nao foi removido.
%  Faz : removido(Movel) entra em Feitos.
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

%% arrombar(Porta)
%  Pre : fantasma no comodo de ORIGEM da passagem da porta e a porta
%        ainda fechada (nem arrombada, nem aberta pelo objeto-chave).
%  Faz : arrombada(Porta) entra em Feitos.
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

% ---------------------------------------------------------------------
% ETAPA 5: susto (distancia, pontos e atualizacao de Sustos)
% ---------------------------------------------------------------------
% Estes predicados so CALCULAM o susto. Quem os usa e a etapa 6
% (barulho e derrubar), que chama atualizar_sustos/4.

%% distancia(+De, +Para, -D)
%  D = numero minimo de passagens de De ate Para, seguindo conecta/2 no
%  sentido cadastrado. Mesmo comodo = 0. So conta ate param(alcance, _);
%  alem disso, FALHA (o susto nao chega la).
%  Portas e moveis NAO atrapalham: o barulho passa por eles.
distancia(De, Para, D) :-
    param(alcance, Max),
    between(0, Max, D),
    alcanca(De, Para, D),
    !.

%  alcanca(+De, +Para, +N): existe caminho de EXATAMENTE N passagens.
%  (o between/3 acima testa 0, 1, 2... e o corte fica com o menor N)
alcanca(Comodo, Comodo, 0).
alcanca(De, Para, N) :-
    N > 0,
    N1 is N - 1,
    conecta(De, Meio),
    alcanca(Meio, Para, N1).

%% pontos_susto(+Tipo, +Distancia, -Pontos)
%  Tipo e barulho ou derrubar. Pontos = base // (1 + Distancia),
%  arredondado para baixo (valores base em config.pl).
%    barulho : dist 0 -> 2, dist 1 -> 1, dist 2 -> 0
%    derrubar: dist 0 -> 3, dist 1 -> 1, dist 2 -> 1
pontos_susto(Tipo, Distancia, Pontos) :-
    base_susto(Tipo, Base),
    Pontos is Base // (1 + Distancia).

%% atualizar_sustos(+Tipo, +Comodo, +Sustos0, -Sustos)
%  Aplica uma acao de susto (barulho ou derrubar) feita em Comodo.
%  Sustos continua na mesma ordem (alfabetica) de Sustos0.
atualizar_sustos(Tipo, Comodo, Sustos0, Sustos) :-
    maplist(novo_susto(Tipo, Comodo), Sustos0, Sustos).

%% novo_susto(+Tipo, +Comodo, +Nome-Antes, -Nome-Depois)
%  Regras para cada morador:
%    - ja fugiu (Antes >= susto_max): nao muda;
%    - fora do alcance ou sem pontos: nao muda;
%    - recebe os pontos; se JA estava tremendo antes da acao
%      (Antes >= susto_tremor) e recebeu pontos, ganha +bonus_tremor;
%    - o total nunca passa de susto_max.
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

% ---------------------------------------------------------------------
% ETAPA 6: acoes de susto (barulho e derrubar)
% ---------------------------------------------------------------------
% Usam atualizar_sustos/4 (etapa 5). Regra de "acao util": so e permitida
% se assustar pelo menos um morador, isto e, se a lista Sustos MUDAR.
% (Morador que ja fugiu ou fora do alcance nao muda, entao nao conta.)

%% barulho(Comodo)
%  Pre : fantasma no Comodo, ainda nao fez barulho ali e a acao assusta
%        pelo menos um morador.
%  Faz : atualiza Sustos; barulho(Comodo) entra em Feitos.
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

%% derrubar(Objeto)
%  Pre : objeto no comodo do fantasma, ainda nao derrubado, e a acao
%        assusta alguem OU o objeto abre uma porta (objeto-chave pode ser
%        derrubado mesmo sem moradores por perto).
%  Faz : atualiza Sustos; derrubado(Objeto) entra em Feitos. Se o objeto
%        abre uma porta, ela passa a contar como aberta (porta_aberta/2
%        olha Feitos), sem custo extra.
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

% ---------------------------------------------------------------------
% (a etapa 7, testes, e feita a mao)
% ---------------------------------------------------------------------
