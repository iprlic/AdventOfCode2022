#!/usr/bin/env ruby
# frozen_string_literal: true
def fall(shape, location, chamber)
    x = location[0]
    y = location[1]
    h = chamber.size

    return [x,y] if y == 0
    return [x,y-1] if y-1 >= h

    can_fall = true 

    case shape
    when '-'
        can_fall = false if chamber[y-1][x] != '.'
        can_fall = false if chamber[y-1][x+1] != '.'
        can_fall = false if chamber[y-1][x+2] != '.'
        can_fall = false if chamber[y-1][x+3] != '.'
    when '+'
        can_fall = false if !chamber[y].nil? && chamber[y][x] != '.'
        can_fall = false if chamber[y-1][x+1] != '.'
        can_fall = false if !chamber[y].nil? && chamber[y][x+2] != '.'
    when 'j'
        can_fall = false if chamber[y-1][x] != '.'
        can_fall = false if chamber[y-1][x+1] != '.'
        can_fall = false if chamber[y-1][x+2] != '.'
    when 'i'
        can_fall = false if chamber[y-1][x] != '.'
    when 'o'
        can_fall = false if chamber[y-1][x] != '.'
        can_fall = false if chamber[y-1][x+1] != '.'
    end

    return [x,y-1] if can_fall
    location
end

def move(shape, location, jet, chamber)
    x = location[0]
    y = location[1]
    h = chamber.size

    return location if jet == '<' && x == 0
    if jet == '>' 
        case shape
        when '-'
            return location if x+3 == 6
        when '+'
            return location if x+2 == 6
        when 'j'
            return location if x+2 == 6
        when 'i'
            return location if x == 6
        when 'o'
            return location if x+1 == 6
        end
    end

    lowest = y
    lowest = y-1 if shape == '+'
    
    return [x-1, y] if jet == '<' && lowest > h
    return [x+1, y] if jet == '>' && lowest > h


    if jet == '<'
        can_move = true

        case shape
        when '-'
            can_move = false if !chamber[y].nil? && chamber[y][x-1] != '.'
        when '+'
            can_move = false if !chamber[y].nil? && chamber[y][x] != '.'       
            can_move = false if !chamber[y+1].nil? && !chamber[y+1].nil? && chamber[y+1][x-1] != '.'
            can_move = false if !chamber[y+2].nil? && !chamber[y+2].nil? && chamber[y+2][x] != '.'
        when 'j'
            can_move = false if !chamber[y].nil? && chamber[y][x-1] != '.'
            can_move = false if !chamber[y+1].nil? && !chamber[y+1].nil? && chamber[y+1][x+1] != '.'
            can_move = false if !chamber[y+2].nil? && !chamber[y+2].nil? && chamber[y+2][x+1] != '.'
        when 'i'
            can_move = false if !chamber[y].nil? && chamber[y][x-1] != '.' 
            can_move = false if !chamber[y+1].nil? && !chamber[y+1].nil? && chamber[y+1][x-1] != '.'
            can_move = false if !chamber[y+2].nil? && !chamber[y+2].nil? && chamber[y+2][x-1] != '.'
            can_move = false if !chamber[y+3].nil? && !chamber[y+3].nil? && chamber[y+3][x-1] != '.'
        when 'o'
            can_move = false if !chamber[y].nil? && chamber[y][x-1] != '.' 
            can_move = false if !chamber[y+1].nil? && !chamber[y+1].nil? && chamber[y+1][x-1] != '.'
        end

        location = [x-1, y] if can_move
    elsif jet == '>'
        can_move = true

        case shape
        when '-'
            can_move = false if !chamber[y].nil? && chamber[y][x+4] != '.'
        when '+'
            can_move = false if !chamber[y].nil? && chamber[y][x+2] != '.'      
            can_move = false if !chamber[y+1].nil? && chamber[y+1][x+3] != '.'
            can_move = false if !chamber[y+2].nil? && chamber[y+2][x+2] != '.'
        when 'j'
            can_move = false if !chamber[y].nil? && chamber[y][x+3] != '.'
            can_move = false if !chamber[y+1].nil? && chamber[y+1][x+3] != '.'
            can_move = false if !chamber[y+2].nil? && chamber[y+2][x+3] != '.'
        when 'i'
            can_move = false if !chamber[y].nil? && chamber[y][x+1] != '.'
            can_move = false if !chamber[y+1].nil? && chamber[y+1][x+1] != '.'
            can_move = false if !chamber[y+2].nil? && chamber[y+2][x+1] != '.'
            can_move = false if !chamber[y+3].nil? && chamber[y+3][x+1] != '.'
        when 'o'
            can_move = false if !chamber[y].nil? && chamber[y][x+2] != '.'
            can_move = false if !chamber[y+1].nil? && chamber[y+1][x+2] != '.'
        end

        location = [x+1, y] if can_move
    else
        puts "ALARM!!!"
        exit
    end


    location
