#!/home/kamei/local/bin/ruby -Ku
# -*- encoding: utf-8 -*-
# -*- coding: utf-8 -*-

def usage
  puts "$ ruby #{__FILE__} PATH_TO_TRAINING_DATA_DIR"
  exit
end

usage if ARGV[0].nil?

DATA_DIR=ARGV[0]

require"fileutils"
Dir.glob("#{DATA_DIR}/*.rfn").each{|pt| FileUtils.rm(pt) }
Dir.glob("#{DATA_DIR}/train.lbl.*").each{|pt|
  @buf=open(pt).readlines
  @buf.map!{|v|v.split(" ",3)}
  @buf.reject!{|v|v[1]=="0"}
  open("#{pt}.rfn","w"){|f| f.write @buf.map{|v|v.join(" ")}.join }
}
