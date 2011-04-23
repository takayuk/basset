#!/home/takayuk/local/bin/python
# encoding: utf-8
# coding: utf-8


def to_words(sentence, target_feature):

    import MeCab
    import os

    dicdir = os.path.expanduser("~/local/lib/mecab/dic/ipadic-utf8")
    tagger = MeCab.Tagger("-Ochasen -x 未知語 -d %s" % dicdir)

    print(sentence)
    token = tagger.parse(sentence)
    print(token)
    return
    
    parsed = [node for node in [line.split("\t") for line in token.split("\n")]]

    #words = {}
    words = [""]
    for node in parsed:
        try:
            surface = node[0]
            feature = node[3]

            for target in target_feature:
                if feature.find(target) >= 0:
                    words[-1] += surface
                    break
                elif not len(words[-1]) is 0:
                    words.append("")
        except IndexError:
            pass

    return words

def bag_ofwords(sentence, target_features):

    parsed_words = to_words(sentence, target_features)

    """
    with open("engadget.url", "w") as file_stream:
        file_stream.write(str(len(parsed_words)) + "\n")
        file_stream.write("\n".join(parsed_words))
    """

import sys
args = sys.argv

bag_ofwords("バルブなどの人工物を喉頭がわりとする方法もあるのですが、取り替えなければいけないのが問題です。", ["名詞", "未知語"])
bag_ofwords(u"そこでハル大学のJim Gilbert博士や、シェフィールド大学の Phil Green 教授ら英国の研究者たちが挑戦しているのが、口内に磁石を取り付けるという、なかなかサイバーな方法。磁石で口内に磁場を作り出し、ヘッドセットに備えつけたセンサで舌や唇の動きを検出、それらの動きから「発声」を認識します。", ["名詞", "未知語"])

