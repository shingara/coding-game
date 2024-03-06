
# Class to manage the Graph link of each node

class Vertex
  def initialize(name)
    @name = name
  end
  attr_accessor :name

  def ==(other)
    self.name == other.name
  end

  def <=>(other)
    self.name <=> other.name
  end
end

class Edge
  def initialize(v1, v2)
    @v1 = v1
    @v2 = v2
    @discovered = false
  end
  attr_accessor :discovered, :v1, :v2

  def to_s
    "Edge: #{v1.name} - #{v2.name} (#{discovered})"
  end

  def adjacent(other)
    [v1, v2].include?(other.v1) || [v1, v2].include?(other.v2)
  end
end

class Continent
  def initialize(edges)
    @edges = edges
  end
  attr_accessor :edges

  def vertices
    @vertices ||= edges.map { |e| [e.v1.name, e.v2.name] }.flatten.uniq
  end

  def total_tiles
    (edges.size - vertices.size) + 1
  end
end

class Graph
  def initialize
    @edges = []
    @continents = []
  end
  attr_accessor :edges, :continents

  def add(edge)
    self.edges << edge
  end

  ## Mark all edge discovered link to this root in this graph
  def DFS(root)
    root.discovered = true
    self.edges.each do |edge|
      next if edge == root || edge.discovered
      next unless edge.adjacent(root)
      DFS(edge)
    end
  end

  def discover_continent
    edges.each do |edge|
      already_discovered = edges.select { |e| e.discovered }.compact
      unless edge.discovered
        DFS(edge)
        # extract only new edges discovered
        discovered = edges.select { |e| e.discovered }.compact - already_discovered
        continents << Continent.new(discovered)
      end
    end
  end

end

e = gets.to_i
graph = Graph.new
e.times do
  n_1, n_2 = gets.split.map { |x| x.to_i }
  graph.add(Edge.new(Vertex.new(n_1), Vertex.new(n_2)))
end
graph.discover_continent
puts [graph.continents.size, graph.continents.map(&:total_tiles).sum].join(' ')
