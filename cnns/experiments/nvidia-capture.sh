#!/usr/bin/env bash

TRUE=1;FALSE=0

TIMESTAMP=$(date -d"$CURRENT +$MINUTES minutes" '+%F-%T-%N-%Z')

echo TIMESTAMP: ${TIMESTAMP}

if [ "$1" != "" ]; then
    echo "compress rate: Positional parameter 1 contains: "$1
else
    echo "compress rate: Positional parameter 1 is empty"
fi

if [ "$2" != "" ]; then
    echo "device: Positional parameter 2 contains: "$2
else
    echo "device: Positional parameter 2 is empty"
fi

if [ "$3" != "" ]; then
    echo "size: Positional parameter 3 contains: "$3
else
    echo "size: Positional parameter 3 is empty"
fi

if [ "$4" != "" ]; then
    echo "type: Positional parameter 4 contains: "$4
else
    echo "type: Positional parameter 4 is empty"
fi

if [ "$5" != "" ]; then
    echo "mem_test: Positional parameter 5 contains: "$5
else
    echo "mem_test: Positional parameter 5 is empty"
fi

compress_rate=${1:-0}
device=${2:-0}
size=${3:-32}
type=${4:-"fp32"}
mem_test=${5:-"TRUE"}

if [ "${type}" == "fp16" ]; then
    program_name="main_fp16_optimizer.py"
    tensor_type="FLOAT16"
    precision="FP16"
else
    # program_name="main.py"
    program_name="main_fp16_optimizer.py"
    tensor_type="FLOAT32"
    precision="FP32"
fi

echo "TIMESTAMP: ${TIMESTAMP}"
file=utilization-${type}-${compress_rate}.csv

nvidia-smi -lms 1 -i ${device} --query-gpu=utilization.gpu,utilization.memory,memory.used  --format=csv -f ${file} &
NVIDIA_PID=$!
sleep 0

CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../ nohup /home/${USER}/anaconda3/bin/python3.6 /home/${USER}/code/time-series-ml/cnns/nnlib/pytorch_experiments/${program_name} --adam_beta2=0.999 --compress_type='STANDARD' --conv_type='FFT2D' --conv_exec_type=CUDA --dataset='cifar10' --dev_percent=0 --dynamic_loss_scale='TRUE' --epochs=2 --compress_rates ${compress_rate} --is_data_augmentation='TRUE' --is_debug='FALSE' --is_dev_dataset='FALSE' --is_progress_bar='FALSE' --learning_rate=0.01 --log_conv_size='FALSE' --loss_reduction='ELEMENTWISE_MEAN' --loss_type='CROSS_ENTROPY' --mem_test=${mem_test} --memory_size=25 --memory_type='STANDARD' --min_batch_size=${size} --model_path='no_model' --momentum=0.9 --network_type='ResNet18' --next_power2='TRUE' --optimizer_type='MOMENTUM' --preserve_energies 100 --sample_count_limit=${size} --scheduler_type='ReduceLROnPlateau' --seed=31 --static_loss_scale=1 --stride_type='STANDARD' --tensor_type=${tensor_type} --test_batch_size=${size} --use_cuda='TRUE' --visualize='FALSE' --weight_decay=0.0005 --workers=6 --precision_type=${precision} --only_train='FALSE' >> ${TIMESTAMP}-cifar10-fft2d-energy100-pytorch-adam-gpu-lr:0.01,decay:0.0005-layers-compress-rates-${compress_rate}-percent-float32.txt 2>&1 &
CUDA_PID=$!
wait ${CUDA_PID}

sleep 0
# kill -9 ${NVIDIA_PID}
kill -s TERM ${NVIDIA_PID}




