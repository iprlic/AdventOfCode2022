#!/usr/bin/env ruby
# frozen_string_literal: true
file_path = File.expand_path('input.txt', __dir__)

valves = {}

input = File.read(file_path).split("\n").map do |line|
    vl = line.split(/; tunnels? leads? to valves? /)

    valve = vl[0].split(' ')[1]
    rate = vl[0].split(' ')[4].split('=')[1].to_i
    leads_to = vl[1].split(', ')

    {
        valve: valve,
        rate: rate,
        leads_to: leads_to
    }
end

input.each do |v|
    valves[v[:valve]] = {
        rate: v[:rate],
        leads_to: v[:leads_to]
    }
end

memo = [{move: 1, valve:"AA", score: 0, open:[]}]
visited = {}
m = 0

while memo.size > 0
    current = memo.pop

    key = "#{current[:valve]}-#{current[:move]}"

    next if !visited[key].nil? && visited[key] >= current[:score]

    visited[key] = current[:score]

    if current[:move] == 30
        m = [m, current[:score]].max
        next
    end

    # open valve
    if valves[current[:valve]][:rate] > 0 && !current[:open].include?(current[:valve])
        current[:open].push(current[:valve])
        new_b = current[:score] + current[:open].map{|v| valves[v][:rate]}.sum
        memo.push({move: current[:move]+1, valve: current[:valve], score: new_b, open: current[:open].dup})
        
        # reset for next step (not opening)
        current[:open].delete(current[:valve])
    end

    #don't open valve
    new_b = current[:score] + current[:open].map{|v| valves[v][:rate]}.sum
    valves[current[:valve]][:leads_to].each do |v|
        memo.push({move: current[:move]+1, valve: v, score: new_b, open: current[:open].dup})
    end
end

puts m


