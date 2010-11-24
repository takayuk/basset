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
    typedef std::map< key_type, std::set< edge<key_type, val_type> > > ty_graph;
    typedef typename ty_graph::iterator it_v;
    
    bool gen(const std::string& path) {
      if (!parser.doc(path)) { std::cout << "not found.\n"; }
      
      ty_labellist labellist = parser.eval_each();
      for (ty_labellist::iterator i = labellist.begin(); i != labellist.end(); ++i) {

        std::set< edge<key_type, val_type> > linked_set;

        for (std::vector< edge<std::string, std::string> >::iterator j = i->second.begin(); j != i->second.end(); ++j) {

          int link_weight;
          from_string<int>(link_weight, j->value(), std::dec);
          
          linked_set.insert(edge<std::string, int>(j->key(), link_weight));
        }

        graph[i->first] = linked_set;
      }

      return true;
    }

    const it_v each() {
      static typename ty_graph::iterator current = graph.end();

      current++;
      if (current == graph.end()) current = graph.begin();
      
      return current;
    }

    void check() {
      std::cout << graph.size() << std::endl;
      for (typename ty_graph::iterator i = graph.begin(); i != graph.end(); ++i) { 
        std::cout << i->first << std::endl;
        for (typename std::set< edge<key_type, val_type> >::iterator j = i->second.begin(); j != i->second.end(); ++j) {

          std::cout << j->key() << ":" << j->value() << " ";
        }
        std::cout << std::endl;
      }
    }

    const unsigned int& degree_of(const key_type& key) {
      return 0;
    }

    Graph() {}
    ~Graph() {}

  private:
    ty_graph graph;
    Parser parser;
};

