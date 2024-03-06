# frozen_string_literal: true
STDOUT.sync = true # DO NOT REMOVE
# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.

all_links = []
all_nodes = {}

class Link
  def initialize(n1, n2)
    @n1 = n1
    @n2 = n2
    @n1.links << self
    @n2.links << self
    @shutdown = false
  end

  def other_node_of(node)
    return n1 if n2 == node
    return n2 if n1 == node
    nil
  end


  def shutdown!
    @shutdown = true
  end
  attr_reader :n1, :n2, :shutdown

  def has_gateway?
    n1.gateway || n2.gateway
  end

  def to_s
    "#{n1.index} #{n2.index}"
  end
end

class Node
  def initialize(index)
    @index = index
    @links = []
  end
  attr_reader :gateway, :index, :links

  def gateway!
    @gateway = true
  end

  def nb_links_to_gateway
    links.select{|l| l.has_gateway? && !l.shutdown }.size
  end

  def risky?
    nb_links_to_gateway > 0 && !gateway
  end

  def big_risky?
    nb_links_to_gateway > 1 && !gateway
  end

  def link_near_gateway
    links.each do |link|
      return link if link.has_gateway? && !link.shutdown
    end
    nil
  end

  def inspect
    "#{index} / #{gateway}"
  end
end

class AllPath
  def initialize(start, nodes)
    @start = start
    @nodes = nodes
    @paths = {}
  end
  attr_reader :start, :nodes

  def process_path
    size_path = $N
    queue = [[start, []]]
    @paths = {start => []}
    visited = []
    while queue.any?
      node, path = queue.shift
      next if visited.include?(node.index)
      visited << node.index
      if !node.risky? && node != start
        @paths[node] = path + [node]
      else
        @paths[node] = path
      end
      node.links.each do |link|
        child = link.other_node_of(node)
        queue << [child, @paths[node]] unless child.gateway
      end
    end
  end

  def shortest
    warn 'process start'
    process_path
    warn 'process finish'
    warn 'all path : ' + @paths.inspect
    risky_node = nil
    min_path = $N
    @paths.each do |node, path|
      next if node.index == start.index

      not_risky_path_size = path.select{|n| !n.risky? }.size
      warn "node : #{node.index} size : #{not_risky_path_size}"
      if not_risky_path_size < min_path && node.big_risky?
        risky_node = node
        min_path = not_risky_path_size
      end
    end
    risky_node
  end

end

# N: the total number of nodes in the level, including the gateways
# L: the number of links
# E: the number of exit gateways
#
$N, $L, $E = gets.split(" ").collect {|x| x.to_i}
$L.times do
  # N1: N1 and N2 defines a link between these nodes
  n1, n2 = gets.split(" ").collect {|x| x.to_i}

  all_nodes[n1] ||= Node.new(n1)
  all_nodes[n2] ||= Node.new(n2)

  all_links << Link.new(
    all_nodes[n1], all_nodes[n2]
  )
end

$E.times do
   gateway = gets.to_i # the index of a gateway node
   all_nodes[gateway].gateway!
end


# game loop
loop do
  si = gets.to_i # The index of the node on which the Skynet agent is positioned this turn
  # warn all_nodes.keys.inspect
  # warn si
  si_node = all_nodes[si]

  ## if the si to 1 step of gateway shutdown the link
  link_near_gateway = si_node.link_near_gateway
  if link_near_gateway
    link_near_gateway.shutdown!
    puts link_near_gateway
    next
  end

  ## How many links to gateway
  risky_nodes = all_nodes.values.select{|n| n.big_risky? }

  warn "risky_node : " + risky_nodes.map(&:gateway).inspect
  warn "risky_node : " + risky_nodes.map(&:index).inspect
  if risky_nodes.any?
    node = AllPath.new(si_node, risky_nodes).shortest
    warn "node shortest : " + node.inspect
    if node
      link = node.link_near_gateway
      puts link
      link.shutdown!
      next
    end
  end

  ## Take a random link because we have time
  link = all_links.select{|l| l.has_gateway? && !l.shutdown }.first
  puts link
  link.shutdown!
end

