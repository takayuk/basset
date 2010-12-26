#!/home/kamei/local/bin/ruby -Ku
# -*- encoding: utf-8 -*-
# -*- coding: utf-8 -*-

@user_ve=Hash.new(0)
open("/home/kamei/workspace/dataset/user_ve").readlines.map{|v|
  v.chomp
  vv=v.split(" ").map{|w|w.gsub(/:[1-9]/,"")}
  @user_ve.store(vv.shift,vv)
}

@ulist=Hash.new(0)
open("/home/kamei/workspace/dataset/kldiv-userlist").readlines.each_with_index{|v,i|
  @ulist.store(i,v.chomp)
}

@pr=Array.new(@ulist.size).map!{|v|v=Array.new(@ulist.size,0)}
open("/home/kamei/workspace/dataset/kldiv").readlines.each_with_index{|v,i|
  v.chomp.split(" ").each_with_index{|w,j|
    @pr[i][j]=w.to_f
  }
}

@ulist.each{|i,u|

  if @user_ve[u]!=0
    
    $min=100000000
    @esti=[]
    @pr[i].each_with_index{|v,j|
      if v < 10 && v > 0
        @esti << j
      end
    }

    @precision=0
    @esti.each{|e|
      @precision+=1 if @user_ve[u].include?(@ulist[e])
    }
    p "#{@precision} / #{@user_ve[u].size}"
  end
}

