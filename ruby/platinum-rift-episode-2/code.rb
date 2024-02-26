STDOUT.sync = true # DO NOT REMOVE
# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.

def debug x
    STDERR.puts x
end

class Zone
    def initialize(id, platinum_source)
        @id, @platinium = id, platinum_source
    end
    attr_reader :id, :links, :owner
    attr_reader :podsP0, :podsP1, :visible, :platinum

    def associate(zone)
        @links ||= []
        @links << zone
    end

    def update(owner, podsP0, podsP1, visible, platinum)
        @owner, @podsP0, @podsP1 = owner, podsP0, podsP1
        @visible, @platinum = visible, platinum
        @my_pods, @ennemy_pods = nil, nil
    end

    def visible?; @visible == 1; end

    def opponent?; @owner != $myId && !neutral?; end

    def neutral?; @owner == -1; end

    def mine?; @owner == $myId; end

    def no_pod?; !has_ennemy_pod? && !has_my_pod?; end

    def has_my_pod?; my_pods > 0; end

    def has_ennemy_pod?; ennemy_pods > 0; end

    def my_pods
        @my_pods ||= $myId == 0 ? send("podsP0") : send("podsP1")
    end

    def ennemy_pods
        @ennemy_pods ||= $myId == 0 ? send("podsP1") : send("podsP0")
    end

    def links_zone
        links.map { |i| $area.zones[i] }
    end

    def link_with_most_platinum
        links_zone.sort_by { |z| z.platinum }.last
    end
end

class Area
    def zones
        @zones ||= {}
    end

    def add_zone(zone)
        zones[zone.id] = zone
      # p zone.id
    end

    def associate(zone_1, zone_2)
        zones[zone_1].associate(zone_2)
        zones[zone_2].associate(zone_1)
    end

    ##
    # define the object opponent_base
    # if define not reassigne it
    def select_opponent_base
        return true if @opponent_base_id

        @opponent_base_id = zones.values.select { |z| z.visible? && z.opponent? }.first
    end

    ##
    # define the object my_base
    # if define not reassigne it
    def select_my_base
        return true if @my_base_id

        debug "visible : #{zones.values.select { |z| z.visible? }.map{|z| [z.id, z.owner] }}"

        @my_base_id = zones.values.select { |z| z.visible? && z.mine? }.first
    end

    def quick_path
        debug "my base :#{@my_base_id.inspect}"
        debug "my opponent : #{@opponent_base_id.inspect}"
        @quick_path ||= Path.new(@my_base_id.id, @opponent_base_id.id).generate
    end


    def zone_with_pod
        zones.values.select { |z| z.visible? && z.my_pods > 0 }
    end

    def move
        @move = []
        zone_with_pod.each do |z|
            STDERR.puts z.inspect
            @move << [z.my_pods, z.id, quick_path[quick_path.index(z.id) + 1]]
        end
        @move.join(" ")
    end
end

class Path
    def initialize(from, to)
        @from, @to = from, to
    end
    attr_reader :from, :to

    def open_list
        @open_list ||= [from]
    end

    def closed_list
        @closed_list ||= []
    end

    def save_path(parent)
        n = to
        @best_path = []
        while parent[n] != n
            @best_path << n
            n = parent[n]
        end
        @best_path << from
        @best_path.reverse
    end

    def generate
        parent = { from => from }
        distance = { from => 0 }
        while !open_list.empty?
            n = nil
            open_list.each do |v|
                if n.nil? ||
                   distance[v] < distance[n]
                    n = v
                end

                raise 'No path' if n.nil?

                return save_path(parent) if n == to

                $area.zones[n].links.each do |link|
                    if !open_list.include?(link) &&
                       !closed_list.include?(link)
                        open_list << link
                        parent[link] = n
                        distance[link] = distance[n] + 1 # consider only 1 more distance
                    else
                        if distance[link] + 1 > distance[n] # Cost of the move
                            distance[link] = distance[n] + 1
                            parent[link] = n

                            if closed_list.include?(link)
                                closed_list.delete(link)
                                open_list << link
                            end
                        end
                    end
                end
                open_list.delete(n)
                closed_list << n
            end
        end
    end
end

# playerCount: the amount of players (always 2)
# myId: my player ID (0 or 1)
# zoneCount: the amount of zones on the map
# linkCount: the amount of links between all zones
$playerCount, $myId, $zoneCount, $linkCount = gets.split(" ").collect { |x| x.to_i }

$area = Area.new
$zoneCount.times do
    # zoneId: this zone's ID (between 0 and zoneCount-1)
    # platinumSource: Because of the fog, will always be 0
    $zoneId, $platinumSource = gets.split(" ").collect { |x| x.to_i }
    $area.add_zone Zone.new($zoneId, $platinumSource)
end
$linkCount.times do
    $zone1, $zone2 = gets.split(" ").collect { |x| x.to_i }
    $area.associate($zone1, $zone2)
end
# STDERR.puts area.zones
# game loop
loop do
    $myPlatinum = gets.to_i # your available Platinum
    $zoneCount.times do
        # zId: this zone's ID
        # ownerId: the player who owns this zone (-1 otherwise)
        # podsP0: player 0's PODs on this zone
        # podsP1: player 1's PODs on this zone
        # visible: 1 if     one of your units can see this tile, else 0
        # platinum: the amount of Platinum this zone can provide (0 if hidden by fog)
        $zId, $ownerId, $podsP0, $podsP1, $visible, $platinum = gets.split(" ").collect { |x| x.to_i }
        debug "visible => #{$zId}/ #{$ownerId}" if $visible == 1
        # STDERR.puts $zId
        # STDERR.puts area.zones.keys
        # STDERR.puts "next"
        $area.zones[$zId].update($ownerId, $podsP0, $podsP1, $visible, $platinum)
    end

    $area.select_opponent_base
    $area.select_my_base

    # Write an action using puts
    # To debug: STDERR.puts "Debug messages..."

    puts $area.move

    # first line for movement commands, second line no longer used (see the protocol in the statement for details)
    puts "WAIT"
end
