
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

## 3. Testes ainda pendentes

Os seguintes testes serão realizados após a integração dos arquivos de cenários, regras, busca e saída:

- Verificar se a busca encontra uma solução válida para o cenário simples.
- Verificar se a busca encontra uma solução válida para o cenário desafiador.
- Verificar se a busca termina sem solução para o cenário impossível.
- Conferir se o custo apresentado corresponde ao custo retornado pela busca.
- Conferir se todas as ações do plano são traduzidas corretamente.
- Verificar se o resultado final confirma a fuga de todos os moradores.
- Registrar as consultas e saídas reais do programa integrado.

