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

def parse2 path
  @data=open(path).readlines.map{|x|
    x.chomp.split(" ").reject{|v|v.empty?}
  }.freeze
end

def parse3 path
  @data=open(path).readlines.map{|v|
    @t=v.chomp.split(" ").reject{|w|w.empty?}
    {@t.shift.to_f=>@t} 
  }
end

=begin
@ugh=parse("/home/kamei/workspace/dataset/head1/user-group_e")
@gbowhash=parse("/home/kamei/workspace/dataset/head1/groupname-bow_e")
=end

@upr=Hash.new(0)
Dir.glob("/home/kamei/workspace/dataset/pr/*").each{|pt|
  @uid=File.split(pt)[1].scan(/(.+)-pr-cluster_e/)[0][0].freeze
  @upr[@uid]=parse3(pt)
}

$processed=0
open("/home/kamei/workspace/dataset/kldiv-userlist","w"){|f| f.puts @upr.keys.join("\n")}
for ui in @upr.keys

  p "#{$processed+=1} / #{@upr.size}"

  @kluiuj=[]
  for uj in @upr.keys

    @kl=0
    @upr[ui].each{|prseti|
      prseti.each{|pri,clusteri|

        @valid=false
        clusteri.each{|tag|
          @upr[uj].each{|prsetj|
            prsetj.each{|prj,clusterj|
              if clusterj.include?(tag)
                @kl+=pri*Math.log(pri/prj)
                @valid=true
                break
              end
            }
          }
        }
        unless @valid
          @kl+=pri*Math.log(pri/0.000000000000001)
        end
      }
    }
    @kluiuj.push(@kl)
  end
  open("/home/kamei/workspace/dataset/kldiv","a"){|f|f.puts "#{@kluiuj.join(" ")} "}
end
exit

@upr.each{|ui,pri|
  @upr.each{|uj,prj|

    @kl=0
    pri.each{|pri_val,ti|
      ti.each{|tag|
        
        prj.each{|prj_val,tj|
          if tj.include?(tag)
            @kl+=pri_val*Math.log(pri_val/prj_val)
            break
          end
        }
      }
    }
  }
}
exit

@uch=Hash.new(0)
Dir.glob("/home/kamei/workspace/dataset/cluster/*_e").each{|pt|

  @uid=File.split(pt)[1].scan(/(.+)-bowcluster_e/)[0][0].freeze
  @uch[@uid]=parse2(pt)
}

@ugh.each{|user,group|
  next if @uch[user]==0
  
  # User's gbow-list
  @n=Hash.new(0)
  group.flatten.reject{|v|v=="1"}.each{|gid|

    next if @gbowhash[gid].empty?
    @gbowhash[gid].each{|bow|
      @n.store(bow[0],bow[1])
    }
  }
  @tn_tk_cm=Hash.new(0)
  @uch[user].each_with_index{|t,commid|
    @freq=0
    t.each{|v|@freq+=@n[v].to_i}
    
    @tn_tk_cm.store(commid,@freq)
  }
  @ttn=@tn_tk_cm.values.inject(0){|t,n|t+n}
  @pr_val=@tn_tk_cm.values.map{|v|v.to_f/@ttn.to_f}

  @pr=Hash.new(0)
  @uch[user].each_with_index{|t,i|
    @pr.store(@pr_val[i],t)
  }

  open("/home/kamei/workspace/dataset/pr/#{user}-pr-cluster_e","w"){|f|
    @pr.each{|p,ts|
      f.puts "#{p} #{ts.join(" ")}"
    }
  }
}

