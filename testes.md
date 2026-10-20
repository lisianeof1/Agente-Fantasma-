
# Registro de testes — Agente Fantasma

**Data:** 19/10/2026  
**Ambiente de testes:** SWISH (Prolog no navegador)  
**Responsável:** Lisiane

## 1. Testes dos fatos dos cenários

Os testes foram realizados para verificar se os fatos dos três cenários foram declarados corretamente e se o Prolog consegue consultá-los.

| Teste | Consulta executada | Resultado esperado | Resultado obtido |
|---|---|---|---|
| Cenário ativo | `cenario_ativo(X).` | Identificar o cenário ativo como `simples` | Passou. O cenário ativo foi identificado corretamente. |
| Cômodos do cenário simples | `comodo(simples, X).` | Encontrar sala, corredor e cozinha | Passou. Os três cômodos foram encontrados. |
| Cômodos do cenário desafiador | `comodo(desafiador, X).` | Encontrar cinco cômodos | Passou. Os cinco cômodos foram encontrados. |
| Cômodos do cenário impossível | `comodo(impossivel, X).` | Encontrar sala, corredor e quarto isolado | Passou. Os três cômodos foram encontrados. |
| Posições iniciais | `inicio(Cenario, Comodo).` | Encontrar a posição inicial do fantasma nos três cenários | Passou. Os fatos foram encontrados corretamente. |
| Moradores | `morador(Cenario, Nome, Comodo).` | Encontrar os moradores e suas posições | Passou. Os moradores foram encontrados nas posições declaradas. |
| Objetos | `objeto(desafiador, Nome, Comodo, Efeito).` | Encontrar o quadro especial e os objetos comuns | Passou. Os objetos e seus efeitos foram consultados corretamente. |
| Porta | `porta(desafiador, Id, De, Para).` | Encontrar a porta trancada do cenário desafiador | Passou. A porta foi identificada corretamente. |
| Móvel bloqueador | `movel(desafiador, Id, De, Para).` | Encontrar o móvel e a passagem bloqueada | Passou. O móvel foi identificado corretamente. |
| Espelho | `espelho(desafiador, Id, Comodo).` | Encontrar o espelho e sua localização | Passou. O espelho foi identificado corretamente. |

## 2. Testes da saída em linguagem natural

Os testes desta seção verificam as funções de apresentação isoladamente, utilizando listas de ações criadas manualmente. Eles ainda não representam resultados obtidos pela busca automática.

| Teste | Função testada | Resultado obtido |
|---|---|---|
| Tradução de ações | `mostrar_acao/1` | Passou. As ações testadas foram convertidas em frases em português. |
| Apresentação de uma sequência | `mostrar_plano/1` | Passou. As ações foram exibidas na ordem da lista, seguidas da mensagem de fim do plano. |
| Apresentação da solução | `mostrar_solucao/2` | Passou. Foram exibidos o plano, o custo informado na consulta e a mensagem de vitória. |
| Apresentação de ausência de solução | `mostrar_sem_solucao/0` | Passou. A mensagem informando que não foi encontrada uma solução foi exibida corretamente. |

### Exemplo de teste manual da apresentação

Foi utilizada uma lista de ações contendo movimentos entre cômodos, uma ação de barulho e ações de derrubar objetos. A função `mostrar_solucao/2` recebeu essa lista e o custo de 8 unidades de energia.

O resultado apresentou as ações em linguagem natural, o custo informado e a mensagem de conclusão. Como o plano foi fornecido manualmente, esse teste verificou somente a apresentação dos resultados, não a validade do plano calculada pelo agente.

## 3. Situação dos testes integrados

Os testes integrados foram executados no SWISH em 20/10/2026, com as regras, os cenários, a busca e a saída reais. Nenhum resultado foi simulado.

| Cenário | Consulta | Resultado observado |
|---|---|---|
| Simples | `executar(simples).` | Passou. A busca retornou um plano de 5 ações, custo acumulado 8 e mensagem de vitória. |
| Desafiador | `executar(desafiador).` | Passou. A busca retornou um plano de 10 ações, custo acumulado 14 e mensagem de vitória. |
| Impossível | `executar(impossivel).` | Passou. A busca não encontrou solução e exibiu a mensagem de ausência de solução. |

Os planos e as conferências de energia e susto estão registrados na seção 7. A seleção explícita dos três cenários foi testada. A consulta direta do cenário padrão, sem chamar `definir_cenario/1`, ainda não foi registrada.

