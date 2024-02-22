STDOUT.sync = true # DO NOT REMOVE
Result = [
   [[0,0],[0,1], [0,2]],
   [[1,0],[1,1], [1,2]],
   [[2,0],[2,1], [2,2]],
   [[0,0],[1,0], [2,0]],
   [[0,1],[1,1], [2,1]],
   [[0,2],[1,2], [2,2]],
   [[0,0],[1,1], [2,2]],
   [[0,2],[1,1], [2,0]],
]

LineByBlock = {}
3.times do |i|
  3.times do |j|
    LineByBlock[[i,j]] = Result.select{|r| r.include?([i,j]) }.map{|r| r.reject{|r1| r1 == [i,j]}}
  end
end

start = '0 0'
alternate_start = '2 2'
opponent_action = []
my_action = []

def convert_to_one_tic_tac_toe(all_action)
  base_action = []
  vector = [0,0]
  vector =[
      (all_action.first[0]/3).to_i,
      (all_action.first[1]/3).to_i
    ]

  all_action.each do |a|
    base_action << [
      a[0] - vector[0]*3,
      a[1] - vector[1]*3
    ]
  end
  [base_action, vector]
end

def has_risk(opponent_action, my_action)
  risk_block = []
  3.times do |i|
    3.times do |j|
      unless block_opponent(opponent_action, [i, j], my_action).empty?
        risk_block << [i, j]
      end
    end
  end
  risk_block
end

def block_opponent(opponent_action, vector, my_action)
  Result.each do |r|
    rv = r.map{|r1| on_local(r1, vector) }
    if opponent_action.select{|oa| rv.include?(oa)}.size > 1
      next if rv.all?{|r1| opponent_action.include?(r1) || my_action.include?(r1) }
      return rv.reject!{|r1| opponent_action.include?(r1) }
    end
  end
  return []
end


def the_best_move(opponent_action, base_action, my_action, all_action, vector)
  # choice = {}
  # Result.each do |r|
  #   next if opponent_action.any?{|oa| r.include?(on_local(oa, vector))}
  #   choice[r] = r.select{|r1| my_action.include?(on_local(r1, vector)) }.size
  # end
  # STDERR.puts "all action #{all_action}"
  # STDERR.puts "base action #{base_action}"
  # STDERR.puts choice
  # STDERR.puts "vector : #{vector}"
  # chooses = []
  # choice.values.sort.reverse.each do |try|
  #   choice.key(try).each do |c|
  #     if base_action.include?(c)
  #       STDERR.puts "choose #{c}"
  #       chooses << on_local(c, vector)
  #     end
  #   end
  # end
  # return chooses
  choice = {}
  3.times.each do |i|
    3.times.each do |j|
      next if opponent_action.include?(on_local([i,j], vector))
      next if my_action.include?(on_local([i,j], vector))
      possible_line = Result.select{|r| r.include?([i,j]) }
      opponent_in_line = possible_line.map{|r| (r.map{|r1| on_local(r1, vector)} & opponent_action).size}.sum
      my_action_in_line = possible_line.map{|r| (r.map{|r1| on_local(r1, vector)} & my_action).size}.sum
      choice[[i,j]] = possible_line.size - opponent_in_line*2 + my_action_in_line
    end
  end
  choice

end


def on_local(base, vector)
  return base if base.empty?
  [
    base[0]+vector[0]*3,
    base[1]+vector[1]*3
  ]
end



unless ENV['TEST']
# game loop
loop do
  all_action = []
  opponent_row, opponent_col = gets.split.map { |x| x.to_i }
  opponent_action << [opponent_row, opponent_col]
  valid_action_count = gets.to_i
  valid_action_count.times do
    row, col = gets.split.map { |x| x.to_i }
    all_action << [row,col]
  end
  base_action, vector = convert_to_one_tic_tac_toe(all_action)

  STDERR.puts "opponent_action #{opponent_action}"
  STDERR.puts "my_action #{my_action}"
  STDERR.puts "vector #{vector}"
  risk_block = has_risk(opponent_action, my_action)
  STDERR.puts "risk_block #{risk_block}"
  action_against = block_opponent(opponent_action, vector, my_action)
  unless action_against.empty?
    STDERR.puts "action_against #{action_against}"
    my_action << action_against.first
    puts action_against.first.join(' ')
    next
  end
  chooses = the_best_move(opponent_action, base_action, my_action, all_action, vector)
  STDERR.puts "chooses #{chooses}"
  local_risk_block =  risk_block.map{|r| on_local(r, vector)}
  STDERR.puts "local_risk_block #{local_risk_block}"
  action = on_local(
    chooses.delete_if{|k,v|
      local_risk_block.include?(on_local(k, vector))
    }.sort_by{|k,v| v}.reverse.first[0],
    vector)
  my_action << action
  puts action.join(' ')
end
end
