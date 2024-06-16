import matplotlib.pyplot as plt
import numpy as np

data = np.loadtxt("results4/avg_time_10.txt", delimiter=",")

x = data[:,0]
y_bin_1 = data[:,1]
y_bin_2 = data[:,2]
y_bin_3 = data[:,3]
y_bin_4 = data[:,4]

plt.plot(x, y_bin_1, label="Quick Sort")
plt.plot(x, y_bin_2, label="Quick Select Sort")
plt.plot(x, y_bin_3, label="Dual Pivot Quick Sort")
plt.plot(x, y_bin_4, label="Dual Pivot Quick Select Sort")

plt.legend()
plt.title("Porównanie wydajności algorytmów sortujących dla losowej tablicy\nŚredni czas działania w zależności od wielkości tablicy, dla 10 powtórzeń")

plt.show()
