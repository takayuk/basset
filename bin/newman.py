#!/home/kamei/local/bin/python3
# -*- coding: utf-8 -*-
# -*- encoding: utf-8 -*-

from numpy import *

'''
$LOAD_PATH.push('.')
require 'Parser'
dataset = parse("groupbow-bow_e")
require"pp"
linkmat=Array.new(dataset.size).map!{Array.new(dataset.size,0)}
dataset.each{|i,v|
  v.each{|j| linkmat[i.to_i][j[0].to_i]=j[1].to_i}
}
n=open("userbow_v").readlines.map{|x|x.chomp}.freeze
#linkmat = dataset[1].clone.freeze
for i in 0..linkmat.size - 1
  for j in 0..linkmat[i].size - 1
    if linkmat[i][j] != linkmat[j][i] then
      raise "Error: Linkmat is directional."
    end
  end
end
'''
alllines=open("user-group_e").read()

'''
cluster = Hash.new([].freeze)
for i in 0..(n.size - 1)
  cluster[i] = Array.new if cluster[i] == [].freeze
  cluster[i] << n[i]
end

m = ((linkmat.flatten.to_a.inject(0) {|t,a| t + a}) / 2).freeze

e = Array.new(cluster.size) {|v| v = Array.new(cluster.size, 0.0)}
for i in 0..(e.size - 1)
  for j in 0..(e[i].size - 1)
    e[i][j] = linkmat[i][j].to_f / m.to_f
  end
end

a = Array.new(e.size, 0.0)
for i in 0..(a.size - 1)
  for k in 0..(e[i].size - 1)
    a[i] += e[i][k]
  end
end

dq = Array.new(e.size) {|v| v = Array.new(e.size, 0.0)}
for i in 0..(dq.size - 1)
  for j in 0..(dq[i].size - 1)
    dq[i][j] = 2.0 * (e[i][j] - (a[i] * a[j]))
  end
end


maxi = -1; maxj = -1
dqmax = -100000000.0 
for i in 0..(dq.size - 1)
  for j in 0..(dq[i].size - 1)
    next if i == j
    if dq[i][j] > dqmax then
      maxi = i
      maxj = j
      dqmax = dq[i][j]
    end
  end
end


cluster[maxj] += cluster[maxi]
cluster.delete(maxi)

x = cluster.clone
cluster.clear
x.each_with_index {|c, i| cluster[i] = c[1].clone}
x.clear

$maxq = -10000000.0
$maxcluster = []

while cluster.size > 1 do

  e.each {|v| v.clear}.clear
  a.clear
  dq.each {|v| v.clear}.clear
  
  e = Array.new(cluster.size) {|v| v = Array.new(cluster.size, 0.0)}
  cluster.each_with_index {|u, ii|
    cluster.each_with_index {|v, jj|

      edge = 0
      u[1].each {|i|
        v[1].each {|j|

          #edge += linkmat[i][j]
          edge += linkmat[n.index(i)][n.index(j)]
        }
      }

      e[ii][jj] = edge.to_f / m.to_f
      e[ii][jj] /= 2.0 if ii == jj
    }
  }

  a = Array.new(e.size, 0.0)
  for i in 0..(a.size - 1)
    for k in 0..(e[i].size - 1)
      a[i] += e[i][k]
    end
  end

  q = 0.0
  for i in 0..(e.size - 1)
    q += e[i][i] - (a[i] ** 2)
  end
  if q > $maxq then
    $maxq = q
    $maxcluster = cluster.clone
  end

  dq = Array.new(e.size) {|v| v = Array.new(e.size, 0.0)}
  for i in 0..(dq.size - 1)
    for j in 0..(dq[i].size - 1)
      dq[i][j] = 2.0 * (e[i][j] - (a[i] * a[j]))
    end
  end

  dqmax = -100000000.0 
  for i in 0..(dq.size - 1)
    for j in 0..(dq[i].size - 1)
      next if i == j
      if dq[i][j] > dqmax then
        maxi = i
        maxj = j
        dqmax = dq[i][j]
      end
    end
  end
 
  cluster[maxj] += cluster[maxi]
  cluster.delete(maxi)

  x = cluster.clone
  cluster.clear
  x.each_with_index {|c, i| cluster[i] = c[1].clone}
  x.clear
end

p $maxq
p $maxcluster

=begin
# Load graph-v 
@ts=open(ARGV[1]).readlines.map{|x|x.chomp}
$maxcluster.each{|k,v|
  @line=""
  v.each{|vv|@line+=@ts[vv]+":1 "}
  open("topic-bow_e","a"){|f|f.puts "#{k} #{@line}"}
}
=end
=begin
Dir.chdir('./out')
$dir, $file = File::split(ARGV[1])
#np=$file.gsub(/.node/, ".cluster")
#np=argv_node.gsub(/.node/, ".cluster")
np = $file + '.cluster'
#open('c_0.cluster', 'w') {|file|
open(np, 'w') {|file|

  $maxcluster.each {|k, v|

    file.puts 'Cluster ' + k.to_s
    #p 'Cluster ' + k.to_s
    v.each {|w|
      #printf("%s ", tags[w])
      file.puts "\t" + tags[w]
    }
    #printf("\n\n")
    file.puts ""
  }
}

#}
=end
'''
