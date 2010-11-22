#include <parser.h>

int main(int argc, char* argv[]) {

  Parser parser;
  parser.doc("/home/kamei/workspace/basset/test/sample_e");
  ty_dataset& g = parser.eval();

  for (ty_dataset::iterator i = g.begin(); i != g.end(); ++i) {
    cout << i->first << endl;
  }

  return 0;
}

