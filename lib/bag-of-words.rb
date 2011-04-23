#!/home/kamei/local/bin/ruby -Ku
# -*- encoding: utf-8 -*-
# -*- coding: utf-8 -*-

def mecab sentence
  require "MeCab"
  
  @result=Hash.new(0)
  begin
    #@tagger=MeCab::Tagger.new("-Ochasen -d /home/takayuk/local/lib/mecab/dic/ipadic-utf8")
    @tagger=MeCab::Tagger.new("-Ochasen -d /home/takayuk/local/lib/mecab/dic/ipadic")
    @node = @tagger.parseToNode(sentence)
    while @node do
      @result.store(@node.surface.force_encoding("UTF-8"),
                    @node.feature.force_encoding("UTF-8")) unless @node.surface.empty?
      @node = @node.next
    end

  rescue
    print "RuntimeError: ", $!, "\n";
  end
  @result
end

def bow sentence, parts_name

  @feature=Array.new
  unless (sentence =~ /[ぁ-ん]/).nil?
    mecab(sentence).each do |k, v|
      if v =~ /#{parts_name}/ then @feature << k end
    end
  end

  @feature.freeze
end


