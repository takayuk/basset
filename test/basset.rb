#!/home/kamei/local/bin/ruby -Ku
# -*- encoding: utf-8 -*-
# -*- coding: utf-8 -*-

$LOAD_PATH.push("/home/kamei/workspace/basset/bin")
require"googlenews_snapshot.rb"
require"to_feature"

@res=snapshot(start_index = 0)

def bow sentence, parts_name
  @feature=Array.new
  unless (sentence =~ /[ぁ-ん]/).nil?
    @mecab_result=mecab(sentence)
    @mecab_result.each{|k,v|
      next if v.nil? or v.empty?
      @scanned = v.scan(/#{parts_name}/)
      @feature << k if !@scanned.nil? and !@scanned.empty?
    }
  end
  @feature
end

require"pp"
@res["responseData"]["results"].each{|v|
  p @f = bow(v["title"], "名詞")
}
