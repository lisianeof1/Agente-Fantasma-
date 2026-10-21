# 👻 Agente Fantasma

Agente inteligente em **Prolog** que planeja como assustar os moradores de uma casa assombrada até que **todos fujam**, gastando a **menor energia possível**.

> Trabalho 1 de Inteligência Artificial, UFSCar, 2026/2
> Professor: Murilo Naldi

## Integrantes

| Nome | RA |
|---|---|
| Juliana Andrade Buono | 845309 |
| Lisiane de Oliveira Ferreira | 846974 |
| Vitória da Silva Costa | 846735 |

## Sobre o projeto

A casa é um **grafo direcionado** de cômodos. O fantasma pode se mover, fazer barulho, derrubar objetos, remover móveis, arrombar portas e usar espelhos para recuperar energia. Cada ação tem **custo** e **condições**, então o agente precisa planejar a ordem das ações e administrar a energia.

O objetivo é fazer cada morador chegar a **8 pontos de susto**. O plano é encontrado por **busca de custo uniforme**, que garante o plano de menor custo total. O resultado é mostrado em **linguagem natural**. Se não houver solução, o programa informa isso.

### Resumo PEAS

| | |
|---|---|
| **P**erformance | Todos os moradores fogem (8 pontos), com o menor custo acumulado de energia |
| **E**nvironment | Casa em forma de grafo; completamente observável, determinística, sequencial, estática, discreta, agente único |
| **A**ctuators | mover, barulho, derrubar, remover, arrombar, usar espelho |
| **S**ensors | Estado do jogo: cômodo, energia, sustos e o que já foi feito |

## Estrutura do repositório

```
.
├── README.md
├── main.pl          # carrega todos os arquivos na ordem correta
├── src/
│   ├── config.pl    # valores configuráveis (energia, custos, susto)
│   ├── regras.pl    # estado, ações, portas, móveis e susto
│   ├── busca.pl     # busca de custo uniforme (resolver/2)
│   └── saida.pl     # saída em linguagem natural e executar/0,1
├── cenarios/
│   └── cenarios.pl  # fatos dos três cenários
├── testes/          # testes do projeto
└── docs/            # relatório e documentos de decisões
```

## Como funciona

### Estado

```prolog
estado(Comodo, Energia, Sustos, Feitos)
```

| Campo | Significado | Exemplo |
|---|---|---|
| `Comodo` | Onde o fantasma está | `sala` |
| `Energia` | Energia disponível | `7` |
| `Sustos` | Pontos de susto de cada morador (lista ordenada) | `[ana-4, bia-0]` |
| `Feitos` | O que já foi feito (lista ordenada) | `[barulho(sala), derrubado(quadro)]` |

Estado inicial de exemplo: `estado(sala, 10, [ana-0], [])`.

O **custo acumulado** fica na busca, fora do estado. Recarregar energia não reduz o custo já gasto.

### Ações

| Ação | Custo | Condições principais | Efeito |
|---|---|---|---|
| `mover(Origem, Destino)` | 1 | Existe conexão e a passagem não está bloqueada | Fantasma vai para o destino |
| `barulho(Comodo)` | 2 | Ainda não houve barulho ali e a ação assusta alguém | Assusta moradores por perto |
| `derrubar(Objeto)` | 2 | Objeto no cômodo, ainda não derrubado, e assusta alguém ou abre uma porta | Assusta e, se o objeto for a chave, abre a porta |
| `remover(Movel)` | 2 | Fantasma no cômodo de origem da passagem bloqueada | Libera a passagem |
| `arrombar(Porta)` | 6 | Fantasma na origem da porta fechada | Abre a porta |
| `usar(Espelho)` | 0 | Fantasma no cômodo do espelho, espelho não usado, energia abaixo do máximo | Recupera 5 de energia (máx. 10) |

Qualquer ação com custo exige energia suficiente.

### Susto

- Os moradores começam com **0** pontos, **tremem a partir de 4** e **fogem com 8**.
- Pontos recebidos: `base // (1 + distância)`, com base 2 para barulho e 3 para derrubar.
- A distância é o número de passagens, seguindo as conexões. O alcance máximo é 2.
- Quem **já estava tremendo antes da ação** e recebeu pontos ganha **+1** de bônus.
- Os pontos nunca passam de 8, e morador que já fugiu não recebe mais nada.

| Distância | Barulho | Derrubar |
|---|---|---|
| 0 (mesmo cômodo) | 2 | 3 |
| 1 | 1 | 1 |
| 2 | 0 | 1 |

### Busca de custo uniforme

