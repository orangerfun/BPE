import logging

LOG_FORMAT = "%(asctime)s-%(levelname)s-%(message)s"
logging.basicConfig(filename="nohup.out", level=logging.DEBUG, format=LOG_FORMAT)
# path = "/media/tmx/nmt_data_preprocess/raw.data.segment"
# ends = ["1.seg","2.seg","3.seg","4.seg","5.seg","6.seg","7.seg","8.seg","9.seg"]
# pres = ["sub_train.en0", "sub_train.zh0"]
path = "./"
ends=[".txt", ".file"]
pres=["1", "2"]
logging.info("start compute num of words")
for pre in pres:
    all_words = []
    for end in ends:
        filename = path+pre+end
        with open(filename, "r", encoding="utf-8") as f:
            all_words.extend(set(f.read().split()))
            all_words = list(set(all_words))
    num_words = len(all_words)
    logging.info("%s : %d", pre, num_words)


