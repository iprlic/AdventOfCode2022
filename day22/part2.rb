#!/usr/bin/env ruby
# frozen_string_literal: true
file_path = File.expand_path('input.txt', __dir__)

input = File.read(file_path)#!/usr/bin/env ruby
# frozen_string_literal: true
file_path = File.expand_path('input.txt', __dir__)

input = File.read(file_path).split("\n\n")

map = input[0].split("\n").map(&:chars)
steps = input[1].split(/[LR]/)
rotations = input[1].split(/\d*/).drop(1)

points = {}

height = map.size
width = map.first.size
starting_x = -1

map.each_with_index do |row, y|
    width = row.size if row.size > width
    row.each_with_index do |char, x|
        next if char == ' '
        points[x] = {} unless points[x]
        points[x][y] = char
        starting_x = x if char == '.' && starting_x == -1 && y == 0
    end
end

pos = {
    x: starting_x,
    y: 0,
    d: 0 # 0 = right, 1 = down, 2 = left, 3 = up
}

def get_quadrant(x,y)
    return 'A' if x >= 50 && x < 100 && y < 50
    return 'B' if x >= 50 && x < 100 && y >= 50 && y < 100
    return 'C' if x >= 50 && x < 100 && y >= 100 && y < 150
    return 'D' if x >= 100 && x < 150 && y < 50
    return 'E' if x >= 0 && x < 50 && y >= 100 && y < 150
    return 'F' if x >= 0 && x < 50 && y >= 150 && y < 200

    puts "ALARM"
    exit
end

def get_next_pos(x,y,d, points, width, height)
    q = get_quadrant(x,y)

    x += 1 if d == 0
    y += 1 if d == 1
    x -= 1 if d == 2
    y -= 1 if d == 3
    
    handled = false
    if !points[x] || !points[x][y]
        case d
        when 0
            case q
            when 'D'
                handled = true
                d = 2
                y = 149-y
                x = 99
            when 'B'
                handled = true
                d = 3
                x = 50+y
                y = 49  
            when 'C'
                handled = true
                d = 2
                x = 149
                y = (149-y).abs
            when 'F'
                handled = true
                d = 3
                x = y-100
                y = 149  
            end
        when 1
            case q
            when 'C'
                handled = true
                d = 2
                y = x+100
                x = 49
            when 'D'
                handled = true
                d = 2
                y = x-50
                x = 99
            when 'F'
                handled = true
                y = 0
                x +=100
            end
        when 2
            case q
            when 'A'
                handled = true
                d = 0
                y = 149-y
                x = 0
            when 'B'
                handled = true
                d = 1
                x = y-50
                y = 100
            when 'E'
                handled = true
                d = 0
                y = (y-149).abs
                x = 50
            when 'F'
                handled = true
                d = 1
                x = y-100
                y = 0
            end
        when 3
            case q
            when 'A'
                handled = true
                d = 0
                y = x+100
                x = 0
            when 'D'
                handled = true
                y = 199
                x -= 100
            when 'E'
                handled = true
                d = 0
                y = x+50
                x = 50
            end
        end
    end

    puts "ALARM" if !handled && (!points[x] || !points[x][y])

    {
        x: x,
        y: y,
        d: d
    }
end

steps.each_with_index do |step, index|
    new_pos = {
        x: pos[:x],
        y: pos[:y],
        d: pos[:d]
    }
    x = pos[:x]
    y = pos[:y]
    d = pos[:d]

    step.to_i.times do
        new_pos = get_next_pos(x,y,d, points, width, height)
        x = new_pos[:x]
        y = new_pos[:y]
        d = new_pos[:d]

        break if points[x] && points[x][y] == '#'
        if points[x] && points[x][y] == '.'
            pos[:x] = x
            pos[:y] = y
            pos[:d] = d
            next
        end
        puts "ALARM"
        exit
    end


    if !rotations[index].nil?
        rot = rotations[index]
        if rot == 'L'
            pos[:d] -= 1
        else
            pos[:d] += 1
        end
        pos[:d] = 0 if pos[:d] == 4
        pos[:d] = 3 if pos[:d] == -1
    end
end

puts ((pos[:y] +1)* 1000) + ((pos[:x] +1) * 4) + pos[:d]