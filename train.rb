#!/home/kamei/local/bin/ruby -Ku

$LOAD_PATH.push("/home/kamei/workspace/basset/lib")
require"cnb"

@cnb=CNBClassifier.new

DATA_DIR=ARGV[0]

Dir.glob("#{DATA_DIR}/train.*.rfn").each{|trpath|
  @ll=open(trpath).readlines.map{|v|v.split(" ",3)}
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
}

require"bow"

def pred text
  @bow=bow(text,"名詞")
  @th=Hash.new(0)
  @bow.uniq.each{|w| @th[w]+=1}
  p @cnb.predict(@th)
end

open(ARGV[1]).readlines.each{|t|
  label,data=t.split(" ",2)
  next if label.empty? or data.empty?

  p label == pred(data)
}

