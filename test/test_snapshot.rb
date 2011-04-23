#!/home/takayuk/local/bin/ruby -Ku
# encoding: utf-8
# coding: utf-8

$LOAD_PATH.push("/home/takayuk/workspace/github/basset/bin",
                "/home/takayuk/workspace/github/basset/lib")

def main(url)
  require "bag-of-words"
  require"snapshot.rb"

  @response = snapshot(url)

  @response.each do |link, description|
    puts link
    @text = description.to_s.strip.gsub(/<("[^"]*"|\'[^\']*\'|[^\'">])*>/,"")
    @bow = bow(@text, "名詞")
    @bow.each do |v| p v if not (v =~ /[一-龠ぁ-んァ-ヴーa-zA-Z0-9]/).nil? end
  end
end

if __FILE__ == $0
  main(ARGV[0])
end
