# frozen_string_literal: true
STDOUT.sync = true # DO NOT REMOVE

# Arbitrary values of max horizontal speed
MAX_DX = 20
MAX_DY = 40

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
  def initialize(x, y, hs, vs, f, r, t)
    @x = x
    @y = y
    @hs = hs
    @vs = vs
    @f = f
    @r = r
    @t = 3 #p
  end
  attr_accessor :x, :y, :hs, :vs, :f, :r, :t

  GRAVITY = 3.711

  def next_vs
    vs + (GRAVITY - t)
  end

  def next_position
    [
      x,
      y + (vs + (vs - next_vs) / 2),
    ]
  end

  def in_wrong_direction?(zone)
    (x < zone.land1.x && hs < 0 ) ||
      (x > zone.land2.x && hs > 0)
  end

  def min_distance_to_land(zone)
    [(zone.land1.x - x).abs,
     (zone.land2.x - x).abs].min + (zone.land1.x - zone.land2.x).abs
  end

  def min_height_to_land(zone)
    (zone.land1.y - y).abs
  end

  def time_to_go_horizontal(zone)
    if in_wrong_direction?(zone) || hs == 0
      1000
    else
      # calcul distance to x / horizontal speed
      min_distance_to_land(zone) / hs.abs.to_f
    end
  end

  def time_to_go_vertical(zone)
    min_height_to_land(zone) / vs.abs.to_f
  end

  def position_to_land(time)
    x + time*hs.abs
  end

  def position_to_land_x(zone)
    min_time_to_go(zone)*hs + x
  end

  def position_to_land_y(zone)
    min_time_to_go(zone)*vs + y
  end

  def min_time_to_go(zone)
    [time_to_go_horizontal(zone), time_to_go_vertical(zone)].min
  end

  def get_in_zone?(zone)
    ((zone.land1.x + 1)..(zone.land2.x - 1)).include?(min_time_to_go(zone)*hs + x)
  end

  def go_to(zone)
    warn "zone to land : #{zone.land1}, #{zone.land2}"
    warn "time_to_go_horizontal: #{time_to_go_horizontal(zone)}"
    warn "time_to_go_vertical: #{time_to_go_vertical(zone)}"
    warn "position_to_land_x: #{position_to_land_x(zone)}"
    warn "get_in_zone: #{get_in_zone?(zone)}"

    # not on top of the zone
    unless on_top_of_zone?(zone)
      if in_wrong_direction?(zone) || go_to_fast_horizontaly?
        return [angle_to_slow, 4].join(' ')
      elsif go_to_slow_horizontaly?
        return [angle_to_aim(zone), 4].join(' ')
      else
        return [0, power_to_hover].join(' ')
      end
    else
      if close_to_land?(zone)
        return [0, 3].join(' ')
      elsif safe_speed
        return [0, 2].join(' ')
      else
        return [angle_to_slow, 4].join(' ')
      end
    end
  end

  def safe_speed
    hs.abs < MAX_DX - 5 && vs.abs < MAX_DY - 5
  end

  def power_to_hover
    warn "power to hover #{vs.abs}"
    vs >= 0 ? 3 : 4
  end

  def close_to_land?(zone)
    y < zone.land1.y + 100
  end

  ##
  # Check if the lander is on top of the zone
  def on_top_of_zone?(zone)
    (zone.land1.x..zone.land2.x).include?(x)
  end

  def go_to_fast_horizontaly?
    hs.abs > 4*MAX_DX
  end

  def go_to_slow_horizontaly?
    hs.abs < 2*MAX_DX
  end

  def angle_to_aim(zone)
    angle = (
      (Math.cos(GRAVITY / 4) * 180) / Math::PI
    ).ceil
    if x < zone.land1.x
      -angle
    else
      angle
    end
  end

  def angle_to_slow
    warn "hs**2 + vs**2 : #{hs**2 + vs**2}"
    warn "sqrt hs**2 + vs**2 : #{Math.sqrt(hs**2 + vs**2)}"
    (
                Math.asin(hs / Math.sqrt(hs**2 + vs**2).to_f) * 180 / Math::PI
    ).to_i
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
  warn "lands to land : #{lands_to_land}"

  loop do
    # HS: the horizontal speed (in m/s), can be negative.
    # VS: the vertical speed (in m/s), can be negative.
    # F: the quantity of remaining fuel in liters.
    # R: the rotation angle in degrees (-90 to 90).
    # P: the thrust power (0 to 4).
    $X, $Y, $HS, $VS, $F, $R, $P = gets.split(" ").collect {|x| x.to_i}
    lander = Lander.new($X, $Y, $HS, $VS, $F, $R, $P)
    warn "next position #{lander.next_position}"
    puts lander.go_to(lands_to_land)
    #puts "0 0" # R P. R is the desired rotation angle. P is the desired thrust power.
  end
end
