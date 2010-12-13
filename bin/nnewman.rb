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

@ugh=parse("/home/kamei/workspace/dataset/head1/user-group_e")
@gbh=parse("/home/kamei/workspace/dataset/head1/groupname-bow_e")

require"narray"

$processed=0
@ugh.each{|user,group|
  p $processed+=1
  next if File.exists?("/home/kamei/workspace/dataset/cluster/#{user}-bowcluster_e")

  puts "\t#{user}"
  @th=Hash.new(0)
  group.each_with_index{|g,i|
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

  @lmat=NArray.object(@gv.size)
  @gv.each_with_index{|vv,i|
    @lmat[i]=Hash.new(0)
    @th[vv].each_with_index{|lw,j|
      @lmat[i].store(@gv.index(lw[0]),lw[1].to_f)
    }
  }

  @m=0
  for i in 0..@lmat.size-1
    @m+=@lmat[i].values.inject(0){|t,a|t+a}
  end

  @cluster=Array.new(@gv.size){|v|[v]}

  p "Clustering start."
  @qmax=-10000000
  @last=[]
  while @cluster.size > 1
    p @cluster.size

    @e_=NArray.object(@cluster.size)
    for i in 0..@cluster.size-1
      @e_[i]=Hash.new(0)
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

    @a_=NArray.float(@cluster.size)
    for i in 0..@cluster.size-1
      @e_[i].each{|j,w| @a_[i]+=w}
    end

    @dqmax=NArray.to_na([-1000,-1000,-1000])
    for i in 0..@cluster.size-1
      @e_[i].each{|j,w|
        @dq=2*(w-(@a_[i]*@a_[j]))
        @dqmax=[i,j,@dq] if @dqmax[2] < @dq
      }
    end

    begin
      @cluster[@dqmax[0]].each{|vi|
        @cluster[@dqmax[1]].each{|vj|
          @lmat[vi][vj]=@lmat[vj][vi]=0
        }
      }
    rescue
      break
    end
  
    @cluster[@dqmax[1]]+=@cluster[@dqmax[0]]
    @cluster.delete_at(@dqmax[0])
    @q=0
    for i in 0..@cluster.size-1
      @e_[i].each{|j,w|
        @q+=@e_[i][i]-(@a_[i]**2)
      }
    end

    if @qmax < @q
      @qmax=@q
      @last=@cluster
    end
  end

  open("/home/kamei/workspace/dataset/cluster/#{user}-bowcluster_e","w"){|f|
    @last.each{|cluster|
      @bow=Array.new(cluster.size)
      cluster.each_with_index{|bowid,i|
        @bow[i]=@gv[bowid]
      }
      f.puts @bow.join(" ")
    }
  }
}

