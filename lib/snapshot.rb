#!/home/takayuk/local/bin/ruby -Ku
# encoding: utf-8
# coding: utf-8

require "json"
require "rexml/document"
require "open-uri"

def snapshot feed_url
  @response = REXML::Document.new(open(feed_url, :proxy=>"http://cache.st.ryukoku.ac.jp:8080"))

  @snapshot = Hash.new(0)
  @response.elements.each("rss/channel/item/") do |item|
    @snapshot.store(item.elements["link"].text, item.elements["description"].text)
  end

  @snapshot.freeze
end

if __FILE__ == $0
  snapshot(ARGV[0])
end


