#include <graph.hpp>

int main(int argc, char* argv[]) {

  Graph<std::string, int> g;
  g.gen("/home/kamei/workspace/basset/tbin/sample_e");

  Graph<std::string, int>::it_v c;

  for (int i = 0; i < 100; ++i) {
    c = g.each();
    std::cout << c->first << std::endl;
  }

  return 0;
}

