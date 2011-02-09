#!/home/kamei/local/bin/ruby -Ku
# -*- encoding: utf-8 -*-
# -*- coding: utf-8 -*-

$LOAD_PATH.push("/home/kamei/workspace/basset/bin")
$LOAD_PATH.push("/home/kamei/workspace/basset/lib")
require"googlenews_snapshot.rb"
require"bow"

Process.daemon

DATA_DIR="/home/kamei/workspace/basset/data"
ITERATION=ARGV[0].to_i

def update_labellist url_path, label
  @vocfreq=Hash.new(0)
  label[1].each{|v| @vocfreq[v]+=1 }
  open("#{DATA_DIR}/#{url_path}.#{label[0]}","a"){|f|
    f.print "#{label[0]} #{@vocfreq.size}"
    @vocfreq.each {|voc,freq| f.print " #{voc}:#{freq}" }
    f.print "\n"
  }
end

def dump label, data
  open("#{DATA_DIR}/dump/#{label}.dump","a"){|f|
    f.puts "#{label} #{data}"
  }
end

@topic_url={1=>"テクノロジー", 2=>"政治"}
@label_path="train.lbl"

@stop_word=["、", "。", "<", ">", "</", "/>", ">...</", "(", ")", "b",
"こと",
"0","1","2","3","4","5","6","7","8","9",
]

ITERATION.times do
  @topic_url.values.each{|t|

    @res=snapshot(start_index = 0, topic=t)
    @res["responseData"]["results"].each{|v|

      next if v["title"].nil? or v["content"].nil?

      dump(Time.now.to_i, v["title"] + v["content"])

      @title_bow = bow(v["title"],"名詞")
      @content_bow = bow(v["content"],"名詞")
      next if @title_bow.empty? or @content_bow.empty?

      @words=[]
      @words << @title_bow.reject{|v|
        v.empty? or @stop_word.include?(v)
      }
      @words << @content_bow.reject{|v|
        v.empty? or @stop_word.include?(v)
      }

      #update_labellist @label_path, [@topic_url.key(t),@words.flatten.uniq]
      update_labellist @label_path, [@topic_url.key(t),@words.flatten]
    }
    open("/home/kamei/workspace/basset/snapshot.log","a"){|f|f.puts Time.now.to_s}
  }
  sleep 1800
end

