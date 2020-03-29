# -*- coding: utf-8 -*-
"""#####################################################################"""

import gym

env = gym.make("Taxi-v3").env

env.render()

"""#####################################################################"""

print("Total de Ações {}".format(env.action_space))
print("Total de Estados {}".format(env.observation_space))

"""#####################################################################"""

state = env.encode(3, 1, 2, 1) 
print("Número do estado:", state)

env.s = state
env.render()

env.s = 369
print("Número do estado:", env.s)
env.render()

"""#####################################################################"""

env.P[329]

"""#####################################################################"""

env.s = 329  # começa no estado do exemplo acima

epochs = 0   # total de ações realizadas 
penalties = 0   # quantidade de punições recebidas por pegar ou largar no lugar errado

frames = [] # usado para fazer uma animação

done = False

while not done:
    action = env.action_space.sample()  # escolhe aleatoriamente uma ação
    state, reward, done, info = env.step(action)  # aplica a ação e pega o resultado

    if reward == -10:  # conta uma punição
        penalties += 1
    
    # Quarda a sequência para poder fazer a animação depois
    frames.append({
        'frame': env.render(mode='ansi'),
        'state': state,
        'action': action,
        'reward': reward
        }
    )

    epochs += 1
    
    
print("Total de ações executadas: {}".format(epochs))
print("Total de penalizações recebidas: {}".format(penalties))

"""#####################################################################"""

from IPython.display import clear_output
from time import sleep

def print_frames(frames):
    for i, frame in enumerate(frames):
        clear_output(wait=True)
        ##print(frame['frame'].getvalue())
        print(f"Timestep: {i + 1}")
        print(f"State: {frame['state']}")
        print(f"Action: {frame['action']}")
        print(f"Reward: {frame['reward']}")
        sleep(.1)
        
##print_frames(frames)

"""#####################################################################"""

import numpy as np

# Inicialização com a tabela de valores Q
q_table = np.zeros([env.observation_space.n, env.action_space.n])

import random
from IPython.display import clear_output

# Hiperparâmetros
alpha = 0.1   # taxa de aprendizagem
gamma = 0.6   # fator de desconto
epsilon = 0.1  # chance de escolha aleatória  

# Total geral de ações executadas e penalidades recebidas durante a aprendizagem
epochs, penalties = 0,0

for i in range(1, 100001): # Vai rodar 100000 diferentes versões do problema
    state = env.reset()  # Inicialização aleatoria do ambient
    done = False
    
    while not done:
        if random.uniform(0, 1) < epsilon:
            action = env.action_space.sample() # Escolhe ação aleatoriamente
        else:
            action = np.argmax(q_table[state]) # Escolhe ação com base no que já aprendeu

        next_state, reward, done, info = env.step(action) # Aplica a ação
        
        old_value = q_table[state, action]  # Valor da ação escolhida no estado atual
        next_max = np.max(q_table[next_state]) # Melhor valor no próximo estado
        
        # Atualize o valor Q usando a fórmula principal do Q-Learning
        new_value = (1 - alpha) * old_value + alpha * (reward + gamma * next_max)
        q_table[state, action] = new_value

        if reward == -10:  # Contabiliza as punições por pegar ou deixar no lugar errado
            penalties += 1

        state = next_state # Muda de estado
        epochs += 1
        

print("Total de ações executadas: {}".format(epochs))
print("Total de penalizações recebidas: {}".format(penalties))

"""#####################################################################"""

env.s = 329
env.render()

q_table[329]

"""#####################################################################"""

state = 329
epochs, penalties = 0, 0
    
done = False
    
while not done:
     action = np.argmax(q_table[state])
     state, reward, done, info = env.step(action)

     if reward == -10:
        penalties += 1

     epochs += 1

print("Total de ações executadas: {}".format(epochs))
print("Total de penalizações recebidas: {}".format(penalties))

"""#####################################################################"""

total_epochs, total_penalties = 0, 0
episodes = 100

for i in range(episodes):
    state = env.reset()
    epochs, penalties, reward = 0, 0, 0
    
    done = False
        
    while not done:
        action = np.argmax(q_table[state])
        state, reward, done, info = env.step(action)

        if reward == -10:
            penalties += 1

        epochs += 1

    total_penalties += penalties
    total_epochs += epochs

print(f"Resultados depois de {episodes} simulações:")
print(f"Média de ações por simulação: {total_epochs / episodes}")
print(f"Média de penalidades: {total_penalties / episodes}")
