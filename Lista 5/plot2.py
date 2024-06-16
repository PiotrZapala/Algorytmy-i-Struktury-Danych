import pandas as pd
import matplotlib.pyplot as plt

data = pd.read_csv('results2.csv')

plt.figure(figsize=(10, 6))
plt.plot(data['n'], data['AverageRounds'], label='Średnia liczba rund', marker='o')
plt.plot(data['n'], data['MaxRounds'], label='Maksymalna liczba rund', marker='x')
plt.plot(data['n'], data['MinRounds'], label='Minimalna liczba rund', marker='s')
plt.xlabel('Liczba wierzchołków')
plt.ylabel('Liczba rund potrzebnych do rozesłania wiadomości')
plt.title('Liczba rund potrzebnych do rozesłania wiadomości w drzewie')
plt.legend()
plt.grid(True)
plt.savefig('plot2.png')
plt.show()