**Ponto para confirmar com Juliana:** as regras atuais só permitem `remover/1` e `arrombar/1` a partir do cômodo de origem declarado. Os planos integrados passaram sem depender da extremidade oposta. Como as conexões são direcionadas, confirmar com Juliana se essa restrição também é a regra desejada para essas ações. Nenhuma alteração foi feita em `regras.pl`.

## 4. Testes individuais das traduções de ações

| Consulta | Resultado esperado | Resultado obtido |
|---|---|---|
| `mostrar_acao(derrubar(quadro_chave)).` | Informar que o quadro foi derrubado e a porta especial foi aberta | Passou.  |
| `mostrar_acao(remover(armario)).` | Informar que o armário foi removido e a passagem foi liberada | Passou. |
| `mostrar_acao(arrombar(porta_quarto)).` | Informar que a porta foi arrombada | Passou. |
| `mostrar_acao(usar(espelho_biblioteca)).` | Informar que o espelho foi usado para recuperar energia | Passou. |
| `mostrar_acao(barulho(cozinha)).` | Informar que o fantasma fez barulho na cozinha | Passou. |
| `mostrar_acao(mover(sala, corredor)).` | Informar que o fantasma se moveu da sala para o corredor | Passou. |


## 5. Verificação de consistência dos cenários

| Teste | Resultado esperado | Resultado obtido |
|---|---|---|
| Porta e conexão | A porta corresponde a uma conexão declarada no cenário desafiador | Passou. A porta corresponde à conexão da biblioteca para o quarto. |
| Móvel e conexão | O móvel bloqueia uma conexão declarada no cenário desafiador | Passou. O armário bloqueia a passagem do corredor para a cozinha. |
| Objeto especial e porta | O efeito do quadro referencia uma porta existente | Passou. O quadro está associado à abertura da porta do quarto. |
| Quarto isolado | Não existem conexões de entrada ou saída para o quarto isolado | Passou. O quarto isolado não possui conexões declaradas. |
| Cenário ativo | O programa identifica o cenário selecionado | Passou. O cenário simples foi identificado corretamente. |

Essas verificações confirmam a consistência dos fatos declarados. Elas não comprovam, por si só, que o algoritmo de busca encontra os planos corretos ou que todas as regras do jogo funcionam.


## 6. Verificação manual de viabilidade dos cenários

### Cenário simples

Foi analisada manualmente uma sequência de ações para assustar a moradora Maria até que ela fugisse.

Sequência proposta:
1. Mover da sala para o corredor.
2. Mover do corredor para a cozinha.
3. Derrubar o vaso.
4. Fazer barulho na cozinha.
5. Derrubar o brinquedo.

Com os custos e os valores de susto definidos no projeto, a sequência gasta 8 unidades de energia e termina com 2 unidades disponíveis. Maria recebe 3 pontos de susto ao ser atingida pelo primeiro objeto, chega a 5 pontos após o barulho e foge ao receber o susto do segundo objeto, considerando o bônus por tremor e o limite de 8 pontos.

**Situação:** sequência de referência conferida manualmente e também validada pelo plano da busca integrada, registrado na seção 7.

### Cenário desafiador

Foi analisada manualmente uma sequência de ações para liberar as passagens e fazer Ana e Bruno fugirem.

Sequência proposta:
1. Derrubar o quadro especial para abrir a porta do quarto.
2. Mover da sala para o corredor.
3. Remover o armário.
4. Mover para a cozinha.
5. Mover para a biblioteca.
6. Usar o espelho.
7. Mover para o quarto.
8. Derrubar o vaso.
9. Derrubar o livro.
10. Fazer barulho no quarto.

Com os custos e os valores de susto propostos, o custo acumulado das ações é de 14 unidades de energia. O fantasma começa com 10 unidades, recupera 5 no espelho e termina com 1 unidade disponível. Ana e Bruno chegam ao limiar de fuga após o barulho, considerando o bônus por tremor e o limite de 8 pontos.

**Situação:** sequência de referência conferida manualmente e também validada pelo plano da busca integrada, registrado na seção 7.

### Observação

Essas sequências são planejamentos manuais para conferir a viabilidade dos cenários. Elas não são resultados produzidos pelo algoritmo de busca.

## 7. Testes integrados com a busca real

**Data:** 20/10/2026  
**Ambiente:** SWISH (Prolog no navegador)  
**Tipo:** teste integrado, usando a busca e as regras reais.

