#!/home/kamei/local/bin/ruby -Ku
# -*- encoding: utf-8 -*-
# -*- coding: utf-8 -*-

class KLdiv

  def initialize

    @tagcluster = Hash.new([].freeze)
    @tagcount = Hash.new(0)

    @dataset = Hash.new([].freeze)

    @user = []
  end

  def load(path)
    
    open(path) {|file|

      current_key = 0
      while line = file.gets

        line.chomp! unless line.nil?
    
        if line[0] == "\t"

          tag = line.strip
          @tagcluster[current_key] = [] if @tagcluster[current_key] == [].freeze
          @tagcluster[current_key] << tag
        elsif !line.empty?
          
          current_key += 1
        end
      end
    }

    @tagcluster
  end

  def load_tagcount(path)

    open(path) {|file|

      while key = file.gets

        count = file.gets.chomp!
        @tagcount[key.strip!] = count.strip.to_i
      end
    } unless path.nil? || path.empty?

    @tagcount
  end

  def new_pr(user_id, cluster, count)

    # クラスタID => タグ出現回数
    tn_hash = Hash.new([].freeze)

    tcn = []
    cluster.each {|cid, tags|

      tn = 0
      tags.each {|tag| tn += count[tag] }

      tn_hash[cid] = tn
    }

    ttn = tn_hash.values.to_a.inject(0) {|t, a| t + a }

    # クラスタ => (TN / TTN)
    pr_hash = Hash.new(0.0)
    tn_hash.each {|cid, tn|

      pr_hash[cid] = tn.to_f / ttn.to_f
    }

    pr_hash
  end

  ### Todo: @tagcluster と @tagcount, user_idを受け取るように変更する
  def new_tn(path = './newman/data/tagcount')

    @tagcluster.freeze
    @tagcount.freeze

    Dir.chdir
    Dir.chdir(path)
    Dir.glob("*.tagc").each {|path| @user << path.split('.').first }

    ### Bug: 異なるユーザにすべて同じデータが入ってしまっている
    @user.each {|u| @dataset[u] = [@tagcluster, @tagcount] }

    #tn_hash=Hash.new {|v| v=Array.new {|w| w=Hash.new(0)}}
    tn_hash = Hash.new([].freeze)

    @user.each {|u|
      
      set = @dataset[u].freeze

      tcn=[]
      set[0].each {|k, v|

        tn = 0
        v.each {|tag|

          tn += set[1][tag]
        }
  
        tcn << {k => tn}
      }

      tn_hash[u] = tcn.clone
    }

    ttn_hash = Hash.new(0)
    @user.each {|u|

      ttn = 0
      tn_hash[u].each {|v| v.each{|kk,vv| ttn += vv }}

      ttn_hash[u] = ttn
    }

    pr_hash = Hash.new([].freeze)
    @user.each {|u|

      pr = []
      #tn_hash[u].each {|k, v|
      tn_hash[u].each {|k|

        k.each {|kk,vv|

          pr << {k => (vv.to_f / ttn_hash[u].to_f)}
        }
      }
      pr_hash[u] = pr
    }
    pr_hash.each {|u, pr|

      pr.each{|p| p.each{|kk,vv| printf("%.8f\n", vv)}}
    }

    pr_hash
  end
end

