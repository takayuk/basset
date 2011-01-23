#!/home/kamei/local/bin/ruby -Ku
# -*- encoding: utf-8 -*-
# -*- coding: utf-8 -*-

$LOAD_PATH.push("/home/kamei/workspace/basset/bin")
require"googlenews_snapshot.rb"
@res=snapshot(start_index = 0)

require"bow"
@res["responseData"]["results"].each{|v|
  p @f = bow(v["title"], "名詞")
}
