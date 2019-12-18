#!/usr/bin/env bash

BASE_DIR="/home/rd/oranger/BPE_seg"
export PYTHONPATH="$BASE_DIR/subword_nmt:$PYTHONPATH"
DATA_DIR=$BASE_DIR/raw_data
CODE_DIR=$BASE_DIR/subword_nmt
SEPARATOR="_"

cd $CODE_DIR

# Learn byte pair encoding on the concatenation of the training text, and get resulting vocabulary for each
cat $DATA_DIR/train.en.seg $DATA_DIR/train.zh.seg | python $CODE_DIR/learn_bpe.py -s 45000 -o $DATA_DIR/bpe45k
python $CODE_DIR/apply_bpe.py -c $DATA_DIR/bpe45k < $DATA_DIR/train.en.seg | python $CODE_DIR/get_vocab.py > $DATA_DIR/vocab.bpe.en
python $CODE_DIR/apply_bpe.py -c $DATA_DIR/bpe45k < $DATA_DIR/train.zh.seg | python $CODE_DIR/get_vocab.py > $DATA_DIR/vocab.bpe.zh


# re-apply byte pair encoding with vocabulary filter for train data
python $CODE_DIR/apply_bpe.py -c $DATA_DIR/bpe45k \
                              --vocabulary $DATA_DIR/vocab.bpe.en \
                              --vocabulary-threshold 3 \
                              -i $DATA_DIR/train.en.seg \
                              -o $DATA_DIR/corpus.train.en \
                              -s $SEPARATOR

python $CODE_DIR/apply_bpe.py -c $DATA_DIR/bpe45k \
                              --vocabulary $DATA_DIR/vocab.bpe.zh \
                              --vocabulary-threshold 3 \
                              -i $DATA_DIR/train.zh.seg \
                              -o $DATA_DIR/corpus.train.zh \
                              -s $SEPARATOR

# 构建词汇表用于tensor2tensor/datagen
python get_vocab_org.py -i $DATA_DIR/corpus.train.zh -o $DATA_DIR/vocab.bpe.zh.45000
python get_vocab_org.py -i $DATA_DIR/corpus.train.en -o $DATA_DIR/vocab.bpe.en.45000


# for valid data
python $CODE_DIR/apply_bpe.py -c $DATA_DIR/bpe45k \
                              --vocabulary $DATA_DIR/vocab.bpe.en \
                              --vocabulary-threshold 3 \
                              -i $DATA_DIR/valid.en.seg \
                              -o $DATA_DIR/corpus.valid.en \
                              -s $SEPARATOR

python $CODE_DIR/apply_bpe.py -c $DATA_DIR/bpe45k \
                              --vocabulary $DATA_DIR/vocab.bpe.zh \
                              --vocabulary-threshold 3 \
                              -i $DATA_DIR/valid.zh.seg \
                              -o $DATA_DIR/corpus.valid.zh \
                              -s $SEPARATOR

# for test data
python $CODE_DIR/apply_bpe.py -c $DATA_DIR/bpe45k \
                              --vocabulary $DATA_DIR/vocab.bpe.en \
                              --vocabulary-threshold 3 \
                              -i $DATA_DIR/test.en.seg \
                              -o $DATA_DIR/corpus.test.en \
                              -s $SEPARATOR

python $CODE_DIR/apply_bpe.py -c $DATA_DIR/bpe45k \
                              --vocabulary $DATA_DIR/vocab.bpe.zh \
                              --vocabulary-threshold 3 \
                              -i $DATA_DIR/test.zh.seg \
                              -o $DATA_DIR/corpus.test.zh \
                              -s $SEPARATOR
