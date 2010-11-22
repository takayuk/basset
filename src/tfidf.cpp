/**
 * Word-weight evaluated by Tf-Idf.
 *
 * Last updated
 * by takayu-k
 * at 2010年 11月 16日 火曜日 19:33:56 JST
*/


#include "tfidf.h"

void Tfidf::eval_all() {

  int processed = 0;
  for (ty_dataset::iterator i = dataset_.begin(); i != dataset_.end(); ++i) {

    ty_wordset wordset;
    
    for (ty_edgeset::iterator j = i->second.begin(); j != i->second.end(); ++j) {

      float val = this->eval(j->first, i->first);
      
      wordset.push_back(ty_wordweight(j->first, val));
    }

    tfidf_[i->first] = wordset; 

    cout << processed++ << " / " << dataset_.size() << endl;
  }
}

float Tfidf::eval(const string& word, const string& dockey) {

  const float tfval = tf(word, dockey);
  const float idfval = idf(word);

  return tfval * idfval;
}

bool Tfidf::dump(const string& path) {

  try {
    ofstream ofs(path.c_str());

    if (ofs) {
      for (ty_userwwmap::iterator i = tfidf_.begin(); i != tfidf_.end(); ++i) {
        
        ofs << i->first << " ";
        for (ty_wordset::iterator j = i->second.begin(); j != i->second.end(); ++j) {
          //float val = tfidf->eval(j->first, i->first);
          ofs << j->first << ":" << j->second << " ";
        }
        ofs << endl;
      }
    }
    return true;
  }
  catch (...)
  {
    return false;
  }
}

Tfidf::Tfidf(const ty_dataset dataset): dataset_(dataset) {
}

Tfidf::~Tfidf() {}

float Tfidf::tf(string word, string dockey) {
  
  //ty_wordset wordset = dataset_[dockey];
  ty_edgeset wordset = dataset_[dockey];

  //ty_wordset::iterator it_word = find_if(
  ty_edgeset::iterator it_word = find_if(
      wordset.begin(), wordset.end(), EdgeFinder(word));

  return log(static_cast<float>(it_word->second)) / log(static_cast<float>(wordset.size()));
  //return static_cast<float>(it_word->second);
}

float Tfidf::idf(const string& word) {

  unsigned short dfreq = 0;
  for (ty_dataset::iterator i = dataset_.begin(); i != dataset_.end(); ++i) {

    //ty_wordset::iterator find_at = find_if(
    ty_edgeset::iterator find_at = find_if(
        i->second.begin(), i->second.end(), EdgeFinder(word));
    if (find_at != i->second.end()) dfreq++;
  }

  return log(static_cast<float>(dataset_.size()) / static_cast<float>(dfreq));
}

