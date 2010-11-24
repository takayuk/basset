#!/home/kamei/local/bin/ruby -Ku
# -*- encoding: utf-8 -*-
# -*- coding: utf-8 -*-

require"rexml/document"
@h=Hash.new(0)
@pattern=/[a-z0-9]/u

@h=Hash.new(0)
open("/home/kamei/workspace/dataset/group_v"){|f|
  while l=f.gets
    l.chomp!

    @s=l.downcase.gsub(/[^a-z0-9 ぁ-んァ-ヴ一-龠ー]/,"")
  end
}

Dir.glob("gdump/gdump/*.dump").each_with_index{|pt,i|
  #@h[File.split(pt)[1].split(".").first]=Array.new
  @bowh=Hash.new(0)
  REXML::Document.new(open(pt)).elements.each("rsp/groups/group/"){|e|

    @s=e.attributes["name"].downcase.gsub(/[^a-z0-9 ぁ-んァ-ヴ一-龠ー]/,"")
    e.attributes["name"].downcase.gsub(/[^a-z0-9 ぁ-んァ-ヴ一-龠ー]/,"").split(" ").each{|bow|
      #@h[File.split(pt)[1].split(".").first] << bow
      @bowh[bow]+=1
    }
  }
  @h[File.split(pt)[1].split(".").first] = @bowh.clone
  printf("%d\r",i)
}
open("group_bow_m","w"){|f|
  f.puts @h.size
  #@h.each{|u,g| f.puts "#{u} #{g.sort.join(":1 ")+":1 "}"}
  @h.each{|u,gbow|
    f.print "#{u} "
    gbow.each{|w,c|
      f.print "#{w}:#{c} "
    }
    f.print "\n"
  }
}
