#include <graph.hpp>

static const std::string data_dir("/home/kamei/workspace/dataset/");

int main(int argc, char* argv[]) {

  typedef Graph<std::string, int> mygraph;

  Graph<std::string, int>* user_ve = new Graph<std::string, int>;
  user_ve->gen(data_dir+"user_ve", 10);
  //Graph<std::string, int>* ug = new Graph<std::string, int>;
  //ug->gen(data_dir+"id-user-group_e");

  Graph<std::string, int>* tfreq = new Graph<std::string, int>;
  tfreq->gen(data_dir+"user-groupbow-freq_e");

  //Graph<std::string, int>* gbow = new Graph<std::string, int>;
  //gbow->gen(data_dir+"group-bow_v");

  //for (int i = 0; i < tfreq->vtotal(); ++i) {
  /*
  mygraph::it_v v = tfreq->each();
  for (; tfreq->valid(v); v = tfreq->each()) {

    bool occ = false;
    for (std::set< edge<std::string, int> >::iterator e = v->second.begin(); e != v->second.end(); ++e) {

      if (e->weight() > 1) {
        std::cout << e->key() << ":" << e->weight() << " ";
        occ = true;
      }
    }
    if (occ) std::cout << std::endl;
  }
  */

  delete user_ve;
  //delete ug;
  //delete tfreq;
  //delete gbow;
}

