#!/usr/bin/env ruby
# frozen_string_literal: true

def manhattan_distance(x1, y1, x2, y2)
    (x1 - x2).abs + (y1 - y2).abs
end

def overlap(a, b, c, d)
    return false if a > d || c > b
    true
end

def get_overlap(a, b, c, d)
    return nil if c <= a && d >= b
    
    if c > a && d < b
        return [
            {
                f: a,
                t: c-1
            },
            {
                f: d+1,
                t: b
            }
        ]
    end

    if c <= a && d >= a
        return [
            {
                f: d+1,
                t: b
            }
        ]
    end

    if c <= b
        return [
            {
                f: a,
                t: c-1
            }
        ]
    end
       
    puts "NOOOOOOOO"
    exit
end

 
 file_path = File.expand_path('input.txt', __dir__)
 
 target_l = 0
 target_h = 4000000
 multiplier = 4000000
 
 input = File.read(file_path).split("\n").map do |line|
    ls = line.split(' ')
 
    x1 = ls[2].chop.split('=')[1].to_i
    y1 = ls[3].chop.split('=')[1].to_i
 
    x2 = ls[8].chop.split('=')[1].to_i
    y2 = ls[9].split('=')[1].to_i
 
    {
         x1: x1,
         y1: y1,
         x2: x2,
         y2: y2
    }
 end
 

xs = {}
ys = {}


input.each do |pair|
    x1 = pair[:x1]
    y1 = pair[:y1]
    x2 = pair[:x2]
    y2 = pair[:y2]
 
    distance = manhattan_distance(x1, y1, x2, y2)

    yf = y1
    yt = y1
    (x1-distance..x1+distance).each do |x|
        if x >= target_l && x <= target_h
            xs[x] = [{
                f: target_l,
                t: target_h
            }] if xs[x].nil?

            new_xs_x = []
            new_yf = yf > target_l ? yf : target_l
            new_yt = yt < target_h ? yt : target_h

            xs[x].each do |x_pair|
                if overlap(x_pair[:f], x_pair[:t], new_yf , new_yt)
                    o = get_overlap(x_pair[:f], x_pair[:t], new_yf, new_yt)
                    new_xs_x.concat(o) if !o.nil?
                else
                    new_xs_x.push(x_pair) 
                end
            end

            xs[x] = new_xs_x

        end


        if x < x1
            yf -= 1
            yt += 1
        else
            yf += 1
            yt -= 1
        end
    end
     
    xf = x1
    xt = x1
    (y1-distance..y1+distance).each do |y|
        if y >= target_l && y <= target_h
            ys[y] = [{
                f: target_l,
                t: target_h
            }] if ys[y].nil?

            new_ys_y = []
            new_xf = xf > target_l ? xf : target_l
            new_xt = xt < target_h ? xt : target_h

            ys[y].each do |y_pair|
                if overlap(y_pair[:f], y_pair[:t], new_xf, new_xt)
                    o = get_overlap(y_pair[:f], y_pair[:t], new_xf, new_xt)
                    new_ys_y.concat(o) if !o.nil?
                else
                    new_ys_y.push(y_pair)
                end
            end

            ys[y] = new_ys_y
        end

        if y < y1
            xf -= 1
            xt += 1
        else
            xf += 1
            xt -= 1
        end
    end
end

xs = xs.select { |k, v| v.length > 0 } 
ys = ys.select { |k, v| v.length > 0 }

print xs.keys.first * multiplier + ys.keys.first
