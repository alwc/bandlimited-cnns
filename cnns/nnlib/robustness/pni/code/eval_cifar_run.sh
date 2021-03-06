#!/usr/bin/env sh

############### Host   ##############################
HOST=$(hostname)
echo "Current host is: $HOST"

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
TENSORBOARD="/home/${USER}/anaconda3/bin/tensorboard"

DATE=`date +%Y-%m-%d`

if [ ! -d "$DIRECTORY" ]; then
    mkdir -p ./save/${DATE}/
fi

############### Configurations ########################
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_input
dataset=cifar10
epochs=160
batch_size=128
optimizer=SGD
# add more labels as additional info into the saving path
label_info=eval_layerwise_resnet20


data_path="/home/${USER}/data/pytorch/cifar10" #dataset path
tb_path=./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info}/tb_log  #tensorboard log path

# set the pretrained model path
# pretrained_model=/home/elliot/Documents/CVPR_2019/CVPR_2019_PNI/code/save/cifar10_noise_resnet20_160_SGD_29_PNI-W/model_best.pth.tar
# pretrained_model=/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/2020-02-03/cifar10_noise_resnet20_160_SGD_train_channelwise_3e-4decay/model_best.pth.tar
pretrained_model=/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/save_adv_train_cifar10_noise_resnet20_input_160_SGD_train_layerwise_3e-4decay/mode_best.pth.tar

############### Neural network ############################
{
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --evaluate --resume ${pretrained_model} \
    --adv_eval --epoch_delay 5 >> eval_${timestamp}.txt 2>&1 &
echo eval_${timestamp}.txt
} &
############## Tensorboard logging ##########################
{
if [ "$enable_tb_display" = true ]; then 
    sleep 30 
    wait
    $TENSORBOARD --logdir $tb_path  --port=6006
fi
} &
{
if [ "$enable_tb_display" = true ]; then
    sleep 45
    wait
    case $HOST in
    "alpha")
        google-chrome http://0.0.0.0:6006/
        ;;
    esac
fi 
} &
wait


############### Configurations ########################
PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_both
dataset=cifar10
epochs=160
batch_size=128
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_no_adv_train_noise_both_scaled_evaluate
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar10_noise_resnet20_both_160_SGD_train_layerwise_3e-4decay/model_best.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 2 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --evaluate --resume ${pretrained_model} \
    --adv_eval --epoch_delay 5 >> train_${timestamp}.txt 2>&1 &
echo train_${timestamp}.txt
[2] 32908
cc@sat:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo train_${timestamp}.txt
train_2020-02-05-03-07-54-093302028.txt


############### Configurations ########################
PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_input
dataset=cifar10
epochs=160
batch_size=128
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_no_adv_train_noise_input_scaled_evaluate
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar10_noise_resnet20_input_160_SGD_train_layerwise_3e-4decay/model_best.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 2 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --evaluate --resume ${pretrained_model} \
    --adv_eval --epoch_delay 5 >> train_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[2] 90255
cc@g-2:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo train_${timestamp}.txt
train_2020-02-05-03-09-58-826649672.txt



############### Configurations ########################
PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_weight
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_train_noise_weight_scaled_evaluate
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/save_adv_train_cifar10_noise_resnet20_weight_160_SGD_train_layerwise_3e-4decay/model_best.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --attack_carlini_eval --resume ${pretrained_model} \
    --adv_eval --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
skr-compute1
test_2020-02-04-23-15-05-106074704.txt



############### Configurations ########################
PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust_both
dataset=cifar10
epochs=160
batch_size=128
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_no_adv_train_noise_both
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save//model_best.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 4 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --adv_eval --evaluate --epoch_delay 5 >> train_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt

############### Configurations ########################
PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust_both
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_no_adv_train_noise_both_eval_carlini
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save//model_best.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 8 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_carlini_eval --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 62935
cc@f:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-05-05-33-13-724803833.txt



PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_both
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_no_adv_train_noise_both_eval_carlini
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar10_noise_resnet20_both_160_SGD_train_layerwise_3e-4decay_no_adv_train/model_best.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 2 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_carlini_eval --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 97261
cc@icml-2:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-05-05-41-56-513704895.txt



PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_no_adv_train_robust_net_eval_carlini
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar10_noise_resnet20_robust_160_SGD_train_layerwise_3e-4decay_robust_net/model_best.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_carlini_eval --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt

cifar10_noise_resnet20_robust_160_SGD_train_layerwise_3e-4decay_robust_net
PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_no_adv_train_robust_net_eval_carlini_0.1
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar10_noise_resnet20_robust_160_SGD_train_layerwise_3e-4decay_robust_net/model_best.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_carlini_eval --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 99447
cc@g-1:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-05-21-11-12-389189283.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=vanilla_resnet20
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_no_adv_train_vanilla_net_eval_carlini
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar10_vanilla_resnet20_160_SGD_train_layerwise_3e-4decay_robust_net/model_best.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_carlini_eval --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[5] 107060
cc@f:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-05-22-19-27-502676125.txt

cifar10_noise_resnet20_robust_160_SGD_train_layerwise_3e-4decay_robust_net_init_noise_0.15

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=vanilla_resnet20
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_no_adv_train_robust_net_0.15-0.1_eval_carlini
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar10_noise_resnet20_robust_160_SGD_train_layerwise_3e-4decay_robust_net_init_noise_0.15/model_best.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_carlini_eval --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 106904
cc@p:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-05-23-39-33-549076258.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_weight
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_train_noise_weight_scaled_evaluate_pgd
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/save_adv_train_cifar10_noise_resnet20_weight_160_SGD_train_layerwise_3e-4decay/model_best.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --attack_eval --attack 'pgd' --attack_iters 10 --resume ${pretrained_model} \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 24576
ady@skr-compute1:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-05-19-14-21-025639460.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_no_adv_train_robust_net_eval_carlini
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/save_cifar10_noise_resnet20_robust_160_SGD_train_layerwise_3e-4decay_robust_net/model_best.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' \
    --attack_iters 10 --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt



PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust # + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_train_robust_net_0.1-0.1_eval_carlini
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar10_noise_resnet20_robust_160_SGD_train_layerwise_3e-4decay_robust_net_adv_train/model_best.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_carlini_eval --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 48857
cc@g-2:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-06-03-18-42-135144659.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=vanilla_resnet20
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_train
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar10_noise_resnet20_robust_160_SGD_train_layerwise_3e-4decay_robust_net_init_noise_0.15/model_best.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --adv_eval --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 109538
cc@p:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-06-03-51-52-701853014.txt


PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust # + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_train_robust_net_0.1-0.1_eval_carlini
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar10_noise_resnet20_robust_160_SGD_train_layerwise_3e-4decay_robust_net_adv_train/model_best.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=1 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --adv_eval --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=vanilla_resnet20 # + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/adv_train.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --adv_eval --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 115159
cc@f:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-06-04-36-38-513433420.txt


PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_weight # + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/pni.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --adv_eval --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 115859
cc@p:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-06-04-55-08-571345127.txt


PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust_02 # + adv. training
dataset=cifar10
epochs=160
batch_size=1024
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/robust_net_0.2.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --adv_eval --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 103401
cc@g-1:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-06-04-57-15-627825880.txt


PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust_01 # + adv. training
dataset=cifar10
epochs=160
batch_size=1024
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/robust_net_01_adv_train.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --adv_eval --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust_01 # + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/robust_net_01_adv_train.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 70334
cc@sat:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-06-05-37-20-303029304.txt


PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=vanilla_resnet20 # + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/adv_train.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 116933
cc@f:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-06-04-51-51-600222099.txt


PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_weight # + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/pni.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 117405
cc@p:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-06-05-39-44-382709938.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust_02 # + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/robust_net_0.2.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 108118
cc@g-1:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-06-05-41-21-419837071.txt

[1] 14846
ady@skr-compute1:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-06-01-07-20-057884541.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust_02 # + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/robust_net_0.2.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 15112
ady@skr-compute1:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-06-01-13-23-661644334.txt


PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_weight # + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_pni_weight.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'cw' --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 78872
cc@nips:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-09-02-53-03-038960053.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_weight # + adv. training
dataset=svhn
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_pni_input.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=1 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'cw' --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[2] 79053
cc@nips:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-09-02-54-07-126881348.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_weight # + adv. training
dataset=svhn
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_pni_weight.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[3] 79326
cc@nips:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-09-02-56-31-610174452.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust_01 # + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_robust_net_01_adv_train.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=1 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'cw' --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[4] 80662
cc@nips:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-09-02-58-52-038016137.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust_01 # + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_robust_net_01_adv_train.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=3 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[5] 81038
cc@nips:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-09-02-59-30-887853098.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=vanilla_resnet20 # + adv. training
dataset=svhn
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_adv_train.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=3 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'cw' --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[6] 83187
cc@nips:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-09-03-09-45-641006470.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=vanilla_resnet20 # + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_adv_train.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'cw' --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 77999
cc@g-1:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-09-03-12-48-873928028.txt


cc@nips:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
cc@nips:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ enable_tb_display=false # enable tensorboard display
cc@nips:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ model=noise_resnet20_robust_02 # + adv. training
cc@nips:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ dataset=cifar10
cc@nips:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ epochs=160
cc@nips:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ batch_size=2560
cc@nips:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ optimizer=SGD
cc@nips:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ # add more labels as additional info into the saving path
cc@nips:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ label_info=train_layerwise_3e-4decay_adv_eval
cc@nips:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_robust_net_02.pth.tar"
cc@nips:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ #dataset path
cc@nips:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ data_path="/home/${USER}/data/pytorch/cifar10"
cc@nips:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
cc@nips:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ CUDA_VISIBLE_DEVICES=3 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
>     --data_path ${data_path}   \
>     --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
>     --epochs ${epochs} --learning_rate 0.1 \
>     --optimizer ${optimizer} \
> --schedule 80 120  --gammas 0.1 0.1 \
>     --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
>     --print_freq 100 --decay 0.0003 --momentum 0.9 \
>     --resume ${pretrained_model} \
>     --attack_eval --attack 'cw' --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
[6] 83187
cc@nips:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-09-03-09-45-641006470.txt


PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=vanilla_resnet20 # + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_plain.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=1 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'cw' --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[2] 78143
cc@g-1:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-09-03-13-42-059583743.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=vanilla_resnet20 # + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar10_vanilla_resnet20_adv_train_100_iters_pgd_accuracy_83-690.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'cw' --attack_iters 200 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 116313
cc@p:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-10-04-12-29-075156811.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust_01 # + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar10-robust-net-adv-train-100-iters-pgd-accuracy-83-860.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=1 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'cw' --attack_iters 200 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[2] 116556
cc@p:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-10-04-18-21-697977954.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust_01 # + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar10_noise_resnet20_robust_01_pgd_40_iters_accuracy_84-250.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'cw' --attack_iters 200 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 22967
cc@icml:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-10-04-26-49-962378485.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=vanilla_resnet20 # + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar10_vanilla_resnet20_pgd_attack_40_iters_acc_83.960.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=1 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'cw' --attack_iters 200 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[2] 23137
cc@icml:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-10-04-28-38-365062586.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust_02 # + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar10_noise_resnet20_robust_02_robustnet_acc_80-380.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=2 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'cw' --attack_iters 200 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[3] 23299
cc@icml:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-10-04-29-38-294959382.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_weight # + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar10_noise_resnet20_weight_pgd_40_iters_attack_accuracy_83-910.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=3 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'cw' --attack_iters 200 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[4] 23533
cc@icml:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-10-04-31-36-515585056.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust_01 # + adv. training
dataset=cifar100
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar100_noise_resnet20_robust_01_160_SGD_train_layerwise_3e-4decay.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'cw' --attack_iters 200 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt


PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=vanilla_resnet20 # + adv. training
dataset=cifar100
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar100_vanilla_resnet20_160_SGD_train_layerwise_3e-4decay.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=1 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'cw' --attack_iters 200 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 144497
cc@g-1:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-10-04-48-49-464479396.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust_02 # + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar10_noise_resnet20_robust_02_robustnet_acc_80-380.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=2 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'cw' --attack_iters 200 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[3] 23299
cc@icml:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-10-04-29-38-294959382.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_weight # + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar10_noise_resnet20_weight_pgd_40_iters_attack_accuracy_83-910.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=3 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'cw' --attack_iters 200 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_weight # + adv. training
dataset=svhn
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_pni_weight.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 144821
cc@g-1:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-10-04-53-11-251398594.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust_01 # + adv. training
dataset=svhn
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_robust_net_01_adv_train.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=1 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'cw' --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[2] 145100
cc@g-1:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-10-04-54-32-156126199.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=vanilla_resnet20 # + adv. training
dataset=svhn
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_adv_train.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'cw' --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 111442
cc@g-2:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-10-04-56-15-080954763.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust_02 # + adv. training
dataset=svhn
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_robust_net_02.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=1 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'cw' --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[2] 111596
cc@g-2:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-10-04-57-20-735208098.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_weight # + adv. training
dataset=svhn
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_pni_weight.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' \
    --attack_iters 7 --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 3197
cc@g-1:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-10-13-15-35-016814491.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust_01 # + adv. training
dataset=svhn
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_robust_net_01_adv_train.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=1 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' --attack_iters 7 --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[2] 3360
cc@g-1:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-10-13-15-52-561784435.txt


PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=vanilla_resnet20 # + adv. training
dataset=svhn
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_adv_train.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' \
    --attack_iters 7 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 116809
cc@g-2:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-10-13-17-42-682609980.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust_02 # + adv. training
dataset=svhn
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_robust_net_02.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=1 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' --attack_iters 7 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[2] 116958
cc@g-2:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-10-13-17-59-636304449.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust_02 # + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar10_noise_resnet20_robust_02_robustnet_acc_80-380.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=2 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' --attack_iters 40 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt


PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_weight # + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar10_noise_resnet20_weight_pgd_40_iters_attack_accuracy_83-910.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=3 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' --attack_iters 40 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[2] 33912
cc@icml:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-10-13-22-27-731072464.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust_01 # + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar10_noise_resnet20_robust_01_pgd_40_iters_accuracy_84-250.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' --attack_iters 40 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt


PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=vanilla_resnet20 # + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar10_vanilla_resnet20_pgd_attack_40_iters_acc_83.960.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=1 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' --attack_iters 40 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt


PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust_02 # + adv. training
dataset=cifar10
epochs=160
batch_size=2500
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar10_noise_resnet20_robust_02_robustnet_acc_80-380.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' --attack_iters 40 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt


PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_weight # + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar10_noise_resnet20_weight_pgd_40_iters_attack_accuracy_83-910.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=1 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' --attack_iters 40 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt


PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust_01 # + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar10_noise_resnet20_robust_01_pgd_40_iters_accuracy_84-250.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=2 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' --attack_iters 40 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt


PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=vanilla_resnet20 # + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar10_vanilla_resnet20_pgd_attack_40_iters_acc_83.960.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=3 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' --attack_iters 40 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_weight # + adv. training
dataset=svhn
epochs=160
batch_size=2500
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_pni_weight.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'cw' --attack_iters 200 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 33831
cc@p:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-10-19-20-35-574208044.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_weight # + adv. training
dataset=svhn
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_pni_weight.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' \
    --attack_iters 7 --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 46960
cc@icml:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-10-20-20-30-037227497.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust_01 # + adv. training
dataset=svhn
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_robust_net_01_adv_train.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=1 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' --attack_iters 7 --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[2] 46962
cc@icml:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-10-20-20-30-087671940.txt


PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=vanilla_resnet20 # + adv. training
dataset=svhn
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_adv_train.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=2 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' \
    --attack_iters 7 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[3] 47019
cc@icml:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-10-20-20-30-129162202.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust_02 # + adv. training
dataset=svhn
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_robust_net_02.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=3 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' --attack_iters 7 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[4] 47076
cc@icml:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-10-20-20-30-172769181.txt


PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust_014 # + adv. training
dataset=svhn
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval-no-adv-train-014-robust-net
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar10_noise_resnet20_roubst_net-014-no-adv-train-acc-83-50.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=1 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'cw' --attack_iters 200 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 92962
cc@p:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-10-22-25-51-041957431.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust # + adv. training
dataset=svhn
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval-no-adv-robust-net
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_noise_resnet20_robust_160_SGD_train_layerwise_3e-4decay-no-adv-train_robust_0-1_0-09-acc-94-299.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/svhn"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=2 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust_013 # + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval-no-adv-robust-net
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar10_noise_resnet20_robust_013_160_SGD_train_layerwise_3e-4decay-no-adv_roubst_net-acc-84-5.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/svhn"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=2 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust
# + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=3e-4decay_adv_eval-adv-train-014-010-robust-net
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar10_noise_resnet20_robust_3e-4decay-adv-train-0-14_0-10-40-iters-82.98-acc.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'cw' --attack_iters 200 \
    --init_noise 0.14 \
    --inner_noise 0.10 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 33624
cc@rtx:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-03-01-22-29-33-870390412.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust
# + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=3e-4decay_adv_eval-adv-train-014-010-robust-net
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar10_noise_resnet20_robust-3e-4decay-adv-train_0-14_0-10-acc-83.27-40-iters.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'cw' --attack_iters 200 \
    --init_noise 0.14 \
    --inner_noise 0.10 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 179500
cc@i-1:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-03-01-22-43-08-076774078.txt


PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=vanilla_resnet20
# + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=3e-4decay_adv_eval-adv-train-014-010-robust-net
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar10_vanilla_resnet20_3e-4decay-adv-train_only-acc-83-81.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=1 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'cw' --attack_iters 200 \
    --init_noise 0.0 \
    --inner_noise 0.0 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[2] 179672
cc@i-1:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-03-01-22-44-38-110830448.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust
# + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=3e-4decay_adv_eval-no-adv-train-014-010-robust-net
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar10_noise_resnet20_robust_3e-4decay-without-adv-train_0-14_0-10_0-acc-86-520.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=2 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'cw' --attack_iters 200 \
    --init_noise 0.14 \
    --inner_noise 0.10 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[3] 179926
cc@i-1:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-03-01-22-48-03-899735183.txt

cifar10_noise_resnet20_weight_pgd_40_iters_attack_accuracy_83-910.pth.tar

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_weight
# + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=3e-4decay_adv_eval-adv-train-weight
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar10_noise_resnet20_weight_pgd_40_iters_attack_accuracy_83-910.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'cw' --attack_iters 200 \
    --init_noise 0.0 \
    --inner_noise 0.0 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 185184
