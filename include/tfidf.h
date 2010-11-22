/**
 * Word-weight evaluated by Tf-Idf.
 *
 * Last updated
 * by takayu-k
 * at 2010年 11月 16日 火曜日 21:57:31 JST
*/



#include "parser.h"

#include <algorithm>
#include <cmath>

typedef pair<string, float> ty_wordweight;
typedef list<ty_wordweight> ty_wordset;
typedef map<string, ty_wordset> ty_userwwmap;

class Tfidf {

  public:
    float eval(const string& word, const string& dockey);
    void eval_all();

    float tf(string word, string dockey);
    
    bool dump(const string& path);
    
    Tfidf(const ty_dataset dataset);
    ~Tfidf();

  private:
    float idf(const string& word);
    
    ty_dataset dataset_;
    ty_userwwmap tfidf_;
};

