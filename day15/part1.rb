#!/usr/bin/env ruby
# frozen_string_literal: true

def manhattan_distance(x1, y1, x2, y2)
   (x1 - x2).abs + (y1 - y2).abs
end

def in_reach?(x1, y1, distance, target_x, target)
   x2 = target_x
   y2 = target
   manhattan_distance(x1, y1, x2, y2) <= distance
end

file_path = File.expand_path('input.txt', __dir__)

target = 2000000

input = File.read(file_path).split("\n").map do |line|
   ls = line.split(' ')

   x1 = ls[2].chop.split('=')[1].to_i
   y1 = ls[3].chop.split('=')[1].to_i

   x2 = ls[8].chop.split('=')[1].to_i
   y2 = ls[9].split('=')[1].to_i

   {
        x1: x1,
        y1: y1,
        x2: x2,
        y2: y2
   }
end

target_no_beacons = {}
target_scanner_or_beacon = {}

input.each do |pair|
    x1 = pair[:x1]
    y1 = pair[:y1]
    x2 = pair[:x2]
    y2 = pair[:y2]

    key1 = "#{x1},#{y1}"
    key2 = "#{x2},#{y2}"

    target_scanner_or_beacon[key1] = true
    target_scanner_or_beacon[key2] = true

    distance = manhattan_distance(x1, y1, x2, y2)

    reachable = true
    target_x = x1

    while reachable do
        reachable = in_reach?(x1, y1, distance, target_x, target)
        target_no_beacons["#{target_x},#{target}"] = true if reachable
        target_x += 1
    end   

    reachable = true
    target_x = x1

    while reachable do
        reachable = in_reach?(x1, y1, distance, target_x, target)
        target_no_beacons["#{target_x},#{target}"] = true if reachable
        target_x -= 1
    end  

end

puts (target_no_beacons.keys - target_scanner_or_beacon.keys).size
