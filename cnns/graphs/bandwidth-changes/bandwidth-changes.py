import matplotlib
# matplotlib.use('TkAgg')
import matplotlib.pyplot as plt
import csv
import os

print(matplotlib.get_backend())

plt.interactive(True)
# http://ksrowell.com/blog-visualizing-data/2012/02/02/optimal-colors-for-graphs/
MY_BLUE = (56, 106, 177)
MY_RED = (204, 37, 41)
MY_ORANGE = (218, 124, 48)
MY_GREEN = (62, 150, 81)
MY_BLACK = (83, 81, 84)


def get_color(COLOR_TUPLE_255):
    return [x / 255 for x in COLOR_TUPLE_255]


font = {'size': 20}
matplotlib.rc('font', **font)

dir_path = os.path.dirname(os.path.realpath(__file__))

GPU_MEM_SIZE = 16280


def read_columns(dataset, columns=5):
    file_name = dir_path + "/" + dataset + ".csv"
    with open(file_name) as csvfile:
        data = csv.reader(csvfile, delimiter=",", quotechar='|')
        cols = []
        for column in range(columns):
            cols.append([])

        for i, row in enumerate(data):
            if i > 0:  # skip header
                for column in range(columns):
                    cols[column].append(float(row[column]))
    return cols


fig = plt.figure(figsize=(10, 8))

datasets = ["accuracy", "compression"]
titles = ["accuracy", "compression"]
labels = ["", "80", "90", "95"]
legend_pos = ["center left", "upper left"]
ncols = [3, 3]
bbox = [(0.0, 0.1), (0.0, 0.2)]
columns = 4
colors = [get_color(color) for color in
          ["", MY_GREEN, MY_BLUE, MY_ORANGE, MY_RED, MY_BLACK]]
markers = ["+", "o", "v", "s", "D", "^"]
linestyles = ["", "-", "--", ":"]

for j, dataset in enumerate(datasets):
    plt.subplot(2, 1, j + 1)
    print("dataset: ", dataset)
    cols = read_columns(dataset, columns=columns)

    print("col 0: ", cols[0])
    print("col 1: ", cols[1])

    for i in range(columns):
        if i > 0:  # skip first column with the epoch number
            plt.plot(cols[0], cols[i], label=f"E={labels[i]}%", lw=3,
                     color=colors[i], linestyle=linestyles[i])

    plt.grid()
    plt.legend(loc=legend_pos[j], ncol=ncols[j], frameon=False,
               prop={'size': 18}, bbox_to_anchor=bbox[j])
    plt.xlabel('Epoch')
    # plt.title(titles[j], fontsize=16)
    if j == 0:
        plt.ylabel("Test accuracy (%)")
    else:
        plt.ylabel("Compression ratio (%)")
    plt.ylim(0, 100)
    plt.xlim(0, 350)

# plt.gcf().autofmt_xdate()
# plt.xticks(rotation=0)
# plt.interactive(False)
# plt.imshow()
plt.show(block=True)
plt.interactive(False)
fig.savefig(dir_path + "/" + "bandwidth-changes.pdf", bbox_inches='tight')