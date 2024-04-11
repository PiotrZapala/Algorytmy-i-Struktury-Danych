import matplotlib.pyplot as plt
import numpy as np

data = np.loadtxt("sprawozdanie/results/optimal_hybrid/hybrid_sort.txt", delimiter=",")

x = data[:,0]
y_comps = data[:,1]
y_shifts = data[:,2]

plt.plot(x, y_comps, label="Porównania")
plt.plot(x, y_shifts, label="Przestawienia")

plt.legend()
plt.title("Najkorzystaniejszy próg przełączania między Quick Sort na Insertion Sort.")

plt.show()
