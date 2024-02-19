STDOUT.sync = true

nf, w, _, ef, ep, _, _, ne = gets.split(" ").collect{|i| i.to_i}
elevators = {ef => ep}
ne.times{e,p=gets.split(" "); elevators[e.to_i] = p.to_i}

loop do
    clone = gets.split(" ") # [$cloneFloor.to_i, $clonePos.to_i, $direction] #clone is an Array clone[0] = floor, clone[1] = pos, clone[2] = direction
    good_direction = clone[2] == "RIGHT" ? clone[1].to_i - 1 < elevators[clone[0].to_i] : clone[1].to_i + 1 > (elevators[clone[0].to_i] || 0)
    puts ([w-1, 0].include?(clone[1].to_i) || !good_direction) ? "BLOCK" : "WAIT"
end
