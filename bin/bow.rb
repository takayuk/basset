#!/home/kamei/local/bin/ruby -Ku
# -*- encoding: utf-8 -*-
# -*- coding: utf-8 -*-

def bow sentence, parts_name
  $LOAD_PATH.push("/home/kamei/workspace/basset/bin")
  require"to_feature"

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

