#include "parser.h"
#include "tfidf.h"

int main(int argc, char* argv[]) {

  //Parser uparser;
  //if (!uparser.doc("/home/kamei/ws/data/user_ve")) cout << "err" << endl;
  //ty_dataset& user = uparser.eval();
  
  Parser* tparser = new Parser;
  if (!tparser->doc("/home/kamei/ws/data/user-groupbow-freq_e")) cout << "err" << endl;
  ty_dataset& tfreq = tparser->eval();

  //Tfidf* tfidf = new Tfidf(tfreq);
  //tfidf->eval_all();

  //for (ty_edgeset::iterator i = user.begin(); i != user.end(); ++i) {
  //}
  
  delete tparser;

  return EXIT_SUCCESS;
}

