# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.

class Map
  def initialize(w, h)
    @w = w
    @h = h
    @lines = []
    @towers = []
    @tower_value = {}
    @round_done = []
  end
  attr_reader :lines
  attr_accessor :round_done

  def add_line(line)
    new_line = line.split('')
    new_line.each_with_index {|l, i|
      if !['.', '#'].include?(l)
        warn "first tower at (#{i}, #{@lines.size}, #{l})"
        id = new_id
        @tower_value[id] = l
        add_tower(i, @lines.size, id, 1)
        round_done << [i, @lines.size, 0]
      end
    }
    @lines << new_line
  end


  def new_id
    @id ||= 0
    @id += 1
    @id
  end

  def add_tower(x, y, t, round)
    @towers << [x, y, t, round]
  end

  def generate
    while @towers.size > 0
      tower = @towers.shift
      x, y, t, round = tower
      # if round > 4
      #   break
      # end
      [
        [x+1, y],
        [x-1, y],
        [x, y+1],
        [x, y-1]
      ].each do |(x, y)|
        next if x < 0 || x >= @w || y < 0 || y >= @h
        if @lines[y][x] == '.'
          @lines[y][x] = t
          add_tower(x, y, t, round+1)
          round_done << [x, y, round]
        elsif ['#', t].include?(@lines[y][x])
          next
        elsif round_done.include?([x, y, round])
          @lines[y][x] = '+'
          add_tower(x, y, t, round+1)
          round_done << [x, y, round]
        end
      end
    end
  end

  def read_lines
    @lines.each do |line|
      line.map!{|i| @tower_value[i] || i}.join('')
      yield line
    end
  end
end

# w: width of the building.
# h: height of the building.

w = gets.to_i
h = gets.to_i
map = Map.new(w, h)
h.times do
  map.add_line(gets.chomp)
end

# Write an answer using puts
# To debug: STDERR.puts "Debug messages..."

# Debug
map.lines.each do |line|
  warn line.join('')
end
warn 'end debug'

map.generate

map.read_lines do |line|
  puts line.join('')
end
