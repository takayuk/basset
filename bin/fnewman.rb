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
      @lmat[i].store(@gv.index(lw[0]),lw[1].to_f)
    }
  }

  @m=0.0
  @lmat.each{|v|@m+=v.values.size/2}
  @m.freeze

  @cluster=Array.new(@vsize){|v|[v,[v]]}
 
=begin
  @a=Array.new(@cluster.size,0.0)
  @cluster.each_with_index{|vset,i|
    vset[1].each{|vid|@a[i]+=@lmat[vid].values.inject(0){|t,a|t+a}}
    @a[i]/=@m
  }
=end
=begin
  @dq=Array.new(@cluster.size){Hash.new(0)}
  for i in 0..@cluster.size-1
    @lmat[i].each{|j,w|
      @q=(@m/2.0)-(@a[i]*@a[j]).freeze
      @dq[i].store(j,@q)
    }
  end
=end
  while @cluster.size>2

=begin
    @maxelem={[0,0]=>0.0}
    @dq.each_with_index{|jset,i|
      next if jset.empty?
      @max=jset.max
      @maxelem={[i,@max[0]]=>@max[1]} if @maxelem.values.first < @max[1]
    }

    # Merge cluster
    @mergeij=@maxelem.keys.first

    @jj=@mergeij[1]
    @ii=@mergeij[0]
=end
    # Update dQ.
=begin
    @cluster.each_with_index{|vset,k|

      vset[1].each{|v|
        p "touch" if @lmat[v].keys.nil?
        p "touch" if @cluster[@ii][1].nil? 
        if !(@lmat[v].keys & @cluster[@ii][1]).empty? && !(@lmat[v].keys & @cluster[@jj][1]).empty?
          @dq[@jj][k]+=@dq[@ii][k]

        elsif !(@lmat[v].keys & @cluster[@ii][1]).empty?
          @dq[@jj][k]=@dq[@ii][k]-(2*@a[@jj]*@a[k])

        elsif !(@lmat[v].keys & @cluster[@jj][1]).empty?
          @dq[@jj][k]=@dq[@jj][k]-(2*@a[@ii]*@a[k])
        end
      }
    }
=end
    #@cluster[@mergeij[1]][1]+=@cluster[@mergeij[0]][1]

    #@cluster[@mergeij[0]].clear

=begin
    for i in 0..@cluster.size-1
      @cluster[i][0]=i
    end
=end 
=begin
    @dq.delete(@ii)
    @dq.each{|vset|
      vset.reject!{|v,w|v==@ii}
    }
=end 

    # Update a[]
    #@a[@mergeij[1]]+=@a[@mergeij[0]]
    #@a[@mergeij[0]]=0

    # for Q-Value
    @dqmax=Array.new(3,0)
    @a=Array.new(@cluster.size,0.0)
    for i in 0..@cluster.size-1
      for j in i..@cluster.size-1
        @e=0
        @cluster[i][1].each{|vi|
          @cluster[j][1].each{|vj|
            @e+=@lmat[vi][vj]
          }
        }
        @e/=@m
        @dqmax=[i,j,@e] if @dqmax[2] < @e
        @a[i]+=@e
      end
    end
    @cluster[@dqmax[1]][1]+=@cluster[@dqmax[0]][1]
    #@cluster[@dqmax[0]][1].clear
    @cluster.delete(@dqmax[0])
    
    @q=0
    for i in 0..@cluster.size-1
      @cluster[i][1].each{|vi|
        @cluster[i][1].each{|vj|
          @q+=@lmat[vi][vj] - (@a[i]**2)
        }
      }
    end
    p @q
=begin
    @e=Array.new(@cluster.size){|v|v=Array.new(@cluster[v][
    @cluster.each_with_index{|cluster,i|
     
      @lmat.each_with_index{|_,v|
        _.keys.each{|w|
          if @cluster[i].include?(v) && @cluster[i].include?(w)
            @e[i]+=@lmat[v][w]
          end
        }
      }
    }
    @Q=0
    @cluster.each_with_index{|vset,i|
      @Q+=@e[i]-(@a[i]**2)
    }
    for i in 0..@cluster.size-1
      @cluster[i][0]=i
    end
=end
  end
  break
}

