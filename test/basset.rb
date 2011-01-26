#!/home/kamei/local/bin/ruby -Ku
# -*- encoding: utf-8 -*-
# -*- coding: utf-8 -*-

$LOAD_PATH.push("/home/kamei/workspace/basset/bin")
$LOAD_PATH.push("/home/kamei/workspace/basset/lib")
require"googlenews_snapshot.rb"
require"bow"

=begin
def update_url url_path, words
  begin
    @url=open(url_path).readlines.map{|v|v.chomp}
  rescue
    @url=[]
  end
  p @urlcount=@url.shift

  words.uniq.each{|w|@url << w unless @url.include?(w)}

  open(url_path,"w"){|f|
    f.puts @url.size
    f.write @url.join("\n")
  }
end
=end

DATA_DIR="/home/kamei/workspace/basset/data"

def update_labellist url_path, label
  open("#{DATA_DIR}/#{url_path}.#{label[0]}","a"){|f|
    f.puts "#{label[0]} #{label[1].size} #{label[1].join(" ")}"
  }
end

@topic_url={1=>"テクノロジー", 2=>"政治"}
@label_path="train.lbl"

@stop_word=["、", "。", "<", ">", "</", "/>", ">...</", "(", ")", "b"]
@res=snapshot(start_index = 0, topic="テクノロジー")
@res["responseData"]["results"].each{|v|

  @words=[]
  @words << bow(v["title"], "名詞").reject{|v|@stop_word.include?(v)}
  @words << bow(v["content"], "名詞").reject{|v|@stop_word.include?(v)}

  update_labellist @label_path, [@topic_url.key("テクノロジー"),@words.flatten.uniq]
}

