#include <graph.hpp>

static const std::string data_dir("/home/kamei/workspace/dataset/");

int main(int argc, char* argv[]) {

  Graph<std::string, int>* ug = new Graph<std::string, int>;
  ug->gen(data_dir+"id-user-group_e");

  Graph<std::string, int>* tfreq = new Graph<std::string, int>;
  tfreq->gen(data_dir+"user-groupbow-freq_e");

  Graph<std::string, int>* gbow = new Graph<std::string, int>;
  gbow->gen(data_dir+"group-bow_v");
 
  delete ug;
  delete tfreq;
  delete gbow;
}

