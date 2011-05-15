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
        raw_desc = html_tag.sub("", doc)
        desc_bow = bow.to_bagofwords("\"%s\"" % raw_desc, ["名詞", "未知語"])

        try:
            del(desc_bow[desc_bow.index("Permalink"):])
        except ValueError as e:
            print(e.message)

        doc_words = [w for w in desc_bow if not stopwords.search(w)]

        corpus.append(doc_words, docid)

    cowords = {}
    docs = corpus.docs()

    for link, words in docs.items():
        for node in words:
            if not cowords.has_key(node): cowords.setdefault(node, {})
            
            for to in words:
                if not cowords[node].has_key(to):
                    cowords[node].setdefault(to, 1)
                else:
                    cowords[node][to] += 1

    for n, m in cowords.items():
        print(n)
        for w, f in m.items():
            print("\t%s %s" % (w, f))
        
        break


if __name__ == "__main__":
    
    import sys
    args = sys.argv

    test_snapshot(args[1])

