#include <graph.hpp>

int main(int argc, char* argv[]) {

  Graph<std::string, int> g;
  g.gen("/home/kamei/workspace/dataset/group_e");

  Graph<std::string, int>::it_v c;

  std::cout << g.vtotal() << std::endl << std::endl;
  for (int i = 0; i < 100; ++i) {
    c = g.each();
    //std::cout << c->first << std::endl;
    std::cout << g.degree_of(c) << std::endl;
  }

  return 0;
}

