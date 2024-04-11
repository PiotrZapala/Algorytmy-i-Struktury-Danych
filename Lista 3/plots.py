import matplotlib.pyplot as plt
import numpy as np

data = np.loadtxt("results2/avg_time.txt", delimiter=",")

x = data[:,0]
y_bin_1 = data[:,1]
y_bin_2 = data[:,2]
y_bin_3 = data[:,3]
y_bin_4 = data[:,4]

plt.plot(x, y_bin_1, label="Binary Search, element w 1/5 tablicy")
plt.plot(x, y_bin_2, label="Binary Search, element w 1/2 tablicy")
plt.plot(x, y_bin_3, label="Binary Search, element w 4/5 tablicy")
plt.plot(x, y_bin_4, label="Binary Search, element spoza tablicy")

plt.legend()
plt.title("Porównanie wydajności Binary Search'a\nŚredni czas wyszukiwania elementu w zależności od wielkości tablicy, dla stu powtórzeń")

plt.show()
