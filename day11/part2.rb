#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
monkies = File.read(file_path).split("\n\n").map do |monkey| 
    m = monkey.split("\n") 
    
    {
        items:  m[1].split(": ").last.split(', ').map(&:to_i),
        operation: {
            operand: m[2].split(" ")[-2],
            x: m[2].split(" ")[-1],
        },
        test:  m[3].split(" ").last.to_i,
        if_true: m[4].split(" ").last.to_i,
        if_false: m[5].split(" ").last.to_i,
        inspections: 0
    }
end

divider = monkies.reduce(1) { |sum, m| sum * m[:test] }

(1..10000).each do |index|
    monkies.each_with_index do |monkey, j|
        monkey[:items].each_with_index do |item, i|
            new_item = item
            x = item 
            x = monkey[:operation][:x].to_i if monkey[:operation][:x] != "old"
            
            new_item = x * item if monkey[:operation][:operand] == '*'
            new_item = x + item if monkey[:operation][:operand] == '+'

            new_item %= divider

            test_true = (new_item % monkey[:test] == 0)
           
            monkies[monkey[:if_true]][:items].append(new_item)  if test_true
            monkies[monkey[:if_false]][:items].append(new_item)  if !test_true

            monkey[:inspections] += 1
        end

        monkey[:items] = []
    end
end


puts monkies.map{ |m| m[:inspections] }.sort.last(2).reduce(1, :*)