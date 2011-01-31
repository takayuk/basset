#!/home/kamei/local/bin/ruby -Ku
# -*- encoding: utf-8 -*- 
# -*- coding: utf-8 -*-

def usage
  puts "$ ruby #{__FILE__} PATH_TO_LABELLIST_DIR"
  exit
end

def tfreq datalist
  return if datalist.class != Array
  @tfreq=Hash.new(0)
  datalist.each{|v|@tfreq[v]+=1}
  @tfreq
end

