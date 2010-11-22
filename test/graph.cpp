#include <graph.h>

int main(int argc, char* argv[]) {

  Graph g("sample_e");
  //g.gen("sample_e");
  g.tester_add(edge<std::string, int>("h",0));

  return 0;
}

