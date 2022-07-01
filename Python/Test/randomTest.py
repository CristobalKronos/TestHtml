"""
Espacio donde probar la librería RANDOM, la cual permite obtener valores aleatorios

@author Cristobal Osses [DonCronos]
"""
#Comentario simple
"""Comentario 
multi-linea"""

import random


random.seed(random.random()) #Inicializador de la seed

rand = random.random() * 100 #Generador de numeros aleatorios entre 0 a 100
rand = int(rand)

randbits = random.getrandbits(8) #Generador de numeros en bits, donde hay que ingresar el valor de bits que se quiere tener

randint = random.randint(1,10) #Generador de valores aleatorios enteros y entre dos valores

print("RandInt: ")
print(random.randint(1,10))
