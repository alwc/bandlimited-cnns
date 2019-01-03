#!/usr/bin/env bash

CUDA_VISIBLE_DEVICES=0,1 PYTHONPATH=../../ python memory_net.py --help

TIMESTAMP=$(date -d"${CURRENT}+${MINUTES}minutes" '+%F-%T.%N_%Z' | tr : - | tr . -)
CUDA_VISIBLE_DEVICES=0,1 PYTHONPATH=../../ nohup ~/anaconda3/bin/python memory_net.py --initbatchsize=256 --maxbatchsize=256 --startsize=32 --endsize=32 --workers=4 --device=cuda --limit_size=0 --num_epochs=300 --is_data_augmentation=True --conv_type=SPECTRAL_PARAM --optimizer=ADAM &> ${TIMESTAMP}-EXEC.log &


# memory efficient dense-net
TIMESTAMP=$(date -d"${CURRENT}+${MINUTES}minutes" '+%F-%T.%N_%Z' | tr : - | tr . -)
# conv_type=SPECTRAL_PARAM
conv_type=STANDARD
CUDA_VISIBLE_DEVICES=0 nohup ~/anaconda3/bin/python demo.py --conv_type=${conv_type} --efficient False --data ../time-series-ml/cnns/pytorch_tutorials/data/cifar-10-batches-py --save save_spatial/ &> ${TIMESTAMP}-EXEC.log &

PATH="~/anaconda3/bin:$PATH" CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../ nohup ~/anaconda3/bin/python fcnn_fft.py --index_back=5  >> log_index-back5.txt 2>&1 &


PATH="~/anaconda3/bin:$PATH" CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../ nohup ~/anaconda3/bin/python fcnn_fft.py --index_back=5  >> log_index-back5.txt 2>&1 &
PATH="~/anaconda3/bin:$PATH" CUDA_VISIBLE_DEVICES=1 PYTHONPATH=../../../ nohup ~/anaconda3/bin/python fcnn_fft.py --index_back=2  >> log_index-back2.txt 2>&1 &
PATH="~/anaconda3/bin:$PATH" CUDA_VISIBLE_DEVICES=2 PYTHONPATH=../../../ nohup ~/anaconda3/bin/python fcnn_fft.py --index_back=3  >> log_index-back3.txt 2>&1 &
PATH="~/anaconda3/bin:$PATH" CUDA_VISIBLE_DEVICES=3 PYTHONPATH=../../../ nohup ~/anaconda3/bin/python fcnn_fft.py --index_back=4  >> log_index-back4.txt 2>&1 &

PATH="~/anaconda3/bin:$PATH" CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../ nohup ~/anaconda3/bin/python fcnn_fft.py --conv_type=SIMPLE_FFT_FOR_LOOP --epochs=300 --index_back=99 >> index_back_99_percent.txt 2>&1 &


PYTHONPATH=../../../ CUDA_VISIBLE_DEVICES=0 nohup ~/anaconda3/bin/python fcnn_fft.py --conv_type=COMPRESS_INPUT_ONLY --epochs=300 --index_back=0 >> index_back_0_percent_input_compression_only-2018-09-18-15-49.txt 2>&1 &

PYTHONPATH=../../../ CUDA_VISIBLE_DEVICES=0 nohup ~/anaconda3/bin/python fcnn_fft.py --conv_type=COMPRESS_INPUT_ONLY --epochs=300 --index_back=5 >> index_back_5_percent_input_compression_only-2018-09-18-15-49.txt 2>&1 &

PYTHONPATH=../../../ CUDA_VISIBLE_DEVICES=1 nohup ~/anaconda3/bin/python fcnn_fft.py --conv_type=COMPRESS_INPUT_ONLY --epochs=300 --index_back=10 >> index_back_10_percent_input_compression_only-2018-09-18-15-49.txt 2>&1 &

PYTHONPATH=../../../ CUDA_VISIBLE_DEVICES=2 nohup ~/anaconda3/bin/python fcnn_fft.py --conv_type=COMPRESS_INPUT_ONLY --epochs=300 --index_back=50 >> index_back_50_percent_input_compression_only-2018-09-18-15-49.txt 2>&1 &

PYTHONPATH=../../../ CUDA_VISIBLE_DEVICES=3 nohup ~/anaconda3/bin/python fcnn_fft.py --conv_type=COMPRESS_INPUT_ONLY --epochs=300 --index_back=90 >> index_back_90_percent_input_compression_only-2018-09-18-15-49.txt 2>&1 &


PYTHONPATH=../../../ CUDA_VISIBLE_DEVICES=0 nohup ~/anaconda3/bin/python fcnn_fft.py --conv_type=FFT1D --datasets=debug --epochs=300 --index_back=0 --preserve_energy=80 >> index_back_0_preserve_energy_80_percent_full_fft1D-2018-09-22-12-26.txt 2>&1;