cc@i-1:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-03-02-00-42-30-175645079.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_weight
# + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=3e-4decay_adv_eval-adv-train-weight
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar10_noise_resnet20_weight_pgd_40_iters_attack_accuracy_83-910.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' --attack_iters 200 \
    --init_noise 0.0 \
    --inner_noise 0.0 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 31798
ady@skr-compute1:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-03-01-18-50-45-213803375.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust
# + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=3e-4decay_adv_eval-adv-train-014-010-robust-net-pgd
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar10_noise_resnet20_robust-3e-4decay-adv-train_0-14_0-10-acc-83.27-40-iters.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=1 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' --attack_iters 200 \
    --init_noise 0.14 \
    --inner_noise 0.10 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 185797
cc@i-1:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-03-02-00-56-02-840569491.txt


PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=vanilla_resnet20
# + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=3e-4decay_adv_eval-adv-train-014-010-robust-net-pgd
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar10_vanilla_resnet20_3e-4decay-adv-train_only-acc-83-81.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=2 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' --attack_iters 200 \
    --init_noise 0.0 \
    --inner_noise 0.0 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[2] 186325
cc@i-1:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-03-02-00-56-48-878324885.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust
# + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=3e-4decay_adv_eval-no-adv-train-014-010-robust-net-pgd
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar10_noise_resnet20_robust_3e-4decay-without-adv-train_0-14_0-10_0-acc-86-520.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=3 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' --attack_iters 200 \
    --init_noise 0.14 \
    --inner_noise 0.10 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[3] 186771
cc@i-1:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-03-02-00-57-14-514740446.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust
# + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=3e-4decay_adv_eval-no-adv-train-014-010-robust-net-pgd-perturb
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar10_noise_resnet20_robust_3e-4decay-without-adv-train_0-14_0-10_0-acc-86-520.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=3 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' --attack_iters 40 \
    --init_noise 0.14 \
    --inner_noise 0.10 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 190477
cc@i-1:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-03-02-02-14-44-880905835.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust
# + adv. training
dataset=svhn
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=3e-4decay_adv-train-008-007-robust-net-cw
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_noise_resnet20_robust_160_SGD_adv-train-0.08-0.07-acc-93-21.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'cw' --attack_iters 200 \
    --init_noise 0.08 \
    --inner_noise 0.07 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 31853
cc@rtx:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-03-06-01-59-37-533036526.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust
# + adv. training
dataset=svhn
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=3e-4decay_adv-train-000-000-robust-net-cw
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_noise_resnet20_robust_160_SGD_no-adv-train_robust-0.08-0.07-acc-94-65.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'cw' --attack_iters 200 \
    --init_noise 0.08 \
    --inner_noise 0.07 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 99758
cc@m-2:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-03-06-02-48-18-522949677.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust
# + adv. training
dataset=svhn
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=3e-4decay_adv-train-008-007-robust-net-pgd
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_noise_resnet20_robust_160_SGD_adv-train-0.08-0.07-acc-93-21.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=1 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' --attack_iters 200 \
    --init_noise 0.08 \
    --inner_noise 0.07 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[2] 99909
cc@m-2:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-03-06-02-49-42-414498876.txt

# pgd iters

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust
# + adv. training
dataset=svhn
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=3e-4decay_no_adv-train-000-000-robust-net-pgd
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_noise_resnet20_robust_160_SGD_no-adv-train_robust-0.08-0.07-acc-94-65.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' --attack_iters 200 \
    --init_noise 0.08 \
    --inner_noise 0.07 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 97780
cc@m:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-03-06-03-03-42-912748914.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust
# + adv. training
dataset=svhn
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=3e-4decay_adv-train-008-007-robust-net-pgd
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_noise_resnet20_robust_160_SGD_adv-train-0.08-0.07-acc-93-21.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=1 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' --attack_iters 200 \
    --init_noise 0.08 \
    --inner_noise 0.07 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[2] 97988
cc@m:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-03-06-03-04-00-676250511.txt

# pgd strengths
PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust
# + adv. training
dataset=svhn
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=3e-4decay_no_adv-train-000-000-robust-net-pgd
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_noise_resnet20_robust_160_SGD_no-adv-train_robust-0.08-0.07-acc-94-65.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' --attack_iters 40 \
    --init_noise 0.08 \
    --inner_noise 0.07 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 99367
cc@m-1:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-03-06-03-09-21-287110968.txt


PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust
# + adv. training
dataset=svhn
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=3e-4decay_adv-train-008-007-robust-net-pgd
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_noise_resnet20_robust_160_SGD_adv-train-0.08-0.07-acc-93-21.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=1 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' --attack_iters 40 \
    --init_noise 0.08 \
    --inner_noise 0.07 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[2] 99459
cc@m-1:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-03-06-03-09-50-384888291.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust
# + adv. training
dataset=svhn
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=3e-4decay_no_adv-train-000-000-robust-net-pgd
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_noise_resnet20_robust_160_SGD_no-adv-train_robust-0.08-0.07-acc-94-65.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' --attack_iters 40 \
    --init_noise 0.08 \
    --inner_noise 0.07 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 22946
cc@rtx:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-03-10-14-49-08-566801022.txt


PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust
# + adv. training
dataset=svhn
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=3e-4decay_adv-train-008-007-robust-net-pgd
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_noise_resnet20_robust_160_SGD_adv-train-0.08-0.07-acc-93-21.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/svhn"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' --attack_iters 40 \
    --init_noise 0.08 \
    --inner_noise 0.07 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 17379
ady@skr-compute1:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-03-10-09-50-45-538003213.txt
[1] 32520
cc@rtx:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-03-18-01-54-54-442153647.txt
[1] 29238
cc@rtx:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-03-18-16-47-58-891288973.txt


PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_weight # + adv. training
dataset=svhn
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_pni_weight.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/svhn"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' \
    --attack_iters 40 --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 9877
cc@rtx:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-03-19-02-00-17-266137172.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=vanilla_resnet20 # + adv. training
dataset=svhn
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_adv_train.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/svhn"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' \
    --attack_iters 40 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 11436
