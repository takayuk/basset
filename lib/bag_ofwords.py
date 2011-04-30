# -*- encoding: utf-8 -*-
# -*- coding: utf-8 -*-


def to_bagofwords(sentence, target_feature):

    import subprocess
    import re
    import os
    
    do_mecab_dir = os.path.abspath(os.path.dirname(__file__))
    cmdline = "%s/do_mecab %s" % (do_mecab_dir, sentence)
    cwd = "."

    subproc = subprocess.Popen(cmdline, shell = True, cwd = cwd,
            stdin=subprocess.PIPE, stdout = subprocess.PIPE, stderr = subprocess.STDOUT,
            close_fds = True)

    (stdouterr, stdin) = (subproc.stdout, subproc.stdin)

    words = [""]
    
    while True:
        line = stdouterr.readline()
        if not line: break

        node = line.decode("utf-8").split("\t")
        for target in target_feature:
            try:
                (surface, feature) = (node[0], node[1])
                if feature.find(target) >= 0:
                    words[-1] += surface
                    break
                elif not len(words[-1]) is 0:
                    words.append("")
            except IndexError:
                pass
    
    stopwords = re.compile("[ぁ-ん]")
    return [word for word in words if not stopwords.match(word)]

if __name__ == "__main__":
    import sys
    args = sys.argv

    b = to_bagofwords("今日も晴れました。", ["名詞"])
    for w in b:
        print(w)
