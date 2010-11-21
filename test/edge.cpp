#include <edge.h>

#include <string>
#include <iostream>

using namespace std;

int main(int argc, char* argv[]) {

  edge<std::string, int> edge("hello", 3);

  const std::string& k = edge.key();

  cout << k << endl;
  cout << edge.value()<< endl;
  cout << edge.weight()<< endl;

  //const std::string k = edge.key();

  return 0;
}

