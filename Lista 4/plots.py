import matplotlib.pyplot as plt
import numpy as np

data = np.loadtxt("results/max_pointer_substitution_insert_rand.txt", delimiter=",")

x = data[:,0]
y_binary_search_tree = data[:,1]
y_red_black_tree = data[:,2]
y_splay_tree = data[:,3]

plt.plot(x, y_binary_search_tree, label="Binary Search Tree")
plt.plot(x, y_red_black_tree, label="Red Black Tree")
plt.plot(x, y_splay_tree, label="Splay Tree")

plt.legend()
plt.title("Porównanie wydajności struktur danych\nMaksymalna liczba podstawień wskaźników dodając losowy ciąg kluczy w zależności od wielkości danych, dla dwudziestu powtórzeń")

plt.show()
