cenário 1(simples): sala -> corredor -> cozinha
- a casa tem sala, corredor e cozinha
- o fantasma começa na sala
- a única moradora começa na cozinha
- o fantasma pode se mover da sala para o corredor e do corredor para a cozinha
- as passagens não têm postas físicas nem móveis bloqueadores
- existem dois objetos que podem ser derrubados na cozinha
- o barulho pode ser feito na cozinha

  com os valores propostos, o fantasma consegue assustar a moradora com uma seqeência simples:
  1. Derruba o primeiro objeto: a moradora passa de 0 para 3 pontos de susto
  2. Faz barulho: ela passa de 3 para 5 pontos e começa a tremer
  3. Derruba o segundo objeto: como ela já estava tremendo, recebe 3 pontos mais o bônus de 1, chegando a 9 e fugindo
 
cenário 2 (desafiador)
- comodos: sala, corredor, cozinha, biblioteca e quarto
- fantasma começa na sala
- dois moradores começam no quarto[um quadro na sala esconde uma chave
- um armário bloqueia a passagem do corredor para a cozinha
- existe uma porta física trancada entre a biblioteca e o quarto
- há um espelho na biblioteca
- há dois objetos de susto no quarto

  solução:
  1. Derrubar o quadro e obter a chave: custo provisório de 2
  2. Ir da sala ao corredor: custo 1
  3. Deslocar o armário: custo provisório de 2
  4. Ir do corredor à cozinha e depois à biblioteca: custo 2
  5. Usar o espelho: recuperar 5 pontos
  6. Destrancar a porta usando a chave
  7. Ir da biblioteca ao quarto: custo 1
  8. Fazer barulho e derrubar os dois objetos para assustar os dois moradores
     O fantasma chega ao quarto com energia suficiente para executar as ações de susto e termina com 1 ponto de energia. O custo total das ações pafa é 14 pontos, mas ele recupera 5 pontos no espelho. Isso demonsta que o cenário é solucionável

cenário 3 (impossível):
- cômodos: sala, corredor e quarto isolado
- fantasma começa na sala
- há uma conexão da sala para o corredor
- o morador começa no quarto isolado
- não existe conexão de ou para o quarto isolado
- não há porta que possa ser arrombada, nem móvel ou ação que crie uma passagem ára o quarto isolado

-> como verificar que o programa realmente termina sem solução? 
