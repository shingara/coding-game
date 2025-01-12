# frozen_string_literal: true
STDOUT.sync = true # DO NOT REMOVE
# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.

gateways =  []
links = []
siblings = {}


def path(gateway, siblings, botnet)
  path  = []
  see = []
  path << gateway
  see << gateway
  edge_of = {}
  while !path.empty?
    next_node = path.shift
    siblings[next_node].each do |sibling|
      if !see.include?(sibling)
        see << sibling
        path << sibling
        edge_of[sibling] = next_node
      end
    end
  end
  length = 0
  previous_node = botnet
  while previous_node != gateway
    previous_node = edge_of[previous_node]
    length += 1
  end
  return edge_of[botnet], length
end


# N: the total number of nodes in the level, including the gateways
# L: the number of links
# E: the number of exit gateways
$N, $L, $E = gets.split(" ").collect {|x| x.to_i}
$L.times do
  # N1: N1 and N2 defines a link between these nodes
  n1, n2 = gets.split(" ").collect {|x| x.to_i}
  links << [n1, n2]
  siblings[n1] ||= []
  siblings[n1] << n2

  siblings[n2] ||= []
  siblings[n2] << n1
end
$E.times do
  gateways << gets.to_i # the index of a gateway node
end

# game loop
loop do
  $SI = gets.to_i # The index of the node on which the Skynet agent is positioned this turn


  # Write an action using puts
  # To debug: STDERR.puts "Debug messages..."

  results = []
  gateways.each do |gateway|
    node_associate, length = path(gateway, siblings, $SI)
    results << [node_associate, length]
  end
  node_associate = results.sort_by! {|x| x[1]}.first[0]
  puts "#{node_associate} #{$SI}" # Example: 0 1 are the indices of the nodes you wish to sever the link between
end
