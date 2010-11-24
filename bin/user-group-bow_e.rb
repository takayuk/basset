#!/home/kamei/local/bin/ruby -Ku
# -*- encoding: utf-8 -*-
# -*- coding: utf-8 -*-

require"rexml/document"
require"rbtagger"
require"pp"

@pattern=/[a-z0-9]/u
@tgr=Brill::Tagger.new
  
open("/home/kamei/workspace/dataset/group_v"){|f|

  @c = 0
  while l=f.gets
    @bowh=Hash.new(0)
    @t=l.chomp.split(" ")
    @id=@t.shift
    
    @s=@t.join(" ").downcase.strip.gsub(/[^a-z0-9 ぁ-んァ-ヴ一-龠ー]/,"")
    if !(@s=~@pattern).nil?
      @s.split(" ").reject{|x| x.size<2}.each{|ss|
        @tgr.tag(ss).reject{|x| x[0].empty?}.each{|w|
          @bowh[w[0]]+=1 if w[1]=="NN"||w[1]=="NNP"
        }
      }
    else
      @s.split(" ").each{|t|
        @bowh[t]+=1
      }
    end

    open("/home/kamei/workspace/dataset/user-groupbow_v","a"){|f|
      f.print "#{@id} "
      @gbow.each{|w,c|
        f.print "#{w}:#{c} "
      }
      f.print "\n"
    }
    @bowh.clear

    printf("%d\r",@c)
    @c+=1
  end
}

=begin
open("/home/kamei/workspace/dataset/user-groupbow_v","w"){|f|
  @h.each{|u,gbow|
    f.print "#{u} "
    gbow.each{|w,c|
      f.print "#{w}:#{c} "
    }
    f.print "\n"
  }
}
=end

