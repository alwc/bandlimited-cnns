#  Band-limited CNNs
#  Copyright (c) 2019. Adam Dziedzic
#  Licensed under The Apache License [see LICENSE for details]
#  Written by Adam Dziedzic

import foolbox
from cnns.nnlib.utils.exec_args import get_args
from cnns.nnlib.datasets.cifar import get_cifar
import torch
import sys
import time
import numpy as np
from cnns.nnlib.robustness.utils import get_foolbox_model
from cnns.nnlib.robustness.utils import get_min_max_counter
if not sys.warnoptions:
    import warnings

    warnings.simplefilter("ignore")


class empty_attack(foolbox.attacks.base.Attack):

    def __call__(self, input_or_adv, label=None, unpack=True, **kwargs):
        return input_or_adv


def get_attacks():
    attacks = [  # empty_attack,
        # (foolbox.attacks.LocalSearchAttack, "LocalSearch",
        #  [x for x in range(1000)]),
        # (foolbox.attacks.MultiplePixelsAttack, "MultiplePixelsAttack",
        # [x for x in range(100, 301, 10)]),
        # (foolbox.attacks.SinglePixelAttack, "SinglePixelAttack",
        #  [x for x in range(0, 1001, 100)]),
        # # foolbox.attacks.AdditiveUniformNoiseAttack,
        # foolbox.attacks.GaussianBlurAttack,
        # foolbox.attacks.AdditiveGaussianNoiseAttack,
        # foolbox.attacks.FGSM,
        # (foolbox.attacks.ContrastReductionAttack, [0.8 + x / 10 for x in range(3)]),
        # (foolbox.attacks.SpatialAttack, "Rotations",
        #  [x for x in range(0, 21, 1)]),
        # (foolbox.attacks.SpatialAttack, "Translations",
        #  [x for x in range(0, 21, 1)]),
        # (foolbox.attacks.SpatialAttack, "All", [x for x in range(0, 21, 1)]),
        # (foolbox.attacks.ContrastReductionAttack,
        #  [x / 10 for x in range(10)]),
        # (foolbox.attacks.GradientAttack, [x / 100 for x in range(21)]),
        (foolbox.attacks.GradientSignAttack, "GradientSignAttack",
         [x for x in np.linspace(0.001, 0.2, 20)][1:]),
        # (
        #     foolbox.attacks.BlendedUniformNoiseAttack,
        #     [x / 10 for x in range(21)]),
        # foolbox.attacks.SaltAndPepperNoiseAttack(foolbox_model),
        # foolbox.attacks.LinfinityBasicIterativeAttack(
        # model, distance=foolbox.distances.MeanSquaredDistance),
    ]
    return attacks


# attack = foolbox.attacks.FGSM(model)
# attack = empty_attack

