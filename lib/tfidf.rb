#!/home/kamei/local/bin/ruby -Ku
# -*- encoding: utf-8 -*-
# -*- coding: utf-8 -*-

def tfreq word, labellist
  @tfreq=0
  labellist.each do |doc|
    @tfreq+=doc[word] if doc.has_key?(word)
  end
  @tfreq
end

def dfreq word, labellist
  @dfreq=0
  labellist.each do |doc|
    @dfreq+=1 if doc.keys.include?(word)
  end
  @dfreq
end

