#!/usr/bin/ruby
require 'sorter'

nrand = 20
nmax = 1000

class Array
	def average
		self.inject(0.0){|t, e| t += e} / self.size
	end

	def stddev
		Math::sqrt(self.inject(0.0){|t, e| t+= e**2} / self.size - self.average**2)
	end
end

class TypedArray
	attr_reader :array, :type

	def initialize(array, type)
		@array = array
		@type = type
	end
end

sorted_array = (1..nmax).to_a
source_arrays = Array.new
source_arrays << TypedArray.new(sorted_array, 'sorted')
source_arrays << TypedArray.new(sorted_array.reverse, 'revers')
nrand.times do
	source_arrays << TypedArray.new(sorted_array.shuffle, 'random')
end

ios = Hash.new
Sorter.constants.each do |algorithm|
	path = "#{algorithm}.dat"
	unless File.exist?(path)
		ios[algorithm] = File.open("#{algorithm}.dat", "w")
		ios[algorithm].puts "#N comparison and moves for sorted, reverse sorted, average and sigma and each for random data"
	else
		ios[algorithm] = nil
	end
end

2.upto(nmax) do |n|
	Sorter.constants.each do |algorithm|
		if ios[algorithm]
			r = source_arrays.map do |e|
				Sorter.const_get(algorithm).new(e.array[0...n], e.type).sort!
			end
			crand = r[2..-1].map{|e| e.c}
			cav = crand.average
			csi = crand.stddev
			mrand = r[2..-1].map{|e| e.m}
			mav = mrand.average
			msi = mrand.stddev
			results = r[0...2].map{|e| [e.c, e.m]} + [cav, csi, mav, msi] + r[2..-1].map{|e| [e.c, e.m]}
			ios[algorithm].puts "#{n} #{results.flatten.join(' ')}"
		end
	end
end

ios.each_value{|io| io.close if io}
