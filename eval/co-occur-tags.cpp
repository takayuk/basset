#include <parser.h>
#include <tfidf.h>

#include <iostream>
#include <vector>
#include <stdexcept>

struct sort_pred {
  bool operator()(const pair<string, int>& lhs, const pair<string, int>& rhs) {
    return lhs.second > rhs.second;
  }
};

int main(int argc, char* argv[]) {

  Parser psr;
  if (!psr.doc("/home/kamei/ws/data/user_ve.hd10")) { cout << "err" << endl; }
  ty_dataset& dataset = psr.eval();
  
  Parser tfidf_psr;
  if (!tfidf_psr.doc("/home/kamei/ws/data/user-gbow-tfidf_e.dump")) { cout << "err" << endl; }
  ty_datasetf& tfidf = tfidf_psr.eval(true);

  vector<string> v;
  for (ty_dataset::iterator i = dataset.begin(); i != dataset.end(); ++i) {
    v.push_back(i->first);
    for (ty_edgeset::iterator k = i->second.begin(); k != i->second.end(); ++k) {
      v.push_back(k->first);
    }
  }

  //Tfidf* tfidfd = new Tfidf(tfidf);

  /// Word-Occured & Weight between user ui <-> uj.
  for (ty_dataset::iterator i = dataset.begin(); i != dataset.end(); ++i) {
    
    ty_wordset tui = tfidf[i->first];

    vector< pair<string, int> > occlist;
    vector< pair<string, float> > occtfv;

    for (vector<string>::iterator j = v.begin(); j != v.end(); ++j) {

      if (i->first == *j) continue;

      ty_wordset tuj = tfidf[*j];
      int pr_friend = 0;
      float simpr = 0.0;
      for (ty_wordset::iterator t = tui.begin(); t != tui.end(); ++t) {

        ty_wordset::iterator oc = find_if(tuj.begin(), tuj.end(), EdgeFinder(t->first));
        if (oc != tuj.end()) {
          ty_wordset tf = tfidf[i->first];

          simpr += find_if(tf.begin(), tf.end(), EdgeFinder(oc->first))->second;
          pr_friend++;
        }
      }
      if (pr_friend > 0) {occlist.push_back(pair<string, int>(*j, pr_friend));}
      if (simpr > 0.0f) {occtfv.push_back(pair<string, float>(*j, simpr));}
    }

    sort(occlist.begin(), occlist.end(), sort_pred());
    sort(occtfv.begin(), occtfv.end(), sort_pred());

    const int top_k = 100;
    int pr = 0;
    int pd = 0;
    //for (std::vector< pair<string, int> >::iterator itr = occlist.begin(); itr != occlist.end(); ++itr) {
    for (std::vector< pair<string, float> >::iterator itr = occtfv.begin(); itr != occtfv.end(); ++itr) {

      if (pd++ > top_k) break;

      ty_edgeset::iterator _i = find_if(i->second.begin(), i->second.end(), EdgeFinder(itr->first));
      if (_i != i->second.end()) {
        pr++;
      }
    }
    //for (int ii = 0; ii < top_k; ++ii) {
      /*
      try {
        ty_edgeset::iterator _i = find_if(i->second.begin(), i->second.end(), EdgeFinder(occlist[ii].first));
        if (_i != i->second.end()) {
          pr++;
        }
      }
      //catch (const out_of_range& e) {
      catch (...) {
        break;
      }
      */
    //}
    cout << i->second.size() << " contacts.\n";
    cout << pr << " / " << i->second.size() << endl;
  }

  return EXIT_SUCCESS;
}

