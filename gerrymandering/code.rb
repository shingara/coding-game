# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.

w, h = gets.split(" ").collect { |x| x.to_i }

class Districts
  def initialize
    @districts={}
  end

  def add(w, h, voters)
    @districts[w] ||= {h => voters}
    @districts[w][h] = voters
  end

  def value_of(w,h)
    @districts[w][h]
  end
end

class BestResults
  def initialize(districts)
    @districts = districts
  end
  attr_reader :districts

  def square_of(w,h)
    @best_results ||= {}
    @best_results[w] ||= {}
    @best_results[w][h] ||= Square.new(w,h, districts, self).best_results
  end
end

class Square
  def initialize(w, h, districts, best_results)
    @w, @h, @districts, @cache_best_results = w, h, districts, best_results
  end
  attr_reader :w, :h, :districts, :cache_best_results

  def best_results
    [
      max_full_h,
      max_full_w,
    ].max
  end

  def max_full_h
    (1..(w/2)).inject(districts.value_of(w,h)) do |sum, i|
      [
        sum,
        cache_best_results.square_of(i, h) + cache_best_results.square_of(w-i, h)
      ].max
    end
  end

  def max_full_w
    (1..(h/2)).inject(districts.value_of(w,h)) do |sum, i|
      [
        sum,
        cache_best_results.square_of(w, i) + cache_best_results.square_of(w, h-i)
      ].max
    end
  end
end

districts = Districts.new

h.times do |y|
  inputs = gets.split(" ")
  inputs.each_with_index do |voters, x|
    districts.add(x + 1 , y + 1, voters.to_i)
  end
end

def debug(str)
  STDERR.puts str
end


cache_best_results = BestResults.new(districts)
p Square.new(w,h, districts, cache_best_results).best_results
