# import pandas as pd
import numpy as np
import os
import sys
import time

# from sklearn import preprocessing
# import seaborn as sns

print("current working directory: ", os.getcwd())

# type = "_small"  # nothing i.e. "" normal or "_small" for small files
type = ""


# sample_size: 1000, 500, 250, 32, 64
# sample_size = 192  # 500 for small data # how many values in a single sample collected
# sample_size = 2048


def get_min_len(datasets):
    min_len = sys.maxsize  # get the minimum length of dataset for each class
    for dataset in datasets.values():
        if len(dataset) < min_len:
            min_len = len(dataset)
    return min_len


def set_dataset(datasets, los_type, distance, counter, start_counter):
    start_time = time.time()
    # csv_path = prefix + los_type + '/' + str(
    #     distance) + 'F_' + los_type + '/Test_165_' + str(
    #     distance) + 'F_' + str(
    #     counter) + suffix + los_type.lower() + type + ".txt"
    # csv_path = prefix + '/Test_165_' + prefix + '_1WiFi_' + los_type.lower() + '.txt'
    # csv_path = 'All/raw_files/all_data'
    # csv_path = 'All/one_two_wifi/' + str(counter + 1) + '_wifi'
    # csv_path = 'All/one_two_wifi_2/' + str(counter + 1) + '_wifi_2'
    csv_path = path_prefix + 'raw_' + str(
        distance) + prefix + '_' + los_type + '/' + los_type + '_' + str(
        distance) + prefix + '_' + str(
        counter) + suffix + '.txt'

    print('csv path: ', csv_path)

    # data1 = pd.read_csv(csv_path1, header=None)
    # # print("data1 values: ", data1.values)
    # data1 = np.array(data1.values).squeeze()

    dataset = np.genfromtxt(csv_path,
                            delimiter="\n",
                            missing_values='',
                            filling_values='inf',
                            skip_header=1,
                            skip_footer=1)
    for expression in ['-inf', '-Inf', 'inf', 'Inf']:
        dataset = np.delete(dataset,
                            np.where(
                                dataset == float(expression)))
    dataset = dataset[~np.isnan(dataset)]
    print("dataset class " + str(counter))
    print("max: ", dataset.max())
    print("min: ", dataset.min())
    print("mean: ", dataset.mean())
    print("len: ", len(dataset))
    # print("data1 head: ", data1.head())
    print("head: ", dataset[:10])
    class_number = counter - start_counter
    if counter in datasets.keys():
        datasets[class_number] = np.concatenate(
            (datasets[class_number], dataset), axis=0)
    else:
        datasets[class_number] = dataset
    end_time = time.time()
    elapsed_time = end_time - start_time
    print('elapsed time to read a single data file: ',
          elapsed_time)


