import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit
import math

data = np.loadtxt("results6/constant_sort_time_desc.txt", delimiter=",")

x = data[:,0]
y_bin_1 = data[:,1]
y_bin_2 = data[:,2]
y_bin_3 = data[:,3]
y_bin_4 = data[:,4]

def model1(n, c):
    return c * n * np.log(n)

def model2(n, c):
    return c * n * n

# Wyznaczanie najlepszego dopasowania dla każdego zbioru danych
params_bin_1, _ = curve_fit(model2, x, y_bin_1)
params_bin_2, _ = curve_fit(model1, x, y_bin_2)
params_bin_3, _ = curve_fit(model2, x, y_bin_3)
params_bin_4, _ = curve_fit(model1, x, y_bin_4)

# Wartości c dla każdego zbioru danych
c_bin_1 = params_bin_1[0]
c_bin_2 = params_bin_2[0]
c_bin_3 = params_bin_3[0]
c_bin_4 = params_bin_4[0]

# Tworzenie przybliżonych wartości dla każdego modelu
y_fit_bin_1 = model2(x, c_bin_1)
y_fit_bin_2 = model1(x, c_bin_2)
y_fit_bin_3 = model2(x, c_bin_3)
y_fit_bin_4 = model1(x, c_bin_4)

# Rysowanie wykresów
plt.figure(figsize=(10, 8))

plt.subplot(2, 2, 1)
plt.plot(x, y_bin_1, 'bo', label="Dane posortowane malejąco")
plt.plot(x, y_fit_bin_1, 'r-', label=f"Model {c_bin_1:.2f} * n^2")
plt.title("Quick Sort")
plt.xlabel("Rozmiar danych")
plt.ylabel("Czas")
plt.legend()

plt.subplot(2, 2, 2)
plt.plot(x, y_bin_2, 'bo', label="Dane posortowane malejąco")
plt.plot(x, y_fit_bin_2, 'r-', label=f"Model {c_bin_2:.2f} * n * log(n)")
plt.title("Quick Select Sort")
plt.xlabel("Rozmiar danych")
plt.ylabel("Czas")
plt.legend()

plt.subplot(2, 2, 3)
plt.plot(x, y_bin_3, 'bo', label="Dane posortowane malejąco")
plt.plot(x, y_fit_bin_3, 'r-', label=f"Model {c_bin_3:.2f} * n^2")
plt.title("Dual Pivot Quick Sort")
plt.xlabel("Rozmiar danych")
plt.ylabel("Czas")
plt.legend()

plt.subplot(2, 2, 4)
plt.plot(x, y_bin_4, 'bo', label="Dane posortowane malejąco")
plt.plot(x, y_fit_bin_4, 'r-', label=f"Model {c_bin_4:.2f} * n * log(n)")
plt.title("Dual Pivot Quick Select Sort")
plt.xlabel("Rozmiar danych")
plt.ylabel("Czas")
plt.legend()

plt.tight_layout()
plt.show()