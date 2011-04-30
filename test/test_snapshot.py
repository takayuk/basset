#!/home/takayuk/local/bin/python
# encoding: utf-8
# coding: utf-8

class Wordlist(object):

    def __init__(self):
        self.wordlist = {}
        self.__wordid = 1

    def __iter__(self):
        for word, info in self.wordlist.items():
            yield (word, info)

    def keys(self):
        return self.wordlist.keys()

    def append(self, word):
        if word in self.wordlist:
            self.wordlist[word][1] += 1
        else:
            self.wordlist.setdefault(word, [self.__wordid, 1])
            self.__wordid += 1

    def info(self, word):
        try:
            return self.wordlist[word]
        except KeyError:
            return None

class Corpus(object):
    
    def __init__(self):
       
        self.indexed_table = []

        self.wordlist = Wordlist()

    def to_url(self, path):
        
        with file(path, "w") as urllist:
            for word in self.wordlist.keys():
                urllist.write("%s\n" % word) 
    
    def to_labellist(self, path):

        with file(path, "w") as lbllist:
            for table in self.indexed_table:
                for node in table:
                    #lbllist.write(" %s:%s" % self.wordlist.index(node))
                    word = self.wordlist.info(node)
                    lbllist.write(" %s:%s" % (word[0], word[1]))
                lbllist.write("\n")

    def append(self, doc):

        wordfreq = {}
        for w in doc:
            if w in wordfreq:
                wordfreq[w] += 1
            else:
                wordfreq.setdefault(w, 1)

            if not w in self.wordlist:
                self.wordlist.append(w)
        
        self.indexed_table.append([])
        for word, freq in wordfreq.items():
            self.indexed_table[-1].append((word, freq))


def test_snapshot(url):
   
    import sys
    sys.path.append("/home/takayuk/workspace/github/basset/lib/")

    import snapshot as ss
    import bag_ofwords as bow

    import re
    html_tag = re.compile(r"<.*?>")
    stopwords = re.compile("[!-/:-@\[-`{-~]|nbsp|amp|[0-9]")
    
    snapshot = ss.snapshot(url)

    corpus = Corpus()
    
    for doc in snapshot:
        raw_desc = html_tag.sub("", doc[1])
        desc_bow = bow.to_bagofwords("\"%s\"" % raw_desc, ["名詞", "未知語"])

        try:
            del(desc_bow[desc_bow.index("Permalink"):])
        except ValueError:
            pass

        doc_words = [w for w in desc_bow if not stopwords.search(w)]

        corpus.append(doc_words)

    corpus.to_url("engadget.url")
    corpus.to_labellist("engadget.lbl")

if __name__ == "__main__":
    
    import sys
    args = sys.argv

    test_snapshot(args[1])

