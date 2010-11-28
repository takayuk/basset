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

namespace {
  template <class T> bool from_string(T& t, const std::string& s, std::ios_base& (*f)(std::ios_base&)) {
    std::istringstream iss(s);
    return !(iss >> f >> t).fail();
  }
}

template <class key_type, class val_type>
class Graph {

  public:
    typedef std::set< edge<key_type, val_type> > ty_edgeset;
    typedef std::map< key_type, std::set< edge<key_type, val_type> > > ty_graph;
    typedef typename ty_graph::iterator it_v;
    typedef typename std::set< edge<key_type, val_type> >::iterator it_e;
   
    /**
     * @brief Generate graph from default format dataset.
     * @param[in] path Path to dataset.
     */
    bool gen(const std::string& path) {
      if (!parser.doc(path)) { std::cout << "not found.\n"; }
      
      ty_labellist labellist = parser.eval_each();
      for (ty_labellist::iterator i = labellist.begin(); i != labellist.end(); ++i) {

        std::set< edge<key_type, val_type> > linked_set;

        for (std::vector< edge<std::string, std::string> >::iterator j = i->second.begin(); j != i->second.end(); ++j) {

          if (j->key().empty()) continue;

          int link_weight;
          from_string<int>(link_weight, j->value(), std::dec);
          
          linked_set.insert(edge<std::string, int>(j->key(), link_weight));
        }

        graph[i->first] = linked_set;
      }

      return true;
    }

    /**
     * @brief With sampling overloaded from bool Graph::gen(const std::string)
     * @param[in] path Path to dataset.
     * @param[in] sampling_count Sampling data count from head of dataset.
     */
    bool gen(const std::string& path, const unsigned int& sampling_count) {

      if (!parser.doc(path, sampling_count)) { std::cout << "not found.\n"; }
      
      ty_labellist labellist = parser.eval_each();
      for (ty_labellist::iterator i = labellist.begin(); i != labellist.end(); ++i) {

        std::set< edge<key_type, val_type> > linked_set;

        for (std::vector< edge<std::string, std::string> >::iterator j = i->second.begin(); j != i->second.end(); ++j) {

          if (j->key().empty()) continue;

          int link_weight;
          from_string<int>(link_weight, j->value(), std::dec);
          
          linked_set.insert(edge<std::string, int>(j->key(), link_weight));
        }

        graph[i->first] = linked_set;
      }
      return true;
    }

    const it_v each() {
      static it_v current = graph.end();

      if (current == graph.end()) current = graph.begin();
      else current++;
      
      return current;
    }

    ty_edgeset edgeset_of(const key_type& key) {
      return graph[key];
    }

    void check() const {
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
      return graph[key].size();
    }

    const unsigned int degree_of(it_v target) const {
      return target->second.size();
    }

    unsigned int deg_total() {
      unsigned int degree = 0;
      
      for (typename ty_graph::const_iterator i = graph.begin(); i != graph.end(); ++i) {
        degree += i->second.size();
      }

      return degree;
    }

    const unsigned int vtotal() const {
      return graph.size();
    }

    const bool valid(const it_v v) const {
      return v != graph.end();
    }

    const bool valid(const it_e e) const {
      return e != graph[e->first].second.end();
    }

    Graph() {}
    ~Graph() {}

  private:
    ty_graph graph;
    Parser parser;
};

