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
目标语言和原语言一起使用BPE，即联合两种语言的词典去做BPE。提高了源语言和目标语言的分割一致性。训练中一般concat两种语言<br>
~joint BPE也有一些问题：因为joint BPE会联合两种语言一起做分词，那么有些单词只会在另一种语言中被观察到才会被分开，但是在训练时我们是看不到另一种语言文本的；因此为了防止这样的事情发生，我们在应用`apply_bpe.py`时设置`--vocabulary`和`--vocabulary-threshold`两个参数，这样脚本将会产生出现在词表中的symbols~（英文不好，无法确定翻译的是否准确-_-)<br>

**STEP1.在中英联合训练样本上训练BPE,然后分别获取中文、英文词表**<br>

    cat train_file.L1 train_file.L2 | subword-nmt/learn_bpe.py -s num_operations -o codes_file
    subword-nmt/apply_bpe.py -c codes_file < train_file.L1 | subword-nmt/get_vocab.py > vocab_file.L1
    subword-nmt/apply_bpe.py -c codes_file < train_file.L2 | subword-nmt/get_vocab > vocab_file.L2
    
    args:
          -s : 同上，迭代次数
          -o : BPE编码输出文件，文件里面是 subword pair ,不是词表
          train_file.L1,train_file.L2分别表示两种语言的样本文件，是平行语料，cat命令将两者拼接在一起
          < 表示输入重定向，即将train_file.L1 作为输入传进apply_bpe.py
          > 表示输出重定向，将get_vocab.py的输出写入vocab_file.L1文件中

**上面三行代码可以简洁的写成如下格式：**

    subword-nmt/learn_joint_bpe_and_vocab.py --input train_file.L1 train_file.L2 -s num_operations -o codes_file --write-vocabulary vocab_file.L1 vocab_file.L2

**STEP2. 带词过滤的应用BPE**

    subword-nmt/apply_bpe.py -c codes_file --vocabulary vocab_file.L1 --vocabulary-threshold 50 < train_file.L1 > train_file.BPE.L1
    subword_nmt/apply_bpe.py -c codes_file --vocabulary vocab_file.L2 --vocabulary-threshold 50 < train_file.L2 > train_file.BPE.L2
    
    note:
        在这两行命令行中重定向输出文件train_file.BPE.L1和train_file.BPE.L2分别是使用BPE分好词的语料，可以应用于NLP任务当中

**STEP3.对于测试集和验证集使用相同的方法**

    subword-nmt/apply_bpe.py -c codes_file --vocabulary vocab_file.L1 --vocabulary-threshold 50 < test_file.L1 > test_file.BPE.L1

# 3.BPE原理
* 将每个单词表示为字符序列，加上一个特殊的单词末尾符号“</w>”（结束符号用来还原翻译的结果）
* 统计相邻的两个字符出现频率，并将频率最高的相邻字符合并
* 最终的符号词汇量大小等于初始词汇量的大小，加上合并操作的数量——合并操作是算法的唯一超参数

# 4. 程序说明
* `bpe_segment_org2.0.sh`使用joint方式进行BPE分词
* `bpe_org.sh`使用joint方式进行BPE分词
* `bpe_segment_sep.sh`对中英文分别进行BPE分词，非joint方式
* `bpe_segment_all.sh`是`bpe_segment_sep.sh`改进版，几乎一样
* `get_vocab_org.py`获取词汇表，方便后面机器翻译的使用
* `cal_word`计算原始语料中词表大小

# 注意事项
* 上面代码使用的命令行格式，使用前先去[githup](https://github.com/rsennrich/subword-nmt)下载源码，也可以直接使用`pip install subword-nmt`安装相应包后调用，详见githup
* 在对中文使用BPE前，需要先对中文语料分词（Hanlp, jieba等）
* 超参数迭代次数`num_operation`的设置：一般设置略小于词汇表大小，比如说词汇表大小是36000，这个参数可以设置成32000
* 两种语言放一起训练（joint方式）的前提是他们属于同一个语系比如说英文和德文，都属于阿拉伯语系， 但是中文和英文不属于同一个语系，所以要分开

# 6. 参考
* [BPE源码](https://github.com/rsennrich/subword-nmt)
* [BPE论文](https://arxiv.org/abs/1508.07909)

        
    
          
