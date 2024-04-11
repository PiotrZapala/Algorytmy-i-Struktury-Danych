import matplotlib.pyplot as plt
import numpy as np

data = np.loadtxt("results1/avg_time.txt", delimiter=",")

x_iterations = data[:,0]
y_time = data[:,1]

plt.plot(x_iterations, y_time, label="Time(lengthOfString)")

plt.legend()
plt.title("Średni czas znajdowania LCS w zależnośći od długości ciągu wejściowego, dla 50 powtórzeń")

plt.show()
