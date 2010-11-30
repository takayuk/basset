#include <graph.hpp>

static const std::string data_dir("/home/kamei/workspace/dataset/");

int main(int argc, char* argv[]) {

  typedef Graph<std::string, int> mygraph;

  /// Sample user.
  mygraph::it_v sample; {
    Graph<std::string, int>* user_ve = new Graph<std::string, int>;
    user_ve->gen(data_dir+"user_ve", 1);
    sample = user_ve->each();
    delete user_ve;
  }

  /// Group BOW-tfreq of sample user.
  mygraph::ty_edgeset s; {
    Graph<std::string, int>* tfreq = new Graph<std::string, int>;
    tfreq->gen(data_dir+"group-bow_e");
    s = tfreq->edgeset_of(sample);
    delete tfreq;
  }

  /// tfreq > 1 BOW list of sample user.
  mygraph::ty_edgeset occt;
  for (mygraph::it_e se = s.begin(); se != s.end(); ++se) {
    if (se->weight() > 1) {
      occt.insert(edge<std::string, int>(se->key(), se->weight()));
    }
  }

  Graph<std::string, int>* gbow = new Graph<std::string, int>;
  gbow->gen(data_dir+"group-bow_v");
  delete gbow;

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
}

