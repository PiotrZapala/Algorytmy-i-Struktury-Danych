import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit

data = np.loadtxt("sprawozdanie/results/optimal_hybrid/hybrid_sort.txt", delimiter=",")

sizes = data[:,0]
average_comparisons = data[:,1]

def model_func(N, C):
    return C * N * np.log(N)

params, covariance = curve_fit(model_func, sizes, average_comparisons)

C_opt = params[0]

fitted_vals = model_func(sizes, C_opt)

plt.figure(figsize=(10, 6))
plt.plot(sizes, average_comparisons, 'bo', label='Średnia liczba porównań')
plt.plot(sizes, fitted_vals, 'r-', label=f'Model C*N*log(N), C={C_opt:.2f}')
plt.xlabel('Rozmiar danych N')
plt.ylabel('Średnia liczba porównań')
plt.title('Dopasowanie modelu C*N*log(N) do średniej liczby porównań')
plt.legend()
plt.grid(True)
plt.show()

