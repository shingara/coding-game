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
  to_cut = nil
  while previous_node != gateway && !previous_node.nil?
    to_cut = previous_node
    previous_node = edge_of[previous_node]
    length += 1 if previous_node
  end
  return to_cut, length
end

def node_with_several_gateway(gateways, siblings)
  gateways.map{|g| siblings[g] }.flatten.group_by{|x| x}.select{|k, v| v.size > 1}.keys
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

def result_of(gateways, siblings)
  results = {}
  gateways.each do |gateway|
    STDERR.puts "Gateway: #{gateway}"
    node_associate, length = path(gateway, siblings, $SI)
    if length > 0
      results[length] ||= {}
      results[length][node_associate] ||= []
      results[length][node_associate] << gateway
    end
  end
  STDERR.puts "Results: #{results}"
  min_length = results.keys.min
  return results, min_length
end


# game loop
loop do
  $SI = gets.to_i # The index of the node on which the Skynet agent is positioned this turn


  # Write an action using puts
  # To debug: STDERR.puts "Debug messages..."

siblings.each do |k, v|
STDERR.puts "Siblings: #{k} ->#{v}"
end

default_results, default_min_length = result_of(gateways, siblings)
if default_min_length > 1
  weak_nodes = node_with_several_gateway(gateways, siblings)
  results, min_length = result_of(weak_nodes, siblings)
  unless results.keys.empty?
    max_links = results[min_length].values.map(&:sum).max
    choice = results[min_length].select {|k, v| v.sum == max_links}.first
    STDERR.puts "Choice: #{choice}"
    gateway = gateways.select do |sib|
      siblings[sib].include?(choice[1].first)
    end.first

    puts "#{gateway} #{choice[1].first}" # Example: 0 1 are the indices of the nodes you wish to sever the link between

    siblings[gateway].delete(choice[1].first)
    siblings[choice[1].first].delete(gateway)
    next
  end
end

  max_links = default_results[default_min_length].values.map(&:sum).max
  choice = default_results[default_min_length].select {|k, v| v.sum == max_links}.first

  puts "#{choice[0]} #{choice[1].first}" # Example: 0 1 are the indices of the nodes you wish to sever the link between

  siblings[choice[0]].delete(choice[1].first)
  siblings[choice[1].first].delete(choice[0])

end