def run(args):
    print(
        "compress rate, attack name, epsilon, correct, counter, correct rate (%), time (sec)")

    model_paths = [
        # (84,
        #  "2019-01-21-14-30-13-992591-dataset-cifar10-preserve-energy-100.0-test-accuracy-84.55-compress-label-84-after-epoch-304.model"),
        (0,
         "2019-01-14-15-36-20-089354-dataset-cifar10-preserve-energy-100.0-test-accuracy-93.48-compress-rate-0-resnet18.model"),
    ]

    # input_epsilons = [0.7, 0.8, 0.9, 1.0]
    # input_epsilons = [0.01, 0.1, 1.0]
    # input_epsilons = [0.0, 0.0001, 0.001, 0.01, 0.05, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]
    # 0.0, 0.001, 0.002, 0.003, 0.004, 0.005, 0.006, 0.007, 0.008, 0.009, 0.01, 0.02
    # input_epsilons = [0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.1]
    # input_epsilons = [0.11 + x / 100 for x in range(10)]
    # input_epsilons = [x / 100 for x in range(21)]
    # input_epsilons = range(0, 100, 10)

    import datetime

    print("start time: ", datetime.datetime.now())

    attacks = get_attacks()

    for current_attack, attack_type, input_epsilons in attacks:
        for compress_rate, model_path in model_paths:
            foolbox_model = get_foolbox_model(args, model_path=model_path,
                                              compress_rate=compress_rate)
            attack = current_attack(foolbox_model)
            print("attack type: ", attack_type)
            # for epsilon in [0.001, 0.005, 0.01, 0.05, 0.1, 0.5, 1.0]:
            for epsilon in input_epsilons:
                if attack.name() == "SaltAndPepperNoiseAttack":
                    epsilon = int(epsilon * 100)
                    epsilons = epsilon
                else:
                    epsilons = [epsilon]
                correct = 0
                counter = 0
                start = time.time()
                for batch_idx, (data, target) in enumerate(test_loader):
                    # print("batch_idx: ", batch_idx)
                    for i, label in enumerate(target):
                        counter += 1
                        label = label.item()
                        image = data[i].numpy()
                        if attack_type == "Rotations":
                            image_attack = attack(image, label,
                                                  do_rotations=True,
                                                  do_translations=False,
                                                  x_shift_limits=(
                                                      -epsilon, epsilon),
                                                  y_shift_limits=(
                                                      -epsilon, epsilon),
                                                  angular_limits=(
                                                      -epsilon, epsilon),
                                                  granularity=10,
                                                  random_sampling=False,
                                                  abort_early=True)
                        elif attack_type == "Translations":
                            image_attack = attack(image, label,
                                                  do_rotations=False,
                                                  do_translations=True,
                                                  x_shift_limits=(
                                                      -epsilon, epsilon),
                                                  y_shift_limits=(
                                                      -epsilon, epsilon),
                                                  angular_limits=(
                                                      -epsilon, epsilon),
                                                  granularity=10,
                                                  random_sampling=False,
                                                  abort_early=True)
                        elif attack.name() == "SpatialAttack":
                            image_attack = attack(image, label,
                                                  do_rotations=True,
                                                  do_translations=True,
                                                  x_shift_limits=(
                                                      -epsilon, epsilon),
                                                  y_shift_limits=(
                                                      -epsilon, epsilon),
                                                  angular_limits=(
                                                      -epsilon, epsilon),
                                                  granularity=10,
                                                  random_sampling=False,
                                                  abort_early=True)
                        elif attack_type == "SinglePixelAttack":
                            image_attack = attack(image, label,
                                                  max_pixels=epsilon,
                                                  pixel_type="single")
                        elif attack_type == "MultiplePixelsAttack":
                            image_attack = attack(image, label,
                                                  num_pixels=epsilon)
                        elif attack.name() == "LocalSearchAttack":
                            image_attack = attack(image, label, t=epsilon)
                        else:
                            image_attack = attack(image, label,
                                                  epsilons=epsilons)
                        if image_attack is None:
                            correct += 1
                            # print("image is None, label:", label, " i:", i)
                        elif args.is_round:
                            print("sum difference before round: ",
                                  np.sum(
                                      np.abs(image_attack * 255 - image * 255)))
                            image_attack = np.round(image_attack * 255) / 255
                            print("sum difference after round: ",
                                  np.sum(
                                      np.abs(image_attack * 255 - image * 255)))
                            predictions = foolbox_model.predictions(
                                image_attack)
                            # print(np.argmax(predictions), label)
                            if np.argmax(predictions) == label:
                                correct += 1
                timing = time.time() - start
                with open("results.csv", "a") as out:
                    msg = "".join((str(x) for x in
                                   [compress_rate, ",", attack.name(), ",",
                                    epsilon,
                                    ",", correct,
                                    ",", counter, ",", correct / counter,
                                    ",", timing]))
                    print(msg)
                    out.write(msg + "\n")


if __name__ == "__main__":
    np.random.seed(31)
    args = get_args()
    # should we turn pixels to the range from 0 to 255 and round them to the the
    # nearest integer value
    args.sample_count_limit = 0
    args.is_round = True

    train_loader, test_loader, train_dataset, test_dataset = get_cifar(args,
                                                                       "cifar10")

    if torch.cuda.is_available() and args.use_cuda:
        print("cuda is available")
        args.device = torch.device("cuda")
        # torch.set_default_tensor_type('torch.cuda.FloatTensor')
    else:
        print("cuda id not available")
        args.device = torch.device("cpu")

    min, max, counter = get_min_max_counter(test_loader=test_loader)
    print("counter: ", counter, " min: ", min, " max: ", max)

    run(args)