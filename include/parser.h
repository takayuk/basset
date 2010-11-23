/**
 * Text parser for default link format.
 *
 * Last updated
 * by takayu-k
 * at 2010年 11月 16日 火曜日 19:33:56 JST
*/

#pragma once

#include <edge.h>

#include <string>
#include <list>
#include <fstream>
#include <map>
#include <strstream>
#include <sstream>
#include <iostream>
#include <vector>


/*
namespace {
  template <class T> bool from_string(T& t, const std::string& s, std::ios_base& (*f)(std::ios_base&))
  {
    std::istringstream iss(s);
    return !(iss >> f >> t).fail();
  }
}
*/

typedef std::map<std::string, std::vector< edge<std::string, std::string> > > ty_labellist;
//typedef std::list<std::string, std::list< edge<std::string, std::string> > > ty_labellist;
//typedef std::vector<std::string, std::list< edge<std::string, std::string> > > ty_labellist;

class Parser {

  public:
    ty_labellist eval_each();
    bool doc(const std::string& path);
    void stat();
    void clear();
    Parser();
    ~Parser();

  private:
    /**
     * @param string str Source string.
     * @param string delim Delimiter.
     * @return list<string> String list splitted.
     */
    void split(std::string str, const std::string& delim, std::vector<std::string>& token);

    std::list<std::string> document;
};

