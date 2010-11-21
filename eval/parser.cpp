/**
 * Text parser for default link format.
 *
 * Last updated
 * by takayu-k
 * at 2010年 11月 17日 水曜日 16:13:40 JST
*/


#include "parser.h"


ty_dataset& Parser::eval() {

  int processed = 0;
  for (list<string>::iterator i = doc_.begin(); i != doc_.end(); ++i) {

    ty_edgeset links;

    list<string> link = split((*i), " ");
    list<string>::iterator j = link.begin();
    
    string ui = *(j++);
    
    for (; j != link.end(); ++j) {
      list<string> uj = split((*j), ":");

      stringstream istr((*(++(uj.begin()))).data());
      unsigned short weight = 0;
      istr >> weight;

      links.push_back(ty_edgef(*uj.begin(), weight));
      //links.insert(ty_edge(*uj.begin(), weight));
    }

    dataset_[ui] = links;

    printf("%d\r", processed++);
  }

  return dataset_;
}

ty_datasetf& Parser::eval(const bool& weight_isfloat) {

  for (list<string>::iterator i = doc_.begin(); i != doc_.end(); ++i) {

    ty_edgefset links;

    list<string> link = split((*i), " ");
    list<string>::iterator j = link.begin();
    
    string ui = *(j++);
    
    for (; j != link.end(); ++j) {
      list<string> uj = split((*j), ":");

      //stringstream istr((*(++(uj.begin()))).data());
      float weight = 0;
      //istr >> weight;
      from_string<float>(weight, *(++(uj.begin())), dec);

      links.push_back(ty_edgef(*uj.begin(), weight));
      //links.insert(ty_edge(*uj.begin(), weight));
    }

    datasetf_[ui] = links;
  }

  return datasetf_;
}


bool Parser::doc(const string& path) {

  try {
    ifstream ifs(path.c_str(), ios::in);

    string buf;
    while (ifs && getline(ifs, buf)) {
      doc_.push_back(buf);
    }
  }
  catch(...) {
    return false;
  }
  return true;
}

void Parser::stat() {

  for (list<string>::iterator i = doc_.begin(); i != doc_.end(); ++i) {
    cout << *i << endl;
  }
}

void Parser::clear() {
  doc_.clear();
  dataset_.clear();
  datasetf_.clear();
}

Parser::Parser() {}

Parser::~Parser() {
  this->clear();
}


/**
 * @param string str 分割したい文字列
 * @param string delim デリミタ
 * @return list<string> 分割された文字列
 */
list<string> Parser::split(string str, string delim) {

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

