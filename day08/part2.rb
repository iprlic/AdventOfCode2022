#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path).split("\n").map(&:chars)

max = 0

input.each_with_index do |line, i|
    line.each_with_index do |tree, j|
        visible_left = 0
        visible_right = 0
        visible_up = 0
        visible_down = 0

        # check left
        x = j
        while x - 1 >= 0
            x -= 1
            visible_left += 1
            break if input[i][x] >= tree
        end

        # check right
        x = j
        while x + 1 <= line.length - 1
            x += 1
            visible_right += 1
            break  if input[i][x] >= tree
        end

        

        # check up
        y = i
        while y - 1  >= 0
            y -= 1
            visible_up += 1
            break if input[y][j] >= tree
        end

        # check down
        y = i
        while y + 1 <= input.length - 1
            y += 1
            visible_down += 1
            break if input[y][j] >= tree
        end

        score = visible_up * visible_down * visible_left * visible_right

        max = score if score > max
    end
end


puts max
