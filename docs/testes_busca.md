# Registro de testes da busca — Agente Fantasma

**Data:** 19/10/2026
**Ambiente de testes:** SWI-Prolog 9.2.9 (Fedora), comando `swipl teste_busca.pl`
**Responsável:** Vitória

## 1. Como os testes funcionam

A busca (`busca.pl`) não conhece o jogo: ela só chama `estado_inicial/1`, `acao/4` e `objetivo/1`. Por isso foi possível testá-la sozinha, em mapas pequenos escritos à mão (`teste_busca.pl`). Nesses mapas os estados são letras e cada ação tem um custo definido no próprio teste.

Para cada teste, o predicado `testar/3` define o estado inicial e a meta, chama `resolver/2` e imprime o plano e o custo, ou `SEM SOLUCAO` quando a consulta falha. O resultado esperado de cada teste foi calculado manualmente antes da execução.

## 2. Testes da busca em mapas pequenos

| Teste | O que o mapa contém | Resultado esperado | Resultado obtido |
|---|---|---|---|
| t1 | `a → fim` custa 10 (1 passo); `a → b → c → fim` custa 3 (3 passos); há um ciclo `c → a` | Plano `[ir(a,b), ir(b,c), ir(c,fim)]`, custo 3 | Passou. O plano de custo 3 foi devolvido, mesmo tendo mais passos. |
| t2 | O mesmo mapa, com uma meta que não existe | A consulta falha, sem laço infinito apesar do ciclo | Passou. Resultado `SEM SOLUCAO`. |
| t3 | O estado inicial já é a meta | Plano vazio `[]`, custo 0 | Passou. |
| t4 | Dois caminhos até `r`: `p → r` custa 5 e `p → q → r` custa 2 | Plano `[ir(p,q), ir(q,r), ir(r,s)]`, custo 3 | Passou. O caminho mais barato até `r` foi escolhido. |
| t5 | Uma ação de custo 0 seguida de uma de custo 2 | Plano `[usa(z0), ir(z1,z2)]`, custo 2 | Passou. A ação de custo zero foi aceita. |

## 3. O que esses testes comprovam e o que não comprovam

Eles indicam que a busca devolve o plano de menor custo (e não o de menos passos), devolve o plano na ordem da primeira à última ação, evita ciclos, falha quando não há solução e aceita ações de custo zero.

Eles **não** comprovam que a busca funciona com as regras e os cenários reais do jogo. O número de estados do jogo é muito maior que o dos mapas de teste, e a busca só reconhece estados repetidos se estados equivalentes forem escritos sempre da mesma forma pelas regras.

## 4. Testes ainda pendentes

Os seguintes testes serão realizados após a integração com as regras e os cenários:

- Cenário simples: o custo esperado é 8, calculado à mão com os valores do projeto (2 movimentos e 3 ações de susto).
- Cenário desafiador: a busca deve devolver um plano válido. Se a sequência manual de 14 unidades for válida nas regras implementadas, o custo devolvido deve ser menor ou igual a 14.
- Cenário impossível: a consulta deve falhar e terminar.
- Verificar que estados equivalentes são reconhecidos como repetidos (o plano não pode conter ações redundantes).
- Medir o tempo de execução do cenário desafiador.
- Registrar as consultas e as saídas reais.
