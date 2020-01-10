#!/usr/bin/env bash
# use separate bpe rather than joint bpe

BASE_DIR="/home/tmx/rd/org/BPE_seg"
export PYTHONPATH="$BASE_DIR/subword_nmt:$PYTHONPATH"
DATA_DIR=/media/tmx/nmt_data_preprocess
CODE_DIR=$BASE_DIR/subword_nmt
SEPARATOR="_"

cd $CODE_DIR

echo "apply bpe on train(en) data..."
python $CODE_DIR/learn_bpe.py -s 9300000 \
                              -i $DATA_DIR/raw.data.segment/train.en.seg \
                              -o $DATA_DIR/bpe_segment/bpe930w.en

python $CODE_DIR/apply_bpe.py -c $DATA_DIR/bpe_segment/bpe930w.en \
                              -s $SEPARATOR \
                              < $DATA_DIR/raw.data.segment/train.en.seg \
                              > $DATA_DIR/bpe_segment/train_corpus.bpe.en

echo "apply bpe on train(zh) data..."
python $CODE_DIR/learn_bpe.py -s 2600000 \
                              -i $DATA_DIR/raw.data.segment/train.zh.seg \
                              -o $DATA_DIR/bpe_segment/bpe260w.zh

python $CODE_DIR/apply_bpe.py -c $DATA_DIR/bpe_segment/bpe260w.zh \
                              -s $SEPARATOR \
                              < $DATA_DIR/raw.data.segment/train.zh.seg \
                              > $DATA_DIR/bpe_segment/train_corpus.bpe.zh

echo "apply bpe on test data..."
python $CODE_DIR/apply_bpe.py -c $DATA_DIR/bpe_segment/bpe260w.zh \
                              -s $SEPARATOR \
                              < $DATA_DIR/raw.data.segment/test.zh.seg \
                              > $DATA_DIR/bpe_segment/test_corpus.bpe.zh

python $CODE_DIR/apply_bpe.py -c $DATA_DIR/bpe_segment/bpe930w.en \
                              -s $SEPARATOR \
                              < $DATA_DIR/raw.data.segment/test.en.seg \
                              > $DATA_DIR/bpe_segment/test_corpus.bpe.en

echo "apply bpe on valid data..."
python $CODE_DIR/apply_bpe.py -c $DATA_DIR/bpe_segment/bpe260w.zh \
                              -s $SEPARATOR \
                              < $DATA_DIR/raw.data.segment/valid.zh.seg \
                              > $DATA_DIR/bpe_segment/valid_corpus.bpe.zh

python $CODE_DIR/apply_bpe.py -c $DATA_DIR/bpe_segment/bpe930w.en \
                              -s $SEPARATOR \
                              < $DATA_DIR/raw.data.segment/valid.en.seg \
                              > $DATA_DIR/bpe_segment/valid_corpus.bpe.en

echo "getting vocab..."
python $CODE_DIR/get_vocab_org.py -i $DATA_DIR/bpe_segment/train_corpus.bpe.zh -o $DATA_DIR/bpe_segment/vocab.bpe.zh.260W
python $CODE_DIR/get_vocab_org.py -i $DATA_DIR/bpe_segment/train_corpus.bpe.en -o $DATA_DIR/bpe_segment/vocab.bpe.en.930W

echo "all finished..."