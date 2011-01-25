#!/home/kamei/local/bin/ruby -Ku
# -*- encoding: utf-8 -*-
# -*- coding: utf-8 -*-

$LOAD_PATH.push(".")
require "cnb"

cnb = CNBClassifier.new

open(ARGV[0]) { |f|
  f.each { |l|
    label, sosei = l.strip.split(' ', 2)
    sosei = sosei.split(' ').map { |v| k, v = v.split(':'); [k, v.to_i] }.flatten
    sosei = Hash[*sosei]
    cnb.train(label, sosei)
  }
}

open(ARGV[1]) { |f|
  f.each { |l|
    label, sosei = l.strip.split(' ', 2)
    sosei = sosei.split(' ').map { |v| k, v = v.split(':'); [k, v.to_i] }.flatten
    sosei = Hash[*sosei]
    puts cnb.classify(sosei)
  }
}

