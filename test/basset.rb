#!/home/kamei/local/bin/ruby -Ku
# -*- encoding: utf-8 -*-
# -*- coding: utf-8 -*-

$LOAD_PATH.push("/home/kamei/workspace/basset/bin")
$LOAD_PATH.push("/home/kamei/workspace/basset/lib")
require"googlenews_snapshot.rb"
require"bow"

Process.daemon

DATA_DIR="/home/kamei/workspace/basset/data"

def update_labellist url_path, label
  open("#{DATA_DIR}/#{url_path}.#{label[0]}","a"){|f|
    f.puts "#{label[0]} #{label[1].size} #{label.join(":1 ")}:1"
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
"こと"]

10000.times do
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

      update_labellist @label_path, [@topic_url.key(t),@words.flatten.uniq]
    }
    open("/home/kamei/workspace/basset/snapshot.log","a"){|f|f.puts Time.now.to_s}
  }
  sleep 1800
end

