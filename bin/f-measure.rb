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

#@pr=Array.new(@ulist.size).map!{|v|v=Array.new(@ulist.size,0)}
@pr=Array.new(@ulist.size).map!{|v|v=Hash.new(0)}
open("/home/kamei/workspace/dataset/kldiv").readlines.each_with_index{|v,i|
  v.chomp.split(" ").each_with_index{|w,j|
    #@pr[i][j]=w.to_f
    @pr[i].store(j,w.to_f)
  }
}

@ulist.each{|i,u|

  if @user_ve[u]!=0
    
    $min=100000000
    @esti=[]
    @pr[i].sort{|a,b|a[1]<=>b[1]}.each_with_index{|jw,_|
      break if @esti.size >= 40
      @esti << jw[0] if jw[1] > 0
    }
    @precision=0
    @esti.each{|e|
      @precision+=1 if @user_ve[u].include?(@ulist[e])
    }
    p "#{@precision} / #{@user_ve[u].size} : #{@esti.size}"
  end
}

