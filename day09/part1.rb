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
posT = {
    x: 0,
    y: 0,
}
posH = {
    x: 0,
    y: 0,
}

input.each do |move|
    move[:size].times do
        curent = [posT[:x], posT[:y]]
        if move[:dir] == "U"
            posH[:y] += 1
        elsif move[:dir] == "D"
            posH[:y] -= 1
        elsif move[:dir] == "L"
            posH[:x] -= 1
        elsif move[:dir] == "R"
            posH[:x] += 1
        end    

        
        distX = (posH[:x] - posT[:x]) 
        distY = (posH[:y] - posT[:y])

       
        if distY > 1
            posT[:y] += 1
            posT[:x] = posH[:x] if posT[:x] != posH[:x]
        end
        if  distY < -1
            posT[:y] -= 1
            posT[:x] = posH[:x] if posT[:x] != posH[:x]
        end

        if distX > 1
            posT[:x] += 1 
            posT[:y] = posH[:y] if posT[:y] != posH[:y]
        end

        if distX < -1
            posT[:x] -= 1 
            posT[:y] = posH[:y] if posT[:y] != posH[:y]
        end

        visited.push([posT[:x], posT[:y]]) if curent != [posT[:x], posT[:y]]

    end

end

puts visited.uniq.size