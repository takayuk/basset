#!/home/kamei/local/bin/ruby -Ku
# -*- encoding: utf-8 -*-
# -*- coding: utf-8 -*-

$LOAD_PATH.push("/home/kamei/workspace/basset/bin")
$LOAD_PATH.push("/home/kamei/workspace/basset/lib")
$LOAD_PATH.push("/home/kamei/workspace/basset/eval")

require"tfreq"

DATA_DIR="/home/kamei/workspace/basset/data"

@label_path="train.lbl"

@words=Array.new
Dir.glob("#{DATA_DIR}/#{@label_path}.*.rfn").each{|v|
  open(v).readlines.map{|w|
    @words+=w.split(" ",3)[2].split(" ")
  }
}

@tfreq=Hash.new(0)
@words.each do |v|
  @voc=v.split(":")
  if @voc[1].nil?
    @tfreq[@voc[0]]+=1
  else
    @tfreq[@voc[0]]+=@voc[1].to_i
  end
end

@tfreq.sort{|a,b|a[1]<=>b[1]}.each{|k,v|
  puts "#{k}\t#{v}"
}
