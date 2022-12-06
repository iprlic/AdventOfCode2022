#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path).chars

current = 3
found = false

while not found
    if input.slice(current-3, 4).uniq().size == 4
        found = true
    else
        current += 1
    end

    break if found || current >= input.size
end

puts current+1