ady@skr-compute1:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-03-18-20-59-57-879357877.txt


PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=vanilla_resnet20 # + adv. training
dataset=svhn
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_vanilla_resnet20_160_SGD_train_layerwise_3e-4decay-7-iters-pgd-0.031-linf-acc-92.39.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/svhn"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval \
    --attack 'pgd' \
    --attack_iters 40 \
    --attack_strengths 0.0 0.005 0.01 0.015 0.02 0.022 0.025 \
    0.028 0.03 0.031 0.032 0.033 0.034 0.035 0.036 0.037 0.038 \
    0.039 0.04 0.05 0.1 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 99881
cc@i:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-03-19-15-34-22-049694952.txt
[2] 100773
cc@i:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-03-19-15-57-47-569137397.txt


PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_weight # + adv. training
dataset=svhn
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_noise_resnet20_weight_160_SGD_train_layerwise_3e-4decay-7-iters-pgd-0.031-linf-acc-92-95.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/svhn"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=1 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' \
    --attack_iters 40 \
    --attack_strengths 0.0 0.005 0.01 0.015 0.02 0.022 0.025 \
    0.028 0.03 0.031 0.032 0.033 0.034 0.035 0.036 0.037 0.038 \
    0.039 0.04 0.05 0.1 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[2] 100052
cc@i:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-03-19-15-35-49-875685754.txt
PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_weight # + adv. training
dataset=svhn
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_noise_resnet20_weight_160_SGD_train_layerwise_3e-4decay-7-iters-pgd-0.031-linf-acc-92-95.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/svhn"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=1 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' \
    --attack_iters 40 \
    --attack_strengths 0.0 0.005 0.01 0.015 0.02 0.022 0.025 \
    0.028 0.03 0.031 0.032 0.033 0.034 0.035 0.036 0.037 0.038 \
    0.039 0.04 0.05 0.1 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[3] 100918
cc@i:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-03-19-15-58-10-868245788.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust
# + adv. training
dataset=svhn
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=3e-4decay_adv-train-008-007-robust-net-pgd
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_noise_resnet20_robust_160_SGD_adv-train_robust-0.08-0.07-7-iters-pgd-0.031-linf-acc-92-37.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/svhn"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=2 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' \
    --attack_iters 40 \
    --init_noise 0.08 \
    --inner_noise 0.07 \
    --attack_strengths 0.0 0.005 0.01 0.015 0.02 0.022 0.025 \
    0.028 0.03 0.031 0.032 0.033 0.034 0.035 0.036 0.037 0.038 \
    0.039 0.04 0.05 0.1 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[3] 100221
cc@i:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-03-19-15-37-42-967035302.txt
[1] 100594
cc@i:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-03-19-15-56-40-230791467.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust
# + adv. training
dataset=svhn
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=3e-4decay_no_adv_train-008-007-robust-net-pgd
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_noise_resnet20_robust_160_SGD_no-adv-train_robust-0.08-0.07-7-iters-pgd-0.031-linf-94.24.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/svhn"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=3 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' \
    --attack_iters 40 \
    --init_noise 0.08 \
    --inner_noise 0.07 \
    --attack_strengths 0.0 0.005 0.01 0.015 0.02 0.022 0.025 \
    0.028 0.03 0.031 0.032 0.033 0.034 0.035 0.036 0.037 0.038 \
    0.039 0.04 0.05 0.1 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[4] 101446
cc@i:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-03-19-16-01-43-838586672.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=vanilla_resnet20 # + adv. training
dataset=svhn
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_vanilla_resnet20_160_SGD_train_layerwise_3e-4decay-7-iters-pgd-0.031-linf-acc-92.39.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/svhn"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval \
    --attack 'cw' \
    --attack_iters 200 \
    --attack_strengths 0 0.0001 0.0005 0.001 0.005 0.01 0.02 0.03 0.04 \
    0.05 0.07 0.1 0.2 0.3 0.4 0.5 1.0 2.0 10.0 100.0 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 80902
cc@j:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-03-19-16-13-14-455998828.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_weight # + adv. training
dataset=svhn
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_noise_resnet20_weight_160_SGD_train_layerwise_3e-4decay-7-iters-pgd-0.031-linf-acc-92-95.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/svhn"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=1 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval \
    --attack 'cw' \
    --attack_iters 200 \
    --attack_strengths 0 0.0001 0.0005 0.001 0.005 0.01 0.02 0.03 0.04 \
    0.05 0.07 0.1 0.2 0.3 0.4 0.5 1.0 2.0 10.0 100.0 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[2] 81104
cc@j:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-03-19-16-16-29-736683213.


PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust
# + adv. training
dataset=svhn
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=3e-4decay_adv-train-008-007-robust-net-pgd
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_noise_resnet20_robust_160_SGD_adv-train_robust-0.08-0.07-7-iters-pgd-0.031-linf-acc-92-37.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/svhn"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=2 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --init_noise 0.08 \
    --inner_noise 0.07 \
    --attack_eval \
    --attack 'cw' \
    --attack_iters 200 \
    --attack_strengths 0 0.0001 0.0005 0.001 0.005 0.01 0.02 0.03 0.04 \
    0.05 0.07 0.1 0.2 0.3 0.4 0.5 1.0 2.0 10.0 100.0 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[3] 81265
cc@j:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-03-19-16-17-05-105035285.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust
# + adv. training
dataset=svhn
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=3e-4decay_no_adv_train-008-007-robust-net-pgd
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_noise_resnet20_robust_160_SGD_no-adv-train_robust-0.08-0.07-7-iters-pgd-0.031-linf-94.24.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/svhn"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=3 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --init_noise 0.08 \
    --inner_noise 0.07 \
    --attack_eval \
    --attack 'cw' \
    --attack_iters 200 \
    --attack_strengths 0 0.0001 0.0005 0.001 0.005 0.01 0.02 0.03 0.04 \
    0.05 0.07 0.1 0.2 0.3 0.4 0.5 1.0 2.0 10.0 100.0 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[4] 81422
cc@j:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-03-19-16-18-20-342223140.txt


PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=vanilla_resnet20 # + adv. training
dataset=svhn
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_vanilla_resnet20_160_SGD_train_layerwise_3e-4decay-7-iters-pgd-0.031-linf-acc-92.39.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/svhn"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval \
    --attack 'pgd' \
    --attack_iters 0 1 4 7 10 20 40 100 1000 \
    --attack_strengths 0.031 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt



PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_weight # + adv. training
dataset=svhn
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_noise_resnet20_weight_160_SGD_train_layerwise_3e-4decay-7-iters-pgd-0.031-linf-acc-92-95.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/svhn"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=1 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval \
    --attack 'pgd' \
    --attack_iters 0 1 4 7 10 20 40 100 1000 \
    --attack_strengths 0.031 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust
# + adv. training
dataset=svhn
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=3e-4decay_adv-train-008-007-robust-net-pgd
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_noise_resnet20_robust_160_SGD_adv-train_robust-0.08-0.07-7-iters-pgd-0.031-linf-acc-92-37.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/svhn"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=2 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --init_noise 0.08 \
    --inner_noise 0.07 \
    --attack_eval \
    --attack 'pgd' \
    --attack_iters 0 1 4 7 10 20 40 100 1000 \
    --attack_strengths 0.031 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt


PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust
# + adv. training
dataset=svhn
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=3e-4decay_no_adv_train-008-007-robust-net-pgd
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_noise_resnet20_robust_160_SGD_no-adv-train_robust-0.08-0.07-7-iters-pgd-0.031-linf-94.24.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/svhn"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=3 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --init_noise 0.08 \
    --inner_noise 0.07 \
    --attack_eval \
    --attack 'pgd' \
    --attack_iters 0 1 4 7 10 20 40 100 1000 \
    --attack_strengths 0.031 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt


PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_weight
# + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=3e-4decay_adv_eval-adv-train-weight
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar10_noise_resnet20_weight_pgd_40_iters_attack_accuracy_83-910.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval \
    --attack 'pgd' \
    --attack_iters 200 \
    --init_noise 0.0 \
    --inner_noise 0.0 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt


PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust
# + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=3e-4decay_adv_eval-adv-train-014-010-robust-net-pgd
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar10_noise_resnet20_robust-3e-4decay-adv-train_0-14_0-10-acc-83.27-40-iters.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=1 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' --attack_iters 200 \
    --init_noise 0.14 \
    --inner_noise 0.10 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 185797
cc@i-1:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-03-02-00-56-02-840569491.txt


PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=vanilla_resnet20
# + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=3e-4decay_adv_eval-adv-train-014-010-robust-net-pgd
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar10_vanilla_resnet20_3e-4decay-adv-train_only-acc-83-81.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=2 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' --attack_iters 200 \
    --init_noise 0.0 \
    --inner_noise 0.0 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[2] 186325
cc@i-1:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-03-02-00-56-48-878324885.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust
# + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=3e-4decay_adv_eval-no-adv-train-014-010-robust-net-pgd-perturb
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar10_noise_resnet20_robust_3e-4decay-without-adv-train_0-14_0-10_0-acc-86-520.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=3 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval \
    --attack 'pgd' \
    --attack_iters 40 \
    --init_noise 0.14 \
    --inner_noise 0.10 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust_01 # + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/robust_net_01_adv_train.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 70334
cc@sat:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-06-05-37-20-303029304.txt


PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=vanilla_resnet20 # + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/adv_train.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 116933
cc@f:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-06-04-51-51-600222099.txt


PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_weight # + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/pni.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 117405
cc@p:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-02-06-05-39-44-382709938.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust_02 # + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/robust_net_0.2.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/cifar10"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=vanilla_resnet20 # + adv. training
dataset=svhn
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_vanilla_resnet20_160_SGD_train_layerwise_3e-4decay-7-iters-pgd-0.031-linf-acc-92.39.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/svhn"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval \
    --attack 'pgd' \
    --attack_iters 40 \
    --attack_strengths 0.0 0.005 0.01 0.015 0.02 0.022 0.025 \
    0.028 0.03 0.031 0.032 0.033 0.034 0.035 0.036 0.037 0.038 \
    0.039 0.04 0.05 0.1 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 99881
cc@i:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-03-19-15-34-22-049694952.txt
[2] 100773
cc@i:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-03-19-15-57-47-569137397.txt


PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=vanilla_resnet20 # + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/adv_train.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/${dataset}"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval \
    --attack 'pgd' \
    --attack_iters 40 \
    --attack_strengths 0.0 0.005 0.01 0.015 0.02 0.022 0.025 \
    0.028 0.03 0.031 0.032 0.033 0.034 0.035 0.036 0.037 0.038 \
    0.039 0.04 0.05 0.1 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[4] 116243
cc@i:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-03-20-00-23-48-560663019.txt


PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_weight # + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/pni.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/${dataset}"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=1 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' \
    --attack_iters 40 \
    --attack_strengths 0.0 0.005 0.01 0.015 0.02 0.022 0.025 \
    0.028 0.03 0.031 0.032 0.033 0.034 0.035 0.036 0.037 0.038 \
    0.039 0.04 0.05 0.1 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[3] 115652
cc@i:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-03-20-00-21-57-832066546.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust_01
# + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=3e-4decay_adv-train-01-01-robust-net-pgd
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/robust_net_01_adv_train.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/${dataset}"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=2 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' \
    --attack_iters 40 \
    --init_noise 0.1 \
    --inner_noise 0.1 \
    --attack_strengths 0.0 0.005 0.01 0.015 0.02 0.022 0.025 \
    0.028 0.03 0.031 0.032 0.033 0.034 0.035 0.036 0.037 0.038 \
    0.039 0.04 0.05 0.1 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[2] 114729
cc@i:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-03-20-00-17-09-105178897.txt


PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust_02
# + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=3e-4decay_no_adv_train-008-007-robust-net-pgd
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/robust_net_0.2.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/${dataset}"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=3 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' \
    --attack_iters 40 \
    --init_noise 0.08 \
    --inner_noise 0.07 \
    --attack_strengths 0.0 0.005 0.01 0.015 0.02 0.022 0.025 \
    0.028 0.03 0.031 0.032 0.033 0.034 0.035 0.036 0.037 0.038 \
    0.039 0.04 0.05 0.1 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 114373
cc@i:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-03-20-00-14-51-668868902.txt


PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=vanilla_resnet20 # + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/adv_train.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/${dataset}"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval \
    --attack 'pgd' \
    --attack_iters 0 1 4 7 10 20 40 100 1000 \
    --attack_strengths 0.031 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt



PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_weight # + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/pni.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/${dataset}"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=1 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' \
    --attack_iters 0 1 4 7 10 20 40 100 1000 \
    --attack_strengths 0.031 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt


PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust_01
# + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=3e-4decay_adv-train-01-01-robust-net-pgd
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/robust_net_01_adv_train.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/${dataset}"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=2 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' \
    --init_noise 0.1 \
    --inner_noise 0.1 \
    --attack_iters 0 1 4 7 10 20 40 100 1000 \
    --attack_strengths 0.031 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt



PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust_02
# + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=3e-4decay_no_adv_train-008-007-robust-net-pgd
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/robust_net_0.2.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/${dataset}"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=3 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' \
    --init_noise 0.08 \
    --inner_noise 0.07 \
    --attack_iters 0 1 4 7 10 20 40 100 1000 \
    --attack_strengths 0.031 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt


PYTHON="/home/${USER}/anaconda3/envs/abs/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust_02
# + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=no_adv_train-02-01-robust-net-pgd
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/robust_net_0.2.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/${dataset}"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} \
    --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} \
    --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval \
    --attack 'boundary' \
    --init_noise 0.2 \
    --inner_noise 0.1 \
    --attack_iters 25000 \
    --attack_strengths 0.0 0.005 0.01 0.015 0.02 0.022 0.025 0.028 0.03 \
    0.031 0.032 0.033 0.034 0.035 0.036 0.037 0.038 0.039 0.04 0.05 0.1 \
    0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 5.0 10.0 100.0 1000.0 \
    --epoch_delay 0 \
    --limit_batch_number 0 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust_01
# + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=3e-4decay_adv-train-01-01-robust-net-pgd
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/robust_net_01_adv_train.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/${dataset}"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=2 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' \
    --init_noise 0.1 \
    --inner_noise 0.1 \
    --attack_iters 0 1 4 7 10 20 40 100 1000 \
    --attack_strengths 0.031 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt


PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust_01
# + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=adv_train-01-01-robust-net-pgd
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/robust_net_01_adv_train.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/${dataset}"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} \
    --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} \
    --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval \
    --attack 'boundary' \
    --init_noise 0.2 \
    --inner_noise 0.1 \
    --attack_iters 1 100 1000 10000 25000 100000 \
    --attack_strengths 0.0 0.005 0.01 0.015 0.02 0.022 0.025 0.028 0.03 \
    0.031 0.032 0.033 0.034 0.035 0.036 0.037 0.038 0.039 0.04 0.05 0.1 \
    0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 \
    --epoch_delay 0 \
    --limit_batch_number 0 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 94420
cc@icml:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-04-01-19-06-38-561124317.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=vanilla_resnet20 # + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/adv_train.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/${dataset}"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval \
    --attack 'pgd' \
    --attack_iters 0 1 4 7 10 20 40 100 1000 \
    --attack_strengths 0.031 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt


PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=vanilla_resnet20
# + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=adv_train-01-01-robust-net-pgd
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/adv_train.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/${dataset}"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=3 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} \
    --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} \
    --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval \
    --attack 'boundary' \
    --init_noise 0.0 \
    --inner_noise 0.0 \
    --attack_iters 1 100 1000 10000 25000 100000 \
    --attack_strengths 0.0 0.005 0.01 0.015 0.02 0.022 0.025 0.028 0.03 \
    0.031 0.032 0.033 0.034 0.035 0.036 0.037 0.038 0.039 0.04 0.05 0.1 \
    0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 \
    1.9 2.0 5.0 10.0 100.0 1000.0 \
    --epoch_delay 0 \
    --limit_batch_number 0 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt


PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_weight # + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/pni.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/${dataset}"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=1 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' \
    --attack_iters 0 1 4 7 10 20 40 100 1000 \
    --attack_strengths 0.031 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt


PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_weight
# + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=adv_train_weight
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/pni.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/${dataset}"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=2 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} \
    --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} \
    --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval \
    --attack 'boundary' \
    --init_noise 0.0 \
    --inner_noise 0.0 \
    --attack_iters 1 100 1000 10000 25000 100000 \
    --attack_strengths 0.0 0.005 0.01 0.015 0.02 0.022 0.025 0.028 0.03 \
    0.031 0.032 0.033 0.034 0.035 0.036 0.037 0.038 0.039 0.04 0.05 0.1 \
    0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 \
    1.9 2.0 5.0 10.0 100.0 1000.0 \
    --epoch_delay 0 \
    --limit_batch_number 0 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[2] 98888
cc@icml:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-04-01-21-32-42-589471223.txt


PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=vanilla_resnet20
# + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=adv_train_weight
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar10_vanilla_resnet20_160_SGD_no_adv_train_vanilla_pure_acc_88_00.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/${dataset}"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=1 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} \
    --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} \
    --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval \
    --attack 'boundary' \
    --init_noise 0.0 \
    --inner_noise 0.0 \
    --attack_iters 1 100 1000 10000 25000 100000 \
    --attack_strengths 0.0 0.005 0.01 0.015 0.02 0.022 0.025 0.028 0.03 \
    0.031 0.032 0.033 0.034 0.035 0.036 0.037 0.038 0.039 0.04 0.05 0.1 \
    0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 \
    1.9 2.0 5.0 10.0 100.0 1000.0 \
    --epoch_delay 0 \
    --limit_batch_number 0 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[3] 99038
cc@icml:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-04-01-21-36-30-611064977.txt

PYTHON="/home/${USER}/anaconda3/envs/abs/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust_02
# + adv. training
dataset=cifar10
num_classes=10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=no_adv_train-02-01-robust-net-pgd
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/robust_net_0.2.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/${dataset}"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} \
    --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} \
    --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval \
    --attack 'boundary' \
    --init_noise 0.2 \
    --inner_noise 0.1 \
    --attack_iters 1 100 1000 10000 100000 \
    --attack_strengths 0.0 0.005 0.01 0.015 0.02 0.022 0.025 0.028 0.03 \
    0.031 0.032 0.033 0.034 0.035 0.036 0.037 0.038 0.039 0.04 0.05 0.1 \
    0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 5.0 10.0 100.0 1000.0 \
    --epoch_delay 0 \
    --limit_batch_number 0 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 21394
