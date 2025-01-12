# frozen_string_literal: true

class Node
  def initialize(value)
    @value = value
    @left = nil
    @right = nil
  end
  attr_accessor :value, :left, :right

  def add(val)
    if val < value
      add_to_left(val)
    else
      add_to_right(val)
    end
  end

  def add_to_left(node)
    if @left.nil?
      @left = Node.new(node)
    else
      @left.add(node)
    end
  end

  def add_to_right(node)
    if @right.nil?
      @right = Node.new(node)
    else
      @right.add(node)
    end
  end

  def to_s
    "#{value} -> l#{left&.to_s} -> r#{right&.to_s}"
  end

  def preorder
    results = [value]
    results << left.preorder unless left.nil?
    results << right.preorder unless right.nil?
    results
  end

  def inorder
    results = []
    results << left.inorder unless left.nil?
    results << value
    results << right.inorder unless right.nil?
    results
  end

  def postorder
    results = []
    results << left.postorder unless left.nil?
    results << right.postorder unless right.nil?
    results << value
    results
  end

  def levelorder
    results = []
    follow = [self]
    while !follow.empty?
      current = follow.shift
      results << current.value
      follow << current.left unless current.left.nil?
      follow << current.right unless current.right.nil?
    end
    results
  end
end

n = gets.to_i
tree = nil
gets.split.each do |input|
  unless tree
    tree = Node.new(input.to_i)
    next
  end
  tree.add(input.to_i)
end
warn tree.to_s

puts tree.preorder.flatten.join(" ")
puts tree.inorder.flatten.join(" ")
puts tree.postorder.flatten.join(" ")
puts tree.levelorder.flatten.join(" ")
