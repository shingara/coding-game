STDOUT.sync = true
class Zone < Struct.new(:nb_floors, :width, :exit_floor, :exit_pos, :elevators)

    def good_direction?(clone)
        if clone.direction == "RIGHT"
            clone.pos - 1 < elevator_position(clone.floor)
        else
            clone.pos + 1 > elevator_position(clone.floor)
        end
    end

    def elevator_position(floor)
        elevator = elevators.select{|e| e[0] == floor }.first
        if elevator.nil? || floor == exit_floor
            exit_pos
        else
            elevator[1] || exit_floor
        end
    end

end

class Clone < Struct.new(:floor, :pos, :direction)
end

$nbFloors, $width, $nbRounds, $exitFloor, $exitPos, $nbTotalClones, $nbAdditionalElevators, $nbElevators = gets.split(" ").collect {|x| x.to_i}

elevators = []
$nbElevators.times do
    elevators << gets.split(" ").collect {|x| x.to_i} #elevator is an Array
end

zone = Zone.new($nbFloors, $width, $exitFloor, $exitPos, elevators)

# game loop
loop do
    $cloneFloor, $clonePos, $direction = gets.split(" ")
    $cloneFloor = $cloneFloor.to_i
    $clonePos = $clonePos.to_i
    clone = Clone.new($cloneFloor, $clonePos, $direction)

    if clone.pos == zone.width - 1 || clone.pos == 0 || !zone.good_direction?(clone)
        puts "BLOCK"
    else
        puts "WAIT" # action: WAIT or BLOCK
    end
end
