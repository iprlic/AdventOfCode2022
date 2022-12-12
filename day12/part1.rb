#!/usr/bin/env ruby
# frozen_string_literal: true

def walk(x, y, step, input, step_counts)
    if x-1 >= 0 && ((input[x-1][y] - input[x][y]).abs <= 1 || input[x-1][y] < input[x][y])
        new_key = "#{x-1}:#{y}"

        if step_counts[new_key].nil? || step_counts[new_key] > step + 1
            step_counts[new_key] = step + 1
            walk(x-1, y, step + 1, input, step_counts)
        end
    end

    if x+1 < input.length && ((input[x+1][y] - input[x][y]).abs <= 1 || input[x+1][y] < input[x][y])
        new_key = "#{x+1}:#{y}"

        if step_counts[new_key].nil? || step_counts[new_key] > step + 1
            step_counts[new_key] = step + 1
            walk(x+1, y, step + 1, input, step_counts)
        end
    end

    if y-1 >= 0 && ((input[x][y-1] - input[x][y]).abs <= 1 || input[x][y-1] < input[x][y])
        new_key = "#{x}:#{y-1}"

        if step_counts[new_key].nil? || step_counts[new_key] > step + 1
            step_counts[new_key] = step + 1
            walk(x, y-1, step + 1, input, step_counts)
        end
    end

    if y+1 < input[0].length && ((input[x][y+1] - input[x][y]).abs <= 1 || input[x][y+1] < input[x][y])
        new_key = "#{x}:#{y+1}"

        if step_counts[new_key].nil? || step_counts[new_key] > step + 1
            step_counts[new_key] = step + 1
            walk(x, y+1, step + 1, input, step_counts)
        end
    end
end

file_path = File.expand_path('input.txt', __dir__)


start = {
    x:  -1,
    y:  -1,
}
goal = {
    x:  -1,
    y:  -1,
}

input = File.read(file_path).split("\n").map.with_index do |line, i|
    line.chars.map.with_index do |char, j|
        if char == 'S'
            start[:x] = i
            start[:y] = j
            char = 'a'
        end

        if char == 'E'
            goal[:x] = i
            goal[:y] = j
            char = 'z'
        end

        char.ord
    end
end

step_counts = {
    "#{start[:x]}:#{start[:y]}" => 0
}



walk(start[:x], start[:y], 0, input, step_counts)

puts step_counts["#{goal[:x]}:#{goal[:y]}"]
