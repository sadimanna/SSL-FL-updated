#!/bin/bash

MODEL_NAME='beit'

cd /home/yan/SSL-FL/${MODEL_NAME}/

DATASET='Retina'
SPLIT_TYPE='split_1'
N_CLASSES=2
DATA_PATH="/data/yan/SSL-FL/${DATASET}/"
N_CLIENTS=5
N_GPUS=3

# ------------------ finetune ----------------- #
FT_EPOCHS=1000
FT_LR='3e-3'
FT_BATCH_SIZE=64

OUTPUT_PATH_FT="/data/yan/SSL-FL/fedavg_${MODEL_NAME}_ckpt_${N_CLIENTS}/random_init_${MODEL_NAME}_base/finetune_${DATASET}_epoch${FT_EPOCHS}_${SPLIT_TYPE}_lr${FT_LR}_bs${FT_BATCH_SIZE}_dis${N_GPUS}"

CUDA_VISIBLE_DEVICES=0,1,2,3 OMP_NUM_THREADS=1 python -m torch.distributed.launch --nproc_per_node=${N_GPUS} run_class_finetune_FedAvg.py \
     --data_path ${DATA_PATH} \
     --data_set ${DATASET} \
     --model_name ${MODEL_NAME} \
     --nb_classes ${N_CLASSES} \
     --output_dir ${OUTPUT_PATH_FT} \
     --lr ${FT_LR} \
     --save_ckpt_freq 50 \
     --model beit_base_patch16_224 \
     --batch_size ${FT_BATCH_SIZE} --update_freq 1 --split_type ${SPLIT_TYPE} \
     --warmup_epochs 5 --layer_decay 0.65 --drop_path 0.2 \
     --weight_decay 0.05 --layer_scale_init_value 0.1 --clip_grad 3.0 \
     --n_clients ${N_CLIENTS} --E_epoch 1 --max_communication_rounds ${FT_EPOCHS} --num_local_clients -1 

