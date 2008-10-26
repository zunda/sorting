# = a library to play with sorting algorithms
# Copyright 2008 by zunda <zunda at freeshell.org>
#
# This program is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation, either version 3 of
# the License, or (at your option) any later version.
#

# additional methods to Array
class Array
	def shuffle
		self.sort_by{rand}
	end
end

module SorterBase
	# base class for sorting algorithms
	class SortingArray < Array
		attr_reader :sequence	# type of sequence
		attr_reader :n	# number of elements
		attr_reader :c	# number of comparisons
		attr_reader :m	# number of moves

		# specify type of sequence: random, sorted, reverse, etc., to _sequence_
		def initialize(array, sequence = nil)
			super(array)
			@n = self.size
			@c = nil
			@m = nil
			@sequence = sequence
		end

		# array itself, shortcut for implmentations of algorithms
		def a
			self
		end

		# returns true if sorted, false if not
		def sorted?
			0.upto(n - 2) do |i|
				return false if self[i] > self[i+1]
			end
			return true
		end
		
		# sort self with an algorithm to be given
		def sort!(&block)
			setup
			sorting_procedure(&block)
			teardown
			return self
		end

		private
		# to be called in the beginning of a sort
		def setup
			@c = 0
			@m = 0
		end

		# to be called on each comparison of elements
		def compare
			@c += 1
			yield
		end

		# to be called on each assignemnt/movement of elements
		def assign
			@m += 1
			yield
		end

		# to be called in the end of a sort
		def teardown
			raise "Sorting failed on #{self.sequence} data with #{self.class}" unless sorted?
		end
	end
end

