#pragma once

#include "edge.h"

template <class key_type, class val_type>
struct edgetuple: public edge {
  
  edgetuple(
      const key_type& key, const val_type& value,
      const unsigned int& i, const unsigned int& j)
    : edge<key_type, val_type>(key, value), i_(i), j_(j) {}
  ~edgetuple() {}

  const edge<key_type, val_type> elem() {
    return this->edgedata;
  }

  const unsigned int i() const { return i_; }
  const unsigned int j() const { return j_; }

  unsigned int i_, j_;
};

