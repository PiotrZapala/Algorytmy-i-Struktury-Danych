import matplotlib.pyplot as plt
import numpy as np

data = np.loadtxt("results/max_pointer_substitution_insert_rand.txt", delimiter=",")

x = data[:, 0]
y_binary_search_tree = data[:, 1]
y_red_black_tree = data[:, 2]
y_splay_tree = data[:, 3]

fig, ax1 = plt.subplots()

ax1.plot(x, y_binary_search_tree, label="Binary Search Tree", color="blue")
ax1.set_xlabel("Rozmiar danych")
ax1.set_ylabel("Liczba podstawień wskaźników", color="blue")
ax1.tick_params(axis="y", labelcolor="blue")

ax2 = ax1.twinx()
ax2.plot(x, y_red_black_tree, label="Red Black Tree", color="red")
ax2.set_ylabel("Liczba podstawień wskaźników", color="red")
ax2.tick_params(axis="y", labelcolor="red")

ax3 = ax1.twinx()
ax3.spines["right"].set_position(("outward", 60))
ax3.plot(x, y_splay_tree, label="Splay Tree", color="green")
ax3.set_ylabel("Liczba podstawień wskaźników", color="green")
ax3.tick_params(axis="y", labelcolor="green")

lines = ax1.get_lines() + ax2.get_lines() + ax3.get_lines()
labels = [line.get_label() for line in lines]

fig.tight_layout()
fig.legend(lines, labels, loc="lower center", ncol=3)
plt.title("Porównanie wydajności struktur danych\nMaksymalna liczba podstawień wskaźników dodając losowy ciąg kluczy w zależności od wielkości danych, dla dwudziestu powtórzeń")

plt.subplots_adjust(top=0.85)

plt.show()