module Sorter
	# Wirth 1976, p.61
	class StraightInsertion < SorterBase::SortingArray
		def sorting_procedure
			self.unshift('sentinel')
			x = nil
			2.upto(n) do |i|
				assign{x = a[i]}
				assign{a[0] = x}
				j = i - 1
				while compare{x < a[j]}
					assign{a[j+1] = a[j]}
					j = j - 1
				end
				assign{a[j+1] = x}
			end
			self.shift	# remove the sentinel
		end
	end

	# Wirth 1976, p.62
	class BinaryInsertion < SorterBase::SortingArray
		def sorting_procedure
			self.unshift('sentinel')
			x = nil
			2.upto(n) do |i|
				assign{x = a[i]}
				l = 1
				r = i - 1
				while l <= r
					m = (l+r)/2
					if compare{x < a[m]}
						r = m - 1
					else
						l = m + 1
					end
				end
				(i-1).downto(l) do |j|
					assign{a[j+1] = a[j]}
				end if i-1 >= l
				assign{a[l] = x}
			end
			self.shift	# remove the sentinel
		end
	end

	# Wirth 1976, p.64
	class StraightSelection < SorterBase::SortingArray
		def sorting_procedure
			self.unshift('dummy')
			x = nil
			1.upto(n-1) do |i|
				k = i
				assign{x = a[i]}
				(i+1).upto(n) do |j|
					if compare{a[j] < x}
						k = j
						assign{x = a[j]}
					end
				end
				assign{a[k] = a[i]}
				assign{a[i] = x}
			end
			self.shift	# remove dummy
		end
	end

	# Wirth 1976, p.66
	class Bubble < SorterBase::SortingArray
		def sorting_procedure
			self.unshift('dummy')
			x = nil
			2.upto(n) do |i|
				n.downto(i) do |j|
					if compare{a[j-1] > a[j]}
						assign{x = a[j-1]}
						assign{a[j-1] = a[j]}
						assign{a[j] = x}
					end
				end
			end
			self.shift	# remove dummy
		end
	end

	# Wirth 1976, p.67
	class Shake < SorterBase::SortingArray
		def sorting_procedure
			self.unshift('dummy')
			x = nil
			l = 2
			r = n
			k = n
			begin
				r.downto(l) do |j|
					if compare{a[j-1] > a[j]}
						assign{x = a[j-1]}
						assign{a[j-1] = a[j]}
						assign{a[j] = x}
						k = j
					end
				end
				l = k + 1
				l.upto(r) do |j|
					if compare{a[j-1] > a[j]}
						assign{x = a[j-1]}
						assign{a[j-1] = a[j]}
						assign{a[j] = x}
						k = j
					end
				end
				r = k - 1
			end until l > r
			self.shift	# remove dummy
		end
	end

	# Wirth 1976, p.70
	class Shell < SorterBase::SortingArray
		def sorting_procedure
			h = [9, 5, 3, 1]
			x = nil
			aa = Hash.new	# we will have to deal with array with minus index
			a.each_with_index{|e,i| aa[i+1] = e}
			h.each do |k|
				s = -k
				(k+1).upto(n) do |i|
					assign{x = aa[i]}
					j = i - k
					s = -k if s == 0
					s += 1
					assign{aa[s] = x}
					while compare{x < aa[j]}
						assign{aa[j+k] = aa[j]}
						j = j - k
					end
					assign{aa[j+k] = x}
				end
			end
			0.upto(n-1){|i| a[i] = aa[i+1]}
		end
	end

	# Wirth 1976, p.75
	class Heap < SorterBase::SortingArray
		def sorting_procedure
			self.unshift('dummy')
			l = (n/2) + 1
			r = n
			x = nil
			while l > 1
				l -= 1
				sift(l, r)
			end
			while r > 1
				assign{x = a[1]}
				assign{a[1] = a[r]}
				assign{a[r] = x}
				r -= 1
				sift(l, r)
			end
			self.shift	# remove dummy
		end

		def sift(l, r)
			x = nil
			i = l
			j = 2*i
			assign{x = a[i]}
			while j <= r
				j += 1 if j < r and compare{a[j] < a[j+1]}
				break if compare{x >= a[j]}
				assign{a[i] = a[j]}
				i = j
				j = 2*i
			end
			assign{a[i] = x}
		end
	end

	# Wirth 1976, p.77
	class Partition < SorterBase::SortingArray
		# this version sometimes fails when key is moved
		def partition_wirth(ix = nil)	# supply ix (zero origin) to specify key element
			setup unless @m and @c
			i = 1
			j = n
			x = nil
			assign{x = a[ix || (rand(n) + 1)]}
			self.unshift('dummy')
			yield(self[1..-1], i - 1, j - 1, x) if block_given?
			begin
				while compare{a[i] < x}
					i += 1
				end
				while compare{x < a[j]}
					j -= 1
				end
				if i <= j
					w = nil
					assign{w = a[i]}
					assign{a[i] = a[j]}
					assign{a[j] = w}
					yield(self[1..-1], i - 1, j - 1, x) if block_given?
					i += 1
					j -= 1
				else
					yield(self[1..-1], i - 1, j - 1, x) if block_given?
				end
			end until i > j
			yield(self[1..-1], i - 1, j - 1, x) if block_given?
			self.shift	# remove dummy
		end

		# this version seems to work with more comparisons and assignments
		def partition(ix = nil, l = nil, r = nil)	# supply ix (zero origin) to specify key element, l and r (zero origin) as range of array to be partitioned
			setup unless @m and @c
			i = l || 0
			j = r || n - 1
			x = nil
			unless ix
				if l and r
					ix = (l + r) / 2
				else
					ix = rand(n)
				end
			end
			assign{x = a[ix]}
			yield(self, i, j, x) if block_given?
			while true
				while compare{a[i] < x}
					i += 1
				end
				while compare{x < a[j]}
					j -= 1
				end
				break if i == j or compare{a[i] == a[j]}
				if i < j
					w = nil
					assign{w = a[i]}
					assign{a[i] = a[j]}
					assign{a[j] = w}
				end
				yield(self, i, j, x) if block_given?
			end
			[i, j]
		end

		def recursive_sort(l, r, &block)	# zero origin
			yield(self, l, r, nil) if block_given?
			if l < r
				i, j = partition(nil, l, r, &block)
				recursive_sort(l, i - 1, &block)
				recursive_sort(j + 1, r, &block)
			end
		end

		def sorting_procedure(&block)
			recursive_sort(0, n - 1, &block)
		end
	end
end

if __FILE__ == $0
	require 'test/unit'

	class ArrayTest < Test::Unit::TestCase
		def test_shuffle
			original = (1..100).to_a
			shuffled = original.shuffle
			assert_equal(original.size, shuffled.size)
			assert_equal(original.sort, shuffled.sort)
			assert_equal(original.sort.uniq, shuffled.sort.uniq)
			assert_not_equal(original, shuffled)	# this might fail
		end
	end
end
