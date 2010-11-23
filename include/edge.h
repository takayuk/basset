#pragma once

#include <map>
#include <string>

template <class key_type, class val_type>
struct edge {
  
  edge(const key_type& key, const val_type& value): edgedata(key, value) {}
  ~edge() {}

  const key_type key() const { return edgedata.first; }
  const val_type value() const { return edgedata.second; }
  
  const val_type& weight() const { return edgedata.second; }

  bool operator ()(const key_type& lhs, const key_type& rhs) {
    return lhs.first == rhs.first;
  }

  const std::pair<key_type, val_type> edgedata;
};