def generate_dataset(sample_size, datasets, train_rate, outlier_std_count):
    # Only truncate the raw dataset sizes.
    set_min_len_manually = False
    if set_min_len_manually:
        min_len = 512 * 2000
    else:
        min_len = get_min_len(datasets=datasets)

    print("min_len of the dataset for a class: ", min_len)
    # make sure we have the same number of samples from each class
    for i in datasets.keys():
        datasets[i] = datasets[i][:min_len]
    del min_len

    def get_samples(array):
        with_step = True
        if with_step:
            # make more data by overlapping the signals
            step = max(sample_size // 4, 1)
            # step = 1
            samples = []
            # i - a start index for a sample
            for i in range(0, len(array) - sample_size, step):
                samples.append(array[i:i + sample_size])
            frame = np.array(samples)
        else:
            len_final = len(array)
            len_reminder = len_final % (sample_size * 2)
            len_final -= len_reminder
            array = array[:len_final]
            # cut off the data to the multiple of sample size
            # take sample_size value and create a row from them
            frame = array.reshape(-1, sample_size)
        # shuffle the data
        np.random.shuffle(frame)
        return frame

    # get 2 dimensional datasets
    for i in datasets.keys():
        datasets[i] = get_samples(datasets[i])

    # divide into train/test datasets
    min_len = get_min_len(datasets=datasets)

    stop_train_index = int(np.ceil(min_len * train_rate))

    train_arrays = {}
    test_arrays = {}

    for class_nr, dataset in datasets.items():
        train_arrays[class_nr] = dataset[:stop_train_index]
        test_arrays[class_nr] = dataset[stop_train_index:]

    # find the mean and std of the train data
    train_raw_arrays = []
    for array in train_arrays.values():
        train_raw_arrays.append(array)
    train_raw = np.concatenate(train_raw_arrays, axis=0)

    mean = train_raw.mean()
    print("train mean value: ", mean)

    std = train_raw.std()
    print("train std: ", std)

    def get_final_data(data, class_number, mean, std, type=''):
        # replace outliers with the mean value
        count_outliers = np.sum(np.abs(data - mean) > outlier_std_count * std)
        print(f"count_outliers {type} (for class: {class_number}): ",
              count_outliers)
        data[np.abs(data - mean) > outlier_std_count * std] = mean
        # normalize the data
        data = (data - mean) / std
        # create and add column with the class number
        class_column = np.full((len(data), 1), class_number)
        data = np.concatenate((class_column, data), axis=1)
        return data

    train_datasets = []
    for class_number, array in train_arrays.items():
        train_datasets.append(
            get_final_data(array,
                           class_number=class_number,
                           mean=mean,
                           std=std,
                           type='train'))
    data_train = np.concatenate(train_datasets, axis=0)
    del train_datasets

    test_datasets = []
    for class_number, array in test_arrays.items():
        test_datasets.append(
            get_final_data(array, class_number=class_number, mean=mean,
                           std=std, type='test'))
    data_test = np.concatenate(test_datasets, axis=0)
    del test_datasets

    # print("data train dims: ", data_train.shape)
    # np.savetxt("WIFI_TRAIN", data_train, delimiter=",")
    sample_size = str(sample_size)
    # dataset_name = "WIFI_class_" + str(class_counter)
    dataset_name = prefix + los_type + '/' + str(
        distance) + 'F_' + los_type + '/'
    los_types_str = "-".join(los_types)
    distances_str = "-".join([str(x) for x in distances])
    dir_counter = str(class_counter) + '_classes_' + suffix
    if set_min_len_manually:
        len_suffix = "_len_" + str(min_len)
        # distances_str += len_suffix
        dir_counter += len_suffix
    dir_name = 'data_journal/' + los_types_str + '-' + distances_str + '-' + str(
        sample_size) + '/' + dir_counter
    print('dir_name: ', dir_name)
    # full_dir = dataset_name + "/" + dir_name
    # full_dir = prefix + '/' + prefix + '_' + los_type.lower()
    # full_dir = 'All/raw_files/all_data'
    # full_dir = 'All/one_two_wifi/2_classes_WiFi'
    # out_dir = 'All/one_two_wifi_2/2_classes_WiFi'

    if not os.path.exists(dir_name):
        os.makedirs(dir_name)

    def write_data(data_set, file_name):
        with open(file_name, "w") as f:
            for row in data_set:
                # first row is a class number (starting from 0)
                f.write(str(int(row[0])))
                # then we have proper values starting from position 1 in each row
                for value in row[1:]:
                    f.write("," + str(value))
                f.write("\n")

    full_dir = dir_name + '/' + dir_counter
    write_data(data_train, full_dir + "_TRAIN")
    write_data(data_test, full_dir + "_TEST")

    print("normalized train mean (should be close to 0): ", data_train.mean())
    print("normalized train std: ", data_train.std())
    print("normalized test mean (should be close to 0): ", data_test.mean())
    print("normalized test std: ", data_test.std())


if __name__ == "__main__":
    # sample_sizes = [2, 4, ]  # 512
    for sample_size in [2**x for x in range(10, 0, -1)]:
    # for sample_size in sample_sizes:
        print("sample size: ", str(sample_size))
        train_rate = 0.5  # rate of training data, test data rate is 1 - train_rate
        outlier_std_count = 10
        # prefix="test_one_wifi_"
        # prefix="wifi6_data/"
        # suffix="_wifi_165"

        # prefix = "ML_"
        prefix = 'F'
        suffix = "WIFI"  # "WIFI" or "WIFI_sample"
        # los_types = ['NLOS', 'LOS', 'NLOSLOS']  # LOS or NLOS
        los_types = ['NLOS']
        distances = [6]

        path_prefix = 'data_journal/'
        # start_counter = 1
        # max_class = 3

        # start_end = [(1, 3), (0, 3), (0, 4), (0, 5), (0, 6)]
        start_end = [(0, 6)]
        for los_type in los_types:
            for distance in distances:
                for start_counter, max_class in start_end:
                    class_counter = max_class - start_counter
                    datasets = dict()
                    for counter in range(start_counter, max_class):
                        set_dataset(datasets=datasets, los_type=los_type,
                                    distance=distance, counter=counter,
                                    start_counter=start_counter)
                    generate_dataset(sample_size=sample_size,
                                     datasets=datasets,
                                     train_rate=train_rate,
                                     outlier_std_count=outlier_std_count)
