/**
 * Text parser for default link format.
 *
 * Last updated
 * by takayu-k
 * at 2010年 11月 28日 日曜日 17:43:20 JST
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


typedef std::map<std::string, std::vector< edge<std::string, std::string> > > ty_labellist;

class Parser {

  public:
    ty_labellist eval_each();

    bool doc(const std::string& path);
    bool doc(const std::string& path, const unsigned int& line_limit);

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

