#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path).split("\n")

fully = input.map do |e|
    sec = e.split(/[,-]/).map(&:to_i)

    x1 = sec[0]
    y1 = sec[1]

    x2 = sec[2]
    y2 = sec[3]

    res = 0

    res = 1 if x1 <= x2 && y1 >= y2
    res = 1 if x1 >= x2 && y1 <= y2

    res
end

puts fully.sum