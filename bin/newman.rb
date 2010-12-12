#!/home/kamei/local/bin/ruby -Ku
# -*- encoding: utf-8 -*-
# -*- coding: utf-8 -*-

def parse path
  @h=Hash.new(0)
  open(path).readlines.map{|x|
    x.chomp.split(" ").reject{|v|v.empty?}
  }.each{|u|
    @h[u.shift]=u.map{|w|w.split(":")}
  }
  @h.clone
end

def deep_copy obj
  Marshal.load(Marshal.dump(obj))
end


@ugh=parse("/home/kamei/workspace/dataset/head1/user-group_e")
@gbh=parse("/home/kamei/workspace/dataset/head1/groupname-bow_e")

@ugh.each{|user,group|
  @user=user.freeze
  #next if File.exists?("cluster/#{@user}-bowcluster_e")
 
  @th=Hash.new(0)
  group.each{|g|
    # Access to Group-BOW of group"g[0]".
    @gbh[g[0]].each{|f|
      @from=f[0]
      @th[@from]=Hash.new(0) if @th[@from]==0
      
      @gbh[g[0]].each{|t|
        @to=t[0]
        next if @from==@to
        @th[@to]=Hash.new(0) if @th[@to]==0

        @th[@from].store(@to,1) unless @th[@from].has_key?(@to)
        @th[@to].store(@from,1) unless @th[@to].has_key?(@from)

        if @th[@from].has_key?(@to)
          @th[@from][@to]+=1
          @th[@to][@from]+=1
        end
      }
    }
  }

  @gv=@th.keys.sort.freeze
  next if @gv.empty?

  @vsize=@gv.size.freeze
  @isize=(@vsize-1).freeze

  @lmat=Array.new(@vsize){Hash.new(0)}
  @gv.each_with_index{|vv,i|
    @th[vv].each_with_index{|lw,j|
      #@lmat[i].store(@gv.index(lw[0]),lw[1].to_f)
      @lmat[i].store(@gv.index(lw[0]),1.0)
    }
  }

  @m=0.0
  @lmat.each{|v|@m+=v.values.size/2}
  @m.freeze

  @cluster=Array.new(@vsize){|v|[v]}

  @qmax=0
  @last=[]
  while @cluster.size>1

    @e=Array.new(@cluster.size){Hash.new(0)}

    @dqmax=[0,0,0]
    @a=Array.new(@cluster.size,0.0)
    for i in 0..@cluster.size-1
      for j in 0..@cluster.size-1
        #next if i==j
        @w=0
        @cluster[i].each{|vi|
          @cluster[j].each{|vj|
            @w+=@lmat[vi][vj]
          }
        }
        @w/=@m
    
        #@e[i].store(j,@w) if @w > 0.0
        @e[i].store(j,@w) if @w > 0.0
       
        @dqmax=[i,j,@w] if @dqmax[2] < @w
       
        @a[i]+=@w
      end
    end
    @cluster[@dqmax[1]]+=@cluster[@dqmax[0]]
    @cluster.delete_at(@dqmax[0])
    
    p @cluster[@dqmax[1]]
    break
    @q=0
    for i in 0..@cluster.size-1
      if @e[i][i] > 0.0
        @q+=@e[i][i] - (@a[i]**2)
      end
    end
    if @qmax < @q
      @qmax=@q
      @last=@cluster.clone
    end
  end
  p @qmax,@last
  break
}

