#!/home/kamei/local/bin/ruby -Ku
# -*- encoding: utf-8 -*-
# -*- coding: utf-8 -*-

class CNBClassifier  
  def initialize(smoothing_parameter = 1)
    @frequency_of_word_by_class = { }
    @number_of_train_data_of_class = Hash.new(0)
    @smoothing_parameter = smoothing_parameter
  end

  def train(label, sosei)
    @frequency_of_word_by_class[label] = Hash.new(0) unless @frequency_of_word_by_class.has_key?(label)
    sosei.each { |k, v|
      @frequency_of_word_by_class[label][k] += v
    }
    @number_of_train_data_of_class[label] += 1
  end

  def total_number_of_word_in_other_class(c)
    all_words = @frequency_of_word_by_class.values.map { |h| h.keys }.flatten.sort.uniq
    other_classes = @frequency_of_word_by_class.keys - [c]
    other_classes.map { |c|
      all_words.map { |w|
        @frequency_of_word_by_class[c][w]
      }
    }.flatten.inject(0) { |s, v| s + v }
  end

  def number_of_word_in_other_class(c, i)
    other_classes = @frequency_of_word_by_class.keys - [c]
    other_classes.map { |c| @frequency_of_word_by_class[c][i] }.inject(0) { |s, v| s + v }
  end

  def classify(sosei)
    all_class = @frequency_of_word_by_class.keys
    all_train_data = @number_of_train_data_of_class.values.inject(0) { |s, v| s + v }
    all_class.map { |c|
      n_c = total_number_of_word_in_other_class(c)
      alpha = @smoothing_parameter*sosei.length
      term2nd = sosei.to_a.map { |e|
        k = e[0]
        v = e[1]
        v*Math.log((number_of_word_in_other_class(c, k) + @smoothing_parameter).to_f/(n_c + alpha))
      }.inject(0) { |s, v| s + v }

      theta_c = @number_of_train_data_of_class[c].to_f/all_train_data
      [c, Math.log(theta_c) - term2nd]
    }.sort { |x, y| x[1] <=> y[1] }.last.first
  end
end

