#!/home/takayuk/local/bin/python
# encoding: utf-8
# coding: utf-8


import sys
sys.path.append("/home/takayuk/workspace/github/basset/lib/")



def test_snapshot(url):
   
    import snapshot as ss
    import bag_ofwords as bow
    import corpus as cs
    
    import re
    html_tag = re.compile(r"<.*?>")
    stopwords = re.compile("[!-/:-@\[-`{-~]|nbsp|amp|[0-9]")
    
    snapshot = ss.snapshot(url)

    corpus = cs.Corpus()
    
    for docid, doc in snapshot:
        raw_desc = html_tag.sub("", doc[1])
        desc_bow = bow.to_bagofwords("\"%s\"" % raw_desc, ["名詞", "未知語"])

        try:
            del(desc_bow[desc_bow.index("Permalink"):])
        except ValueError:
            pass

        doc_words = [w for w in desc_bow if not stopwords.search(w)]

        corpus.append(doc_words, docid)

    corpus.to_url("engadget.url")
    corpus.to_labellist("engadget.lbl")

if __name__ == "__main__":
    
    import sys
    args = sys.argv

    test_snapshot(args[1])

