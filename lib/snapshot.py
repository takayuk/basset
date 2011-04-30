# encoding: utf-8
# coding: utf-8


def snapshot(url):

    import urllib
    from xml.dom import minidom, Node
    
    response = minidom.parse(urllib.urlopen(url))

    titles = [title.firstChild.toxml() for title in response.getElementsByTagName("title")]
    del(titles[0])
    
    descs = [desc.firstChild.toxml() for desc in response.getElementsByTagName("description")]


    return zip(titles, descs)



if __name__ == "__main__":
    import sys
    args = sys.argv

    snapshot(args[1])
