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
%   [x] 1. Arquivos base e atalhos do cenario ativo   <-- este arquivo
%   [ ] 2. estado_inicial/1 e objetivo/1
%   [ ] 3. porta_aberta/2 e bloqueada/3
%   [ ] 4. acoes sem susto: mover, usar, remover, arrombar
%   [ ] 5. susto: distancia, pontos e atualizacao de Sustos
%   [ ] 6. acoes de susto: barulho e derrubar
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
% (as proximas etapas entram aqui)
% ---------------------------------------------------------------------
