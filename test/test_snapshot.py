#!/home/takayuk/local/bin/python
# encoding: utf-8
# coding: utf-8


def test_snapshot(url):
    
    import bag_ofwords

    corpus = {}


"""
def main(url)
  require "swapped.bag-of-words"
  require "snapshot.rb"
  require "labellist"

  @corpus = Hash.new(0)

  @response = snapshot(url)

  @response.each do |link, description|
    
    @text = description.to_s.strip.gsub(/<("[^"]*"|\'[^\']*\'|[^\'">])*>/,"")
    @bow = bow(@text, target = ["名詞", "未知語"])

    @corpus.store(link, @bow.reject{|v| v =~ /[^一-龠ぁ-んァ-ヴーa-zA-Z0-9]/})
    @urllist = to_url(@corpus)

    open(ARGV[1], "w") do |file| file.write @urllist.join("\n") end
    break
  end
end

if __FILE__ == $0
  main(ARGV[0])
end
"""