- Cada nó da fronteira tem a forma `no(Estado, Custo, Acoes)`, e a fronteira fica sempre **ordenada por custo crescente**.
- O objetivo é testado **ao retirar** o nó da fronteira, o que garante o plano de menor custo.
- Estados já explorados são guardados e descartados, evitando ciclos.
- Se a fronteira esvaziar, `resolver/2` **falha**, e a saída informa que não há solução.

```prolog
?- resolver(Plano, Custo).
% Plano = lista de ações, da primeira à última
% Custo = soma dos custos das ações do plano
```

## Cenários

| Cenário | Descrição | Resultado esperado |
|---|---|---|
| `simples` | 3 cômodos (sala, corredor, cozinha). Maria está na cozinha. Dois objetos comuns, sem portas nem móveis. | Plano encontrado |
| `desafiador` | 5 cômodos. Ana e Bruno estão no quarto. O `quadro_chave` (na sala) abre a `porta_quarto`; o `armario` bloqueia corredor → cozinha; há um espelho na biblioteca. | Plano encontrado, respeitando bloqueios e energia |
| `impossivel` | João está no `quarto_isolado`, sem nenhuma conexão até ele. | Sem solução |

> As conexões são **direcionadas**: para permitir ida e volta, é preciso declarar os dois sentidos.

## ▶️ Como executar

### Opção 1: Clonando o repositório (SWI-Prolog)

1. Instale o [SWI-Prolog](https://www.swi-prolog.org/Download.html).
2. Clone e entre na pasta:

```bash
git clone <URL-DO-REPOSITORIO>
cd <NOME-DA-PASTA>
```

3. Abra o Prolog carregando o `main.pl`:

```bash
swipl main.pl
```

4. Execute um cenário:

```prolog
?- executar(simples).
?- executar(desafiador).
?- executar(impossivel).
```

Para rodar o cenário que já está ativo (por padrão, `desafiador`):

```prolog
?- executar.
```

### Opção 2: Online no SWISH

1. Acesse <https://swish.swi-prolog.org/>.
2. Crie um novo programa e **cole o conteúdo dos arquivos em um único editor**, nesta ordem:
   1. `src/config.pl`
   2. `src/regras.pl`
   3. `cenarios/cenarios.pl`
   4. `src/busca.pl`
   5. `src/saida.pl`
3. **Não cole o `main.pl`**: ele só serve para carregar arquivos.
4. No campo de consulta, rode:

```prolog
?- executar(simples).
```

### Consultas úteis para depuração

```prolog
?- definir_cenario(simples).      % escolhe o cenário ativo
?- estado_inicial(E).             % mostra o estado inicial
?- resolver(Plano, Custo).        % roda só a busca, sem formatar a saída
```

## Exemplo de saída

A saída segue este formato (o plano e o custo reais dependem do cenário):

```
Cenario selecionado: simples

Casa do cenario simples
Comodos: [sala,corredor,cozinha]
Passagens direcionadas:
  sala -> corredor
  corredor -> cozinha
Moradores e seus comodos:
  maria esta em cozinha.

========== PLANO ENCONTRADO ==========
Quantidade de acoes: ...

1. O fantasma se move de sala para corredor.
2. ...
Fim do plano.
Custo total acumulado retornado pela busca: ...
VITORIA! Todos os moradores fugiram!
======================================
```

Para o cenário `impossivel`:

```
Nao foi encontrada uma sequencia de acoes capaz de fazer todos os moradores fugirem neste cenario.
```

## Configuração

Os valores do jogo ficam em `src/config.pl`, e as regras não precisam ser alteradas para mudá-los.

| Parâmetro | Valor |
|---|---|
| Energia inicial / máxima | 10 / 10 |
| Recarga do espelho | 5 |
| Tremor / fuga | 4 / 8 |
| Bônus de tremor | 1 |
| Alcance do susto | 2 passagens |
| Custos (mover, barulho, derrubar, remover, arrombar, usar) | 1, 2, 2, 2, 6, 0 |

Para criar um novo cenário, basta adicionar fatos em `cenarios/cenarios.pl` com um novo identificador (`comodo/2`, `conecta/3`, `inicio/2`, `morador/3`, `objeto/4`, `porta/4`, `movel/4`, `espelho/3`).

## Testes

Os testes ficam na pasta `testes/`.

```bash
# exemplo: ajuste o nome do arquivo
swipl -s testes/<arquivo_de_teste>.pl
```

## Documentação

O relatório completo e as decisões do grupo estão na pasta [`docs/`](docs/).

## Tecnologias

- [SWI-Prolog](https://www.swi-prolog.org/)
- [SWISH](https://swish.swi-prolog.org/)
