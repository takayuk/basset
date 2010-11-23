/**
 * Graph data structure.
 *
 * Last updated
 * by takayu-k
 * at 
*/

#pragma once


#include <edge.h>
#include <parser.h>

#include <string>
#include <map>
#include <set>

class EdgeFinder {

  public:
    bool operator () (const ty_edge& edge) {
      return edge.first == query;
    }

    EdgeFinder(const string& query): query(query) {}

    string query;
};
 
/*
template <class T>
bool from_string(T& t, const std::string& s, std::ios_base& (*f)(std::ios_base&))
{
  std::istringstream iss(s);
  return !(iss >> f >> t).fail();
}
*/


template <class key_type, class val_type>
class Graph {

  public:
    bool gen(const std::string& path) {
      return true;
    }

    const unsigned int& degree_of(const key_type& key) {
      return 0;
    }

    Graph(): e(0,0) {
    }

    ~Graph() {}

  private:

    //std::map<key_type, std::set< edge<key_type, val_type> > graph_;
    //Parser parser;
    edge<key_type, val_type> e;
};
