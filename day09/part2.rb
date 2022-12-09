#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path).split("\n").map do |line| 
    l = line.split(" ") 
    {
        dir: l[0],
        size: l[1].to_i,
    }
end

visited = [[0,0]]

pos = []

10.times do
    pos.push({
        x: 0,
        y: 0,
    })
end
cnt = 0

input.each do |move|
    cnt += 1
    move[:size].times do
        current = [pos[9][:x], pos[9][:y]]
        if move[:dir] == "U"
            pos[0][:y] += 1
        elsif move[:dir] == "D"
            pos[0][:y] -= 1
        elsif move[:dir] == "L"
            pos[0][:x] -= 1
        elsif move[:dir] == "R"
            pos[0][:x] += 1
        end    

        (1..9).each do |index|
            posT = pos[index]
            posH = pos[index - 1]
            distX = (posH[:x] - posT[:x]) 
            distY = (posH[:y] - posT[:y])

            if (distX.abs > 1 || distY.abs > 1) && (posH[:x] != posT[:x]) && (posH[:y] != posT[:y])
                posT[:y] += 1 if distY >= 1
                posT[:y] -= 1 if distY <= -1
                posT[:x] += 1 if distX >= 1
                posT[:x] -= 1 if distX <= -1
            end
               
            distX = (pos[index - 1][:x] - pos[index][:x]) 
            distY = (pos[index - 1][:y] - pos[index][:y])

            if distY > 1
                posT[:y] += 1
                posT[:x] = posH[:x] if posT[:x] != posH[:x]
            end

            distX = (pos[index - 1][:x] - pos[index][:x]) 
            distY = (pos[index - 1][:y] - pos[index][:y])
            if  distY < -1
                posT[:y] -= 1
                posT[:x] = posH[:x] if posT[:x] != posH[:x]
            end

            distX = (pos[index - 1][:x] - pos[index][:x]) 
            distY = (pos[index - 1][:y] - pos[index][:y])
            if distX > 1
                posT[:x] += 1 
                posT[:y] = posH[:y] if posT[:y] != posH[:y]
            end

            distX = (pos[index - 1][:x] - pos[index][:x]) 
            distY = (pos[index - 1][:y] - pos[index][:y])
            if distX < -1
                posT[:x] -= 1 
                posT[:y] = posH[:y] if posT[:y] != posH[:y]
            end

        end

        if current != [pos[9][:x], pos[9][:y]]
            visited.push([pos[9][:x], pos[9][:y]]) 
        end

    end

end

puts visited.uniq.size