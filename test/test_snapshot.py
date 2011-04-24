#!/home/takayuk/local/bin/python
# encoding: utf-8
# coding: utf-8


def test_snapshot(url):
   
    import sys
    sys.path.append("/home/takayuk/workspace/github/basset/lib/")

    import snapshot as ss

    corpus = ss.snapshot("http://japanese.engadget.com/rss.xml")
    print(corpus.__class__)
    for c in corpus[2:3]:
        print(c[0])
        print(c[1])


test_snapshot("")