PYTHONPATH=../../../ CUDA_VISIBLE_DEVICES=0 nohup ~/anaconda3/bin/python fcnn_fft.py --conv_type=FFT1D --datasets=debug --epochs=300 --index_back=0 --preserve_energy=70 >> index_back_0_preserve_energy_70_percent_full_fft1D-2018-09-22-12-26.txt 2>&1;


PYTHONPATH=../../../ CUDA_VISIBLE_DEVICES=1 nohup ~/anaconda3/bin/python fcnn_fft.py --conv_type=FFT1D --datasets=debug --epochs=300 --index_back=0 --preserve_energy=90 >> index_back_0_preserve_energy_90_percent_full_fft1D-2018-09-22-12-26.txt 2>&1; PYTHONPATH=../../../ CUDA_VISIBLE_DEVICES=1 nohup ~/anaconda3/bin/python fcnn_fft.py --conv_type=FFT1D --datasets=debug --epochs=300 --index_back=0 --preserve_energy=95 >> index_back_0_preserve_energy_95_percent_full_fft1D-2018-09-22-12-26.txt 2>&1; PYTHONPATH=../../../ CUDA_VISIBLE_DEVICES=1 nohup ~/anaconda3/bin/python fcnn_fft.py --conv_type=FFT1D --datasets=debug --epochs=300 --index_back=0 --preserve_energy=99 >> index_back_0_preserve_energy_99_percent_full_fft1D-2018-09-22-12-26.txt 2>&1; PYTHONPATH=../../../ CUDA_VISIBLE_DEVICES=1 nohup ~/anaconda3/bin/python fcnn_fft.py --conv_type=FFT1D --datasets=debug --epochs=300 --index_back=0 --preserve_energy=50 >> index_back_0_preserve_energy_50_percent_full_fft1D-2018-09-22-12-26.txt 2>&1; PYTHONPATH=../../../ CUDA_VISIBLE_DEVICES=1 nohup ~/anaconda3/bin/python fcnn_fft.py --conv_type=FFT1D --datasets=debug --epochs=300 --index_back=0 --preserve_energy=10 >> index_back_0_preserve_energy_10_percent_full_fft1D-2018-09-22-12-26.txt 2>&1;


PYTHONPATH=../../../ CUDA_VISIBLE_DEVICES=0 nohup ~/anaconda3/bin/python fcnn_fft.py --conv_type=FFT1D --datasets=debug --epochs=1 --min_batch_size=4096 --index_back=0 --preserve_energy=100 >> index_back_0_preserve_energy_100_percent_full_fft1D-2018-09-22-12-26.txt 2>&1;
PYTHONPATH=../../../ CUDA_VISIBLE_DEVICES=0 nohup ~/anaconda3/bin/python fcnn_fft.py --conv_type=FFT1D --datasets=debug --epochs=1 --min_batch_size=4096 --index_back=0 --preserve_energy=99 >> index_back_0_preserve_energy_99_percent_full_fft1D-2018-09-22-12-26.txt 2>&1;
PYTHONPATH=../../../ CUDA_VISIBLE_DEVICES=0 nohup ~/anaconda3/bin/python fcnn_fft.py --conv_type=FFT1D --datasets=debug --epochs=1 --min_batch_size=4096 --index_back=0 --preserve_energy=90 >> index_back_0_preserve_energy_90_percent_full_fft1D-2018-09-22-12-26.txt 2>&1;
PYTHONPATH=../../../ CUDA_VISIBLE_DEVICES=0 nohup ~/anaconda3/bin/python fcnn_fft.py --conv_type=FFT1D --datasets=debug --epochs=1 --min_batch_size=4096 --index_back=0 --preserve_energy=95 >> index_back_0_preserve_energy_95_percent_full_fft1D-2018-09-22-12-26.txt 2>&1;
PYTHONPATH=../../../ CUDA_VISIBLE_DEVICES=0 nohup ~/anaconda3/bin/python fcnn_fft.py --conv_type=FFT1D --datasets=debug --epochs=1 --min_batch_size=4096 --index_back=0 --preserve_energy=50 >> index_back_0_preserve_energy_50_percent_full_fft1D-2018-09-22-12-26.txt 2>&1;
PYTHONPATH=../../../ CUDA_VISIBLE_DEVICES=0 nohup ~/anaconda3/bin/python fcnn_fft.py --conv_type=FFT1D --datasets=debug --epochs=1 --min_batch_size=4096 --index_back=0 --preserve_energy=30 >> index_back_0_preserve_energy_30_percent_full_fft1D-2018-09-22-12-26.txt 2>&1;
PYTHONPATH=../../../ CUDA_VISIBLE_DEVICES=0 nohup ~/anaconda3/bin/python fcnn_fft.py --conv_type=FFT1D --datasets=debug --epochs=1 --min_batch_size=4096 --index_back=0 --preserve_energy=10 >> index_back_0_preserve_energy_10_percent_full_fft1D-2018-09-22-12-26.txt 2>&1;

