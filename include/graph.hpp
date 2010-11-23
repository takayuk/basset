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

/*
class EdgeFinder {

  public:
    bool operator () (const ty_edge& edge) {
      return edge.first == query;
    }

    EdgeFinder(const string& query): query(query) {}

    string query;
};
*/

namespace {
  template <class T> bool from_string(T& t, const std::string& s, std::ios_base& (*f)(std::ios_base&))
  {
    std::istringstream iss(s);
    return !(iss >> f >> t).fail();
  }
}

template <class key_type, class val_type>
class Graph {

  public:
    bool gen(const std::string& path) {

      if (!parser.doc(path)) { std::cout << "not found.\n"; }
      
      ty_labellist labellist = parser.eval_each();
      for (ty_labellist::iterator i = labellist.begin(); i != labellist.end(); ++i) {

        for (std::vector< edge<std::string, std::string> >::iterator j = i->second.begin(); j != i->second.end(); ++j) {

          int link_weight;
          from_string<int>(link_weight, j->value(), std::dec);
          edge<std::string, int>(j->key(), link_weight);
        }
      }

      return true;
    }

    const unsigned int& degree_of(const key_type& key) {
      return 0;
    }

    Graph() {
    }

    ~Graph() {}

  private:
    std::map<key_type, std::set< edge<key_type, val_type> > > graph;
    Parser parser;
};
