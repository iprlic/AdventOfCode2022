#!/usr/bin/env ruby
# frozen_string_literal: true
file_path = File.expand_path('input.txt', __dir__)

original = {}
current = []
input = File.read(file_path).split("\n").each_with_index do |line, index|
    original[index] = line.to_i
    current.push(index)
end

size = input.size

zero_key = -1

original.each do |key, value|
    if value == 0
        zero_key = key
        next
    end

    move_right = value > 0
    index = current.index(key)

    new_index = index + value - (move_right ? 0 : 1)

    while new_index <= -1 * current.size
        new_index += current.size
        new_index -=1
    end

    while new_index >= current.size
        new_index -= current.size
        new_index +=1
    end

    current.delete_at(index)
    current.insert(new_index, key)
end



index = current.index(zero_key)

first_index = index+1000
second_index = index+2000
third_index = index+3000

while first_index >= size
    first_index -= size
end

while second_index >= size
    second_index -= size
end

while third_index >= size
    third_index -= size
end

first = current[first_index]
second = current[second_index]
third = current[third_index]

puts original[first]+original[second]+original[third]
