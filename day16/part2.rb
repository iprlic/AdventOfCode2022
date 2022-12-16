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

memo = [{move: 1, my_valve:"AA", elephant_valve: "AA", score: 0, open:[]}]
visited = {}

m = 0

while memo.size > 0
    current = memo.pop

    key = "#{current[:my_valve]}-#{current[:elephant_valve]}--#{current[:move]}"

    next if !visited[key].nil? && visited[key] >= current[:score]

    visited[key] = current[:score]

    if current[:move] == 26
        m = [m, current[:score]].max
        next
    end

    # open valve
    if valves[current[:my_valve]][:rate] > 0 && !current[:open].include?(current[:my_valve])
        current[:open].push(current[:my_valve])

        # elephant opens valve
        if valves[current[:elephant_valve]][:rate] > 0 && !current[:open].include?(current[:elephant_valve])
            current[:open].push(current[:elephant_valve])


            new_b = current[:score] + current[:open].map{|v| valves[v][:rate]}.sum
            memo.push({move: current[:move]+1, my_valve: current[:my_valve], elephant_valve: current[:elephant_valve], score: new_b, open: current[:open].dup})

            # reset for next step (not opening) elephant
            current[:open].delete(current[:elephant_valve])
        end
    
        # elephant doesn't open the valve
        new_b = current[:score] + current[:open].map{|v| valves[v][:rate]}.sum
        valves[current[:elephant_valve]][:leads_to].each do |v|
            memo.push({move: current[:move]+1, my_valve: current[:my_valve], elephant_valve: v, score: new_b, open: current[:open].dup})
        end


        # reset for next step (not opening)
        current[:open].delete(current[:my_valve])
    end

        #don't open valve
    valves[current[:my_valve]][:leads_to].each do |mv|
        # elephant opens valve
        if valves[current[:elephant_valve]][:rate] > 0 && !current[:open].include?(current[:elephant_valve])
            current[:open].push(current[:elephant_valve])


            new_b = current[:score] + current[:open].map{|v| valves[v][:rate]}.sum
            memo.push({move: current[:move]+1, my_valve: mv, elephant_valve: current[:elephant_valve], score: new_b, open: current[:open].dup})

            # reset for next step (not opening) elephant
            current[:open].delete(current[:elephant_valve])
        end
    
        # elephant doesn't open the valve
        new_b = current[:score] + current[:open].map{|v| valves[v][:rate]}.sum
        valves[current[:elephant_valve]][:leads_to].each do |ev|
            memo.push({move: current[:move]+1, my_valve: mv, elephant_valve: ev, score: new_b, open: current[:open].dup})
        end

    end
end

puts m