### Cenário simples

**Consulta:** `executar(simples).`

A busca retornou 5 ações, custo acumulado 8 e exibiu a mensagem de vitória.

Plano observado:
1. Mover da sala para o corredor.
2. Mover do corredor para a cozinha.
3. Fazer barulho na cozinha.
4. Derrubar o vaso na cozinha.
5. Derrubar o brinquedo na cozinha.

Na conferência do plano, Maria recebe 2 pontos com o barulho, chega a 5 após o vaso e atinge o limite de fuga com o brinquedo, considerando o bônus por tremor e o máximo de 8 pontos. O plano gasta 8 unidades e deixa 2 de energia.

**Resultado:** passou. A busca encontrou um plano válido para o cenário simples.

### Cenário desafiador

**Consulta:** `executar(desafiador).`

A busca retornou 10 ações, custo acumulado 14 e exibiu a mensagem de vitória.

Plano observado:
1. Derrubar o quadro-chave e abrir a porta do quarto.
2. Mover da sala para o corredor.
3. Remover o armário.
4. Mover do corredor para a cozinha.
5. Mover da cozinha para a biblioteca.
6. Usar o espelho na biblioteca.
7. Mover da biblioteca para o quarto.
8. Fazer barulho no quarto.
9. Derrubar o vaso do quarto.
10. Derrubar o livro do quarto.

Na conferência do plano, Ana e Bruno recebem 2 pontos com o barulho, chegam a 5 após o vaso e atingem o limite de fuga com o livro, considerando o bônus por tremor e o máximo de 8 pontos. O custo acumulado é 14. O espelho recupera energia sem reduzir esse custo, e o fantasma termina com 1 unidade de energia.

**Resultado:** passou. A busca encontrou um plano válido para o cenário desafiador.

### Cenário impossível

**Consulta:** `executar(impossivel).`

Saída observada:

> Nao foi encontrada uma sequencia de acoes capaz de fazer todos os moradores fugirem neste cenario.

**Resultado:** passou. A busca terminou sem solução e não exibiu mensagem de vitória.

### Observação sobre a seleção dos cenários

As três consultas selecionam explicitamente o cenário por meio de `executar(Cenario)`. Assim, os testes confirmam a seleção explícita de cada cenário. A consulta direta do padrão inicial `cenario_ativo(X).`, antes de escolher um cenário, ainda precisa ser registrada separadamente.

### Repetição do teste de saída

Após incluir cortes nas traduções de ações conhecidas, a apresentação do plano foi testada novamente. As frases e a numeração permaneceram iguais; ao pedir outra resposta no SWISH, não apareceu a mensagem genérica de ação sem tradução.

## 8. Teste da saída condicionada ao cenário ativo

Foram realizados testes temporários para verificar se a função `executar/0` encaminha corretamente os resultados de acordo com o cenário selecionado.

| Cenário ativo | Resultado esperado | Resultado obtido |
|---|---|---|
| Simples | Exibir o plano simulado, o custo informado e a mensagem de vitória | Passou. O plano de cinco ações e o custo simulado de 8 foram apresentados. |
| Impossível | Exibir a mensagem de ausência de solução | Passou. A simulação não retornou um plano e a mensagem de ausência de solução foi apresentada. |

**Limitação:** os testes utilizaram uma implementação temporária de `resolver/2`, condicionada ao cenário ativo. Eles verificam o encaminhamento dos resultados pela função de saída, mas não comprovam o funcionamento do algoritmo de busca nem a impossibilidade do terceiro cenário.

A implementação temporária deverá ser removida antes da integração com a busca real.


## 9. Melhoria na apresentação do plano

A saída em linguagem natural foi aprimorada para numerar as ações e informar a quantidade total de ações do plano.

| Teste | Resultado esperado | Resultado obtido |
|---|---|---|
| Numeração das ações | Exibir as ações sequencialmente, começando em 1 | Passou. As ações foram exibidas com numeração sequencial. |
| Contagem das ações | Informar a quantidade de elementos do plano | Passou. A quantidade de ações foi apresentada corretamente. |
| Apresentação completa | Mostrar plano, quantidade de ações, custo e mensagem de conclusão | Passou. Todas as informações foram exibidas corretamente. |

O teste desta seção utilizou uma lista de ações e um custo fornecidos manualmente, portanto verificou apenas a apresentação. Os resultados da busca real estão registrados na seção 7.
