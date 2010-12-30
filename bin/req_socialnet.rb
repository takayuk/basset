#!/home/kamei/local/bin/ruby -Ku
# -*- encoding: utf-8 -*-
# -*- coding: utf-8 -*-

exit if ARGV[0].nil?
THREADS=ARGV[0].to_i

$LOAD_PATH.push(".")
require"flickr_request"

$mutex=Mutex.new

def request
  while true
    $mutex.lock
    @uid=@us.empty? ? nil:@us.pop
    $mutex.unlock

    contacts_of(@uid) unless @uid.nil?
    break if @uid.nil?
  end
end

$us=open("user_v").readlines.map{|v|v.chomp!}.reject{|v|File.exists?("dump/#{v}")}

@ths=Array.new(THREADS).map!{
  Thread.start { request }
}.each{|t|t.join}

