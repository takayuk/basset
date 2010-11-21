/**
 * Text parser for default link format.
 *
 * Last updated
 * by takayu-k
 * at 2010年 11月 16日 火曜日 19:33:56 JST
*/

#pragma once

#include <string>
#include <list>
#include <fstream>
#include <map>
#include <strstream>
#include <sstream>
#include <iostream>

using namespace std;


typedef pair<string, unsigned short> ty_edge;
typedef pair<string, float> ty_edgef;

typedef list<ty_edge> ty_edgeset;
typedef list<ty_edgef> ty_edgefset;
//typedef map<ty_edge> ty_edgeset;
//typedef map< pair<string, unsigned short> > ty_edgeset;
typedef map<string, ty_edgeset> ty_dataset;
typedef map<string, ty_edgefset> ty_datasetf;

class EdgeFinder {

  public:
    bool operator () (const ty_edge& edge) {
      return edge.first == query;
    }

    EdgeFinder(const string& query): query(query) {}

    string query;
};
  
template <class T>
bool from_string(T& t, const std::string& s, std::ios_base& (*f)(std::ios_base&))
{
  std::istringstream iss(s);
  return !(iss >> f >> t).fail();
}

class Parser {

  public:
    ty_dataset& eval(); 
    ty_datasetf& eval(const bool& weight_isfloat); 
    bool doc(const string& path);
    void stat();

    void clear();

    Parser();
    ~Parser();

  private:
    /**
     * @param string str 分割したい文字列
     * @param string delim デリミタ
     * @return list<string> 分割された文字列
     */
    list<string> split(string str, string delim);

    /*
    bool operator () (const ty_edge& lhs, const ty_edge& rhs) {
      return lhs.second < rhs.second;
    }
    */

    list<string> doc_;
    ty_dataset dataset_;
    ty_datasetf datasetf_;
};

