#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path).split("\n").map { |e| e.split(" ") }

rounds = input.map do |e|

    a = e[0]
    b = e[1]
    result = 1
    result += 1 if b == 'Y'
    result += 2 if b == 'Z'

    result += 3 if (a == 'A' && b == 'X') || (a == 'B' && b == 'Y') || (a == 'C' && b == 'Z')
    result += 6 if (a == 'A' && b == 'Y') || (a == 'B' && b == 'Z') || (a == 'C' && b == 'X')


    result
end


puts rounds.sum