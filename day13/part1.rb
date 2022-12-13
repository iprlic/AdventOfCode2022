#!/usr/bin/env ruby
# frozen_string_literal: true
require 'json'

def compare(a, b)
    a.each_with_index do |a_item, i|
        b_item = b[i]

        return false if b_item.nil?

        if a_item.is_a? Integer and b_item.is_a? Integer
            return true if a_item < b_item
            return false if a_item > b_item
        end

        if a_item.is_a? Array and b_item.is_a? Array
            com = compare(a_item, b_item)

            return com if !com.nil?
        end

        if a_item.is_a? Array and b_item.is_a? Integer
            com = compare(a_item, [b_item])
            return com if !com.nil?
        end

        if a_item.is_a? Integer and b_item.is_a? Array
            com = compare([a_item], b_item)
            return com if !com.nil?
        end
    end

    return true if a.length < b.length

    return nil
end

file_path = File.expand_path('input.txt', __dir__)

input = File.read(file_path).split("\n\n").map do |pairs|
    pairs.split("\n").map do |pair|
        JSON.load (pair)
    end
end

correct_order = []

input.each_with_index do |pairs, i|
    a = pairs[0]
    b = pairs[1]


    correct_order.push(i+1) if compare(a, b)
end

puts correct_order.reduce(:+)