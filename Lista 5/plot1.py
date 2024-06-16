import pandas as pd
import matplotlib.pyplot as plt

data = pd.read_csv('results1.csv')

plt.figure(figsize=(10, 6))
plt.plot(data['n'], data['PrimTime'], label='Prim', marker='o')
plt.plot(data['n'], data['KruskalTime'], label='Kruskal', marker='s')
plt.xlabel('Liczba wierzchołków (n)')
plt.ylabel('Średni czas wykonania (s)')
plt.title('Porównanie czasów wykonania algorytmów Prima i Kruskala')
plt.legend()
plt.grid(True)
plt.savefig('plot1.png')
plt.show()