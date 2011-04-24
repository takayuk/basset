# -*- encoding: utf-8 -*-
# -*- coding: utf-8 -*-

def mecab sentence
  require "MeCab"

  require "pp"
  @result=Hash.new(0)
  begin
    @tagger=MeCab::Tagger.new("-Odump --unk-feature=未知語 -d /home/takayuk/local/lib/mecab/dic/ipadic-utf8")
    
    @node = @tagger.parseToNode(sentence)
    while @node do
      p @node.surface.force_encoding("UTF-8")
      @result.store(@node.surface.force_encoding("UTF-8"),
                    @node.feature.force_encoding("UTF-8"))
      @node = @node.next
    end

    pp @result
  rescue
    print "RuntimeError: ", $!, "\n";
  end
  @result.freeze
end

def bow sentence, parts_name

  @words = [""]
  mecab(sentence).each do |k, v|
    #puts "#{k}\t#{v}"
    parts_name.each do |part|
      if v =~ /#{part}/ #=> Matched.
        @words[-1] += k
        break
      else
        @words.push("") if not @words[-1].empty?
      end
    end
  end

  @words.freeze
end


