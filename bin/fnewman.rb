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

@ugh.each{|k,v|
  @user=k.freeze
  #next if File.exists?("cluster/#{@user}-bowcluster_e")
 
  @th=Hash.new(0)
  v.each{|g|
    # Access to Group-BOW of group"g[0]".
    @gbh[g[0]].each{|f| @from=f[0]
      @th[@from]=Hash.new(0) if @th[@from]==0
      
      @gbh[g[0]].each{|t| @to=t[0]
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

  @lmat_=Array.new(@vsize){Hash.new(0)}
  @gv.each_with_index{|vv,i|
    @th[vv].each_with_index{|lw,j|
      @lmat_[i].store(@gv.index(lw[0]),lw[1].to_f)
    }
  }

  @m=0.0
  @lmat_.each{|v|@m+=v.values.size/2}
  @m.freeze

  @cluster=Hash.new(0)
  @acluster=Array.new(@vsize){|v|[v,[v]]}
  
  @gv.each_with_index{|v,i| @cluster[i]=Array.new(1,i) }
  @csize=@cluster.size
 
  @a=Array.new(@csize,0.0)
  @cluster.each{|i,vset|
    vset.each{|vid| @a[i]+=@lmat_[vid].values.inject(0){|t,a|t+a}}
  }
 
  @aa=Array.new(@csize,0.0)
  @acluster.each_with_index{|vset,i|
    vset[1].each{|vid|@aa[i]+=@lmat_[vid].values.inject(0){|t,a|t+a}}
  }

  @dq=Array.new(@csize){Hash.new(0)}
  for i in 0..@csize-1
    @lmat_[i].each{|j,w|
      @q=(@m/2.0)-(@a[i]*@a[j]).freeze
      @dq[i].store(j,@q)
    }
  end

  @dq2=Array.new(@csize){Hash.new(0)}
  for i in 0..@csize-1
    @lmat_[i].each{|j,w|
      @q=(@m/2.0)-(@aa[i]*@a[j]).freeze
      @dq2[i].store(j,@q)
    }
  end

  #while @cluster.size>2
  while @acluster.size>2

    @maxelem={[0,0]=>0.0}
    #@dq.each_with_index{|jset,i|
    @dq2.each_with_index{|jset,i|
      next if jset.empty?
      @max=jset.max
      @maxelem={[i,@max[0]]=>@max[1]} if @maxelem.values.first < @max[1]
    }

    # Merge cluster
    @mergeij=@maxelem.keys.first

    @jj=@mergeij[1]
    @ii=@mergeij[0]

    # Update dQ.
    #@cluster.each{|k,vset|
    #@cluster.each_with_index{|vset,k|
    @acluster.each_with_index{|vset,k|

      #vset.each{|v|
      vset[1].each{|v|
        #if !(@lmat_[v].keys & @cluster[@ii]).empty? && !(@lmat_[v].keys & @cluster[@jj]).empty?
        if !(@lmat_[v].keys & @acluster[@ii][1]).empty? && !(@lmat_[v].keys & @acluster[@jj][1]).empty?
          @dq[@jj][k]+=@dq[@ii][k]
        #elsif !(@lmat_[v].keys&@cluster[@ii]).empty?
        elsif !(@lmat_[v].keys&@acluster[@ii][1]).empty?
          @dq[@jj][k]=@dq[@ii][k]-(2*@a[@jj]*@a[k])
        #elsif !(@lmat_[v].keys&@cluster[@jj]).empty?
        elsif !(@lmat_[v].keys&@acluster[@jj][1]).empty?
          @dq[@jj][k]=@dq[@jj][k]-(2*@a[@ii]*@a[k])
        end
      }
    }
    
    @cluster[@mergeij[1]]+=@cluster[@mergeij[0]]
    @acluster[@mergeij[1]][1]+=@acluster[@mergeij[0]][1]

    @cluster.delete(@mergeij[0])
    @acluster.delete_at(@mergeij[0])

  
    for i in 0..@acluster.size-1
      @acluster[i][0]=i
    end
    p @acluster

    @dq.delete(@ii)
    @dq.each{|vset|
      vset.reject!{|v,w|v==@ii}
    }
    
    # Update a[]
    @a[@mergeij[1]]+=@a[@mergeij[0]]
    @a[@mergeij[0]]=0

    # for Q-Value
    @e=Array.new(@vsize,0.0)
    #@cluster.each{|i,vset|
    @acluster.each_with_index{|cluster,i|
      @lmat_.each_with_index{|vset,v|
        vset.keys.each{|w|
          if @cluster[i].include?(v) && @cluster[i].include?(w)
            @e[i]+=@lmat_[v][w]
          end
        }
      }
    }
    @Q=0
    @cluster.each{|i,vset|
      @Q+=@e[i]-(@a[i]**2)
    }

  end
  break
}
