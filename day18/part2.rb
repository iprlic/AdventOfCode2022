#!/usr/bin/env ruby
# frozen_string_literal: true
file_path = File.expand_path('input.txt', __dir__)

$min_x = 1000
$max_x = -1000
$min_y = 1000
$max_y = -1000
$min_z = 1000
$max_z = -1000

$canTouch = {}
$visited = {}

def get_edges(x, y, z)
    key = "#{x},#{y},#{z}"

    return if !$visited[key].nil?
    return if !$canTouch[key].nil?


    if $points[key].nil?
        $visited[key] = true
        get_edges(x+1, y, z) if x + 1 <= $max_x
        get_edges(x-1, y, z) if x - 1 >= $min_x
        get_edges(x, y+1, z) if y + 1 <= $max_y
        get_edges(x, y-1, z) if y - 1 >= $min_y
        get_edges(x, y, z+1) if z + 1 <= $max_z
        get_edges(x, y, z-1) if z - 1 >= $min_z
    else
        $canTouch[key] = {
            x: x,
            y: y,
            z: z
        }
    end
end

$points = {}

File.read(file_path).split("\n").each do |line|
    l = line.split(',').map(&:to_i)

    $min_x = l[0] if l[0] < $min_x
    $max_x = l[0] if l[0] > $max_x

    $min_y = l[1] if l[1] < $min_y
    $max_y = l[1] if l[1] > $max_y

    $min_z = l[2] if l[2] < $min_z
    $max_z = l[2] if l[2] > $max_z
    key = "#{l[0]},#{l[1]},#{l[2]}"

    $points[key] = {
        x: l[0],
        y: l[1],
        z: l[2]
    }
end


$min_x -= 1
$max_x += 1
$min_y -= 1
$max_y += 1
$min_z -= 1
$max_z += 1

get_edges($min_x, $min_y, $min_z)

total = 0

$canTouch.each do |k, v|
    total +=1 if $visited["#{v[:x]+1},#{v[:y]},#{v[:z]}"]
    total +=1 if $visited["#{v[:x]-1},#{v[:y]},#{v[:z]}"]

    total +=1 if $visited["#{v[:x]},#{v[:y]+1},#{v[:z]}"]
    total +=1 if $visited["#{v[:x]},#{v[:y]-1},#{v[:z]}"]
    total +=1 if $visited["#{v[:x]},#{v[:y]},#{v[:z]+1}"]
    total +=1 if $visited["#{v[:x]},#{v[:y]},#{v[:z]-1}"]
end

puts total