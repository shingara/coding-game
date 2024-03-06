# frozen_string_literal: true
STDOUT.sync = true # DO NOT REMOVE

class Land
  def initialize(x, y)
    @x = x
    @y = y
  end
  attr_reader :x, :y

  def stable?(land)
    y == land.y
  end

  def to_s; "#{x} #{y}"; end
end

class Zone
  def initialize(land1, land2)
    @land1 = land1
    @land2 = land2
  end
  attr_reader :land1, :land2
  def ==(other)
    land1 == other.land1 && land2 == other.land2
  end
end

class ZoneToLand
  def self.process(lands)
    stable = []
    prev = lands[0]
    lands.each{|l|
      next if l == prev
      stable << Zone.new(prev, l) if prev.stable?(l)
      prev = l
    }
    stable.first
  end
end

class Lander
  def initialize(x, y, hs, vs, f, r, p)
    @x = x
    @y = y
    @hs = hs
    @vs = vs
    @f = f
    @r = r
    @p = 3 #p
  end
  attr_reader :x, :y, :hs, :vs, :f, :r, :p

  GRAVITY = 3.711

  def next_vs
    vs + (GRAVITY - p)
  end

  def next_position
    [
      x,
      y + (vs + (vs - next_vs) / 2),
    ]
  end

  def go_to(zone)
    [r, p].join(' ')
  end

end

unless ENV['TEST']
  lands = []

  $N = gets.to_i # the number of points used to draw the surface of Mars.

  $N.times do
    # LAND_X: X coordinate of a surface point. (0 to 6999)
    # LAND_Y: Y coordinate of a surface point. By linking all the points together in a sequential fashion, you form the surface of Mars.
    $LAND_X, $LAND_Y = gets.split(" ").collect {|x| x.to_i}
    lands << Land.new($LAND_X, $LAND_Y)
  end

  lands_to_land = ZoneToLand.process(lands)
  warn lands_to_land

  loop do
    # HS: the horizontal speed (in m/s), can be negative.
    # VS: the vertical speed (in m/s), can be negative.
    # F: the quantity of remaining fuel in liters.
    # R: the rotation angle in degrees (-90 to 90).
    # P: the thrust power (0 to 4).
    $X, $Y, $HS, $VS, $F, $R, $P = gets.split(" ").collect {|x| x.to_i}
    lander = Lander.new($X, $Y, $HS, $VS, $F, $R, $P)
    warn lander.next_position
    puts lander.go_to(lands_to_land)
    #puts "0 0" # R P. R is the desired rotation angle. P is the desired thrust power.
  end
end
