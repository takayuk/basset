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
#include <vector>

using namespace std;

#include <edge.h>

#include <set>


/*
namespace {
  template <class T> bool from_string(T& t, const std::string& s, std::ios_base& (*f)(std::ios_base&))
  {
    std::istringstream iss(s);
    return !(iss >> f >> t).fail();
  }
}
*/

typedef std::map<std::string, std::vector< edge<std::string, std::string> > > ty_dataset;

class Parser {

  public:
    //ty_dataset& eval() {
    ty_dataset eval_each() {

      cout << "eval\n";
      //std::map<std::string, std::vector< edge<std::string, std::string> > > dataset_;
      ty_dataset dataset;

      int pd = 0;

      for (list<string>::iterator i = doc_.begin(); i != doc_.end(); ++i) {

        std::vector<std::string> label;
        split((*i), " ", label);
       
        std::vector<std::string>::iterator j = label.begin();

        std::string ui = *(j++);

        std::vector< edge<std::string, std::string> > labellist;
        for (; j != label.end(); ++j) {
          std::vector<string> linknode;
          split((*j), ":", linknode);

          labellist.push_back(edge<std::string, std::string>(linknode[0], linknode[1]));
        }
        dataset[ui] = labellist;
        cout << pd++ << endl;
      }

      return dataset;
    }

    //ty_datasetf& eval(const bool& weight_isfloat); 
    bool doc(const string& path) {

      cout << path << endl;
      try {
        ifstream ifs(path.c_str(), ios::in);

        string buf;
        while (ifs && getline(ifs, buf)) {
          cout << "read\n";
          doc_.push_back(buf);
        }
      }
      catch(...) {
        return false;
      }
      return true;
    }
    
    void stat() {
      std::cout << "Lines >> " << doc_.size() << std::endl;
    }
    
    void clear() {
      doc_.clear();
      //dataset_.clear();
    }

    Parser() {}
    ~Parser() {
      this->clear();
    }

  private:
    /**
     * @param string str Source string.
     * @param string delim Delimiter.
     * @return list<string> String list splitted.
     */
    /*
    list<string> split(string str, string delim) {

      list<string> result;

      size_t cutAt;
      while ((cutAt = str.find_first_of(delim)) != str.npos) {
        if (cutAt > 0) {
          result.push_back(str.substr(0, cutAt));
        }
        str = str.substr(cutAt + 1);
      }
      if (str.length() > 0) {
        result.push_back(str);
      }
      return result;
    }
    */

    void split(
        std::string str, const std::string& delim,
        std::vector<std::string>& token) {
      
      token.clear();

      size_t cutAt;
      while ((cutAt = str.find_first_of(delim)) != str.npos) {
        if (cutAt > 0) {
          token.push_back(str.substr(0, cutAt));
        }
        str = str.substr(cutAt + 1);
      }
      if (str.length() > 0) { token.push_back(str); }
    }

    list<string> doc_;
};

