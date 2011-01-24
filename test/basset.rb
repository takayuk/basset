#!/home/kamei/local/bin/ruby -Ku
# -*- encoding: utf-8 -*-
# -*- coding: utf-8 -*-

$LOAD_PATH.push("/home/kamei/workspace/basset/bin")
require"googlenews_snapshot.rb"
require"bow"

@stop_word=["、", "。", "<", ">", "</", "/>"]
@res=snapshot(start_index = 0, topic="テクノロジー")
@res["responseData"]["results"].each{|v|
  p bow(v["title"], "名詞")
  p bow(v["content"], "名詞").reject{|v|
    @stop_word.include?(v)
  }
}
=begin
puts "\n\n\n"
@res=snapshot(start_index = 1, topic="テクノロジー")
@res["responseData"]["results"].each{|v|
  p bow(v["title"], "名詞")
  p bow(v["content"], "名詞")
}
puts "\n\n\n"
@res=snapshot(start_index = 3, topic="テクノロジー")
@res["responseData"]["results"].each{|v|
  p bow(v["title"], "名詞")
  p bow(v["content"], "名詞")
}
=end

