STDOUT.sync = true # DO NOT REMOVE
# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.
result = [
   [[0,0],[0,1], [0,2]],
   [[1,0],[1,1], [1,2]],
   [[2,0],[2,1], [2,2]],
   [[0,0],[1,0], [2,0]],
   [[0,1],[1,1], [2,1]],
   [[0,2],[1,2], [2,2]],
   [[0,0],[1,1], [2,2]],
   [[2,2],[1,1], [0,0]],
]

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


def block_opponent(result, opponent_action, vector)
  STDERR.puts "opponent_action #{opponent_action}"
  result.each do |r|
    rv = r.map{|r1| [r1[0]+vector[0]*3, r1[1]+vector[1]*3] }
    if opponent_action.select{|oa| rv.include?(oa)}.size > 1
      return rv.reject!{|r1| opponent_action.include?(r1) }
    end
  end
  return nil
end


def the_best_move(result, opponent_action, base_action, my_action, all_action, vector)
  choice = {}
  result.each do |r|
    next if opponent_action.any?{|oa| r.include?(oa)}
    choice[r] = r.select{|r1| my_action.include?(r1) }.size
  end
  STDERR.puts "all action #{all_action}"
  STDERR.puts "base action #{base_action}"
  STDERR.puts choice
  STDERR.puts "vector : #{vector}"
  choose = nil
  choice.values.sort.reverse.each do |try|
    choice.key(try).each do |c|
      STDERR.puts "test #{c}"
      if base_action.include?(c)
        STDERR.puts "choose #{c}"
        choose = [
          c[0]+vector[0]*3,
          c[1]+vector[1]*3
        ].join(' ')
        break
      end
    end
    break if choose
  end
  return choose
end

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

  action_against = block_opponent(result, opponent_action, vector)
  if action_against
    STDERR.puts "action_against #{action_against}"
    puts action_against.join(' ')
    next
  end
  choose = the_best_move(result, opponent_action, base_action, my_action, all_action, vector)
  puts choose
end
