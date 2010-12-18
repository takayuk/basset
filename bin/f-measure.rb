#!/home/kamei/local/bin/ruby -Ku
# -*- encoding: utf-8 -*-
# -*- coding: utf-8 -*-

@prh=Hash.new([].freeze)
open("/home/kamei/workspace/dataset/kldiv").readlines.first(1).each{|v|
  #v.chomp.split(" ").map{|w|{(@i+=1)=>w.to_f}}
  v.chomp.split(" ").each_with_index{|w,i|@prh.store(i,w.to_f)}
}

@ulist=open("/home/kamei/workspace/dataset/kldiv-userlist").readlines.map{|v|v.chomp}

@min=100000.0
@esti=nil
@prh.sort{|a,b|a[1]<=>b[1]}.each{|k,v|

  if v < @min && v > 0
    @min=v
    @esti=k
  end
}
p @esti
p @ulist.first(10)
p @ulist[@esti]