end

def embed(shape, location, chamber)
    x = location[0]
    y = location[1]
    h = chamber.size

    chamber.append(['.', '.', '.', '.', '.', '.', '.']) if y >= h

    chamber.append(['.', '.', '.', '.', '.', '.', '.']) if ['+', 'j', 'i', 'o'].include?(shape) && y+1 >= h
    chamber.append(['.', '.', '.', '.', '.', '.', '.']) if ['j', 'i', '+'].include?(shape) && y+2 >= h
    chamber.append(['.', '.', '.', '.', '.', '.', '.']) if shape == 'i' && y+3 >= h

    case shape
    when '-'
        chamber[y][x] = shape
        chamber[y][x+1] = shape
        chamber[y][x+2] = shape
        chamber[y][x+3] = shape
    when '+'
        chamber[y][x+1] = shape
        chamber[y+1][x] = shape
        chamber[y+1][x+1] = shape
        chamber[y+1][x+2] = shape
        chamber[y+2][x+1] = shape
    when 'j'
        chamber[y][x] = shape
        chamber[y][x+1] = shape
        chamber[y][x+2] = shape
        chamber[y+1][x+2] = shape
        chamber[y+2][x+2] = shape
    when 'i'
        chamber[y][x] = shape
        chamber[y+1][x] = shape
        chamber[y+2][x] = shape
        chamber[y+3][x] = shape
    when 'o'
        chamber[y][x] = shape
        chamber[y][x+1] = shape
        chamber[y+1][x] = shape
        chamber[y+1][x+1] = shape
    end

    chamber
end

file_path = File.expand_path('input.txt', __dir__)

jets = File.read(file_path).chars

shapes = ['-', '+', 'j', 'i', 'o']

max_moves = 1000000000000
current_shape = 0
current_jet = 0
chamber = []
fives = {}
repeats = []
moves_left = -1
leftover_height = -1
total_height = -1

repeated = false
last_5 = []
jet_size = jets.size

max_moves.times do |i|

    location = [2, chamber.size + 3]

    while true do
        location = move(shapes[current_shape], location, jets[current_jet], chamber)
        current_jet += 1
        current_jet = 0 if current_jet > jets.size - 1


        prev_y = location[1].dup
        location = fall(shapes[current_shape], location, chamber)


        break if prev_y == location[1]
    end

    last_5.append(location[0])
     
    chamber = embed(shapes[current_shape], location, chamber)
    
    if last_5.size == 10 && !repeated
        key = "#{last_5.join('-')}#{current_jet}"

        if fives[key].nil?
            fives[key] = {
                move: i,
                height: chamber.size
            }
        else
            repeats.push(fives[key])
            repeats.push(
                {
                    move: i,
                    height: chamber.size
                }
            )
            

            first_occurrence = repeats[0]
            second_occurrence = repeats[1]

            new_max_moves = max_moves - first_occurrence[:move]

            repeats_move = second_occurrence[:move] - first_occurrence[:move]
            repeats_height = second_occurrence[:height] - first_occurrence[:height]

            total_repeats = new_max_moves / repeats_move
            total_height = first_occurrence[:height] + (total_repeats * repeats_height)

            moves_left = (new_max_moves % repeats_move) - 1
            repeated = true
        end

        last_5 = [] 
    end

    if repeated && moves_left == 0
        leftover_height = chamber.size - repeats[1][:height]
        total_height += leftover_height
        break
    end
    if moves_left != -1
        moves_left -= 1
    end

    current_shape +=1
    current_shape = 0 if current_shape > 4
end

puts total_height == -1 ? chamber.size : total_height
