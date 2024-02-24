# frozen_string_literal: true

$n = gets.to_i
$vs = gets.chomp
list = $vs.split(" ").map{|v| v.to_i}

worst = -1
list.each_with_index do |v,i|
  if worst < v
    list[i+1, list.length].each do |v2|
      val = v - v2
      worst = val if val > worst
    end
  end
end
puts worst == -1 ? 0 : -worst
