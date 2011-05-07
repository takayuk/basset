# encoding: utf-8
# coding: utf-8


def snapshot(url):

    import urllib
    from xml.dom import minidom, Node
    
    response = minidom.parse(urllib.urlopen(url))

    docids = []
    descs = []

    for entry in response.getElementsByTagName("item"):
        docids.append(entry.getElementsByTagName("link").item(0).childNodes[0].data)
        descs.append(entry.getElementsByTagName("description").item(0).childNodes[0].data)

    return zip(docids, descs)


if __name__ == "__main__":
    import sys
    args = sys.argv

    ss = snapshot(args[1])

    for s, t in ss:
        print(s)
        print(t)


