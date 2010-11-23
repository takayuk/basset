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

  bool operator ()(const key_type& compared_obj) {
    return edgedata.first == compared_obj.edgedata.first;
  }

  bool operator<(const edge<key_type, val_type>& compared_obj) const {
    return edgedata.first < compared_obj.edgedata.first;
  }

  std::pair<key_type, val_type> edgedata;
};

