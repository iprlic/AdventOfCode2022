#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path).split("\n")

path = []
dirs = {}

input.each do |line|
    cmd = line.split(" ")
        
    if cmd[0] == "$" && cmd[1] == "cd"
        if cmd[2] == ".."
            path.pop()
        else
            path.push(cmd[2])
        end
    end

    if cmd[0] != "$" && cmd[0] != "dir"
        path.each_with_index do |dir, index|
            pth = path[0..index].join("/")
            dirs[pth] = 0 if dirs[pth] == nil
            dirs[pth] += cmd[0].to_i
        end
    end
end



required = 30000000 - (70000000 - dirs['/'])
min = 70000000

dirs.each do |key, value|
    if value >= required && value < min
        min = value
    end
end

puts min