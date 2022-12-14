#!/usr/bin/env ruby
# frozen_string_literal: true
file_path = File.expand_path('input.txt', __dir__)

maxX = 0
maxY = 0
minX = 100000
minY = 100000

input = File.read(file_path).split("\n").map do |line|
    cors = line.split(' -> ')
    pairs = []
    cors.each_with_index do |item, i|

        x1 = item.split(',')[0].to_i
        y1 = item.split(',')[1].to_i
        maxX = x1 if x1 > maxX
        maxY = y1 if y1 > maxY
        minX = x1 if x1 < minX
        minY = y1 if y1 < minY

        next if i == 0
       

        x2 = cors[i-1].split(',')[0].to_i
        y2 = cors[i-1].split(',')[1].to_i

        pairs.push({
            from: { x: x2, y: y2 },
            to: { x: x1, y: y1 }
        })
    end

    pairs
end


taken = {}


(0..maxY).each do |y|
    (minX..maxX).each do |x|
        isRock = false
        input.each do |pairs|
            pairs.each do |pair|
                if pair[:from][:x] == pair[:to][:x] && pair[:from][:x] == x && (y.between?(pair[:from][:y], pair[:to][:y]) || y.between?(pair[:to][:y], pair[:from][:y]))
                    isRock = true
                elsif pair[:from][:y] == pair[:to][:y] && pair[:from][:y] == y && (x.between?(pair[:from][:x], pair[:to][:x]) || x.between?(pair[:to][:x], pair[:from][:x]))
                    isRock = true
                end
            end
        end
        taken["#{x},#{y}̨"] = true if isRock

        #print '#' if isRock
        #print '.' if !isRock
    end
    #print "\n"
end

maxY += 2
#puts "Map constructed"

abyss = false
cnt = 0


while !abyss
    cnt += 1
    x = 500 
    y = 0
    canFall = true

    while canFall
        newY = y + 1
        canFall = false

        if newY != maxY
            if !taken["#{x},#{newY}̨"]
                canFall = true
                y = newY
            elsif !taken["#{x-1},#{newY}̨"]
                canFall = true
                x -= 1
                y = newY
            elsif !taken["#{x+1},#{newY}̨"]
                canFall = true
                x += 1
                y = newY
            end
        end


        abyss = true if !canFall && x == 500 && y == 0

        !taken["#{x},#{y}̨"] = true if !canFall
    end
end

puts cnt