#!/home/kamei/local/bin/ruby -Ku

$LOAD_PATH.push("/home/kamei/workspace/basset/lib")
require"cnb"

@ll=open(ARGV[0]).readlines.map{|v|v.split(" ",3)}

@cnb=CNBClassifier.new
@ll.each{|l|
  @sosei=Hash.new(0)
  l[2].split(" ").each{|w|
    if w.split(":").size>1
      @sosei.store(w.split(":")[0],w.split(":")[1].to_i)
    else
      @sosei.store(w.split(":")[0],1)
    end
  }

  @cnb.train(l[0], @sosei)
}

p @cnb.frequency_of_word_by_class
