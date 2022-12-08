#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path).split("\n").map(&:chars)

total = 0

input.each_with_index do |line, i|
    line.each_with_index do |tree, j|
        if i == 0 || j == 0 || i == input.length - 1 || j == line.length - 1
            total += 1        
        else
            visible_left = true
            visible_right = true
            visible_up = true
            visible_down = true

            # check left
            x = j
            while x - 1 >= 0
                x -= 1
                visible_left = false if input[i][x] >= tree
            end

            # check right
            x = j
            while x + 1 <= line.length - 1
                x += 1
                visible_right = false if input[i][x] >= tree
            end

          

            # check up
            y = i
            while y - 1  >= 0
                y -= 1
                visible_up = false if input[y][j] >= tree
            end

            # check down
            y = i
            while y + 1 <= input.length - 1
                y += 1
                visible_down = false if input[y][j] >= tree
            end

            total +=1 if visible_left || visible_right || visible_up || visible_down
        end
    end
end


puts total
