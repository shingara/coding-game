
# Class to manage the Graph link of each node

require 'set'
class Link
  attr_accessor :node, :next

  def initialize(node)
    @node = node
    @siblings = Set.new
  end
  attr_accessor :siblings

  def add(node)
    siblings.add(node)
  end
end

class Graph
  def initialize
    @nodes = {}
  end

  def add_link(n1, n2)
    @nodes[n1] ||= Link.new(n1)
    @nodes[n1].add(n2)

    @nodes[n2] ||= Link.new(n2)
    @nodes[n2].add(n1)
  end
end

e = gets.to_i
graph = Graph.new
e.times do
  n_1, n_2 = gets.split.map { |x| x.to_i }
  graph.add_link(n_1, n_2)
end

STDERR.puts graph.inspect
