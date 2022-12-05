#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path).split("\n").map { |e| e.split(" ") }

rounds = input.map do |e|

    a = e[0]
    b = e[1]

    checked = false

    if (a == 'A' && b == 'X') && !checked
        b = 'Z' 
        checked = true
    end

    if (a == 'A' && b == 'Y') && !checked
        b = 'X' 
        checked = true
    end

     if (a == 'A' && b == 'Z') && !checked
        b = 'Y'
        checked = true
    end



    if (a == 'B' && b == 'X') && !checked
        b = 'X' 
        checked = true
    end

    if (a == 'B' && b == 'Y') && !checked
        b = 'Y'
        checked = true
    end


    if (a == 'B' && b == 'Z') && !checked
        b = 'Z' 
        checked = true
    end



    if (a == 'C' && b == 'X') && !checked
        b = 'Y' 
        checked = true
    end

    if (a == 'C' && b == 'Y') && !checked
        b = 'Z'
        checked = true
    end

    if (a == 'C' && b == 'Z') && !checked
        b = 'X'
        checked = true
    end


    result = 1
    result += 1 if b == 'Y'
    result += 2 if b == 'Z'

    result += 3 if (a == 'A' && b == 'X') || (a == 'B' && b == 'Y') || (a == 'C' && b == 'Z')
    result += 6 if (a == 'A' && b == 'Y') || (a == 'B' && b == 'Z') || (a == 'C' && b == 'X')


    result
end


puts rounds.sum