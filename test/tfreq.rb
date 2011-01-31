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
Dir.glob("#{DATA_DIR}/#{@label_path}.*").each{|v|
  open(v).readlines.map{|w|
    @words+=w.split(" ",3)[2].split(" ")
  }
}
#@words.uniq!
p @tfreq = tfreq(@words)
@tfreq.sort{|a,b|b[1]<=>a[1]}.each{|k,v|
  puts "#{k}\t#{v}"
}
#p @words.size
