import matplotlib.pyplot as plt
import numpy as np

data = np.loadtxt("results/avg_time/avg_time_100.txt", delimiter=",")

x = data[:,0]
y_insertion_sort = data[:,1]
y_merge_sort = data[:,2]
y_quick_sort = data[:,3]
y_dual_pivot_quick_sort = data[:,4]
y_hybrid_sort = data[:,5]
y_custom_sort = data[:,6]

plt.plot(x, y_insertion_sort, label="Insertion Sort")
plt.plot(x, y_merge_sort, label="Merge Sort")
plt.plot(x, y_quick_sort, label="Quick Sort")
plt.plot(x, y_dual_pivot_quick_sort, label="Dual Pivot Quick Sort")
plt.plot(x, y_hybrid_sort, label="Hybrid Sort")
plt.plot(x, y_custom_sort, label="Custom Sort")

plt.legend()
plt.title("Porównanie wydajności algorytmów sortowania\nŚredni czas działania algorytmów w zależności od wielkości tablicy, dla stu powtórzeń")

plt.show()
