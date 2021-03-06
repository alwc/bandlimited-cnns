import numpy as np
from matplotlib import pyplot as plt
from mpl_toolkits.axes_grid1 import ImageGrid
import foolbox
from cnns.nnlib.robustness.utils import to_fft
from cnns.nnlib.robustness.utils import to_fft_magnitude
import torch
from cnns.nnlib.pytorch_layers.fft_band_2D import FFTBandFunction2D
from cnns.nnlib.pytorch_layers.fft_band_2D_complex_mask import \
    FFTBandFunctionComplexMask2D
from cnns.nnlib.utils.complex_mask import get_hyper_mask
from cnns.nnlib.utils.complex_mask import get_disk_mask
from cnns.nnlib.utils.object import Object
from cnns.nnlib.utils.arguments import Arguments
from cnns.nnlib.utils.shift_DC_component import shift_DC
from mpl_toolkits.axes_grid1 import make_axes_locatable
from PIL import Image
from torch.nn.functional import pad as torch_pad
import cv2

# figuresizex = 10.0
# figuresizey = 10.0

# generate images

# dataset = "mnist"
dataset = "imagenet"
format = "png"

if dataset == "imagenet":
    limx, limy = 224, 224
elif dataset == "mnist":
    limx, limy = 28, 28

half = limx // 2
extent1 = [0, limx, 0, limy]
extent2 = [-half + 1, half, -half + 1, half]

images, labels = foolbox.utils.samples(dataset=dataset, index=0,
                                       batchsize=20,
                                       shape=(limx, limy),
                                       data_format='channels_first')
print("max value in images pixels: ", np.max(images))
images = images / 255
image = images[0]
label = labels[0]
print("label: ", label)
is_log = True


# cv2.imwrite("image-cv2.png", (image * 255).astype(np.uint8))
def save_image(filename, image):
    result_image = Image.fromarray(
        (np.transpose(image, (1, 2, 0)) * 255).astype(np.uint8), mode="RGB")
    result_image.save(filename + "." + format)


def save_image_CHW(filename, image):
    result_image = Image.fromarray(
        (image * 255).astype(np.uint8), mode="RGB")
    result_image.save(filename + "." + format)


save_image("image", image)
save_image_CHW("image_CHW", image)

args = Arguments()
args.compress_fft_layer = 80
args.compress_rate = args.compress_fft_layer
args.next_power2 = False
args.is_DC_shift = False
result = Object()
image = torch.from_numpy(image).unsqueeze(0)
N, C, H, W = image.size()
pad = 3
pad_fft = 26
side = "one"

if side == "two":
    Hfft = H + pad * 2 + pad_fft * 2
    # (padLeft, padRight, padTop, padBottom)
    image = torch_pad(image,
                  (pad + pad_fft, pad + pad_fft, pad + pad_fft, pad + pad_fft),
                  'constant', 0)
elif side == "one":
    Hfft = H + pad * 2 + pad_fft
    # (padLeft, padRight, padTop, padBottom)
    image = torch_pad(image,
                      (pad, pad + pad_fft,
                       pad, pad + pad_fft),
                      'constant', 0)
else:
    raise Exception(f"Unknown side type: {side}")

print("Hfft: ", Hfft)

image_proxy = FFTBandFunction2D.forward(
    ctx=result,
    input=image,
    args=args,
    onesided=False).numpy().squeeze(0)
if side == "two":
    image_proxy = image_proxy[..., pad + pad_fft:limx + pad + pad_fft,
                  pad + pad_fft:limy + pad + pad_fft]
xfft_proxy = result.xfft.squeeze(0)

save_image(
    "image_proxy" + str(args.compress_rate) + "_pad_fft_" + str(
        pad_fft) + "_pad_" + str(pad) + "_side_" + str(side), image_proxy)
