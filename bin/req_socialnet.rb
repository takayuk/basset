#!/home/kamei/local/bin/ruby -Ku
# -*- encoding: utf-8 -*-
# -*- coding: utf-8 -*-

def usage
  puts "$ #{__FILE__} SRC_PATH TARGET_PATH THREAD_COUNT"
  puts "$ #{__FILE__} user.url . 8"
  exit
end

usage if ARGV[0].nil? || ARGV[1].nil? || ARGV[2].nil?
SRC=ARGV[0]
TARGET=ARGV[1]
THREADS=ARGV[2].to_i

$LOAD_PATH.push("/home/kamei/workspace/basset/bin")
require"flickr_request"

$mutex=Mutex.new

def request
  while true
    $mutex.lock
    @uid=$us.empty? ? nil : $us.pop
    $mutex.unlock

    #contacts_of(@uid,TARGET) unless @uid.nil?
    photos_of(@uid,TARGET) unless @uid.nil?
    break if @uid.nil?

    sleep 0.1
    p $us.size
  end
end

Dir.mkdir("#{TARGET}/dump") unless Dir.exists?("#{TARGET}/dump")
$us=open(SRC).readlines.map{|v|v.chomp!}.reject{|v|File.exists?("#{TARGET}/dump/#{v}")}

@ths=Array.new(THREADS).map!{
  Thread.start { request }
}.each{|t|t.join}

