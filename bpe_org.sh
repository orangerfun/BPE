#!/usr/bin/env bash

BASE_DIR="/home/rd/oranger/subword_nmt/subword_nmt"
export PYTHONPATH="$BASE_DIR:$PYTHONPATH"
DATA_DIR=$BASE_DIR/data

python learn_joint_bpe_and_vocab.py --input data/data.en data/data.zh \
                                    -s 32000 \
                                    -o bpe32k \
                                    --write-vocabulary data/vocab.en data/vocab.zh
                                    --separator _

python subword-nmt/apply_bpe.py --vocabulary data/vocab.en \
                                --vocabulary-threshold 50 \
                                -c bpe32k < data/train.en > data/corpus.32k.en
                                -s _

python subword-nmt/apply_bpe.py --vocabulary data/vocab.zh \
                                --vocabulary-threshold 50 \
                                -s _
                                -c bpe32k < data/train.zh > corpus.32k.zh