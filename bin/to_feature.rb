#!/home/kamei/local/bin/ruby -Ku
# -*- coding: utf-8 -*-
# -*- encoding: utf-8 -*-

require 'MeCab'
def mecab sentence
  @result=Hash.new(0)
  begin
    @tagger=MeCab::Tagger.new("-Ochasen -d /home/kamei/local/lib/mecab/dic/ipadic-utf8")
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