PYTHONPATH=../../../ CUDA_VISIBLE_DEVICES=2 nohup ~/anaconda3/bin/python fcnn_fft.py --conv_type=FFT1D --datasets=debug --epochs=1 --min_batch_size=4096 --index_back=0 --preserve_energy=100 --network_type=SMALL >> small_index_back_0_preserve_energy_100_percent_full_fft1D-2018-09-22-12-26.txt 2>&1;
PYTHONPATH=../../../ CUDA_VISIBLE_DEVICES=2 nohup ~/anaconda3/bin/python fcnn_fft.py --conv_type=FFT1D --datasets=debug --epochs=1 --min_batch_size=4096 --index_back=0 --preserve_energy=99  --network_type=SMALL >> small_index_back_0_preserve_energy_99_percent_full_fft1D-2018-09-22-12-26.txt 2>&1;
PYTHONPATH=../../../ CUDA_VISIBLE_DEVICES=2 nohup ~/anaconda3/bin/python fcnn_fft.py --conv_type=FFT1D --datasets=debug --epochs=1 --min_batch_size=4096 --index_back=0 --preserve_energy=90  --network_type=SMALL >> small_index_back_0_preserve_energy_90_percent_full_fft1D-2018-09-22-12-26.small_txt 2>&1;
PYTHONPATH=../../../ CUDA_VISIBLE_DEVICES=2 nohup ~/anaconda3/bin/python fcnn_fft.py --conv_type=FFT1D --datasets=debug --epochs=1 --min_batch_size=4096 --index_back=0 --preserve_energy=95  --network_type=SMALL >> small_index_back_0_preserve_energy_95_percent_full_fft1D-2018-09-22-12-26.txt 2>&1;
PYTHONPATH=../../../ CUDA_VISIBLE_DEVICES=2 nohup ~/anaconda3/bin/python fcnn_fft.py --conv_type=FFT1D --datasets=debug --epochs=1 --min_batch_size=4096 --index_back=0 --preserve_energy=50  --network_type=SMALL >> small_index_back_0_preserve_energy_50_percent_full_fft1D-2018-09-22-12-26.txt 2>&1;
PYTHONPATH=../../../ CUDA_VISIBLE_DEVICES=2 nohup ~/anaconda3/bin/python fcnn_fft.py --conv_type=FFT1D --datasets=debug --epochs=1 --min_batch_size=4096 --index_back=0 --preserve_energy=30  --network_type=SMALL >> small_index_back_0_preserve_energy_30_percent_full_fft1D-2018-09-22-12-26.txt 2>&1;
PYTHONPATH=../../../ CUDA_VISIBLE_DEVICES=2 nohup ~/anaconda3/bin/python fcnn_fft.py --conv_type=FFT1D --datasets=debug --epochs=1 --min_batch_size=4096 --index_back=0 --preserve_energy=10  --network_type=SMALL >> small_index_back_0_preserve_energy_10_percent_full_fft1D-2018-09-22-12-26.txt 2>&1;


PYTHONPATH=../../../ nohup ~/anaconda3/bin/python fcnn_fft.py --conv_type=FFT1D --datasets=all --epochs=300 --min_batch_size=16 --index_back=0 --preserve_energy=90 --network_type=STANDARD --compress_type=BIG_COEFF >> big_coeff_index_back_0_preserve_energy_90_percent_full_fft1D-2018-09-22-12-26.txt 2>&1 &

PYTHONPATH=../../../ nohup ~/anaconda3/bin/python fcnn_fft.py --conv_type=FFT1D --datasets=all --epochs=300 --min_batch_size=16 --index_back=0 --preserve_energy=90 --network_type=STANDARD --compress_type=LOW_COEFF >> low_coeff_index_back_0_preserve_energy_90_percent_full_fft1D-2018-09-22-12-26.txt 2>&1 &

CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../ nohup /home/${USER}/anaconda3/bin/python3.6 main.py --adam_beta1=0.9 --adam_beta2=0.999 --compress_type='STANDARD' --conv_type='FFT2D' --dataset='cifar10' --dev_percent=0 --dynamic_loss_scale='TRUE' --epochs=350 --index_back=0 --is_data_augmentation='TRUE' --is_debug='FALSE' --is_dev_dataset='FALSE' --is_progress_bar='FALSE' --learning_rate=0.01 --loss_reduction='ELEMENTWISE_MEAN' --loss_type='CROSS_ENTROPY' --mem_test='FALSE' --memory_size=25.0 --memory_type='STANDARD' --min_batch_size=32 --model_path='no_model' --momentum=0.9 --network_type='ResNet18' --next_power2='TRUE' --optimizer_type='MOMENTUM' --preserve_energies 90.0 95.0 100 --sample_count_limit=0 --scheduler_type='ReduceLROnPlateau' --seed=31 --static_loss_scale=1.0 --stride_type='STANDARD' --tensor_type='FLOAT32' --test_batch_size=32 --use_cuda='TRUE' --visualize='FALSE' --weight_decay=0.0005 --workers=4 >> 2018-12-03-11-50-cifar10-ENERGY-90.txt 2>&1 &

CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../ nohup /home/${USER}/anaconda3/bin/python3.6 main.py --adam_beta2=0.999 --compress_type='STANDARD' --conv_type='STANDARD2D' --dataset='cifar10' --dev_percent=0 --dynamic_loss_scale='TRUE' --epochs=350 --index_back=0 --is_data_augmentation='TRUE' --is_debug='FALSE' --is_dev_dataset='FALSE' --is_progress_bar='FALSE' --is_serial_conv='FALSE' --learning_rate=0.01 --log_interval=1 --loss_reduction='ELEMENTWISE_MEAN' --loss_type='CROSS_ENTROPY' --mem_test='FALSE' --memory_size=25 --memory_type='STANDARD' --min_batch_size=32 --model_path='no_model' --momentum=0.9 --network_type='ResNet18' --next_power2='FALSE' --optimizer_type='MOMENTUM' --preserve_energies=100 --sample_count_limit=0 --scheduler_type='ReduceLROnPlateau' --seed=31 --static_loss_scale=1 --stride_type='STANDARD' --tensor_type='FLOAT32' --test_batch_size=32 --use_cuda='TRUE' --visualize='FALSE' --weight_decay=0.0005 --workers=6

CUDA_VISIBLE_DEVICES=2 PYTHONPATH=../../../ nohup /home/${USER}/anaconda3/bin/python3.6 main.py --adam_beta2=0.999 --compress_type='STANDARD' --conv_type='FFT2D' --conv_exec_type=CUDA --dataset='cifar10' --dev_percent=0 --dynamic_loss_scale='TRUE' --epochs=350 --index_back=0 --is_data_augmentation='TRUE' --is_debug='FALSE' --is_dev_dataset='FALSE' --is_progress_bar='FALSE' --learning_rate=0.01 --loss_reduction='ELEMENTWISE_MEAN' --loss_type='CROSS_ENTROPY' --mem_test='FALSE' --memory_size=25 --memory_type='STANDARD' --min_batch_size=32 --model_path='no_model' --momentum=0.9 --network_type='ResNet18' --next_power2='FALSE' --optimizer_type='MOMENTUM' --preserve_energies=100 --sample_count_limit=0 --scheduler_type='ReduceLROnPlateau' --seed=31 --static_loss_scale=1 --stride_type='STANDARD' --tensor_type='FLOAT32' --test_batch_size=32 --use_cuda='TRUE' --visualize='FALSE' --weight_decay=0.0005 --workers=6  >> 2018-12-09-19-28-cifar10-ENERGY-100-adam-gpu4.txt 2>&1 &

CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../ nohup /home/${USER}/anaconda3/bin/python3.6 main.py --adam_beta2=0.999 --compress_type='STANDARD' --conv_type='FFT2D' --conv_exec_type=CUDA --dataset='cifar10' --dev_percent=0 --dynamic_loss_scale='TRUE' --epochs=350 --index_back=0 --is_data_augmentation='TRUE' --is_debug='FALSE' --is_dev_dataset='FALSE' --is_progress_bar='FALSE' --learning_rate=0.01 --loss_reduction='ELEMENTWISE_MEAN' --loss_type='CROSS_ENTROPY' --mem_test='FALSE' --memory_size=25 --memory_type='STANDARD' --min_batch_size=32 --model_path='no_model' --momentum=0.9 --network_type='ResNet18' --next_power2='FALSE' --optimizer_type='MOMENTUM' --preserve_energies 97 95 10 --sample_count_limit=0 --scheduler_type='ReduceLROnPlateau' --seed=31 --static_loss_scale=1 --stride_type='STANDARD' --tensor_type='FLOAT32' --test_batch_size=32 --use_cuda='TRUE' --visualize='FALSE' --weight_decay=0.0005 --workers=6  >> 2018-12-10-09-56-cifar10-ENERGY-97-95-10-adam-gpu5.txt 2>&1 &

CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../ nohup /home/${USER}/anaconda3/bin/python3.6 main.py --adam_beta2=0.999 --compress_type='STANDARD' --conv_type='STANDARD2D' --conv_exec_type=CUDA --dataset='cifar100' --dev_percent=0 --dynamic_loss_scale='TRUE' --epochs=350 --index_back=0 --is_data_augmentation='TRUE' --is_debug='FALSE' --is_dev_dataset='FALSE' --is_progress_bar='FALSE' --learning_rate=0.01 --loss_reduction='ELEMENTWISE_MEAN' --loss_type='CROSS_ENTROPY' --mem_test='FALSE' --memory_size=25 --memory_type='STANDARD' --min_batch_size=32 --model_path='no_model' --momentum=0.9 --network_type='DenseNetCifar' --next_power2='TRUE' --optimizer_type='MOMENTUM' --preserve_energies 100 --sample_count_limit=0 --scheduler_type='ReduceLROnPlateau' --seed=31 --static_loss_scale=1 --stride_type='STANDARD' --tensor_type='FLOAT32' --test_batch_size=32 --use_cuda='TRUE' --visualize='FALSE' --weight_decay=0.0005 --workers=6  >> 2018-12-10-16-17-cifar100-densenet-adam-gpu12-standard2d.txt 2>&1 &

CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../ nohup /home/${USER}/anaconda3/bin/python3.6 main.py --adam_beta2=0.999 --compress_type='STANDARD' --conv_type='STANDARD' --conv_exec_type=BATCH --dataset='ucr' --dev_percent=0 --dynamic_loss_scale='TRUE' --epochs=300 --index_back=0 --is_data_augmentation='TRUE' --is_debug='FALSE' --is_dev_dataset='FALSE' --is_progress_bar='FALSE' --learning_rate=0.01 --loss_reduction='ELEMENTWISE_MEAN' --loss_type='CROSS_ENTROPY' --mem_test='FALSE' --memory_size=25 --memory_type='STANDARD' --min_batch_size=16 --model_path='no_model' --momentum=0.9 --network_type='FCNN_STANDARD' --next_power2='TRUE' --optimizer_type='MOMENTUM' --preserve_energies 100 --sample_count_limit=0 --scheduler_type='ReduceLROnPlateau' --seed=31 --static_loss_scale=1 --stride_type='STANDARD' --tensor_type='FLOAT32' --test_batch_size=16 --use_cuda='TRUE' --visualize='FALSE' --weight_decay=0 --workers=6  >> 2018-12-11-08-58-standard1d-fcnn.txt 2>&1 &

CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../ nohup /home/${USER}/anaconda3
/bin/python3.6 main.py --adam_betmaina2=0.999 --compress_type='STANDARD' --conv_type='FFT2D' --conv_exec_type=CUDA --dataset='cifar100' --dev_pe
rcent=0 --dynamic_loss_scale='TRUE' --epochs=350 --index_back=0 --is_data_augmentation='TRUE' --is_debug='FALSE' --is_dev_dataset='FALSE' --
is_progress_bar='FALSE' --learning_rate=0.01 --loss_reduction='ELEMENTWISE_MEAN' --loss_type='CROSS_ENTROPY' --mem_test='FALSE' --memory_siz
e=25 --memory_type='STANDARD' --min_batch_size=32 --model_path='no_model' --momentum=0.9 --network_type='DenseNetCifar' --next_power2='TRUE'
 --optimizer_type='MOMENTUM' --preserve_energies=100 --sample_count_limit=0 --scheduler_type='ReduceLROnPlateau' --seed=31 --static_loss_sca
le=1 --stride_type='STANDARD' --tensor_type='FLOAT32' --test_batch_size=32 --use_cuda='TRUE' --visualize='FALSE' --weight_decay=0.0001 --wor
kers=6  >> 2018-12-10-09-56-cifar100-ENERGY-100-adam-gpu3.txt 2>&1 &

CUDA_VISIBLE_DEVICES=1 PYTHONPATH=../../../ nohup /home/${USER}/anaconda3
/bin/python3.6 main.py --adam_betmaina2=0.999 --compress_type='STANDARD' --conv_type='FFT1D' --conv_exec_type=BATCH --dataset='debug9conv1-100' --dev_pe
rcent=0 --dynamic_loss_scale='TRUE' --epochs=300 --index_back=0 --is_data_augmentation='TRUE' --is_debug='FALSE' --is_dev_dataset='FALSE' --
is_progress_bar='FALSE' --learning_rate=0.001 --loss_reduction='ELEMENTWISE_MEAN' --loss_type='CROSS_ENTROPY' --mem_test='FALSE' --memory_siz
e=25 --memory_type='STANDARD' --min_batch_size=8 --model_path='no_model' --momentum=0.9 --network_type='FCNN_STANDARD' --next_power2='TRUE'
 --optimizer_type='ADAM' --preserve_energies=100 --sample_count_limit=0 --scheduler_type='ReduceLROnPlateau' --seed=31 --static_loss_sca
le=1 --stride_type='STANDARD' --tensor_type='FLOAT32' --test_batch_size=8 --use_cuda='TRUE' --visualize='FALSE' --weight_decay=0 --wor
kers=6  >> 2018-12-10-09-56-ucr-ENERGY-100-adam-gpu3.txt 2>&1 &

