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
  #@lmat.each{|v|@m+=v.values.size/2}
  @lmat.each{|v|@m+=v.keys.size}
  @m.freeze

  @cluster=Array.new(@vsize){|v|[v]}

  while @cluster.size > 1
    @e_=Array.new(@cluster.size){Hash.new(0)}
    for i in 0..@cluster.size-1
      for j in 0..@cluster.size-1
        @linktotal=0
        @cluster[i].each{|vi|
          @cluster[j].each{|vj|
            @linktotal+=@lmat[vi][vj]
          }
        }
        @e_[i].store(j,@linktotal/@m) if @linktotal > 0
      end
    end

    @a_=Array.new(@cluster.size,0)
    for i in 0..@cluster.size-1
      @e_[i].each{|j,w| @a_[i]+=w}
    end

    @dqmax=[nil,nil,0]
    for i in 0..@cluster.size-1
      @e_[i].each{|j,w|
        @dq=2*(w-(@a_[i]*@a_[j]))
        @dqmax=[i,j,@dq] if @dqmax[2] < @dq
      }
    end
    p @dqmax

    @cluster[@dqmax[0]].each{|vi|
      @cluster[@dqmax[1]].each{|vj|
        @lmat[vi][vj]=@lmat[vj][vi]=0
      }
    }
    @cluster[@dqmax[1]]+=@cluster[@dqmax[0]]
    @cluster.delete_at(@dqmax[0])
    @q=0
    for i in 0..@cluster.size-1
      @e_[i].each{|j,w|
        @q+=@e_[i][i]-(@a_[i]**2)
      }
    end
    p @q
  end

  break

  @qmax=0
  @last=[]
  while @cluster.size>1

    @e=Array.new(@cluster.size){Hash.new(0)}

    @dqmax=[nil,nil,0]
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
    
        @e[i].store(j,@w) if @w > 0.0
       
        @dqmax=[i,j,@w] if @dqmax[2] < @w
       
        @a[i]+=@w
      end
    end

    break unless @dqmax[2]>0.0
    next if @dqmax[0]==@dqmax[1]

    @cluster[@dqmax[1]]+=@cluster[@dqmax[0]]
    @cluster.delete_at(@dqmax[0])
    #p @cluster,@dqmax

    @q=0.0
    for i in 0..@cluster.size-1
      for j in @e[i].keys
        if i == j
          @q+=@e[i][j] - (@a[i]**2)
        end
      end
=begin
      if @e[i][i] > 0.0
        @q+=@e[i][i] - (@a[i]**2)
      end
=end
    end
    p @q
    
    if @qmax < @q
      @qmax=@q
      @last=@cluster
    end
  end
  p @qmax,@last
  break
}

