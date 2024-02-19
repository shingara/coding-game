STDOUT.sync = true 
class Elevator < Struct.new(:floor, :pos)
end

class Zone < Struct.new(:nb_floors, :width, :exit_floor, :exit_pos, :elevators)
    
    def good_direction?(clone)
        if clone.direction == "RIGHT"
            clone.pos - 1 < elevator_position(clone.floor)
        else
            clone.pos + 1 > elevator_position(clone.floor)
        end
    end
    
    def elevator_position(floor)
        elevator = elevators.select{|e| e.floor == floor }.first
        if elevator.nil? || floor == exit_floor
            exit_pos
        else
            elevator.pos || exit_floor
        end
    end

end

class Game < Struct.new(:nb_rounds, :nb_total_clones)
end

class Clone < Struct.new(:floor, :pos, :direction)
end

$nbFloors, $width, $nbRounds, $exitFloor, $exitPos, $nbTotalClones, $nbAdditionalElevators, $nbElevators = gets.split(" ").collect {|x| x.to_i}



elevators = []
$nbElevators.times do
    # elevatorFloor: floor on which this elevator is found
    # elevatorPos: position of the elevator on its floor
    $elevatorFloor, $elevatorPos = gets.split(" ").collect {|x| x.to_i}
    elevators << Elevator.new($elevatorFloor, $elevatorPos)
end

game = Game.new($nbRounds, $nbTotalClones)
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