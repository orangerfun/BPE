#!/usr/bin/env bash

BASE_DIR="/home/tmx/rd/org/BPE_seg"
export PYTHONPATH="$BASE_DIR/subword_nmt:$PYTHONPATH"
DATA_DIR=/home/tmx/rd/test
CODE_DIR=$BASE_DIR/subword_nmt
SEPARATOR="_"

cd $CODE_DIR
python $CODE_DIR/learn_bpe.py -s 15000 -i $DATA_DIR/org.data.segment/train.en.seg -o $DATA_DIR/BPE/bpe15k.en
python $CODE_DIR/apply_bpe.py -c $DATA_DIR/BPE/bpe15k.en -s $SEPARATOR < $DATA_DIR/org.data.segment/train.en.seg > $DATA_DIR/BPE/corpus.bpe.en

python $CODE_DIR/learn_bpe.py -s 15000 -i $DATA_DIR/org.data.segment/train.zh.seg -o $DATA_DIR/BPE/bpe15k.zh
python $CODE_DIR/apply_bpe.py -c $DATA_DIR/BPE/bpe15k.zh -s $SEPARATOR < $DATA_DIR/org.data.segment/train.zh.seg > $DATA_DIR/BPE/corpus.bpe.zh