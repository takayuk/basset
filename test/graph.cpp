#include <graph.hpp>

int main(int argc, char* argv[]) {

  Graph<std::string, int> g;
  g.gen("/home/kamei/workspace/basset/tbin/sample_e");

  g.check();

  return 0;
}

