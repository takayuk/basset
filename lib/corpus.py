# encoding: utf-8
# coding: utf-8


from pymongo import Connection
import bson

class Corpus(object):
    
    def __init__(self):
        self.con = Connection("localhost", 27017)
        self.db = self.con.corpus

        self.col = self.db.engadget

    def __del__(self):
        self.col.remove()
        self.con.disconnect()

    def to_url(self, path):
        """
        Convert occurred words to word urllist format.
        """
        with file(path, "w") as url:
            for record in self.col.find():
                #url.write("%s %s\n" % (record["word"], " ".join(record["docid"])))
                try:
                    url.write("%s %s\n" % record["word"], len(record["docid"]))
                except TypeError:
                    print(record["docid"])
    
    def to_labellist(self, path):
        """
        Convert indexed table of corpus to labellist format.
        """
        pass

    def append(self, doc, docid):
        
        for w in doc:
            try:
                if self.col.find({"word": w}).count() is 0:
                    id_lastused = self.col.find().count()
                    self.col.insert({"word": w, "wordid": id_lastused + 1, "docid": [docid], "freq":1})
                else:
                    data = self.col.find_one({"word": w})
                    data["freq"] += 1
                    data["docid"].append(docid)
                    self.col.save(data)
            except bson.errors.InvalidStringData:
                pass


