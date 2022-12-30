#!/usr/bin/env ruby
# frozen_string_literal: true
file_path = File.expand_path('input.txt', __dir__)

input = File.read(file_path).split("\n").map(&:chars)

$storm_symbols = ['>', 'v', '<', '^']
goal = {
    x: input.first.size - 2,
    y: input.size - 1
}

current = {
    x: 1,
    y: 0
}

storms = {}
taken = {}
$memo = {}

$best_minute = -1

$cycle_length = (input.first.size - 2).lcm(input.size - 2)
$max_y = input.size - 1
$max_x = input.first.size - 1

input.each_with_index do |row, y|
    row.each_with_index do |cell, x|
        if $storm_symbols.include?(cell)
            storms["#{x},#{y}"] = {
                x: x,
                y: y,
                d: cell
            }
            taken["#{x},#{y}"] = cell
        end
    end
end

$all_takens = {}
(0..$cycle_length-1).each do |i|
    $all_takens[i] = {}

    storms.each do |k, v|
        if i > 0
            case v[:d]
            when '>'
                storms[k][:x] += 1
                storms[k][:x] = 1 if v[:x] > goal[:x]
            when 'v'
                storms[k][:y] += 1
                storms[k][:y] = 1 if v[:y] == goal[:y]
            when '<'
                storms[k][:x] -= 1
                storms[k][:x] = goal[:x] if v[:x] == 0
            when '^'
                storms[k][:y] -= 1
                storms[k][:y] = goal[:y]-1 if v[:y] == 0
            end
        end

        if $all_takens[i]["#{v[:x]},#{v[:y]}"].nil?
            $all_takens[i]["#{v[:x]},#{v[:y]}"] = v[:d]
        elsif $storm_symbols.include?($all_takens[i]["#{v[:x]},#{v[:y]}"])
            $all_takens[i]["#{v[:x]},#{v[:y]}"] = 2
        else
            $all_takens[i]["#{v[:x]},#{v[:y]}"] += 1
        end
    end

    taken = $all_takens[i]
end

         
def tick(goal, current, minutes=0)
    cycle_minute = minutes % $cycle_length
    memo_key = "#{cycle_minute}-#{current[:x]},#{current[:y]}"

    #puts "here"

    return if !$memo[memo_key].nil?

    $memo[memo_key] = minutes

    if current[:x] == goal[:x] && current[:y] == goal[:y]
        $best_minute = minutes if minutes < $best_minute || $best_minute == -1

        return
    end

    return if minutes > 800 # 700 is the max possible

    minutes += 1

    taken = $all_takens[cycle_minute]
   

    can_down = false
    can_up = false
    can_left = false
    can_right = false
    can_wait = false


    if goal[:y] != 0 && goal[:x] != 1
        can_left = current[:x] > 1 && taken["#{current[:x]-1},#{current[:y]}"].nil? && current[:y] != 0
        can_right = current[:x] < goal[:x] && taken["#{current[:x]+1},#{current[:y]}"].nil? && current[:y] != 0
        can_up = current[:y] > 1 && taken["#{current[:x]},#{current[:y]-1}"].nil? # check start position
        can_down = (current[:y] < goal[:y]-1 || (current[:y] == goal[:y]-1 && current[:x] == goal[:x])) && taken["#{current[:x]},#{current[:y]+1}"].nil?
        can_wait = taken["#{current[:x]},#{current[:y]}"].nil?
    else
        can_left = current[:x] > 1 && taken["#{current[:x]-1},#{current[:y]}"].nil? && current[:y] != $max_y
        can_right = current[:x] < $max_x-1 && taken["#{current[:x]+1},#{current[:y]}"].nil? && current[:y] != 0 && current[:y] != $max_y
        
        can_up = (current[:y] > 1 || (current[:y]==1 && current[:x]==1)) && taken["#{current[:x]},#{current[:y]-1}"].nil? 
        can_down = current[:y] < $max_y-1 && taken["#{current[:x]},#{current[:y]+1}"].nil?
        
        can_wait = taken["#{current[:x]},#{current[:y]}"].nil?
    end

    tick(goal, {
        x: current[:x].clone-1,
        y: current[:y].clone
    }, minutes) if can_left
    

    tick(goal, {
        x: current[:x].clone+1,
        y: current[:y].clone
    }, minutes) if can_right

    tick(goal, {
        x: current[:x].clone,
        y: current[:y].clone-1
    }, minutes) if can_up

    tick(goal, {
        x: current[:x].clone,
        y: current[:y].clone+1
    }, minutes) if can_down

    tick(goal, {
        x: current[:x].clone,
        y: current[:y].clone
    }, minutes) if can_wait
end


tick(goal, current)

first_pass = $best_minute - 1
$best_minute = -1
$memo = {}

first_pass = 228

puts "first pass: #{first_pass}"

tick(current, goal, first_pass)

second_pass = $best_minute - 1 - first_pass
$best_minute = -1
$memo = {}

puts "second pass: #{second_pass}"

tick(goal, current, second_pass + first_pass)


second_pass = 233


third_pass = $best_minute - 1 - first_pass - second_pass

puts "third pass: #{third_pass}"

puts first_pass + second_pass + third_pass


#### some guess work here with limitts, IDK