CUDA_VISIBLE_DEVICES=1 PYTHONPATH=../../../ nohup /home/${USER}/anaconda3/bin/python3.6 main.py --adam_beta2=0.999 --compress_type='STANDARD' --conv_type='FFT1D' --conv_exec_type=BATCH --dataset='debug9conv1-100' --dev_percent=0 --dynamic_loss_scale='TRUE' --epochs=300 --index_back=0 --is_data_augmentation='TRUE' --is_debug='FALSE' --is_dev_dataset='FALSE' --is_progress_bar='FALSE' --learning_rate=0.001 --loss_reduction='ELEMENTWISE_MEAN' --loss_type='CROSS_ENTROPY' --mem_test='FALSE' --memory_size=25 --memory_type='STANDARD' --min_batch_size=8 --model_path='no_model' --momentum=0.9 --network_type='FCNN_STANDARD' --next_power2='TRUE' --optimizer_type='ADAM' --preserve_energies=100 --sample_count_limit=0 --scheduler_type='ReduceLROnPlateau' --seed=31 --static_loss_scale=1 --stride_type='STANDARD' --tensor_type='FLOAT32' --test_batch_size=8 --use_cuda='TRUE' --visualize='FALSE' --weight_decay=0 --workers=6  >> 2018-12-10-09-56-ucr-ENERGY-100-adam-gpu3.txt 2>&1 &


CUDA_VISIBLE_DEVICES=1 PYTHONPATH=../../../ nohup /home/${USER}/anaconda3/bin/python3.6 main.py --adam_beta2=0.999 --compress_type='STANDARD' --conv_type='FFT2D' --conv_exec_type=CUDA --dataset='cifar100' --dev_perc
ent=0 --dynamic_loss_scale='TRUE' --epochs=350 --index_back=0 --is_data_augmentation='TRUE' --is_debug='FALSE' --is_dev_dataset='FALSE' --is
_progress_bar='FALSE' --learning_rate=0.01 --loss_reduction='ELEMENTWISE_MEAN' --loss_type='CROSS_ENTROPY' --mem_test='FALSE' --memory_size=
25 --memory_type='STANDARD' --min_batch_size=32 --model_path='no_model' --momentum=0.9 --network_type='DenseNetCifar' --next_power2='TRUE' -
-optimizer_type='MOMENTUM' --preserve_energies=95 --sample_count_limit=0 --scheduler_type='ReduceLROnPlateau' --seed=31 --static_loss_scale=
1 --stride_type='STANDARD' --tensor_type='FLOAT32' --test_batch_size=32 --use_cuda='TRUE' --visualize='FALSE' --weight_decay=0.0001 --worker
s=6  >> 2018-12-14-15-00-cifar100-fft2d-energy95-pytorch-adam-gpu3.txt 2>&1 &

CUDA_VISIBLE_DEVICES=1 PYTHONPATH=../../../ nohup /home/${USER}/anaconda3/bin/python3.6 main.py --adam_beta2=0.999 --compress_type='STANDARD' --conv_type='FFT2D' --conv_exec_type=CUDA --dataset='cifar100' --dev_percent=0 --dynamic_loss_scale='TRUE' --epochs=350 --index_back=0 --is_data_augmentation='TRUE' --is_debug='FALSE' --is_dev_dataset='FALSE' --is_progress_bar='FALSE' --learning_rate=0.01 --loss_reduction='ELEMENTWISE_MEAN' --loss_type='CROSS_ENTROPY' --mem_test='FALSE' --memory_size=25 --memory_type='STANDARD' --min_batch_size=32 --model_path='2018-12-19-20-41-18-699435-dataset-cifar100-preserve-energy-95.0-test-accuracy-61.5.model' --momentum=0.9 --network_type='DenseNetCifar' --next_power2='TRUE' --optimizer_type='MOMENTUM' --preserve_energies=95 --sample_count_limit=0 --scheduler_type='ReduceLROnPlateau' --seed=31 --static_loss_scale=1 --stride_type='STANDARD' --tensor_type='FLOAT32' --test_batch_size=32 --use_cuda='TRUE' --visualize='FALSE' --weight_decay=0.0001 --workers=6  >> 2018-12-19-23-00-cifar100-fft2d-energy95-pytorch-adam-gpu3.txt 2>&1 &

CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../ nohup /home/${USER}/anaconda3/bin/python3.6 main.py --adam_beta2=0.999 --compress_type='STANDARD' --conv_type='FFT2D' --conv_exec_type=CUDA --dataset='cifar100' --dev_percent=0 --dynamic_loss_scale='TRUE' --epochs=350 --index_back=0 --is_data_augmentation='TRUE' --is_debug='FALSE' --is_dev_dataset='FALSE' --is_progress_bar='FALSE' --learning_rate=0.01 --loss_reduction='ELEMENTWISE_MEAN' --loss_type='CROSS_ENTROPY' --mem_test='FALSE' --memory_size=25 --memory_type='STANDARD' --min_batch_size=32 --model_path='2018-12-19-20-49-06-599729-dataset-cifar100-preserve-energy-99.0-test-accuracy-72.71.model' --momentum=0.9 --network_type='DenseNetCifar' --next_power2='TRUE' --optimizer_type='MOMENTUM' --preserve_energies=99 --sample_count_limit=0 --scheduler_type='ReduceLROnPlateau' --seed=31 --static_loss_scale=1 --stride_type='STANDARD' --tensor_type='FLOAT32' --test_batch_size=32 --use_cuda='TRUE' --visualize='FALSE' --weight_decay=0.0001 --workers=6  >> 2018-12-19-23-00-cifar100-fft2d-energy99-pytorch-adam-gpu3.txt 2>&1 &

CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../ nohup /home/${USER}/anaconda3/bin/python3.6 main.py --adam_beta2=0.999 --compress_type='STANDARD' --conv_type='FFT2D' --conv_exec_type=CUDA --dataset='cifar100' --dev_percent=0 --dynamic_loss_scale='TRUE' --epochs=350 --index_back=0 --is_data_augmentation='TRUE' --is_debug='FALSE' --is_dev_dataset='FALSE' --is_progress_bar='FALSE' --learning_rate=0.01 --loss_reduction='ELEMENTWISE_MEAN' --loss_type='CROSS_ENTROPY' --mem_test='FALSE' --memory_size=25 --memory_type='STANDARD' --min_batch_size=32 --model_path='2018-12-19-17-45-59-022669-dataset-cifar100-preserve-energy-98.0-test-accuracy-69.22.model' --momentum=0.9 --network_type='DenseNetCifar' --next_power2='TRUE' --optimizer_type='MOMENTUM' --preserve_energies=98 --sample_count_limit=0 --scheduler_type='ReduceLROnPlateau' --seed=31 --static_loss_scale=1 --stride_type='STANDARD' --tensor_type='FLOAT32' --test_batch_size=32 --use_cuda='TRUE' --visualize='FALSE' --weight_decay=0.0001 --workers=6  >> 2018-12-19-23-00-cifar100-fft2d-energy98-pytorch-adam-gpu3.txt 2>&1 &

CUDA_VISIBLE_DEVICES=1 PYTHONPATH=../../../ nohup /home/${USER}/anaconda3/bin/python3.6 main.py --adam_beta2=0.999 --compress_type='STANDARD' --conv_type='FFT2D' --conv_exec_type=CUDA --dataset='cifar100' --dev_percent=0 --dynamic_loss_scale='TRUE' --epochs=350 --index_back=0 --is_data_augmentation='TRUE' --is_debug='FALSE' --is_dev_dataset='FALSE' --is_progress_bar='FALSE' --learning_rate=0.01 --loss_reduction='ELEMENTWISE_MEAN' --loss_type='CROSS_ENTROPY' --mem_test='FALSE' --memory_size=25 --memory_type='STANDARD' --min_batch_size=32 --model_path='2018-12-19-19-35-14-502498-dataset-cifar100-preserve-energy-99.5-test-accuracy-74.41.model' --momentum=0.9 --network_type='DenseNetCifar' --next_power2='TRUE' --optimizer_type='MOMENTUM' --preserve_energies=99.5 --sample_count_limit=0 --scheduler_type='ReduceLROnPlateau' --seed=31 --static_loss_scale=1 --stride_type='STANDARD' --tensor_type='FLOAT32' --test_batch_size=32 --use_cuda='TRUE' --visualize='FALSE' --weight_decay=0.0001 --workers=6  >> 2018-12-19-23-00-cifar100-fft2d-energy99.5-pytorch-adam-gpu3.txt 2>&1 &

CUDA_VISIBLE_DEVICES=1 PYTHONPATH=../../../ nohup /home/${USER}/anaconda3
/bin/python3.6 main.py --adam_beta2=0.999 --compress_type='STANDARD' --conv_type='FFT2D' --conv_exec_type=CUDA --dataset='cifar10' --dev_per
cent=0 --dynamic_loss_scale='TRUE' --epochs=350 --index_back=0 --is_data_augmentation='TRUE' --is_debug='FALSE' --is_dev_dataset='FALSE' --i
s_progress_bar='FALSE' --learning_rate=0.06 --loss_reduction='ELEMENTWISE_MEAN' --loss_type='CROSS_ENTROPY' --mem_test='FALSE' --memory_size
=25 --memory_type='STANDARD' --min_batch_size=32 --model_path='no_model' --momentum=0.9 --network_type='ResNet18' --next_power2='TRUE' --opt
imizer_type='MOMENTUM' --preserve_energies 92 --sample_count_limit=0 --scheduler_type='ReduceLROnPlateau' --seed=31 --static_loss_scale=1 --
stride_type='STANDARD' --tensor_type='FLOAT32' --test_batch_size=32 --use_cuda='TRUE' --visualize='FALSE' --weight_decay=0.0001 --workers=6
 >> 2018-12-19-22-43-cifar10-fft2d-energy92-pytorch-adam-gpu6-lr:0.06,decay:0.0001-adam.txt 2>&1 &

CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../ nohup /home/${USER}/anaconda3
/bin/python3.6 main.py --adam_beta2=0.999 --compress_type='STANDARD' --conv_type='FFT2D' --conv_exec_type=CUDA --dataset='cifar10' --dev_per
cent=0 --dynamic_loss_scale='TRUE' --epochs=350 --index_back=0 --is_data_augmentation='TRUE' --is_debug='FALSE' --is_dev_dataset='FALSE' --i
s_progress_bar='FALSE' --learning_rate=0.03 --loss_reduction='ELEMENTWISE_MEAN' --loss_type='CROSS_ENTROPY' --mem_test='FALSE' --memory_size
=25 --memory_type='STANDARD' --min_batch_size=32 --model_path='no_model' --momentum=0.9 --network_type='ResNet18' --next_power2='TRUE' --opt
imizer_type='MOMENTUM' --preserve_energies 99 --sample_count_limit=0 --scheduler_type='ReduceLROnPlateau' --seed=31 --static_loss_scale=1 --
stride_type='STANDARD' --tensor_type='FLOAT32' --test_batch_size=32 --use_cuda='TRUE' --visualize='FALSE' --weight_decay=0.0001 --workers=6
 >> 2018-12-19-22-43-cifar10-fft2d-energy99-pytorch-adam-gpu6-lr:0.06,decay:0.0001-adam.txt 2>&1 &



CUDA_VISIBLE_DEVICES=3 PYTHONPATH=../../../ nohup /home/${USER}/anaconda3
/bin/python3.6 main.py --adam_beta2=0.999 --compress_type='STANDARD' --conv_type='FFT2D' --conv_exec_type=CUDA --dataset='cifar10' --dev_per
cent=0 --dynamic_loss_scale='TRUE' --epochs=350 --index_back=0 --is_data_augmentation='TRUE' --is_debug='FALSE' --is_dev_dataset='FALSE' --i
s_progress_bar='FALSE' --learning_rate=0.09 --loss_reduction='ELEMENTWISE_MEAN' --loss_type='CROSS_ENTROPY' --mem_test='FALSE' --memory_size
=25 --memory_type='STANDARD' --min_batch_size=32 --model_path='no_model' --momentum=0.9 --network_type='ResNet18' --next_power2='TRUE' --opt
imizer_type='MOMENTUM' --preserve_energies 92 --sample_count_limit=0 --scheduler_type='ReduceLROnPlateau' --seed=31 --static_loss_scale=1 --
stride_type='STANDARD' --tensor_type='FLOAT32' --test_batch_size=32 --use_cuda='TRUE' --visualize='FALSE' --weight_decay=0.0001 --workers=6
 >> 2018-12-19-22-43-cifar10-fft2d-energy92-pytorch-adam-gpu11-lr:0.05,decay:0.0001.txt 2>&1 &




CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../ nohup /home/${USER}/anaconda3/bin/python3.6 main.py --adam_beta2=0.999 --compress_type='STANDARD' --conv_type='FFT2D' --conv_exec_type=CUDA --dataset='cifar100' --dev_percent=0 --dynamic_loss_scale='TRUE' --epochs=350 --index_back=0 --is_data_augmentation='TRUE' --is_debug='FALSE' --is_dev_dataset='FALSE' --is_progress_bar='FALSE' --learning_rate=0.01 --loss_reduction='ELEMENTWISE_MEAN' --loss_type='CROSS_ENTROPY' --mem_test='FALSE' --memory_size=25 --memory_type='STANDARD' --min_batch_size=32 --model_path='no_model' --momentum=0.9 --network_type='DenseNetCifar' --next_power2='TRUE' --optimizer_type='MOMENTUM' --preserve_energies=90 --sample_count_limit=0 --scheduler_type='ReduceLROnPlateau' --seed=31 --static_loss_scale=1 --stride_type='STANDARD' --tensor_type='FLOAT32' --test_batch_size=32 --use_cuda='TRUE' --visualize='FALSE' --weight_decay=0.0001 --workers=6  >> 2018-12-26-23-00-cifar100-fft2d-energy90-pytorch-adam-gpu3.txt 2>&1 &

CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../ nohup /home/${USER}/anaconda3/bin/python3.6 main.py --adam_betmaina2=0.999 --compress_type='STANDARD' --conv_type='FFT2D' --conv_exec_type=CUDA --dataset='cifar100' --dev_percent=0 --dynamic_loss_scale='TRUE' --epochs=350 --index_back=0 --is_data_augmentation='TRUE' --is_debug='FALSE' --is_dev_dataset='FALSE' --is_progress_bar='FALSE' --learning_rate=0.01 --loss_reduction='ELEMENTWISE_MEAN' --loss_type='CROSS_ENTROPY' --mem_test='FALSE' --memory_size=25 --memory_type='STANDARD' --min_batch_size=32 --model_path='no_model' --momentum=0.9 --network_type='DenseNetCifar' --next_power2='TRUE' --optimizer_type='MOMENTUM' --preserve_energies=95 --sample_count_limit=0 --scheduler_type='ReduceLROnPlateau' --seed=31 --static_loss_scale=1 --stride_type='STANDARD' --tensor_type='FLOAT32' --test_batch_size=32 --use_cuda='TRUE' --visualize='FALSE' --weight_decay=0.0001 --workers=6  >> 2019-01-03-11-43-cifar100-ENERGY-95-adam-gpu3.txt 2>&1 &