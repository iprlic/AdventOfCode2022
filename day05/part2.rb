#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path).split("\n\n")

stacks_raw = input[0].split("\n")
moves = input[1].split("\n").map{|e| e.split(" ").select.with_index{|_, i| [1,3,5].include?(i)}.map(&:to_i) }


stack_len = stacks_raw.last.split(" ").size
stacks_raw = stacks_raw.reverse.drop(1)
stacks = Array.new(stack_len){[]}


stacks_raw.each do |s|
    s.chars.each_with_index do |e, index|
        stacks[index / 4].push(e) if index % 4 == 1 && e != " "
    end
end

moves.each do |m|
    pops = stacks[m[1]-1].pop(m[0])
    stacks[m[2]-1].push(*pops)
end

stacks.each do |s|
    print s.last
end
puts