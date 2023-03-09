# frozen_string_literal: true

require_relative './node'

# A balanced binary search tree
class BalancedBST
  attr_reader :root

  def initialize(array)
    @root = build_tree(array.uniq.sort)
  end

  def build_tree(array)
    mid_idx = array.length / 2

    root = Node.new(array[mid_idx])
    left_array = array[0...mid_idx]
    right_array = array[mid_idx + 1...array.length]

    root.left = build_tree(left_array) unless left_array.empty?
    root.right = build_tree(right_array) unless right_array.empty?

    root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def find(value, root = @root)
    if value == root.value
      root
    elsif value < root.value && !root.left.nil?
      find(value, root.left)
    elsif value > root.value && !root.right.nil?
      find(value, root.right)
    end
  end

  def insert(value, root = @root)
    if value == root.value
      root
    elsif value < root.value
      if root.left.nil?
        root.left = Node.new(value)
      else
        insert(value, root.left)
      end
    elsif value > root.value
      if root.right.nil?
        root.right = Node.new(value)
      else
        insert(value, root.right)
      end
    end
  end

  def delete(value, root = @root)
    # Special case: Node is root of BST -> delete Node and update @root
    if value == root.value
      to_delete = root

      @root = if to_delete.left.nil? && to_delete.right.nil?
                nil
              elsif to_delete.left.nil? && !to_delete.right.nil?
                to_delete.right
              elsif !to_delete.left.nil? && to_delete.right.nil?
                to_delete.left
              else
                delete_with_two_children(to_delete)
              end

    # Node is left child of current root -> delete Node and update root.left
    elsif !root.left.nil? && value == root.left.value
      delete_left_child(root)
    # Node is right child of current root -> ´delete Node and update root.right
    elsif !root.right.nil? && value == root.right.value
      delete_right_child(root)
    # Node value is greater than value -> delete in left subtree
    elsif value < root.value && !root.left.nil?
      delete(value, root.left)
    # Node value is smaller than value -> delete in right subtree
    elsif value > root.value && !root.right.nil?
      delete(value, root.right)
    end
  end

  def level_order(roots = [@root], &block)
    next_roots = []

    roots.each do |root|
      next_roots << root.left unless root.left.nil?
      next_roots << root.right unless root.right.nil?
      yield root
    end

    level_order(next_roots, &block) unless next_roots.empty?
  end

  def inorder(node = @root, &block)
    inorder(node.left, &block) unless node.left.nil?
    yield node
    inorder(node.right, &block) unless node.right.nil?
  end

  def preorder(node = @root, &block)
    yield node
    preorder(node.left, &block) unless node.left.nil?
    preorder(node.right, &block) unless node.right.nil?
  end

  def postorder(node = @root, &block)
    postorder(node.left, &block) unless node.left.nil?
    postorder(node.right, &block) unless node.right.nil?
    yield node
  end

  # h_left and h_right for leaves is set to -1 so a leave is defined as height 0
  def height(node = @root)
    if node.nil?
      -1
    else
      h_left = height(node.left)
      h_right = height(node.right)

      h_left > h_right ? h_left + 1 : h_right + 1
    end
  end

  # TODO: depth
  def depth(node = @root)
    if node == @root
      0
    else
      previous_node = @root
      found = false

      until found
        if previous_node.left == node || previous_node.right == node
          found = true
        elsif node < previous_node
          previous_node = previous_node.left
        else
          previous_node = previous_node.right
        end
      end

      depth(previous_node) + 1
    end
  end

  # TODO: balanced?
  def balanced?
    balanced = true
    nodes = []
    inorder { |node| nodes << node }

    nodes.each do |node|
      h_left = height(node.left)
      h_right = height(node.right)
      dif_h = h_left - h_right
      balanced = false if dif_h.abs > 1
    end

    balanced
  end
  # TODO: rebalance
  def rebalance
    return if balanced?

    values = []
    inorder { |node| values << node.value }

    @root = build_tree(values)
  end

  private

  def delete_with_two_children(to_delete)
    current_pos = to_delete.right

    if current_pos.left.nil?
      tmp = current_pos
      delete(tmp.value, current_pos)
      tmp.left = to_delete.left
    else
      current_pos = current_pos.left until current_pos.left.left.nil?
      tmp = current_pos.left
      delete(tmp.value, current_pos)
      tmp.left = to_delete.left
      tmp.right = to_delete.right
    end

    tmp
  end

  def delete_right_child(root)
    to_delete = root.right

    root.right = if to_delete.left.nil? && to_delete.right.nil?
                   nil
                 elsif to_delete.left.nil? && !to_delete.right.nil?
                   to_delete.right
                 elsif !to_delete.left.nil? && to_delete.right.nil?
                   to_delete.left
                 else
                   delete_with_two_children(to_delete)
                 end
  end

  def delete_left_child(root)
    to_delete = root.left

    root.left = if to_delete.left.nil? && to_delete.right.nil?
                  nil
                elsif to_delete.left.nil? && !to_delete.right.nil?
                  to_delete.right
                elsif !to_delete.left.nil? && to_delete.right.nil?
                  to_delete.left
                else
                  delete_with_two_children(to_delete)
                end
  end
end
