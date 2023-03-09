# frozen_string_literal: true

require_relative './lib/balanced_bst'

bst = BalancedBST.new(Array.new(15) { rand(1..100) })
bst.pretty_print

puts 'Balanced?'
puts bst.balanced?

puts "\nLevelorder:"
bst.level_order { |node| print "#{node} " }
puts "\nPreorder:"
bst.preorder { |node| print "#{node} " }
puts "\nPostorder:"
bst.postorder { |node| print "#{node} " }
puts "\nInorder:"
bst.inorder { |node| print "#{node} " }
puts ''

5.times { bst.insert(rand(101..200)) }
bst.pretty_print

puts 'Balanced?'
puts bst.balanced?

bst.rebalance
bst.pretty_print


puts 'Balanced?'
puts bst.balanced?

puts "\nLevelorder:"
bst.level_order { |node| print "#{node} " }
puts "\nPreorder:"
bst.preorder { |node| print "#{node} " }
puts "\nPostorder:"
bst.postorder { |node| print "#{node} " }
puts "\nInorder:"
bst.inorder { |node| print "#{node} " }
puts ''
