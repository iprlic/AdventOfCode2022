#!/usr/bin/env ruby
# frozen_string_literal: true
file_path = File.expand_path('input.txt', __dir__)

input = File.read(file_path).split("\n").map(&:reverse).map(&:chars)

total = 0

# sum
input.each do |num|
    c = 0
    num.each_with_index do |digit, i|
        pos = 5**i
        c += (pos * digit.to_i) if ['0','1','2'].include?(digit)
        c += (pos * -1) if digit == '-'
        c += (pos * -2) if digit == '='
    end

    total +=c
end


# convert to base 5
total5 = []

while total/5 > 0
    total5.push(total%5)
    total /= 5
end
total5.push(total%5) if total > 0


# convert to base SNAFU
total5.each_with_index do |digit, i|
    if [3,4,5].include? digit
        total5[i] = digit - 5
        total5.append(0) if total5[i+1].nil?
        total5[i+1] += 1 
    end
end

puts total5.map { |d| d != -1 && d != -2 ? d.to_s : d == -1 ? '-' : '=' }.reverse.join