(abs) ady@skr-compute1:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-04-01-21-41-19-811355024.txt



PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=noise_resnet20_robust_02
# + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=no_adv_train-02-01-robust-net-pgd
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/robust_net_0.2.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/${dataset}"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} \
    --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} \
    --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval \
    --attack 'boundary' \
    --init_noise 0.2 \
    --inner_noise 0.1 \
    --attack_iters 25000 \
    --attack_strengths 0.0 0.005 0.01 0.015 0.02 0.022 0.025 0.028 0.03 \
    0.031 0.032 0.033 0.034 0.035 0.036 0.037 0.038 0.039 0.04 0.05 0.1 \
    0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 5.0 10.0 100.0 1000.0 \
    --epoch_delay 0 \
    --limit_batch_number 0 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[2] 135091
(base) cc@icml:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-04-03-21-48-44-859279002.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=vanilla_resnet20
# + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=3e-4decay_no_adv_train_pure_net
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar10_vanilla_resnet20_160_SGD_no_adv_train_vanilla_pure_acc_88_00.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/${dataset}"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=2 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval \
    --attack 'pgd' \
    --attack_iters 40 \
    --init_noise 0.0 \
    --inner_noise 0.0 \
    --attack_strengths 0.0 0.005 0.01 0.015 0.02 0.022 0.025 \
    0.028 0.03 0.031 0.032 0.033 0.034 0.035 0.036 0.037 0.038 \
    0.039 0.04 0.05 0.1 \
    --limit_batch_number 0 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[4] 138294
(base) cc@icml:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-04-04-01-50-30-113750780.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=vanilla_resnet20 # + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar10_vanilla_resnet20_160_SGD_no_adv_train_vanilla_pure_acc_88_00.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/${dataset}"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' \
    --attack_iters 0 1 4 7 10 20 40 100 1000 \
    --attack_strengths 0.031 \
    --epoch_delay 5 \
    --limit_batch_number 0 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[2] 137903
(base) cc@icml:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-04-04-01-46-28-941560255.txt

PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=vanilla_resnet20
# + adv. training
dataset=cifar10
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=3e-4decay_no_adv_train_pure_net
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/cifar10_vanilla_resnet20_160_SGD_no_adv_train_vanilla_pure_acc_88_00.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/${dataset}"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=3 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --init_noise 0.0 \
    --inner_noise 0.0 \
    --attack_eval \
    --attack 'cw' \
    --attack_iters 200 \
    --attack_strengths 0 0.0001 0.0005 0.001 0.005 0.01 0.02 0.03 0.04 \
    0.05 0.07 0.1 0.2 0.3 0.4 0.5 1.0 2.0 10.0 100.0 \
    --epoch_delay 5 \
    --limit_batch_number 0 \
    >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[3] 138174
(base) cc@icml:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-04-04-01-49-43-730749382.txt

PYTHON="/home/${USER}/anaconda3/envs/abs/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=vanilla_resnet20
dataset=svhn
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=3e-4decay_no_adv_train_pure_net
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_plain.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/${dataset}"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --init_noise 0.0 \
    --inner_noise 0.0 \
    --attack_eval \
    --attack 'cw' \
    --attack_iters 200 \
    --attack_strengths 0 0.0001 0.0005 0.001 0.005 0.01 0.02 0.03 0.04 \
    0.05 0.07 0.1 0.2 0.3 0.4 0.5 1.0 2.0 10.0 100.0 \
    --epoch_delay 5 \
    --limit_batch_number 0 \
    >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[1] 23880
(abs) ady@skr-compute1:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-04-03-21-01-21-352312259.txt


PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=vanilla_resnet20
# + adv. training
dataset=svhn
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=3e-4decay_no_adv_train_pure_net
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_plain.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/${dataset}"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=2 PYTHONPATH=../../../../../ nohup $PYTHON main.py \
    --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval \
    --attack 'pgd' \
    --attack_iters 40 \
    --init_noise 0.0 \
    --inner_noise 0.0 \
    --attack_strengths 0.0 0.005 0.01 0.015 0.02 0.022 0.025 \
    0.028 0.03 0.031 0.032 0.033 0.034 0.035 0.036 0.037 0.038 \
    0.039 0.04 0.05 0.1 \
    --limit_batch_number 0 \
    --epoch_delay 5 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[3] 139916
(base) cc@icml:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-04-04-03-07-22-766531349.txt


PYTHON="/home/${USER}/anaconda3/bin/python" # python environment
enable_tb_display=false # enable tensorboard display
model=vanilla_resnet20 # + adv. training
dataset=svhn
epochs=160
batch_size=2560
optimizer=SGD
# add more labels as additional info into the saving path
label_info=train_layerwise_3e-4decay_adv_eval
pretrained_model="/home/${USER}/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code/save/svhn_plain.pth.tar"
#dataset path
data_path="/home/${USER}/data/pytorch/${dataset}"
timestamp=$(date +%Y-%m-%d-%H-%M-%S-%N)
CUDA_VISIBLE_DEVICES=0 PYTHONPATH=../../../../../ nohup $PYTHON main.py --dataset ${dataset} \
    --data_path ${data_path}   \
    --arch ${model} --save_path ./save/${DATE}/${dataset}_${model}_${epochs}_${optimizer}_${label_info} \
    --epochs ${epochs} --learning_rate 0.1 \
    --optimizer ${optimizer} \
	--schedule 80 120  --gammas 0.1 0.1 \
    --batch_size ${batch_size} --workers 4 --ngpu 1 --gpu_id 0 \
    --print_freq 100 --decay 0.0003 --momentum 0.9 \
    --resume ${pretrained_model} \
    --attack_eval --attack 'pgd' \
    --attack_iters 0 1 4 7 10 20 40 100 1000 \
    --attack_strengths 0.031 \
    --epoch_delay 5 \
    --limit_batch_number 0 >> test_${timestamp}.txt 2>&1 &
echo test_${timestamp}.txt
[2] 139765
(base) cc@icml:~/code/bandlimited-cnns/cnns/nnlib/robustness/pni/code$ echo test_${timestamp}.txt
test_2020-04-04-03-06-20-362063058.txt