#!/usr/bin/ruby
#
# A sandbox to test partition sort
#
# Copyright 2008 by zunda <zunda at freeshell.org>
#
# Permission is granted for use, copying, modification,
# distribution, and distribution of modified versions of this
# work as long as the above copyright notice is included.
#

require 'sorter'

class String
	def color(color)
		sgr = {
			:normal => 0,
			:black => 0,
			:red => 1,
			:green => 2,
			:yello => 3,
			:blue => 4,
			:magenta => 5,
			:cyan => 6,
			:white => 7,
			:reset => 9,
		}
		self.replace("\e[3#{sgr[color]}m#{self}\e[m")
	end

	def underline
		self.replace("\e[4m#{self}\e[m")
	end
end

class Array
	def with_em(i, j, x)
		idx = 0
		self.map do |e|
			str = '%2d' % e
			str.color(:red) if x == e
			str.color(:green).underline if idx == i or idx == j
			idx += 1
			str
		end.join(' ')
	end

	def partitioned?(x, l = nil, r = nil)
		result = self.index(x)
		if result
			(l ? l : 0).upto(result - 1) do |i|
				if self[i] > x
					result = false
					break
				end
			end
		end
		if result
			(result + 1).upto(r ? r : self.size - 1) do |i|
				if self[i] < x
					result = false
					break
				end
			end
		end
		result
	end
end

orig = [44, 55, 12, 42, 94, 06, 18, 67]
0.upto(orig.size - 1) do |ix|
	s = Sorter::Partition.new(orig)
	k = s[ix]
	s.partition(ix) do |ary, i, j, x|
		puts ary.with_em(i, j, x)
	end
	puts "%s after %d comparisons and %s assignments" % [s.partitioned?(k) ? 'OK'.color(:green) : 'NG'.color(:red), s.c, s.m]
	puts
end

s = Sorter::Partition.new(orig)
ix = 3
l = 2
r = 6
k = s[ix]
s.partition(ix, l, r) do |ary, i, j, x|
	puts ary.with_em(i, j, x)
end
puts "%s after %d comparisons and %s assignments" % [s.partitioned?(k, l, r) ? 'OK'.color(:green) : 'NG'.color(:red), s.c, s.m]
puts

s = Sorter::Partition.new([2, 1, 1, 1, 1, 1, 2])
ix = 3
k = s[ix]
s.partition(ix) do |ary, i, j, x|
	puts ary.with_em(i, j, x)
end
puts "%s after %d comparisons and %s assignments" % [s.partitioned?(k) ? 'OK'.color(:green) : 'NG'.color(:red), s.c, s.m]
puts

s = Sorter::Partition.new(orig)
puts s.with_em(nil, nil, nil)
s.partition(nil, 0, s.size - 1) do |ary, i, j, x|
	puts ary.with_em(i, j, x)
end
puts

s = Sorter::Partition.new(orig)
s.sort! do |ary, i, j, x|
	puts ary.with_em(i, j, x)
end
