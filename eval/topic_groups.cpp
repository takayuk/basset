#include <graph.hpp>

#include <algorithm>
#include <functional>

static const std::string data_dir("/home/kamei/workspace/dataset/");

int main(int argc, char* argv[]) {

  typedef Graph<std::string, int> mygraph;

  Parser p;
  p.doc("/home/kamei/workspace/dataset/group_v");
  p.eval_each();
  p.clear();
  //p.doc("/home/kamei/workspace/basset/group_vb");
  //p.clear();
  return 0;

  /// User i.
  std::string ui; {
    Graph<std::string, int>* user_ve = new Graph<std::string, int>;
    user_ve->gen(data_dir+"user_ve", 1);
    mygraph::it_v uie = user_ve->each();
    ui = uie->first;
    delete user_ve;
  }

  /// Resources[Group] for ui
  mygraph::ty_edgeset r_ui; {
    Graph<std::string, int>* ug_e = new Graph<std::string, int>;
    ug_e->gen(data_dir+"id-user-group_e");
    r_ui = ug_e->edgeset_of(ui);
    delete ug_e;
  }

  /// Topics[Group-BOW] for ui
  //std::vector<mygraph::ty_edgeset> tlist_ui; {
  std::vector<std::string> t_ui; {
   
    Graph<std::string, int>* ut_e = new Graph<std::string, int>;
    ut_e->gen(data_dir+"group-bow_v");
    
    for (mygraph::it_e r = r_ui.begin(); r != r_ui.end(); ++r) {
      
      mygraph::ty_edgeset rt = ut_e->edgeset_of(r->key());

      for (mygraph::it_e t = rt.begin(); t != rt.end(); ++t) {
        t_ui.push_back(t->key());
      }
    }
    delete ut_e;
  }

  std::unique(t_ui.begin(), t_ui.end());

  /// Group BOW-tfreq of sample user.
  /*
  mygraph::ty_edgeset t_ui; {
    Graph<std::string, int>* tfreq = new Graph<std::string, int>;
    tfreq->gen(data_dir+"group-bow_e");
    t_ui = tfreq->edgeset_of(sample);
    delete tfreq;
  }
  */

  /// tfreq > 1 BOW list of sample user.
  /*
  mygraph::ty_edgeset occt;
  for (mygraph::it_e se = t_ui.begin(); se != t_ui.end(); ++se) {
    if (se->weight() > 1) {
      occt.insert(edge<std::string, int>(se->key(), se->weight()));
    }
  }
  */

  /*
  mygraph::it_v r; {
    Graph<std::string, int>* gbow = new Graph<std::string, int>;
    gbow->gen(data_dir+"group-bow_v");
    delete gbow;
  }

  mygraph::ty_edgeset sgroup; {
    Graph<std::string, int>* group_e = new Graph<std::string, int>;
    group_e->gen(data_dir+"group_e");
    sgroup = group_e->edgeset_of(sample);
    delete group_e;
  }

  for (mygraph::it_e e = occt.begin(); e != occt.end(); ++e) {
    for (mygraph::it_e sg = sgroup.begin(); sg != sgroup.end(); ++sg) {
    }
  }
  */
}

