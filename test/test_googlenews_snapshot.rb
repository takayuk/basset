#!/home/kamei/local/bin/ruby -Ku
# -*- encoding: utf-8 -*-
# -*- coding: utf-8 -*-

$LOAD_PATH.push("/home/kamei/workspace/basset/bin")
require"googlenews_snapshot.rb"

@res=snapshot(start_index = 0)

require"pp"
@res["responseData"]["results"].each{|v|
  pp v["title"] unless (v["content"] =~ /[ぁ-ん]/).nil?
  pp v["content"] unless (v["content"] =~ /[ぁ-ん]/).nil?
  puts ""
}
