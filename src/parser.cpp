/**
 * Text parser for default link format.
 *
 * Last updated
 * by takayu-k
 * at 2010年 11月 16日 火曜日 19:33:56 JST
*/

#include <string>
#include <list>
#include <fstream>
#include <map>
#include <strstream>
#include <sstream>
#include <iostream>
#include <vector>

#include <edge.h>

#include <parser.h>

ty_labellist Parser::eval_each() {

  ty_labellist labellist;

  for (std::list<std::string>::iterator i = document.begin(); i != document.end(); ++i) {

    std::vector<std::string> label;
    split((*i), " ", label);

    std::vector<std::string>::iterator j = label.begin();

    std::string ui = *(j++);

    std::vector< edge<std::string, std::string> > labelnode;
    //std::list< edge<std::string, std::string> > labelnode;
    for (; j != label.end(); ++j) {
      std::vector<std::string> linknode;
      split((*j), ":", linknode);

      labelnode.push_back(edge<std::string, std::string>(linknode[0], linknode[1]));
    }
    
    labellist[ui] = labelnode;
    //labellist.push_back(labelnode);
  }

  return labellist;
}

bool Parser::doc(const std::string& path) {

  std::ifstream ifs;
  ifs.exceptions(std::ifstream::eofbit | std::ifstream::failbit | std::ifstream::badbit);

  try {
    ifs.open(path.c_str());

    /// [Bug] NOT catched "File not found".
    if (!ifs || !ifs.is_open()) return false;
    
    while (ifs && !ifs.eof()) {
      std::string buffer;
      getline(ifs, buffer);
      
      document.push_back(buffer);
    }
    ifs.close();
  }
  catch (std::ifstream::failure e) {
    std::cout << e.what() << std::endl;
  }

  return true;
}

bool Parser::doc(const std::string& path, const unsigned int& line_limit) {

  std::ifstream ifs;
  ifs.exceptions(std::ifstream::eofbit | std::ifstream::failbit | std::ifstream::badbit);

  try {
    ifs.open(path.c_str());

    /// [Bug] NOT catched "File not found".
    if (!ifs || !ifs.is_open()) return false;
    
    while (ifs && !ifs.eof()) {
      std::string buffer;
      getline(ifs, buffer);
      
      document.push_back(buffer);

      if (document.size() > line_limit) break;
    }
    ifs.close();
  }
  catch (std::ifstream::failure e) {
    std::cout << e.what() << std::endl;
  }

  return true;
}

void Parser::stat() {
  std::cout << "Lines >> " << document.size() << std::endl;
}

void Parser::clear() {
  document.clear();
}

Parser::Parser() {}

Parser::~Parser() {
  this->clear();
}

/**
 * @param string str Source string.
 * @param string delim Delimiter.
 * @return list<string> String list splitted.
 */
void Parser::split(
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

