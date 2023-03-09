# frozen_string_literal: true

# A node for a balanced BST
class Node
  include Comparable
  attr_accessor :value, :left, :right

  def initialize(value = nil, left = nil, right = nil)
    @value = value
    @left = left
    @right = right
  end

  def to_s
    @value.to_s
  end

  def <=>(other)
    @value <=> other.value
  end
end
