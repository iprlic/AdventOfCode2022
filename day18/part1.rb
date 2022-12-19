#!/usr/bin/env ruby
# frozen_string_literal: true
file_path = File.expand_path('input.txt', __dir__)

input = File.read(file_path).split("\n").map do |line|
    l = line.split(',').map(&:to_i)

    {
        x: l[0],
        y: l[1],
        z: l[2]
    }
end

fallen = {}
total = 0

input.each do |point|
    x = point[:x]
    y = point[:y]
    z = point[:z]

    if fallen["#{x-1}"].nil? || fallen["#{x-1}"]["#{y}"].nil? || fallen["#{x-1}"]["#{y}"]["#{z}"].nil?
        total += 1 
    else
        total -= 1
    end

    if fallen["#{x+1}"].nil? || fallen["#{x+1}"]["#{y}"].nil? || fallen["#{x+1}"]["#{y}"]["#{z}"].nil?
        total += 1 
    else
        total -= 1
    end

    if fallen["#{x}"].nil? || fallen["#{x}"]["#{y+1}"].nil? || fallen["#{x}"]["#{y+1}"]["#{z}"].nil?
        total += 1
    else
        total -= 1
    end

    if fallen["#{x}"].nil? || fallen["#{x}"]["#{y-1}"].nil? || fallen["#{x}"]["#{y-1}"]["#{z}"].nil?
        total += 1
    else
        total -= 1
    end

    if fallen["#{x}"].nil? || fallen["#{x}"]["#{y}"].nil? || fallen["#{x}"]["#{y}"]["#{z+1}"].nil?
        total += 1
    else
        total -= 1
    end

    if fallen["#{x}"].nil? || fallen["#{x}"]["#{y}"].nil? || fallen["#{x}"]["#{y}"]["#{z-1}"].nil?
        total += 1
    else
        total -= 1
    end


    fallen["#{x}"] = {} if fallen["#{x}"].nil? 
    fallen["#{x}"]["#{y}"] = {} if fallen["#{x}"]["#{y}"].nil? 
    fallen["#{x}"]["#{y}"]["#{z}"] = true
end

puts total
