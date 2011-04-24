#!/home/takayuk/local/bin/python
# encoding: utf-8
# coding: utf-8


def snapshot(url):

    import urllib
    from xml.dom import minidom, Node
    
    response = minidom.parse(urllib.urlopen(url))

    titles = [title.firstChild.toxml() for title in response.getElementsByTagName("title")]
    descs = [desc.firstChild.toxml() for desc in response.getElementsByTagName("description")]

    return zip(titles, descs)

