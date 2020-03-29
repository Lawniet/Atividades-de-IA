## Q-Learning com Gym
 Ambiente do OpenAI Gym que simula a resolução do problema do Taxi (versão 3) com reforço de aprendizagem. 

 ## Instruções de instalação

 Para o funcionamento correto do código é necessário ter instalado o Python 3, o gerenciador de pacotes Pip 3. Após isso será preciso instalar as bibliotecas gym e IPython.
 Para instalar as dependências seguem os comandos de terminal:

 .. code:: shell
    pip3 install gym
    pip3 install IPython

Após finalizado a instalação das bibliotecas, basta instalar o código fonte:

.. code:: shell
    git clone https://github.com/openai/gym.git
    cd Q_learning

Para executar o código basta digitar o comando abaixo:

.. code:: shell
    Python3 Q_learning.py

 # Agente:

    Retângulo amarelo ou verde (fica verde quando está levando um passageiro)

# Ambiente:

    16 possíveis posições possíveis
    4 posições fixas para pegar (saída) ou largar (chegada) o passageiro (R,G,Y,B)
    Cor azul indica local de saída do passageiro e cor rosa o local de chegada
    Alguns muros indicados pelo símbolo "|"

# Estados:

500 possíveis combinações que o ambiente pode assumir
Ações:

    0 = sul (mover taxi para baixo)
    1 = norte (mover taxi para cima)
    2 = leste (mover taxi para direita)
    3 = oeste (mover taxi para esquerda)
    4 = pegar o passageiro
    5 = largar o passageiro

# Alterando o estado

Use a função env.encode(taxi_linha,taxi_coluna,passageiro_saida,passageiro_chegada), o local de saída é um valor de 0 a 3 indicado cada uma das 4 possíveis posições de saída e chegada: R (0), G (1), Y (2) ou B (3).

# Função de reforço

Valor de reforço para cada combinação de estado X ação (ou seja, uma tabela com 500 * 6 = 3000 posições no caso deste problema)

[(sempre_um, próximo_estado, valor_do_reforço, atingiu_o_objetivo)]

Possíveis punições:

    -1 : Cada movimento feito pelo carro ou tentativa de bater no muro
    -10 : Pegar ou largar o passageiro no lugar errado

Possíveis recompensas:

    +20 : Deixar o passageiro no lugar certo

