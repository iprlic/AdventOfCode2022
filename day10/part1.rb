#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path).split("\n").map do |line| 
    l = line.split(" ") 
    cmd = l[0]
    val = nil
    val = l[1].to_i if cmd != 'noop'
    {
        cmd: cmd,
        val: val,
    }
end


total = 0
cycle = 0
x = 1
checkpoints = [20, 60, 100, 140, 180, 220]

input.each do |line|
    cycle += 1

    if checkpoints.include?(cycle)
        total += cycle * x
    end

    if line[:cmd] == 'addx'
        
        cycle += 1
        if checkpoints.include?(cycle)
            total += cycle * x
        end
        x += line[:val]        
    end
end

puts total