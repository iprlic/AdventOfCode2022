#!/usr/bin/env ruby
# frozen_string_literal: true
file_path = File.expand_path('input.txt', __dir__)

input = File.read(file_path).split("\n\n")

map = input[0].split("\n").map(&:chars)
steps = input[1].split(/[LR]/)
rotations = input[1].split(/\d*/).drop(1)

points = {}

height = map.size
width = map.first.size
starting_x = -1

map.each_with_index do |row, y|
    width = row.size if row.size > width
    row.each_with_index do |char, x|
        next if char == ' '
        points[x] = {} unless points[x]
        points[x][y] = char
        starting_x = x if char == '.' && starting_x == -1 && y == 0
    end
end

pos = {
    x: starting_x,
    y: 0,
    d: 0 # 0 = right, 1 = down, 2 = left, 3 = up
}

steps.each_with_index do |step, index|
    step.to_i.times do
        case pos[:d]
        when 0
            x = pos[:x] + 1
            y = pos[:y]

            if !points[x] || !points[x][y]
                found = false
                x = 0
                while not found
                    if points[x] && points[x][y]
                        found = true
                        break
                    end

                    x += 1
                end
            end
        when 1
            x = pos[:x]
            y = pos[:y] + 1

            if !points[x] || !points[x][y]
                found = false
                y = 0
                while not found
                    if points[x] && points[x][y]
                        found = true
                        break
                    end

                    y += 1
                end
            end
        when 2
            x = pos[:x] - 1
            y = pos[:y] 

            if !points[x] || !points[x][y]
                found = false
                x = width - 1
                while not found
                    if points[x] && points[x][y]
                        found = true
                        break
                    end

                    x -= 1
                end
            end
        when 3
            x = pos[:x]
            y = pos[:y] - 1

            if !points[x] || !points[x][y]
                found = false
                y = height - 1
                while not found
                    if points[x] && points[x][y]
                        found = true
                        break
                    end

                    y -= 1
                end
            end
        end

        break if points[x] && points[x][y] == '#'
        if points[x] && points[x][y] == '.'
            pos[:x] = x
            pos[:y] = y
            next
        end
        puts "ALARM"
        exit
    end


    if !rotations[index].nil?
        rot = rotations[index]
        if rot == 'L'
            pos[:d] -= 1
        else
            pos[:d] += 1
        end
        pos[:d] = 0 if pos[:d] == 4
        pos[:d] = 3 if pos[:d] == -1
    end
end

puts ((pos[:y] +1)* 1000) + ((pos[:x] +1) * 4) + pos[:d]