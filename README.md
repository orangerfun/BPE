# 1.背景
机器翻译处理的词汇表是定长的，但是实际翻译却是OOV(out of vocabulary)的。以前是把新词汇加到词典里去。而BPE是一种使用subword单元的策略，会把未登录词或罕见词以subword units序列来进行编码，更简单更有效
# 2.BPE使用
### 2.1 单独BPE
目标语言和源语言分别使用BPE去计算词典。从文本和词汇表大小来说更加紧凑，能保证每个subword单元在各自的训练数据上都有。同样的名字在不同的语言中可能切割的不一样，神经网络很难去学习subword units之间的映射

    ./subword_nmt/learn_bpe.py -s num_operations < train_file > codes_file
    ./subword_nmt/apply_bpe.py -c codes_file < test_file > out_file
    args:
      num_operations:超参数，迭代次数
      train_file: 要分词的文件,即要处理的原文件
      codes_file: BPE编码的输出文件
### 2.2 joint BPE
目标语言和原语言一起使用BPE，即联合两种语言的词典去做BPE。提高了源语言和目标语言的分割一致性。训练中一般concat两种语言
