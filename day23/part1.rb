#!/usr/bin/env ruby
# frozen_string_literal: true
file_path = File.expand_path('input.txt', __dir__)

input = File.read(file_path).split("\n").map(&:chars)

elves = {}

input.each_with_index do |row, y|
    row.each_with_index do |char, x|

        elves["#{x},#{y}"] = { x: x, y: y }  if char == '#'
    end
end

def should_move(x, y, elves)
    count = 0

    count += 1 if elves["#{x},#{y-1}"].nil?
    count += 1 if elves["#{x},#{y+1}"].nil?
    count += 1 if elves["#{x-1},#{y}"].nil?
    count += 1 if elves["#{x+1},#{y}"].nil?

    count += 1 if elves["#{x-1},#{y-1}"].nil?
    count += 1 if elves["#{x+1},#{y+1}"].nil?
    count += 1 if elves["#{x-1},#{y+1}"].nil?
    count += 1 if elves["#{x+1},#{y-1}"].nil?

    !(count == 8 || count == 0)
end

def new_pos(x, y, dir, elves)
    case dir
    when 'N'
        return [x, y-1] if elves["#{x},#{y-1}"].nil? && elves["#{x-1},#{y-1}"].nil? && elves["#{x+1},#{y-1}"].nil?
    when 'S'
        return [x, y+1] if elves["#{x},#{y+1}"].nil? && elves["#{x-1},#{y+1}"].nil? && elves["#{x+1},#{y+1}"].nil?
    when 'E'
        return [x+1, y] if elves["#{x+1},#{y}"].nil? && elves["#{x+1},#{y-1}"].nil? && elves["#{x+1},#{y+1}"].nil?
    when 'W'
        return [x-1, y] if elves["#{x-1},#{y}"].nil? && elves["#{x-1},#{y-1}"].nil? && elves["#{x-1},#{y+1}"].nil?
    end

    nil
end


dirs = ['N', 'S', 'W', 'E']

10.times do

    suggestions = {}
    new_elves = {}

    elves.each do |key, elf|
        x = elf[:x]
        y = elf[:y]
        if should_move(x, y, elves)
            dirs.each do |dir|
                np = new_pos(x, y, dir, elves)

                if !np.nil?
                    suggestions["#{np[0]},#{np[1]}"] = [] unless suggestions["#{np[0]},#{np[1]}"]
                    suggestions["#{np[0]},#{np[1]}"].push({
                        x: np[0],
                        y: np[1],
                        key: key
                    })
                    break
                end
            end
        end
    end

    suggestions.each do |key, s|
        if s.size == 1
            old_key = s.first[:key]
            new_elves[key] = {
                x: s.first[:x],
                y: s.first[:y]
            }
            elves.delete(old_key)
        end
    end

    elves = new_elves.merge(elves)

    dirs.push(dirs.shift)

   
end

min_X = elves.values.map { |e| e[:x] }.min
max_X = elves.values.map { |e| e[:x] }.max
min_Y = elves.values.map { |e| e[:y] }.min
max_Y = elves.values.map { |e| e[:y] }.max

total = 0
(min_Y..max_Y).each do |y|
    (min_X..max_X).each do |x|
        total += 1 if !elves["#{x},#{y}"]
    end
end

puts total