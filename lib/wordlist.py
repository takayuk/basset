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
        if not word in self.wordlist:
            #self.wordlist.setdefault(word, [self.__wordid, 1])
            self.wordlist.setdefault(word, self.__wordid)
            self.__wordid += 1

    def wordid(self, word):
        try:
            return self.wordlist[word]
        except KeyError:
            return None

if __name__ == "__main__":
    
    import sys
    args = sys.argv

    wordlist = Wordlist()

    wordlist.append("a")
    wordlist.append("b")
    wordlist.append("c")
    wordlist.append("d")

    print(wordlist.wordid("a"))
    print(wordlist.keys())

    for word in wordlist:
        print(word)
