#!/home/takayuk/local/bin/python
# encoding: utf-8
# coding: utf-8


def test_snapshot(url):
   
    import sys
    sys.path.append("/home/takayuk/workspace/github/basset/lib/")

    import snapshot as ss

    import re
    html_tag = re.compile(r"<.*?>")
    corpus = ss.snapshot("http://japanese.engadget.com/rss.xml")
    print(corpus.__class__)
    for c in corpus[2:3]:
        print(c[0])
        print(html_tag.sub("", c[1]))


test_snapshot("")
