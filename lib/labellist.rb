# encoding: utf-8
# coding: utf-8

def to_url(corpus_map)
 
  @url = corpus_map.values.flatten.uniq

  @urllist = Array.new
  @urllist.push(@url.size.to_s)
  @urllist << @url

  @urllist.freeze
end

def to_labelmap(corpus_map, urllist)
  
  @labelmap = Hash.new(0)

  corpus_map.each do |d_j, w_i|
    @labelmap.store(d_j, w_i.map do |i| urllist.index(i) end)
  end

  return @labelmap.freeze
end

